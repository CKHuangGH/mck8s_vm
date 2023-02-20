th=$1
i=$(awk "NR==1" node_list_all)
port=30901
echo "      - job_name: 'sasi' " >> values.yaml
echo "        scrape_interval: 5s" >> values.yaml
echo "        metrics_path: /metrics" >> values.yaml
echo "        honor_labels: true" >> values.yaml
echo "        scheme: http" >> values.yaml
echo "        tls_config:" >> values.yaml	
echo "          insecure_skip_verify: true" >> values.yaml		
echo "        static_configs:" >> values.yaml	
echo "          - targets: [$i:$port]" >> values.yaml
echo "            labels:" >> values.yaml
echo "              cluster_name: sasi" >> values.yaml

while read line
do 
echo $line
ip1=$(echo $line | cut -d "." -f 2)
ip2=$(echo $line | cut -d "." -f 3)
break
done < node_list_all

ssh -o StrictHostKeyChecking=no root@10.$ip1.$ip2.3 ssh-keyscan 10.$ip1.$ip2.2 >> /root/.ssh/known_hosts
ssh-keyscan 10.$ip1.$ip2.3 >> /root/.ssh/known_hosts

port=30090
j=1
for q in $(cat node_list)
do
    name=cluster$j
	echo "$q:$port:$name:$th" >> member	
    j=$((j+1))				
done

cp member /root/member

scp member root@10.$ip1.$ip2.3:/root/member