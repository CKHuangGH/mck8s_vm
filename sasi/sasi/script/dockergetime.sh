docker ps --format "{{.Names}}" | grep k8s_sasi-proxy > name
for i in $(cat name)
do
    docker cp $i:/scrapetime /root/
done