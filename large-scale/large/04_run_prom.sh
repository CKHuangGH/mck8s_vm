while read line
do 
echo $line
ip1=$(echo $line | cut -d "." -f 2)
ip2=$(echo $line | cut -d "." -f 3)
break
done < node_list_all

. ./script/toppodd.sh > /dev/null &
. ./script/toppodkf.sh > /dev/null &
. ./script/toppodks.sh > /dev/null &
. ./script/topnode.sh 0 > /dev/null &
. ./script/toppodm.sh 0 &

ssh root@10.$ip1.$ip2.3 timeout 1800 tcpdump -i ens3 src port 30090 -nn -q >> cross  &

j=1
for i in $(cat node_list)
do 
	ssh root@$i . /root/mck8s_vm/large-scale/large/script/toppodd.sh > /dev/null &
	ssh root@$i . /root/mck8s_vm/large-scale/large/script/toppodkf.sh > /dev/null &
	ssh root@$i . /root/mck8s_vm/large-scale/large/script/toppodks.sh > /dev/null &
	ssh root@$i . /root/mck8s_vm/large-scale/large/script/topnode.sh $j > /dev/null &
	ssh root@$i . /root/mck8s_vm/large-scale/large/script/toppodm.sh $j &
	j=$((j+1))	
done

echo "wait for 1600 secs"
sleep 2400
. 05.getdocker.sh