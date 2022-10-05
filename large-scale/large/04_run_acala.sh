chmod 777 toppodd.sh
chmod 777 toppodkf.sh
chmod 777 toppodks.sh

chmod 777 topnode.sh
chmod 777 toppodm.sh
chmod 777 vmdool.sh
chmod 777 cross.sh

python3 scrapetime.py &
./toppodd.sh &
./toppodkf.sh &
./toppodks.sh &

./topnode.sh &
./toppodm.sh &
ssh root@10.158.0.3 timeout 1200 tcpdump -i ens3 src port 31580 -nn -q >> cross  &

for i in $(cat node_list)
do 
	sh /root/mck8s_vm/large-scale//topnode.sh &
	ssh root@$i chmod 777 /root/mck8s_vm/large-scale/worker_node.sh
	ssh root@$i sh /root/mck8s_vm/large-scale/worker_node.sh $cluster &
done