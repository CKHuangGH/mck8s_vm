sed -i '1d' node_list
port=31580
j=1
for i in $(cat node_list)
do
    name=cluster$j
	echo "$i:$port:$name" >> member	
    j=$((j+1))				
done
#mv member /root/member
scp member root@10.158.0.3:/root/member