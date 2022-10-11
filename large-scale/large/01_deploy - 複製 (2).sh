cp ../node_list node_list
cp ../node_list_all node_list_all
j=1
for i in $(cat node_list)
do
	echo "deploy member at $i"
	##change here
	ssh root@$i kubectl apply -f /root/mck8s_vm/large-scale/acala/member/mawd/deploy_member.yaml  
	j=$((j+1))	
done
echo "wait 30s-------------------------------"
sleep 30
##change here
kubectl apply -f /root/mck8s_vm/large-scale/acala/controller/5s/deploy_controller.yaml
echo "wait 60s-------------------------------"
sleep 60

echo "Good for check"