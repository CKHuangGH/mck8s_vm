for i in $(cat node_list)
do
		echo "$i write the IP address and Port to value.yaml"
        ssh root@$i docker ps --format "{{.Ports}}{{.Names}}" |grep control| cut -f 1 -d ":" > address
        ssh root@$i docker ps --format "{{.Ports}}{{.Names}}" |grep control| cut -f 3 -d ":" | cut -f 1 -d "-" > port
        ssh root@$i docker ps --format "{{.Names}}" | grep control | cut -f 1 -d "-" > cluster_name
        j=1
        y=1
        for i in $(cat address)
        do
            name=$(awk "NR==${j}" cluster_name)
            port=$(awk "NR==${y}" port)
			echo "      - job_name: '$name' " >> values.yaml
			echo "        scrape_interval: 5s" >> values.yaml
			echo "        metrics_path: /federate" >> values.yaml
			echo "        honor_labels: true" >> values.yaml
			echo "        scheme: http" >> values.yaml
			echo "        params:" >> values.yaml
			echo "          match[]:" >> values.yaml
			echo "            - '{__name__=~\"job:.*\"}'" >> values.yaml
			echo "            - '{job=\"prometheus\"}'" >> values.yaml
			echo "            - '{job=\"kubernetes-nodes\"}'" >> values.yaml
			echo "            - '{job=\"kubernetes-cadvisor\"}'" >> values.yaml
			echo "            - '{name=~\".+\"}'" >> values.yaml
			echo "            - '{job=\"kubernetes-service-endpoints\"}'" >> values.yaml
			echo "            - '{job=\"kubernetes-pods\"}'" >> values.yaml
			echo "            - '{job=\"kubernetes-apiservers\"}'" >> values.yaml
			echo "            - '{pod_name=\".+\"}'" >> values.yaml
			echo "            - '{namespace=\"global\"}'" >> values.yaml
			echo "            - '{job=\"node-exporter\"}'" >> values.yaml			
			echo "        tls_config:" >> values.yaml	
			echo "          insecure_skip_verify: true" >> values.yaml		
			echo "        static_configs:" >> values.yaml	
            echo "          - targets: [$i:$port]" >> values.yaml
            echo "            labels:" >> values.yaml
            echo "              cluster_name: $name" >> values.yaml						
            j=$((j+1))
            y=$((y+1))
        done
done
