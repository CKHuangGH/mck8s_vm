cluster=1
for i in $(cat node_list)
do
	ssh root@$i chmod 777 /root/mck8s_vm/large-scale/worker_patch.sh
	ssh root@$i sh /root/mck8s_vm/large-scale/worker_patch.sh $cluster &
	cluster=$((cluster+1))
done