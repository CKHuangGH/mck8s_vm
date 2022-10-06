python3 scrapetime.py &
. ./script/toppodd.sh > /dev/null &
. ./script/toppodkf.sh > /dev/null &
. ./script/toppodks.sh > /dev/null &
. ./script/topnode.sh 0 > /dev/null &
. ./script/toppodm.sh 0 > /dev/null &

ssh root@10.158.0.3 timeout 60 tcpdump -i ens3 src port 31580 and dst net 10.158.0.0/16 -nn -q >> cross  &

j=1
for i in $(cat node_list)
do 
	. /root/mck8s_vm/large-scale/large/script/toppodd.sh > /dev/null &
	. /root/mck8s_vm/large-scale/large/script/toppodkf.sh > /dev/null &
	. /root/mck8s_vm/large-scale/large/script/toppodks.sh > /dev/null &
	. /root/mck8s_vm/large-scale/large/script/topnode.sh $j > /dev/null &
	. /root/mck8s_vm/large-scale/large/script/toppodm.sh $j > /dev/null &
	j=$((j+1))	
done
echo "wait for 60 secs"
sleep 60
