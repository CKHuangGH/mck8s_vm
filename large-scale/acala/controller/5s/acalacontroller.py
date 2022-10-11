import socket
import gzip
import time
import shutil
import requests
from prometheus_api_client import PrometheusConnect
from kubernetes import client, config
import kubernetes.client
import base64
import yaml
import logging
from aiohttp import ClientSession
import asyncio


ipdict={}
portdict={}
timedict={}
resources = {}
scrapetime = {}
scrapelist=[]
timeout_seconds = 30

logging.basicConfig(level=logging.INFO)

def getControllerMasterIP():
    config.load_kube_config()
    api_instance = kubernetes.client.CoreV1Api()
    master_ip = ""
    try:
        nodes = api_instance.list_node(pretty=True, _request_timeout=timeout_seconds)
        nodes = [node for node in nodes.items if
                 'node-role.kubernetes.io/master' in node.metadata.labels]
        # get all addresses of the master
        addresses = nodes[0].status.addresses

        master_ip = [i.address for i in addresses if i.type == "InternalIP"][0]
    except:
        print("Connection timeout after " + str(timeout_seconds) + " seconds to host cluster")

    return master_ip

def timewriter(text):
    try:
        f = open("exectime_management", 'a')
    except:
        print("Open exectime failed")
    try:
        f.write(text)
        f.write("\n")
        f.close
    except:
        print("Write error")

def decompressfile(name,nameup):
    start = time.perf_counter()
    with gzip.open(name, 'rb') as f_in, open(nameup, 'wb') as f_out:
        shutil.copyfileobj(f_in, f_out)
    end = time.perf_counter()
    timewriter("decompressfile" + " " + str(end-start))

def posttogateway(clustername,instance, name):
    start = time.perf_counter()
    gateway_host="127.0.0.1"
    gateway_port="9091"
    url = "http://" + str(gateway_host) + ":" + str(gateway_port) + "/metrics/job/" + clustername + "/instance/" + instance
    res = requests.post(url=url,data=open(name, 'rb'),headers={'Content-Type': 'application/octet-stream'})
    end = time.perf_counter()
    timewriter("posttogateway" + " " + str(end-start))

def getresources(mode,cluster):
    start = time.perf_counter()
    prom_host = getControllerMasterIP()
    prom_port = 30090
    prom_url = "http://" + str(prom_host) + ":" + str(prom_port)
    pc = PrometheusConnect(url=prom_url, disable_ssl=True)
    if mode == "CPU" or mode == 'cpu':
        query="(1-sum(increase(node_cpu_seconds_total{cluster_name=\"rntsm\",job=\"" + cluster + "\",mode=\"idle\"}[1m]))/sum(increase(node_cpu_seconds_total{cluster_name=\"rntsm\",job=\"" + cluster + "\"}[1m])))*100"
        result = pc.custom_query(query=query)
        if len(result) > 0:
            resources[cluster] = float(result[0]['value'][1])
    elif mode == "Memory" or mode == 'memory':
        query="node_memory_MemFree_bytes{cluster_name=\"rntsm\",job=\"" + cluster + "\"}"
        result = pc.custom_query(query=query)
        if len(result) > 0:
            resources[cluster] = float(result[0]['value'][1])
    else:
        print("Please input cpu or Memory")
    end = time.perf_counter()
    #timewriter("getresources" + " " + str(end-start))

def decidetime(cluster, minlevel, timemax, maxlevel, timemin):
    start = time.perf_counter()
    current=resources[cluster]
    if current >= minlevel: 
        answer=(m*current)+b
        timedict[cluster]=int(answer)
    elif current > maxlevel:
        timedict[cluster]=timemin
    else:
        timedict[cluster]=timemax
    scrapetime[cluster]=timedict[cluster]
    end = time.perf_counter()
    #timewriter("decidetime" + " " + str(end-start))

def parse_ip_port_name(data):
    origdata = data.strip('\n')
    parseddata = origdata.split(":")
    return str(parseddata[0]), int(parseddata[1]), str(parseddata[2])

def read_member_cluster():
    f = open("/root/member", 'r')
    for line in f.readlines():
        ip, port, cluster=parse_ip_port_name(line)
        scrapelist.append(ip)
        ipdict[cluster]=ip
        portdict[cluster]=port
        timedict[cluster]=0

def getformule(minlevel, timemax, maxlevel, timemin):
    global m
    m=(int(timemin)-int(timemax))/(int(maxlevel)-int(minlevel))
    global b
    b=(float(timemax)-(m*float(minlevel)))

def getsecret():
    config.load_kube_config()
    api_instance = kubernetes.client.CoreV1Api()
    namespace="monitoring"
    name=getsecretname()

    resp=api_instance.read_namespaced_secret(name=name, namespace=namespace)
    return resp

def getsecretname():
    config.load_kube_config()
    api_instance = kubernetes.client.CoreV1Api()
    namespace="monitoring"
    label_selector="app=kube-prometheus-stack-prometheus-scrape-confg"

    try:
        resp=api_instance.list_namespaced_secret(namespace=namespace, label_selector=label_selector,timeout_seconds=timeout_seconds)
    except:
        print("Connection timeout after " + str(timeout_seconds) + " seconds to host cluster")
    
    return resp.items[0].metadata.name

def updateSecret(code):
    config.load_kube_config()
    api_instance = kubernetes.client.CoreV1Api()
    secret = getsecret()
    namespace="monitoring"
    name = getsecretname()
    secret.data['additional-scrape-configs.yaml'] = code
    api_instance.patch_namespaced_secret(name=name, namespace=namespace, body=secret)

def modifyconfig():
    config.load_kube_config()
    api_instance = kubernetes.client.CoreV1Api()
    min_key = min(scrapetime, key = scrapetime.get)
    value="'" + str(int(scrapetime[min_key]))+"s'"
    secret = getsecret()
    config_base64=secret.data['additional-scrape-configs.yaml']
    config_decode=base64.b64decode(config_base64)
    yaml_config=yaml.full_load(config_decode.decode())
    for item in yaml_config:
        item['scrape_interval']=value
    config_encode=base64.b64encode(str(yaml_config).encode("utf-8"))
    encodedStr=config_encode.decode("UTF-8")
    code=encodedStr
    updateSecret(code)

async def fetch(link, clientMessage, number):
    print('Send: %r' % clientMessage)
    reader, writer = await asyncio.open_connection(link, 31580)
    writer.write(clientMessage.encode())
    #client.sendall(clientMessage.encode())
    fname = "after" + str(number) + ".gz"
    with open(fname, "wb") as f:
        while True:
            bytes_read = await reader.read(BUFFER_SIZE)
            if not bytes_read:    
                break
            f.write(bytes_read)
            writer.close()

async def tcp_echo_client(links,clientMessage):
    tasks = [asyncio.create_task(fetch(link, clientMessage, links.index(link))) for link in links]
    await asyncio.gather(*tasks)

if __name__ == "__main__":
    perparestart = time.perf_counter()
    minlevel, timemax, maxlevel, timemin=20,60,40,5
    read_member_cluster()
    getformule(minlevel, timemax, maxlevel, timemin)
    clientMessage = "rntsm:1"
    BUFFER_SIZE=8192
    perpareend = time.perf_counter()
    timewriter("perpare" + " " + str(perpareend-perparestart))
    loop = asyncio.get_event_loop()
    while True:
        try:
            totaltimestart = time.perf_counter()
            loop.run_until_complete(tcp_echo_client(scrapelist,clientMessage))
            for number in range(len(scrapelist)):
                name= "after" + str(number)+".gz"
                nameup="after"+ str(number)
                decompressfile(name,nameup)
                whichone=number+1
                clustername="cluster"+str(whichone)
                try:
                    posttogateway(clustername,ipdict[clustername],nameup)
                    clientMessage = "rntsm"
                except:
                    clientMessage = "rntsm:1"
            totaltimeend = time.perf_counter()
            timewriter("onescrapetotaltime" + " " + str(totaltimeend-totaltimestart))
        except:
            print("failed")
        time.sleep(5)