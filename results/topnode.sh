TimerForNode=1
NameForTopNode=kubetopNode.csv
NodeTime=0

update_file_node() {
  kubectl --context cluster0 top nodes | tr -s '[:blank:]' ',' | tee --append $NameForTopNode;
  echo $(date +'%s.%N') | tee --append $NameForTopNode;
}

while ((NodeTime < 600))
do
  update_file_node
  sleep $TimerForNode;
  NodeTime=$NodeTime+1
done