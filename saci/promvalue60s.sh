port=30090
j=1

for i in $(cat node_list)
do
	ip1=$(echo $i | cut -d "." -f 2)
	ip2=$(echo $i | cut -d "." -f 3)
    name=cluster$j
	echo "      - job_name: '$name' " >> values.yaml
	echo "        scrape_interval: 60s" >> values.yaml
	echo "        metrics_path: /federate" >> values.yaml
	echo "        honor_labels: true" >> values.yaml
	echo "        scheme: http" >> values.yaml
	echo "        params:" >> values.yaml
	echo "          match[]:" >> values.yaml
	echo "            - '{instance=~\"10.$ip1.$ip2.2:9100\"}'" >> values.yaml
	echo "            - '{instance=~\"10.$ip1.$ip2.3:9100\"}'" >> values.yaml
	echo "            - '{instance=~\"10.$ip1.$ip2.4:9100\"}'" >> values.yaml
	echo "            - '{instance=~\"10.$ip1.$ip2.5:9100\"}'" >> values.yaml
	echo "            - '{instance=~\"10.$ip1.$ip2.6:9100\"}'" >> values.yaml
	echo "        tls_config:" >> values.yaml	
	echo "          insecure_skip_verify: true" >> values.yaml		
	echo "        static_configs:" >> values.yaml	
    echo "          - targets: [$i:$port]" >> values.yaml
    echo "            labels:" >> values.yaml
    echo "              cluster_name: $name" >> values.yaml						
    j=$((j+1))
done

while read line
do 
echo $line
ip1=$(echo $line | cut -d "." -f 2)
ip2=$(echo $line | cut -d "." -f 3)
break
done < node_list_all

ssh -o StrictHostKeyChecking=no root@10.$ip1.$ip2.3 ssh-keyscan 10.$ip1.$ip2.2 >> /root/.ssh/known_hosts
ssh-keyscan 10.$ip1.$ip2.3 >> /root/.ssh/known_hosts