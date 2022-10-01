sed -i '1d' node_list
port=30090
j=1
for i in $(cat node_list)
do
    name=cluster$j
	echo "      - job_name: '$name' " >> values.yaml
	echo "        scrape_interval: 5s" >> values.yaml
	echo "        metrics_path: /federate" >> values.yaml
	echo "        honor_labels: true" >> values.yaml
	echo "        scheme: http" >> values.yaml
	echo "        params:" >> values.yaml
	echo "          match[]:" >> values.yaml
	echo "            - '{job=~\"node-exporter\"}'" >> values.yaml
	echo "        tls_config:" >> values.yaml	
	echo "          insecure_skip_verify: true" >> values.yaml		
	echo "        static_configs:" >> values.yaml	
    echo "          - targets: [$i:$port]" >> values.yaml
    echo "            labels:" >> values.yaml
    echo "              cluster_name: $name" >> values.yaml						
    j=$((j+1))
done
