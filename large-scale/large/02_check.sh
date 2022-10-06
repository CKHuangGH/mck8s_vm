for i in $(cat node_list)
do
	ssh root@$i kubectl get pod -n monitoring | grep member
done

kubectl get pod -n monitoring | grep master