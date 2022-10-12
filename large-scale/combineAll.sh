number=$1

apt-get update
sudo apt-get install vim -y
sudo apt install python3-pip -y
pip3 install kubernetes

for i in `seq 0 $number`
do
    sed -i 's/kubernetes-admin/k8s-admin-cluster'$i'/g' ~/.kube/cluster$i
    sed -i 's/name: kubernetes/name: cluster'$i'/g' ~/.kube/cluster$i
    sed -i 's/cluster: kubernetes/cluster: cluster'$i'/g' ~/.kube/cluster$i
done

for i in `seq 0 $number`
do
    string=$string"/root/.kube/cluster$i:"
done
string=$string | sed "s/.$//g"
KUBECONFIG=$string kubectl config view --flatten > ~/.kube/config

for i in `seq 0 $number`
do
    kubectl config rename-context k8s-admin-cluster$i@kubernetes cluster$i
done

sleep 2

while read line
do 
echo $line
ip1=$(echo $line | cut -d "." -f 2)
ip2=$(echo $line | cut -d "." -f 3)
break
done < node_list_all
#ssh -o StrictHostKeyChecking=no root@10.$ip1.$ip2.3 sudo apt-get install vim -y
ssh -o StrictHostKeyChecking=no root@10.$ip1.$ip2.3 mkdir /root/.kube
scp /root/.kube/config root@10.$ip1.$ip2.3:/root/.kube

cluster=1
for i in $(cat node_list)
do
	ssh-keyscan $i >> /root/.ssh/known_hosts
	scp /root/.kube/config root@$i:/root/.kube
	ssh root@$i chmod 777 /root/mck8s_vm/large-scale/worker_node.sh
	ssh root@$i sh /root/mck8s_vm/large-scale/worker_node.sh $cluster &
	cluster=$((cluster+1))
	sleep 2
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

sleep 3

for i in `seq 0 0`
do
    kubectl config use-context cluster$i
	helm repo update
	helm install cilium cilium/cilium --version 1.11.4 --wait --wait-for-jobs --namespace kube-system --set cluster.name=cluster$i --set cluster.id=$i
done

# for i in `seq 0 0`
# do
# kubectl config use-context cluster$i
# KUBE_EDITOR="sed -i s/metricsBindAddress:.*/metricsBindAddress:\ "0.0.0.0:10249"/g" kubectl edit cm/kube-proxy -n kube-system
# kubectl delete pod -l k8s-app=kube-proxy -n kube-system
# done

sleep 5

#Deploy metrics server
#wget https://gist.githubusercontent.com/moule3053/1b14b7898fd473b4196bdccab6cc7b48/raw/916f4362bcde612d0f96af48bc7ef7b99ab06a1f/metrics_server.yaml
for i in `seq 0 0`
do
    kubectl --context=cluster$i create -f metrics_server.yaml
done
sleep 5
echo "-------------------------------------- OK --------------------------------------"
