chmod 777 topnode.sh
chmod 777 toppodd.sh
chmod 777 toppodkf.sh
chmod 777 toppodks.sh
chmod 777 toppodm.sh
chmod 777 vmdool.sh
chmod 777 cross.sh

	ssh root@$i chmod 777 /root/mck8s_vm/large-scale/worker_node.sh
	ssh root@$i sh /root/mck8s_vm/large-scale/worker_node.sh $cluster &

python3 scrapetime.py &
./toppodd.sh &
./toppodkf.sh &
./toppodks.sh &
./vmdool.sh &
./topnode.sh &
./toppodm.sh &
ssh root@10.158.0.3 timeout 1200 tcpdump -i ens3 src port 31580 and host 10.158.4.2 -nn -q >> cross  &

for i in $(cat node_list)
do 
	echo "ping $i"
	ping $i -c 4 >> ./results/ping.txt
done