docker ps --format "{{.Names}}" | grep k8s_mcs_multiclusterscheduler > name
for i in $(cat name)
do
 docker cp $i:/logs.csv /root/
done