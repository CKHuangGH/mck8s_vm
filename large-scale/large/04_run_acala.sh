chmod 777 ./script/toppodd.sh
chmod 777 ./script/toppodkf.sh
chmod 777 ./script/toppodks.sh
chmod 777 ./script/topnode.sh
chmod 777 ./script/toppodm.sh


for i in $(cat node_list)
do 
	ssh root@$i chmod 777 /root/mck8s_vm/large-scale/large/script/toppodd.sh
	ssh root@$i chmod 777 /root/mck8s_vm/large-scale/large/script/toppodkf.sh
	ssh root@$i chmod 777 /root/mck8s_vm/large-scale/large/script/toppodks.sh
	ssh root@$i chmod 777 /root/mck8s_vm/large-scale/large/script/topnode.sh
	ssh root@$i chmod 777 /root/mck8s_vm/large-scale/large/script/toppodm.sh
done



python3 scrapetime.py &
sh ./script/toppodd.sh > /dev/null &
sh ./script/toppodkf.sh > /dev/null &
sh ./script/toppodks.sh > /dev/null &
sh ./script/topnode.sh 0 > /dev/null &
sh ./script/toppodm.sh 0 > /dev/null &

ssh root@10.158.0.3 timeout 60 tcpdump -i ens3 src port 31580 dst net 10.158.0.0/16 -nn -q >> cross  &

j=1
for i in $(cat node_list)
do 
	sh /root/mck8s_vm/large-scale/large/script/toppodd.sh > /dev/null &
	sh /root/mck8s_vm/large-scale/large/script/toppodkf.sh > /dev/null &
	sh /root/mck8s_vm/large-scale/large/script/toppodks.sh > /dev/null &
	sh /root/mck8s_vm/large-scale/large/script/topnode.sh $j > /dev/null &
	sh /root/mck8s_vm/large-scale/large/script/toppodm.sh $j > /dev/null &
	j=$((j+1))	
done

sleep 60
echo "wait for 60 secs"