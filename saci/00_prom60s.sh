cp node_list node_list_all
sed -i '1d' node_list
ls /root/.kube/
read -p "please enter the last cluster number in .kube: " number

./promvalue60s.sh
./combineAll.sh $number
./mck8s-management.sh

#./05_joining_test.sh $number
# chmod 777 /root/mck8s_vm/error/01_status.sh
# chmod 777 /root/mck8s_vm/error/02_run.sh
# chmod 777 /root/mck8s_vm/error/03_getdocker.sh
# chmod 777 /root/mck8s_vm/error/04_cptorennes.sh