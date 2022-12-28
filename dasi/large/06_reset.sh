j=1
for i in $(cat node_list)
do
	echo "deploy member at $i"
	ssh root@$i rm -f /root/exectime
	ssh root@$i rm -f /root/kubetopNodecluster*
	ssh root@$i rm -f /root/kubetopPodMcluster*
	ssh root@$i kubectl delete -f /root/mck8s_vm/large-scale/acala/member/ma/deploy_member.yaml
	ssh root@$i kubectl delete -f /root/mck8s_vm/large-scale/acala/member/mawd/deploy_member.yaml  
	j=$((j+1))	
done

kubectl delete -f /root/mck8s_vm/large-scale/acala/controller/5s/deploy_controller.yaml
kubectl delete -f /root/mck8s_vm/large-scale/acala/controller/60s/deploy_controller.yaml
rm -rf ./results/