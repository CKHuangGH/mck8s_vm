chmod 777 topnode.sh
chmod 777 toppodd.sh
chmod 777 toppodkf.sh
chmod 777 toppodks.sh
chmod 777 toppodm.sh
chmod 777 vmdool.sh
chmod 777 text.sh
chmod 777 cross.sh

./toppodd.sh &
./toppodkf.sh &
./toppodks.sh &
./vmdool.sh &
./topnode.sh &
./toppodm.sh &
./cross.sh &
./text.sh
python3 scrapetime.py &