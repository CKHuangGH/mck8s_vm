#!/bin/bash 
read -p "please input last clustername(ex: 3):" cluster

# Deploy Prometheus on member clusters
for i in `seq 1 $cluster`
do
kubectl config use-context cluster$i; kubectl create ns monitoring; helm install prometheus-community/kube-prometheus-stack --generate-name --set grafana.service.type=NodePort --set prometheus.service.type=NodePort --set prometheus.prometheusSpec.scrapeInterval="5s" --namespace monitoring; kubectl config use-context cluster0
done

# Deploy Prometheus Federation on Cluster 0
kubectl create ns monitoring
helm install prometheus-community/kube-prometheus-stack --generate-name --set grafana.service.type=NodePort --set prometheus.service.type=NodePort --set prometheus.prometheusSpec.scrapeInterval="5s" --namespace monitoring --values values.yaml

# Install kubefedctl
wget --tries=0 https://github.com/kubernetes-sigs/kubefed/releases/download/v0.1.0-rc6/kubefedctl-0.1.0-rc6-linux-amd64.tgz
tar xzvf kubefedctl-0.1.0-rc6-linux-amd64.tgz
mv kubefedctl /usr/local/bin/

# Add helm chart
sleep 30
kubectl config use-context cluster0
helm repo add kubefed-charts https://raw.githubusercontent.com/kubernetes-sigs/kubefed/master/charts
helm repo update

# Deploy KubeFed
helm --namespace kube-federation-system upgrade -i kubefed kubefed-charts/kubefed --create-namespace


# Join clusters to KubeFed
sleep 30
for i in `seq 1 $cluster`
do
kubefedctl join cluster$i --cluster-context cluster$i --host-cluster-context cluster0 --v=2
done

# Deploy metrics server
wget https://gist.githubusercontent.com/moule3053/1b14b7898fd473b4196bdccab6cc7b48/raw/916f4362bcde612d0f96af48bc7ef7b99ab06a1f/metrics_server.yaml
for i in `seq 0 $cluster`
do
	kubectl --context=cluster$i create -f metrics_server.yaml
done

# Expose Cilium etcd to other clusters
echo "Expose Cilium etcd to other clusters .........."
for i in `seq 1 $cluster`
do
kubectl --context cluster$i -n kube-system apply -f https://raw.githubusercontent.com/cilium/cilium/v1.9/examples/kubernetes/clustermesh/cilium-etcd-external-service/cilium-etcd-external-nodeport.yaml
done

# Install jq
echo "Installing jq ..........."
apt install -y jq

# Extract the TLS keys and generate the etcd configuration
echo "Extract the TLS keys and generate the etcd configuration ............"
cd ~/ && git clone https://github.com/cilium/clustermesh-tools.git
#cd ~/ && git clone https://github.com/cilium/clustermesh-tools.git
cd clustermesh-tools

for i in `seq 1 $cluster`
do
kubectl config use-context cluster$i
./extract-etcd-secrets.sh
kubectl config use-context cluster0
done

# Generate a single Kubernetes secret from all the keys and certificates extracted
echo "Generate a single Kubernetes secret from all the keys and certificates extracted ........"
./generate-secret-yaml.sh > clustermesh.yaml

# Ensure that the etcd service names can be resolved
echo "Ensure that the etcd service names can be resolved........."
./generate-name-mapping.sh > ds.patch

# Apply the patch to all DaemonSets in all clusters
echo "Apply the patch to all DaemonSets in all clusters .........."
for i in `seq 1 $cluster`
do
kubectl --context cluster$i -n kube-system patch ds cilium -p "$(cat ds.patch)"
done

#Establish connections between clusters
echo "Establish connections between clusters............"
for i in `seq 1 $cluster`
do
kubectl --context cluster$i -n kube-system apply -f clustermesh.yaml
done

# Restart the cilium-agent in all clusters
echo "Restart the cilium-agent in all clusters ............"
for i in `seq 1 $cluster`
do
kubectl --context cluster$i -n kube-system delete pod -l k8s-app=cilium
done
sleep 10
# Restart the cilium-operator
echo "Restart the cilium-operator ......."
for i in `seq 1 $cluster`
do
kubectl --context cluster$i -n kube-system delete pod -l name=cilium-operator
done

echo "Done setting up Cilium cluster mesh!"

echo "DONE. Kubernetes Federation is setup."