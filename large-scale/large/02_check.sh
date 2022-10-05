for i in $(cat node_list)
do
	ssh root@$i kubectl get cs
	ssh root@$i kubectl get pod -m monitoring | grep acala
done

kubectl get pod -m monitoring | grep acala