while read line
do 
echo $line
ip1=$(echo $line | cut -d "." -f 2)
ip2=$(echo $line | cut -d "." -f 3)
break
done < node_list
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
scp member root@10.$ip1.$ip2.3:/root/member