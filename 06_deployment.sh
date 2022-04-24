# apply all crds
kubectl config use-context cluster0
kubectl apply -f manifests/crds/01_rbac_mck8s.yaml
kubectl apply -f manifests/crds/
echo "wait for 3 sec"
sleep 3
kubectl apply -f manifests/controllers/01_deployment_multi_cluster_scheduler.yaml
kubectl apply -f manifests/controllers/02_deployment_multi_cluster_hpa.yaml