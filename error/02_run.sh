ssh -o StrictHostKeyChecking=no root@10.158.4.2 kubectl apply -f /root/acala_error/member/deploy_member.yaml
sleep 30
python3 /root/k8s_google_injection/run_deployments_jobs_mck8s.py
sleep 900
./03_getdocker.sh