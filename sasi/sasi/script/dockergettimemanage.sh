docker ps --format "{{.Names}}" | grep k8s_mcs_multiclusterscheduler > name
j=100
for i in $(cat name)
do
    docker cp $i:/logs.csv /root/mck8s_vm/sasi/sasi/results/logs$j.csv
    j=$((j+1))
done