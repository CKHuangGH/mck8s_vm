i=$(awk "NR==1" node_list)
port=30901
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