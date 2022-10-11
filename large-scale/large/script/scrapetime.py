import requests
import time
from kubernetes import client, config
import kubernetes.client



timeout_seconds=30
def test(hostip):
    prom_host=hostip
    f = open("prom_scrape_acala", 'a')
    prom_port = 30090
    prom_url = "http://" + str(prom_host) + ":" + \
                                str(prom_port) + "/api/v1/targets"
    prom_header = {'Accept-Encoding': 'gzip'}
    r = requests.get(url=prom_url,headers=prom_header)
    data = r.json()
    for item in data["data"]["activeTargets"]:
        if item["labels"]["job"] == "acala":
            print(item["scrapeUrl"])
            f.write(str(item["lastScrapeDuration"]))
            f.write("\n")
            f.close
            
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

i=0
while i<1200:
    hostip=getControllerMasterIP()
    test(hostip)
    time.sleep(1)
    i+=1
    

