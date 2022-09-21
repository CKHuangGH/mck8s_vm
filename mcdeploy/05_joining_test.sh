ls /root/.kube/
read -p "please input how many ckuster want to join the mck8s_lsv(ex: 3):" cluster
time for i in `seq 1 $cluster`
do
kubefedctl join cluster$i --cluster-context cluster$i --host-cluster-context cluster0 --v=2
done