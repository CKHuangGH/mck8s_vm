mv kubetopPodD.csv /root/mck8s_lsv/results/results/kubetopPodD.csv
mv kubetopNode.csv /root/mck8s_lsv/results/results/kubetopNode.csv
mv kubetopPodKS.csv /root/mck8s_lsv/results/results/kubetopPodKS.csv
mv kubetopPodM.csv /root/mck8s_lsv/results/results/kubetopPodM.csv
mv kubetopPodKF.csv /root/mck8s_lsv/results/results/kubetopPodKF.csv
mv psr.csv /root/mck8s_lsv/results/results/psr.csv
mv dockerstats.csv /root/mck8s_lsv/results/results/dockerstats.csv

scp -r /root/mck8s_lsv/results/results chuang@172.16.111.106:/home/chuang/results