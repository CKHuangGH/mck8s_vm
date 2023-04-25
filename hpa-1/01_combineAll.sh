## install vim
apt-get update
sudo apt-get install vim -y
sudo apt install python3-pip -y

for i in `seq 0 0`
do
    sed -i 's/kubernetes-admin/k8s-admin-cluster'$i'/g' ~/.kube/cluster$i
    sed -i 's/name: kubernetes/name: cluster'$i'/g' ~/.kube/cluster$i
    sed -i 's/cluster: kubernetes/cluster: cluster'$i'/g' ~/.kube/cluster$i
done

for i in `seq 0 0`
do
    string=$string"/root/.kube/cluster$i:"
done
string=$string | sed "s/.$//g"
KUBECONFIG=$string kubectl config view --flatten > ~/.kube/config

for i in `seq 0 0`
do
    kubectl config rename-context k8s-admin-cluster$i@kubernetes cluster$i
done

for i in $(cat node_list)
do
	ssh-keyscan $i >> /root/.ssh/known_hosts
done

# Install helm3
echo "Helm3"
wget -c https://get.helm.sh/helm-v3.8.2-linux-amd64.tar.gz
tar xzvf helm-v3.8.2-linux-amd64.tar.gz
mv linux-amd64/helm /usr/local/bin/
helm repo add stable https://charts.helm.sh/stable
helm repo add cilium https://helm.cilium.io/
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

sleep 5

for i in `seq 0 0`
do
    kubectl config use-context cluster$i
	helm repo update
	helm install cilium cilium/cilium --version 1.11.4 --namespace kube-system --set cluster.name=cluster$i --set cluster.id=$i
    echo "wait for 5 secs"
    sleep 5
done

sleep 10

#Deploy metrics server
#wget https://gist.githubusercontent.com/moule3053/1b14b7898fd473b4196bdccab6cc7b48/raw/916f4362bcde612d0f96af48bc7ef7b99ab06a1f/metrics_server.yaml
for i in `seq 0 0`
do
    kubectl --context=cluster$i create -f metrics_server.yaml
    echo "wait for 2 secs"
	sleep 2
done

echo "-------------------------------------- OK --------------------------------------"
