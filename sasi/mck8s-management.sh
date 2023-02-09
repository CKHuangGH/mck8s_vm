#!/bin/bash 

# Deploy Prometheus Federation on Cluster 0
kubectl config use-context cluster0
kubectl create ns monitoring
helm install --version 34.10.0 prometheus-community/kube-prometheus-stack --generate-name --wait --wait-for-jobs --set grafana.service.type=NodePort --set grafana.service.nodePort=30099 --set prometheus.service.type=NodePort --set prometheus.prometheusSpec.scrapeInterval="5s" --namespace monitoring --set prometheus.server.extraFlags="web.enable-lifecycle" --values values.yaml

# Install kubefedctl
wget --tries=0 https://github.com/kubernetes-sigs/kubefed/releases/download/v0.9.1/kubefedctl-0.9.1-linux-amd64.tgz
tar xzvf kubefedctl-0.9.1-linux-amd64.tgz
mv kubefedctl /usr/local/bin/

# Add helm chart

kubectl config use-context cluster0
helm repo add kubefed-charts https://raw.githubusercontent.com/kubernetes-sigs/kubefed/master/charts
helm repo update

# Deploy KubeFed
helm --namespace kube-federation-system upgrade -i kubefed kubefed-charts/kubefed --version 0.9.1 --create-namespace

echo "------------------------Management node ok---------------------" 