ls /root/.kube/
read -p "please enter the last cluster number in .kube: " number

./01_combineAll.sh $number
sleep 3
./createvalue.sh
sleep 3
./04_mck8s-2.sh
sleep 3
./05_joining_test.sh $number
#sleep 100
# chmod 777 /root/mck8s_vm/error/01_status.sh
# chmod 777 /root/mck8s_vm/error/02_run.sh
# chmod 777 /root/mck8s_vm/error/03_getdocker.sh
# chmod 777 /root/mck8s_vm/error/04_cptorennes.sh
kubectl get node
kubectl get pod
kubectl get pod -n monitoring
for i in $(cat node_list)
do
	ssh -o StrictHostKeyChecking=no root@$i kubectl get node
	ssh -o StrictHostKeyChecking=no root@$i kubectl get pod
	ssh -o StrictHostKeyChecking=no root@$i kubectl get pod -n monitoring
done

echo "good to start run error"