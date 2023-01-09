while read line
do 
echo $line
ip1=$(echo $line | cut -d "." -f 2)
ip2=$(echo $line | cut -d "." -f 3)
break
done < node_list_all

#python3 ./script/scrapetime.py &
. ./script/toppodd.sh > /dev/null &
#. ./script/toppodkf.sh > /dev/null &
#. ./script/toppodks.sh > /dev/null &
#. ./script/topnode.sh 0 > /dev/null &
#. ./script/toppodm.sh 0 > /dev/null &

ssh root@10.$ip1.$ip2.3 timeout 6000 tcpdump -i ens3 src port 30090 -nn -q >> cross  &

j=1
for i in $(cat node_list)
do 
	#ssh root@$i . /root/mck8s_vm/saci/saci/script/toppodd.sh > /dev/null &
	#ssh root@$i . /root/mck8s_vm/saci/saci/script/toppodkf.sh > /dev/null &
	#ssh root@$i . /root/mck8s_vm/saci/saci/script/toppodks.sh > /dev/null &
	#ssh root@$i . /root/mck8s_vm/saci/saci/script/topnode.sh $j > /dev/null &
	#ssh root@$i . /root/mck8s_vm/saci/saci/script/toppodm.sh $j > /dev/null &
	ssh root@$i . /root/mck8s_vm/saci/saci/script/getpod.sh $j > /dev/null &
	j=$((j+1))	
done

python3 /root/k8s_google_injection/run_deployments_jobs_mck8s_worst_fit.py

echo "wait for 2400 secs"
sleep 3600
. 03.getdocker.sh