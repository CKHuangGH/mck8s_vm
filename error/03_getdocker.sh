ssh -o StrictHostKeyChecking=no root@10.158.4.2 chmod 777 /root/mck8s_vm/error/dockererror.sh
ssh -o StrictHostKeyChecking=no root@10.158.4.2 . /root/mck8s_vm/error/dockererror.sh
scp root@10.158.4.2:/root/error.csv /root/mck8s_vm/error/results/error.csv
mv mck8s_multiclusterscheduling_cloud_logs* results/