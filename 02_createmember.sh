for i in $(cat node_list)
do
		echo "$i write the IP address and Port to member"
        ssh root@$i docker ps --format "{{.Ports}}{{.Names}}" |grep control| cut -f 1 -d ":" > address
        ssh root@$i docker ps --format "{{.Ports}}{{.Names}}" |grep control| cut -f 5 -d ":" | cut -f 1 -d "-" > port
        ssh root@$i docker ps --format "{{.Names}}" | grep control | cut -f 1 -d "-" > cluster_name
        j=1
        y=1
        for i in $(cat address)
        do
            name=$(awk "NR==${j}" cluster_name)
            port=$(awk "NR==${y}" port)
			echo "$i:$port:$name" >> member					
            j=$((j+1))
            y=$((y+1))
        done
done
mv member /root/member
