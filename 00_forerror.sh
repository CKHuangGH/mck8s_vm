./01_combineAll.sh
sleep 10
./04_mck8s-2.sh
sleep 10
./05_joining_test.sh
sleep 10
./06_deployment.sh
sleep 100
chmod 777 /root/mck8s_vm/error/01_status.sh
chmod 777 /root/mck8s_vm/error/02_run.sh
chmod 777 /root/mck8s_vm/error/03_getdocker.sh
chmod 777 /root/mck8s_vm/error/04_cptorennes.sh
echo "good to start run error"