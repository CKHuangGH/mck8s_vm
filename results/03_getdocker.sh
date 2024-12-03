
while read line
do 
echo $line
ip1=$(echo $line | cut -d "." -f 2)
ip2=$(echo $line | cut -d "." -f 3)
break
done < node_list_all


while read line
do 
echo $line
ip3=$(echo $line | cut -d "." -f 2)
ip4=$(echo $line | cut -d "." -f 3)
break
done < node_list

ssh -o StrictHostKeyChecking=no root@10.$ip3.$ip4.2 chmod 777 /root/mck8s_vm/results/dockergetime.sh
ssh -o StrictHostKeyChecking=no root@10.$ip3.$ip4.2 . /root/mck8s_vm/results/dockergetime.sh
scp root@10.$ip3.$ip4.2:/root/exectime /root/mck8s_vm/results/results/exectime
ssh -o StrictHostKeyChecking=no root@10.$ip1.$ip2.3 chmod 777 /root/mck8s_vm/results/dockergettimemanage.sh
ssh -o StrictHostKeyChecking=no root@10.$ip1.$ip2.3 . /root/mck8s_vm/results/dockergettimemanage.sh
scp root@10.$ip1.$ip2.3:/root/exectime_management /root/mck8s_vm/results/results/exectime_management