#!/bin/bash
cluster=$1

#modify the address for kubeproxy
echo "copy metrics_server.yaml-----------------------"
mv /root/mck8s_vm/large-scale/metrics_server.yaml /root/

echo "Install Helm3-----------------------"
wget -c https://get.helm.sh/helm-v3.8.2-linux-amd64.tar.gz
tar xzvf helm-v3.8.2-linux-amd64.tar.gz
mv linux-amd64/helm /usr/local/bin/
helm repo add stable https://charts.helm.sh/stable
helm repo add cilium https://helm.cilium.io/
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
echo "wait for 5 secs-------------------------"
sleep 5

echo "Install cilium-----------------------"
kubectl config use-context cluster$cluster
helm repo update
helm install cilium cilium/cilium --version 1.11.4 --wait --wait-for-jobs --namespace kube-system --set cluster.name=cluster$cluster --set cluster.id=$cluster

# echo "kubeproxy edit-----------------------"
# ##kubeproxy modify
# kubectl config use-context cluster$cluster
# KUBE_EDITOR="sed -i s/metricsBindAddress:.*/metricsBindAddress:\ "0.0.0.0:10249"/g" kubectl edit cm/kube-proxy -n kube-system
# kubectl delete pod -l k8s-app=kube-proxy -n kube-system
# echo "wait for 5 secs-------------------------"
# sleep 10
sleep 10
echo "Install Prometheus-----------------------"
kubectl config use-context cluster$cluster
kubectl create ns monitoring
sleep 2
helm install --version 34.10.0 prometheus-community/kube-prometheus-stack --generate-name --wait --wait-for-jobs --set grafana.service.type=NodePort --set grafana.service.nodePort=30099 --set prometheus.service.type=NodePort --set prometheus.prometheusSpec.scrapeInterval="5s" --namespace monitoring --values /root/mck8s_vm/large-scale/values_worker.yaml
echo "wait for 5 secs-------------------------"
sleep 5

echo "Install Metrics server-----------------------"
kubectl --context=cluster$cluster create -f metrics_server.yaml

echo "Member cluster$cluster is ready"