while read line
do 
echo $line
ip1=$(echo $line | cut -d "." -f 2)
ip2=$(echo $line | cut -d "." -f 3)
break
done < node_list_all

python3 ./script/scrapetime.py &
. ./script/toppodd.sh > /dev/null &
. ./script/toppodkf.sh > /dev/null &
. ./script/toppodks.sh > /dev/null &
. ./script/topnode.sh 0 &
. ./script/toppodm.sh 0 &

ssh root@10.$ip1.$ip2.3 timeout 60 tcpdump -i ens3 src port 31580 -nn -q >> cross  &

j=1
for i in $(cat node_list)
do 
	. /root/mck8s_vm/large-scale/large/script/toppodd.sh > /dev/null &
	. /root/mck8s_vm/large-scale/large/script/toppodkf.sh > /dev/null &
	. /root/mck8s_vm/large-scale/large/script/toppodks.sh > /dev/null &
	. /root/mck8s_vm/large-scale/large/script/topnode.sh $j &
	. /root/mck8s_vm/large-scale/large/script/toppodm.sh $j &
	j=$((j+1))	
done
echo "wait for 60 secs"
sleep 60
