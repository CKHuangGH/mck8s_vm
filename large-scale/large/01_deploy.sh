cp ../node_list node_list

for i in $(cat node_list)
do
	echo "deploy member at $i"
	ssh root@$i kubectl apply -f /root/mck8s_vm/large-scale/acala/member/mawd/deploy_member.yaml
done
echo "wait 30s-------------------------------"
sleep 30

kubectl apply -f /root/mck8s_vm/large-scale/acala/controller/5s/deploy_controller.yaml
echo "wait 30s-------------------------------"
sleep 30

echo "Good for check"