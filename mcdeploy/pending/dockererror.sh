docker ps --format "{{.Names}}" | grep k8s_acala-member > name
for i in $(cat name)
do
 docker cp $i:/error.csv /root/
done