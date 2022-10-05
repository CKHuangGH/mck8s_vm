for i in $(cat node_list)
do
	ssh root@$i kubectl apply -f /root/mck8s_vm/large-scale/acala/member/mawd/deploy_member.yaml
done

sleep 30

kubectl apply -f /root/mck8s_vm/large-scale/acala/controller/5s/deploy_member.yaml

sleep 30

echo "Good for check"