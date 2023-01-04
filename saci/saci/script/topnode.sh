i=$1
TimerForNode=1
NameForTopNode=kubetopNodecluster$i.csv

NodeTime=0

update_file_node() {
  kubectl top nodes | tr -s '[:blank:]' ',' | tee --append $NameForTopNode;
  echo $(date +'%s.%N') | tee --append $NameForTopNode;
}

while ((NodeTime < 5700))
do
  update_file_node
  sleep $TimerForNode;
  NodeTime=$NodeTime+1
done