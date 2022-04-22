echo "write the IP address and Port to value.yaml"
docker ps --format "{{.Ports}}{{.Names}}" |grep control| cut -f 1 -d ":" > address
docker ps --format "{{.Ports}}{{.Names}}" |grep control| cut -f 5 -d ":" | cut -f 1 -d "-" > port
i=$(awk "NR==1" address)
port=$(awk "NR==1" port)
echo "      - job_name: 'rntsm' " >> values.yaml
echo "        scrape_interval: 5s" >> values.yaml
echo "        metrics_path: /metrics" >> values.yaml
echo "        honor_labels: true" >> values.yaml
echo "        scheme: http" >> values.yaml
echo "        tls_config:" >> values.yaml	
echo "          insecure_skip_verify: true" >> values.yaml		
echo "        static_configs:" >> values.yaml	
echo "          - targets: [$i:$port]" >> values.yaml
echo "            labels:" >> values.yaml
echo "              cluster_name: rntsm" >> values.yaml