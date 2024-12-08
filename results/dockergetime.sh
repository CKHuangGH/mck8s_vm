docker ps --format "{{.Names}}" | grep k8s_amember-mawd > name
for i in $(cat name)
do
 docker cp $i:/exectime /root/
done