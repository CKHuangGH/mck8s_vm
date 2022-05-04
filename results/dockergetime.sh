docker ps --format "{{.Names}}" | grep k8s_rntsm > name
for i in $(cat name)
do
 docker cp $i:/exectime /root/
done
scp /root/exectime root@10.158.0.2:/root/mck8s_vm/results/results/exectime