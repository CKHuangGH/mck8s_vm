mkdir results
cp /root/mck8s_vm/node_list /root/mck8s_vm/error/node_list

for i in $(cat node_list)
do 
	echo "ping $i"
	ping $i -c 4 >> /root/mck8s_vm/error/results/ping.txt
done

read -p "please input end:" end
echo "save time" >> /root/mck8s_vm/error/results/status.txt
echo $(date +'%s.%N') >> /root/mck8s_vm/error/results/status.txt
for i in `seq 0 $end`
do
	echo "-------------------------" >> /root/mck8s_vm/error/results/status.txt
	echo "-------------cluster$i-------------" >> /root/mck8s_vm/error/results/status.txt
	echo "cluster$i"
	kubectl --context cluster$i get pod -n kube-system >> /root/mck8s_vm/error/results/status.txt
	echo "-------------------------" >> /root/mck8s_vm/error/results/status.txt
	kubectl --context cluster$i get pod -n monitoring >> /root/mck8s_vm/error/results/status.txt
	echo "-------------------------" >> /root/mck8s_vm/error/results/status.txt
	kubectl --context cluster$i get node >> /root/mck8s_vm/error/results/status.txt
	echo "-------------------------" >> /root/mck8s_vm/error/results/status.txt
done

echo "--------------------Management cluster--------------------" >> /root/mck8s_vm/error/results/status.txt
kubectl --context cluster0 -n kube-federation-system get kubefedclusters >> /root/mck8s_vm/error/results/status.txt
echo "-------------------------" >> /root/mck8s_vm/error/results/status.txt
kubectl --context cluster0 get pod -n kube-federation-system >> /root/mck8s_vm/error/results/status.txt
echo "-------------------------" >> /root/mck8s_vm/error/results/status.txt
kubectl --context cluster0 get pod  >> /root/mck8s_vm/error/results/status.txt
echo "-------------------------" >> /root/mck8s_vm/error/results/status.txt
kubectl --context cluster0 describe node >> /root/mck8s_vm/error/results/status.txt
echo "-----------cluster1--------------" >> /root/mck8s_vm/error/results/status.txt
kubectl --context cluster1 describe node >> /root/mck8s_vm/error/results/status.txt
	