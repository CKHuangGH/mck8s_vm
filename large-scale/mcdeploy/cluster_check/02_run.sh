kubectl apply -f /root/mck8s_vm/mcdeploy/manifests/controllers/mcsv1.yaml
echo "sleep for 120secs (v1-------------------------------------------)"
sleep 120
python3 /root/k8s_google_injection/run_deployments_jobs_mck8s_worst_fit.py
sleep 10
chmod 777 03_getcluster.sh
./03_getcluster.sh
sleep 5
chmod 777 04_cptorennes.sh
./04_cptorennes.sh