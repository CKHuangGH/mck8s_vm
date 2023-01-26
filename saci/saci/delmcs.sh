docker ps --format "{{.Names}}" | grep k8s_mcs_multiclusterscheduler > name
j=10
for i in $(cat name)
do
    docker cp $i:/logs.csv /root/logs$j.csv
    j=$((j+1))
done

kubectl get pod -o custom-columns=NAME:.metadata.name > mcsname
for i in $(cat mcsname)
do
    kubectl delete pod $i
done