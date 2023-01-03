docker ps --format "{{.Names}}" | grep k8s_acala-controller > name
for i in $(cat name)
do
 docker cp $i:/exectime_management /root/
done