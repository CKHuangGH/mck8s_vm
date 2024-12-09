mv kubetopPodD.csv /root/mck8s_vm/results/results/kubetopPodD.csv
mv kubetopNode.csv /root/mck8s_vm/results/results/kubetopNode.csv
mv kubetopNode2.csv /root/mck8s_vm/results/results/kubetopNode2.csv
mv kubetopPodKS.csv /root/mck8s_vm/results/results/kubetopPodKS.csv
mv kubetopPodKS2.csv /root/mck8s_vm/results/results/kubetopPodKS2.csv
mv kubetopPodM.csv /root/mck8s_vm/results/results/kubetopPodM.csv
mv kubetopPodM2.csv /root/mck8s_vm/results/results/kubetopPodM2.csv
mv kubetopPodKF.csv /root/mck8s_vm/results/results/kubetopPodKF.csv
mv psr.csv /root/mck8s_vm/results/results/psr.csv
mv plaintext /root/mck8s_vm/results/results/plaintext
mv cross /root/mck8s_vm/results/results/cross
mv prom_scrape_rntsm /root/mck8s_vm/results/results/prom_scrape_rntsm
mv exectime /root/mck8s_vm/results/results/exectime
mv exectime_management /root/mck8s_vm/results/results/exectime_management
random_number=$((1 + $RANDOM))
scp -o StrictHostKeyChecking=no -r /root/mck8s_vm/results/results chuang@172.16.111.106:/home/chuang/results$random_number