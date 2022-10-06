chmod 777 ./scripet/toppodd.sh
chmod 777 ./scripet/toppodkf.sh
chmod 777 ./scripet/toppodks.sh
chmod 777 ./scripet/topnode.sh
chmod 777 ./scripet/toppodm.sh


for i in $(cat node_list)
do 
	ssh root@$i chmod 777 /root/mck8s_vm/large-scale/large/scripet/topnode.sh
	ssh root@$i chmod 777 /root/mck8s_vm/large-scale/large/scripet/toppodm.sh
done



python3 scrapetime.py &
./scripet/toppodd.sh &
./scripet/toppodkf.sh &
./scripet/toppodks.sh &

./scripet/topnode.sh 0 &
./scripet/toppodm.sh &

ssh root@10.158.0.3 timeout 1800 tcpdump -i ens3 src port 31580 -nn -q >> cross  &


for i in $(cat node_list)
do 
	sh /root/mck8s_vm/large-scale/large/scripet/topnode.sh $j &
	ssh root@$i chmod 777 /root/mck8s_vm/large-scale/worker_node.sh
	j=$((j+1))	
done