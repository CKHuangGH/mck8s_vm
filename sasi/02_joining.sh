ls /root/.kube/
read -p "please enter the last cluster number in .kube: " cluster

for i in `seq 1 $cluster`
do
kubefedctl join cluster$i --cluster-context cluster$i --host-cluster-context cluster0 --v=2
done

# apply all crds
kubectl config use-context cluster0
kubectl apply -f manifests/crds/01_rbac_mck8s.yaml
kubectl apply -f manifests/crds/
#echo "Please apply mcs by youself"
kubectl apply -f manifests/controllers/mcsv2.yaml
#kubectl apply -f manifests/controllers/02_deployment_multi_cluster_hpa.yaml

kubectl get node
kubectl get pod
kubectl get pod -n monitoring
echo "--------------------------------------------------"
for i in $(cat node_list)
do
	ssh -o StrictHostKeyChecking=no root@$i kubectl get node
	ssh -o StrictHostKeyChecking=no root@$i kubectl get pod
	ssh -o StrictHostKeyChecking=no root@$i kubectl get pod -n monitoring
	echo "--------------------------------------------------"
done

echo "good to start run experiment-----------------------------------------------"