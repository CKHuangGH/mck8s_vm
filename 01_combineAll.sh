## install vim

sudo apt-get install vim -y


while read line
do 
echo $line
ip1=$(echo $line | cut -d "." -f 2)
ip2=$(echo $line | cut -d "." -f 3)
break
done < node_list



for i in `seq 0 1`
do
    sed -i 's/kubernetes-admin/k8s-admin-cluster'$i'/g' ~/.kube/cluster$i
    sed -i 's/name: kubernetes/name: cluster'$i'/g' ~/.kube/cluster$i
    sed -i 's/cluster: kubernetes/cluster: cluster'$i'/g' ~/.kube/cluster$i
done

for i in `seq 0 1`
do
    string=$string"/root/.kube/cluster$i:"
done
string=$string | sed "s/.$//g"
KUBECONFIG=$string kubectl config view --flatten > ~/.kube/config

for i in `seq 0 1`
do
    kubectl config rename-context k8s-admin-cluster$i@kubernetes cluster$i
done

for i in $(cat node_list)
do
	ssh-keyscan $i >> /root/.ssh/known_hosts
	#scp /root/.kube/config root@$i:/root/.kube
	ssh root@$i wget -c https://github.com/scottchiefbaker/dool/archive/refs/tags/v1.0.0.tar.gz
	ssh root@$i tar xzvf v1.0.0.tar.gz
	ssh root@$i mv dool-1.0.0/dool /usr/local/bin/
    ssh root@$i mv dool-1.0.0/plugins/ /usr/local/bin/
done
ssh -o StrictHostKeyChecking=no root@10.$ip1.$ip2.3 sudo apt-get install vim -y
ssh -o StrictHostKeyChecking=no root@10.$ip1.$ip2.3 ssh-keyscan 10.$ip1.$ip2.2 >> /root/.ssh/known_hosts
ssh-keyscan 10.$ip1.$ip2.3 >> /root/.ssh/known_hosts
ssh -o StrictHostKeyChecking=no root@10.$ip1.$ip2.3 mkdir /root/.kube
scp /root/.kube/config root@10.$ip1.$ip2.3:/root/.kube

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

for i in `seq 0 1`
do
    kubectl config use-context cluster$i
	helm repo update
	helm install cilium cilium/cilium --version 1.11.4 --namespace kube-system --set cluster.name=cluster$i --set cluster.id=$i
    echo "wait for 5 secs"
    sleep 5
done

sleep 10

for i in `seq 0 1`
do
kubectl config use-context cluster$i
KUBE_EDITOR="sed -i s/metricsBindAddress:.*/metricsBindAddress:\ "0.0.0.0:10249"/g" kubectl edit cm/kube-proxy -n kube-system
kubectl delete pod -l k8s-app=kube-proxy -n kube-system
echo "wait for 1 secs"
sleep 1
done

#Deploy Prometheus on member clusters
for i in `seq 1 1`
do
kubectl config use-context cluster$i
kubectl create ns monitoring
helm install --version 34.10.0 prometheus-community/kube-prometheus-stack --generate-name --set grafana.service.type=NodePort --set grafana.service.nodePort=30099 --set prometheus.service.type=NodePort --set prometheus.prometheusSpec.scrapeInterval="5s" --namespace monitoring --values /root/mck8s_vm/values_worker.yaml
echo "wait for 5 secs"
sleep 5
done



#Deploy metrics server
#wget https://gist.githubusercontent.com/moule3053/1b14b7898fd473b4196bdccab6cc7b48/raw/916f4362bcde612d0f96af48bc7ef7b99ab06a1f/metrics_server.yaml
for i in `seq 0 1`
do
    kubectl --context=cluster$i create -f metrics_server.yaml
    echo "wait for 2 secs"
	sleep 2
done

echo "-------------------------------------- OK --------------------------------------"