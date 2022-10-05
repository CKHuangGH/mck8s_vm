docker ps --format "{{.Names}}" | grep k8s_rntsm-dsia > name
for i in $(cat name)
do
 docker cp $i:/exectime_management /root/
done