docker ps --format "{{.Names}}" | grep mcs > name
for i in $(cat name)
do
 docker cp $i:/cluster.csv /root/
done