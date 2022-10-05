chmod 777 topnode.sh
chmod 777 toppodd.sh
chmod 777 toppodkf.sh
chmod 777 toppodks.sh
chmod 777 toppodm.sh
chmod 777 vmdool.sh
chmod 777 cross.sh

python3 scrapetime2.py &
./toppodd.sh &
./toppodkf.sh &
./toppodks.sh &
./vmdool.sh &
./topnode.sh &
./toppodm.sh &
ssh root@10.158.0.3 timeout 1200 tcpdump -i ens3 src port 30090 and host 10.158.4.2 -nn -q >> cross  &