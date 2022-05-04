TimerForNode=1
NameForTopNode=kubetopNode.csv
NameForTopNode2=kubetopNode2.csv
NodeTime=0

update_file_node() {
  kubectl --context cluster0 top nodes | tr -s '[:blank:]' ',' | tee --append $NameForTopNode;
  echo $(date +'%s.%N') | tee --append $NameForTopNode;
}

update_file_node2() {
  kubectl --context cluster1 top nodes | tr -s '[:blank:]' ',' | tee --append $NameForTopNode2;
  echo $(date +'%s.%N') | tee --append $NameForTopNode2;
}

while ((NodeTime < 1200))
do
  update_file_node
  update_file_node2
  sleep $TimerForNode;
  NodeTime=$NodeTime+1
done