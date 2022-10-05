cp node_list node_list_all
sed -i '1d' node_list
ls /root/.kube/
read -p "please enter the last cluster number in .kube: " number

./acalavalue.sh
./combineAll.sh $number
./mck8s-management.sh

#./05_joining_test.sh $number
# chmod 777 ./large/01_deploy.sh
# chmod 777 ./large/02_check.sh
# chmod 777 ./large/error/03_getdocker.sh
# chmod 777 ./large/error/04_cptorennes.sh