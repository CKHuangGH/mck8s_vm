ls /root/.kube/
read -p "please enter the last cluster number in .kube: " number

./01_combineAll.sh $number
./createvalue.sh
./04_mck8s-2.sh

#./05_joining_test.sh $number
# chmod 777 /root/mck8s_vm/error/01_status.sh
# chmod 777 /root/mck8s_vm/error/02_run.sh
# chmod 777 /root/mck8s_vm/error/03_getdocker.sh
# chmod 777 /root/mck8s_vm/error/04_cptorennes.sh