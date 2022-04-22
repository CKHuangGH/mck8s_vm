#!/bin/bash 

kubectl config use-context cluster0
kubectl label nodes cluster0-control-plane node=master
KUBE_EDITOR="sed -i s/metricsBindAddress:.*/metricsBindAddress:\ "0.0.0.0:10249"/g" kubectl edit cm/kube-proxy -n kube-system
kubectl delete pod -l k8s-app=kube-proxy -n kube-system
docker cp /root/.kube/config cluster0-control-plane:/root/.kube
docker cp /root/member cluster0-control-plane:/root/member
sleep 5
# Deploy Prometheus Federation on Cluster 0
kubectl config use-context cluster0
kubectl create ns monitoring
helm install --version 33.1.0 prometheus-community/kube-prometheus-stack --generate-name --set grafana.service.type=NodePort --set grafana.service.nodePort=30099 --set prometheus.service.type=NodePort --set prometheus.prometheusSpec.scrapeInterval="5s" --namespace monitoring --set prometheus.server.extraFlags="web.enable-lifecycle" --values values.yaml

# Install kubefedctl
wget --tries=0 https://github.com/kubernetes-sigs/kubefed/releases/download/v0.9.1/kubefedctl-0.9.1-linux-amd64.tgz
tar xzvf kubefedctl-0.9.1-linux-amd64.tgz
mv kubefedctl /usr/local/bin/

# Add helm chart
sleep 3
kubectl config use-context cluster0
helm repo add kubefed-charts https://raw.githubusercontent.com/kubernetes-sigs/kubefed/master/charts
helm repo update

# Deploy KubeFed
helm --namespace kube-federation-system upgrade -i kubefed kubefed-charts/kubefed --version 0.9.1 --create-namespace

# Deploy metrics server
#wget https://gist.githubusercontent.com/moule3053/1b14b7898fd473b4196bdccab6cc7b48/raw/916f4362bcde612d0f96af48bc7ef7b99ab06a1f/metrics_server.yaml
kubectl --context=cluster0 create -f metrics_server.yaml

echo "------------------------Management node ok---------------------" 