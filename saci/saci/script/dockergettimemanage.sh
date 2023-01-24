docker ps --format "{{.Names}}" | grep k8s_mcs_multiclusterscheduler > name
j=1
for i in $(cat name)
do
    docker cp $i:/logs.csv /root/logs$j.csv
    j=$((j+1))
done