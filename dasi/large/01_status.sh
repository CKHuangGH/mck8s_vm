cp ../node_list node_list
cp ../node_list_all node_list_all
mkdir results

for i in $(cat node_list)
do 
	echo "ping $i"
	ping $i -c 4 >> ./results/ping.txt
done

read -p "please input end:" end
echo "save time" >> ./results/status.txt
echo $(date +'%s.%N') >> ./results/status.txt
for i in `seq 0 $end`
do
	echo "-------------------------" >> ./results/status.txt
	echo "-------------cluster$i-------------" >> ./results/status.txt
	echo "cluster$i"
	kubectl --context cluster$i get pod -n kube-system >> ./results/status.txt
	echo "-------------------------" >> ./results/status.txt
	kubectl --context cluster$i get pod -n monitoring >> ./results/status.txt
	echo "-------------------------" >> ./results/status.txt
	kubectl --context cluster$i get node >> ./results/status.txt
	echo "-------------------------" >> ./results/status.txt
	kubectl --context cluster$i describe node >> ./results/status.txt
done

echo "--------------------Management cluster--------------------" >> ./results/status.txt
kubectl --context cluster0 get kubefedclusters -n kube-federation-system >> ./results/status.txt
echo "-------------------------" >> ./results/status.txt
kubectl --context cluster0 get pod -n kube-federation-system >> ./results/status.txt
echo "-------------------------" >> ./results/status.txt
kubectl --context cluster0 get pod  >> ./results/status.txt
echo "-------------------------" >> ./results/status.txt
kubectl --context cluster0 describe node >> ./results/status.txt