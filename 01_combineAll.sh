ls /root/.kube/
read -p "please enter the last cluster number in .kube: " number
sed -i '1d' node_list
for i in `seq 0 $number`
do
    string=$string"/root/.kube/cluster$i:"
done
string=$string | sed "s/.$//g"
KUBECONFIG=$string kubectl config view --flatten > ~/.kube/config

for i in `seq 0 $number`
do
    kubectl config rename-context kind-cluster$i cluster$i
done


for i in $(cat node_list)
do
	ssh-keyscan $i >> /root/.ssh/known_hosts
	scp /root/.kube/config root@$i:/root/.kube
done

echo "Finish"