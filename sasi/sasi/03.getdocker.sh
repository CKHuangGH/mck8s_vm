j=1
for i in $(cat node_list)
do 
    #ssh -o StrictHostKeyChecking=no root@$i . /root/mck8s_vm/large-scale/large/script/dockergetime.sh
    #scp root@$i:/root/exectime /root/mck8s_vm/large-scale/large/results/exectime_cluster$j
	#scp root@$i:/root/kubetopNodecluster$j.csv /root/mck8s_vm/sasi/sasi/results/kubetopNodecluster$j.csv
	#scp root@$i:/root/kubetopPodMcluster$j.csv /root/mck8s_vm/sasi/sasi/results/kubetopPodMcluster$j.csv
	scp root@$i:/root/kubegetpodcluster$j.csv /root/mck8s_vm/sasi/sasi/results/kubegetpodcluster$j.csv
	j=$((j+1))	
done

cp ../node_list_all node_list_all

while read line
do 
echo $line
ip1=$(echo $line | cut -d "." -f 2)
ip2=$(echo $line | cut -d "." -f 3)
break
done < node_list_all

ssh -o StrictHostKeyChecking=no root@10.$ip1.$ip2.3 . /root/mck8s_vm/sasi/sasi/script/dockergetime.sh
scp root@10.$ip1.$ip2.3:/root/scrapetime /root/mck8s_vm/sasi/sasi/results/scrapetime

. /root/mck8s_vm/sasi/sasi/script/dockergettimemanage.sh
#kubectl logs multiclusterscheduler* > log.txt
#mv logs.txt /root/mck8s_vm/sasi/sasi/results/logs.txt
mv kubetopPodD.csv /root/mck8s_vm/sasi/sasi/results/kubetopPodD.csv
mv kubetopPodKS.csv /root/mck8s_vm/sasi/sasi/results/kubetopPodKS.csv
mv kubetopPodKF.csv /root/mck8s_vm/sasi/sasi/results/kubetopPodKF.csv
mv kubetopNodecluster0.csv /root/mck8s_vm/sasi/sasi/results/kubetopNodecluster0.csv
mv kubetopPodMcluster0.csv /root/mck8s_vm/sasi/sasi/results/kubetopPodMcluster0.csv
mv cross /root/mck8s_vm/sasi/sasi/results/cross
mv prom_scrape_acala /root/mck8s_vm/sasi/sasi/results/prom_scrape_acala
mv multi_cluster_scheduling_logs* results/
mv /root/member /root/mck8s_vm/sasi/sasi/results/member

sleep 3
random_number=$((1 + $RANDOM))
scp -o StrictHostKeyChecking=no -r /root/mck8s_vm/sasi/sasi/results chuang@172.16.111.106:/home/chuang/results$random_number

echo "-----------------------copy ok -------------------------------"