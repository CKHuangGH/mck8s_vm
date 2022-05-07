ssh -o StrictHostKeyChecking=no root@10.158.4.2 chmod 777 /root/mck8s_vm/results/dockergetime.sh
ssh -o StrictHostKeyChecking=no root@10.158.4.2 . /root/mck8s_vm/results/dockergetime.sh
scp root@10.158.4.2:/root/exectime /root/mck8s_vm/results/results/exectime
ssh -o StrictHostKeyChecking=no root@10.158.0.3 chmod 777 /root/mck8s_vm/results/dockergettimemanage.sh
ssh -o StrictHostKeyChecking=no root@10.158.0.3 . /root/mck8s_vm/results/dockergettimemanage.sh
scp root@10.158.0.3:/root/exectime_management /root/mck8s_vm/results/results/exectime_management