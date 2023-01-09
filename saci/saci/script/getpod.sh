i=$1
TimerForNode=1
NameForTopNode=kubegetpodcluster$i.csv

NodeTime=0

update_file_node() {
  kubectl get pod | tr -s '[:blank:]' ',' | tee --append $NameForTopNode;
  echo $(date +'%s.%N') | tee --append $NameForTopNode;
}

while ((NodeTime < 6000))
do
  update_file_node
  sleep $TimerForNode;
  NodeTime=$NodeTime+1
done