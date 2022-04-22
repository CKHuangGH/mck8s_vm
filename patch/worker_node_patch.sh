#!/bin/bash
min=$1
max=$2
j=$3
#reload the grafana instance
for i in `seq $min $max`
do
echo "copy image to worker"
docker cp /root/grafana.tar cluster$i-worker:/root
echo "exporting image"
docker exec cluster$i-worker ctr -n k8s.io image import /root/grafana.tar
echo "delete pod"
kubectl --context cluster$i delete pod -l app.kubernetes.io/name=grafana -n monitoring
done

echo "-------------------------------------- $j patch OK --------------------------------------"