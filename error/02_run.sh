kubectl apply -f /root/acala_error/member/deploy_member.yaml
python3 /root/k8s_google_injection/run_deployments_jobs_mck8s.py
sleep(1800)
./03_getdocker.sh