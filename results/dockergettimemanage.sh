docker ps --format "{{.Names}}" | grep k8s_rntsm-dsia > name
for i in $(cat name)
do
 docker cp $i:/exectime_management /root/
done
scp /root/exectime_management root@10.158.0.2:/root/mck8s_vm/results/results/exectime_management