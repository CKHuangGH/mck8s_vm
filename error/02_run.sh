ssh -o StrictHostKeyChecking=no root@10.158.4.2 docker pull chuangtw/acalamember:latest
sleep 10
ssh -o StrictHostKeyChecking=no root@10.158.4.2 kubectl apply -f /root/acala_error/02.member_stander/deploy_member.yaml
sleep 60
python3 /root/k8s_google_injection/run_deployments_jobs_mck8s.py
sleep 1800
./03_getdocker.sh
sleep 5
./04_cptorennes.sh