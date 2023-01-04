j=1
for i in $(cat node_list)
do 
    #ssh -o StrictHostKeyChecking=no root@$i . /root/mck8s_vm/large-scale/large/script/dockergetime.sh
    #scp root@$i:/root/exectime /root/mck8s_vm/large-scale/large/results/exectime_cluster$j
	scp root@$i:/root/kubetopNodecluster$j.csv /root/mck8s_vm/saci/saci/results/kubetopNodecluster$j.csv
	scp root@$i:/root/kubetopPodMcluster$j.csv /root/mck8s_vm/saci/saci/results/kubetopPodMcluster$j.csv
	scp root@$i:/root/kubegetpodcluster$j.csv /root/mck8s_vm/saci/saci/results/kubegetpodcluster$j.csv
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

#ssh -o StrictHostKeyChecking=no root@10.$ip1.$ip2.3 . /root/mck8s_vm/saci/saci/script/dockergettimemanage.sh
#scp root@10.$ip1.$ip2.3:/root/exectime_management /root/mck8s_vm/large-scale/large/results/exectime_management


mv kubetopPodD.csv /root/mck8s_vm/saci/saci/results/kubetopPodD.csv
mv kubetopPodKS.csv /root/mck8s_vm/saci/saci/results/kubetopPodKS.csv
mv kubetopPodKF.csv /root/mck8s_vm/saci/saci/results/kubetopPodKF.csv
mv kubetopNodecluster0.csv /root/mck8s_vm/saci/saci/results/kubetopNodecluster0.csv
mv kubetopPodMcluster0.csv /root/mck8s_vm/saci/saci/results/kubetopPodMcluster0.csv
mv cross /root/mck8s_vm/saci/saci/results/cross
mv prom_scrape_acala /root/mck8s_vm/saci/saci/results/prom_scrape_acala

sleep 3

scp -o StrictHostKeyChecking=no -r /root/mck8s_vm/saci/saci/results chuang@172.16.111.106:/home/chuang/results

echo "-----------------------copy ok -------------------------------"