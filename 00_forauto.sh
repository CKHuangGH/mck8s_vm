cp node_list node_list_all
./01_combineAll.sh
sleep 10
./02_acalavalue.sh
sleep 10
./03_createmember.sh
sleep 10
./04_mck8s-2.sh
sleep 10
./05_joining_test.sh
sleep 10
./06_deployment.sh
sleep 100

echo "good to start run error"