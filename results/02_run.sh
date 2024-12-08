mkdir results
chmod 777 topnode.sh
chmod 777 toppodd.sh
chmod 777 toppodkf.sh
chmod 777 toppodks.sh
chmod 777 toppodm.sh
chmod 777 vmdool.sh
chmod 777 cross.sh

python3 scrapetime.py &
./toppodd.sh &
./toppodkf.sh &
./toppodks.sh &
./vmdool.sh &
./topnode.sh &
./toppodm.sh &


while read line
do 
echo $line
ip1=$(echo $line | cut -d "." -f 2)
ip2=$(echo $line | cut -d "." -f 3)
break
done < node_list_all


while read line
do 
echo $line
ip3=$(echo $line | cut -d "." -f 2)
ip4=$(echo $line | cut -d "." -f 3)
break
done < node_list

ssh root@10.$ip1.$ip2.3 timeout 1200 tcpdump -i ens3 src port 31580 and host 10.$ip3.$ip4.2 -nn -q >> cross  &