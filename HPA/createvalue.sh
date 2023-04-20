sed -i '1d' node_list
port=30090
j=1

for i in $(cat node_list)
do
	ip1=$(echo $i | cut -d "." -f 2)
	ip2=$(echo $i | cut -d "." -f 3)
    name=cluster$j
	echo "      - job_name: '$name' " >> values.yaml
	echo "        scrape_interval: 5s" >> values.yaml
	echo "        metrics_path: /federate" >> values.yaml
	echo "        honor_labels: true" >> values.yaml
	echo "        scheme: http" >> values.yaml
	echo "        params:" >> values.yaml
	echo "          match[]:" >> values.yaml
	echo "            - '{job=~\"10.$ip1.$ip2.2:9100\"}'" >> values.yaml
	echo "            - '{job=~\"10.$ip1.$ip2.3:9100\"}'" >> values.yaml
	echo "            - '{job=~\"10.$ip1.$ip2.4:9100\"}'" >> values.yaml
	echo "            - '{job=~\"10.$ip1.$ip2.5:9100\"}'" >> values.yaml
	echo "            - '{job=~\"10.$ip1.$ip2.6:9100\"}'" >> values.yaml
	echo "            - '{job=~\"10.$ip1.$ip2.7:9100\"}'" >> values.yaml
	echo "            - '{job=~\"10.$ip1.$ip2.8:9100\"}'" >> values.yaml
	echo "            - '{job=~\"10.$ip1.$ip2.9:9100\"}'" >> values.yaml
	echo "            - '{job=~\"10.$ip1.$ip2.10:9100\"}'" >> values.yaml
	echo "            - '{job=~\"10.$ip1.$ip2.11:9100\"}'" >> values.yaml
	echo "            - '{job=~\"10.$ip1.$ip2.12:9100\"}'" >> values.yaml
	echo "            - '{job=~\"10.$ip1.$ip2.13:9100\"}'" >> values.yaml
	echo "            - '{job=~\"10.$ip1.$ip2.14:9100\"}'" >> values.yaml
	echo "            - '{job=~\"10.$ip1.$ip2.15:9100\"}'" >> values.yaml
	echo "            - '{job=~\"10.$ip1.$ip2.16:9100\"}'" >> values.yaml
	echo "            - '{job=~\"10.$ip1.$ip2.17:9100\"}'" >> values.yaml
	echo "            - '{job=~\"10.$ip1.$ip2.18:9100\"}'" >> values.yaml
	echo "            - '{job=~\"10.$ip1.$ip2.19:9100\"}'" >> values.yaml
	echo "            - '{job=~\"10.$ip1.$ip2.20:9100\"}'" >> values.yaml
	echo "            - '{job=~\"10.$ip1.$ip2.21:9100\"}'" >> values.yaml
	echo "        tls_config:" >> values.yaml	
	echo "          insecure_skip_verify: true" >> values.yaml		
	echo "        static_configs:" >> values.yaml	
    echo "          - targets: [$i:$port]" >> values.yaml
    echo "            labels:" >> values.yaml
    echo "              cluster_name: $name" >> values.yaml						
    j=$((j+1))
done
