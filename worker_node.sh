#!/bin/bash
min=$1
max=$2
j=$3
#modify the address for kubeproxy
mv /root/mck8s_lsv/metrics_server.yaml /root/

for i in `seq $min $max`
do
kubectl config use-context cluster$i
kubectl label nodes cluster$i-control-plane node=master
KUBE_EDITOR="sed -i s/metricsBindAddress:.*/metricsBindAddress:\ "0.0.0.0:10249"/g" kubectl edit cm/kube-proxy -n kube-system
kubectl delete pod -l k8s-app=kube-proxy -n kube-system
docker cp /root/.kube/config cluster$i-control-plane:/root/.kube
done

#Deploy Prometheus on member clusters
for i in `seq $min $max`
do
kubectl config use-context cluster$i
kubectl create ns monitoring
helm install --version 33.1.0 prometheus-community/kube-prometheus-stack --generate-name --set grafana.service.type=NodePort --set grafana.service.nodePort=30099 --set prometheus.service.type=NodePort --set prometheus.prometheusSpec.scrapeInterval="5s" --namespace monitoring --values /root/mck8s_lsv/values_worker.yaml
echo "wait for 5 secs"
sleep 5
done

#Deploy metrics server
#wget https://gist.githubusercontent.com/moule3053/1b14b7898fd473b4196bdccab6cc7b48/raw/916f4362bcde612d0f96af48bc7ef7b99ab06a1f/metrics_server.yaml
for i in `seq $min $max`
do
    kubectl --context=cluster$i create -f metrics_server.yaml
    kubectl --context=cluster$i apply -f /root/rntsm/arch02/member/deploy_member.yaml
	sleep 2
done

echo "-------------------------------------- $j OK --------------------------------------"