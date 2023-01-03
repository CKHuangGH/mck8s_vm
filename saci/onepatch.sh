cat node_list
read -p "which cluster need redeploy: " cluster

echo "Install cilium-----------------------"
kubectl config use-context cluster$cluster
helm repo update
helm install cilium cilium/cilium --version 1.11.4 --wait --namespace kube-system --set cluster.name=cluster$cluster --set cluster.id=$cluster

echo "Install Prometheus-----------------------"
kubectl config use-context cluster$cluster
kubectl create ns monitoring
helm install --version 34.10.0 prometheus-community/kube-prometheus-stack --generate-name --set grafana.service.type=NodePort --set grafana.service.nodePort=30099 --set prometheus.service.type=NodePort --set prometheus.prometheusSpec.scrapeInterval="5s" --namespace monitoring --values /root/mck8s_vm/large-scale/values_worker.yaml
echo "wait for 5 secs-------------------------"
sleep 5

echo "Install Metrics server-----------------------"
kubectl --context=cluster$cluster create -f metrics_server.yaml

kubectl config use-context cluster0