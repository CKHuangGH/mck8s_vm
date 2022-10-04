docker ps --format "{{.Names}}" | grep k8s_rntsm > name
for i in $(cat name)
do
 docker cp $i:/exectime /root/
done