cluster=$1

for i in `seq 1 $cluster`
do
kubefedctl join cluster$i --cluster-context cluster$i --host-cluster-context cluster0 --v=2
done

# apply all crds
kubectl config use-context cluster0
kubectl apply -f manifests/crds/01_rbac_mck8s.yaml
kubectl apply -f manifests/crds/
#echo "Please apply mcs by youself"
kubectl apply -f manifests/controllers/01_deployment_multi_cluster_scheduler.yaml
kubectl apply -f manifests/controllers/02_deployment_multi_cluster_hpa.yaml