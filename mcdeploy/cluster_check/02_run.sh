kubectl apply -f /root/mck8s_vm/mcdeploy/manifests/controllers/mcsv1.yaml
echo "sleep for 120secs (v1-------------------------------------------)"
sleep 120
python3 /root/k8s_google_injection/run_deployments_jobs_mck8s_worst_fit.py
./03_getdocker.sh
sleep 5
./04_cptorennes.sh