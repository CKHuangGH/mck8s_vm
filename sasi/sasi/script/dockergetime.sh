docker ps --format "{{.Names}}" | grep k8s_amember > name
for i in $(cat name)
do
 docker cp $i:/exectime /root/
done