TimerForNode=1
NameForTopNode=kubetopNode.csv
NodeTime=0

update_file_node() {
  kubectl --context cluster0 top nodes | tr -s '[:blank:]' ',' | tee --append $NameForTopNode;
  echo $(date +'%s.%N') | tee --append $NameForTopNode;
}

while ((NodeTime < 120))
do
  update_file_node &
  sleep $TimerForNode;
  NodeTime=$NodeTime+1
done

sleep 5

TimerForPodD=1
NameForPodD=kubetopPodD.csv
PodDTime=0
update_file_podD() {
  kubectl --context cluster0 top pod | tr -s '[:blank:]' ',' | tee --append $NameForPodD;
  echo $(date +'%s.%N') | tee --append $NameForPodD;
}

while ((PodDTime < 120))
do
  update_file_podD &
  sleep $TimerForPodD;
  PodDTime=$PodDTime+1
done

sleep 5

TimerForPodKS=1
NameForPodKS=kubetopPodKS.csv
PodKSTime=0
update_file_podks() {
  kubectl --context cluster0 top pod -n kube-system | tr -s '[:blank:]' ',' | tee --append $NameForPodKS;
  echo $(date +'%s.%N') | tee --append $NameForPodKS;
}

while ((PodKSTime < 120))
do
  update_file_podks &
  sleep $TimerForPodKS;
  PodKSTime=$PodKSTime+1
done

sleep 5

TimerForPodM=1
NameForPodM=kubetopPodM.csv
PodMTime=0
update_file_podm() {
  kubectl --context cluster0 top pod -n monitoring | tr -s '[:blank:]' ',' | tee --append $NameForPodM;
  echo $(date +'%s.%N') | tee --append $NameForPodM;
}

while ((PodMTime < 120))
do
  update_file_podm &
  sleep $TimerForPodM;
  PodMTime=$PodMTime+1
done

sleep 5
TimerForPodKF=1
NameForPodKF=kubetopPodKF.csv
PodKFTime=0
update_file_PodKF() {
  kubectl --context cluster0 top pod -n kube-federation-system | tr -s '[:blank:]' ',' | tee --append $NameForPodKF;
  echo $(date +'%s.%N') | tee --append $NameForPodKF;
}

while ((PodKFTime < 120))
do
  update_file_PodKF &
  sleep $TimerForPodKF;
  PodKFTime=$PodKFTime+1
done

sleep 5
INTERVAL=1
OUTNAME=dockerstats.csv
i=0
update_file() {
  docker stats --no-stream --format "table {{.Name}},{{.CPUPerc}},{{.MemUsage}},{{.NetIO}},{{.BlockIO}},{{.PIDs}}" | tr -s '[:blank:]' ',' | tee --append $OUTNAME;
  echo $(date +'%s.%N') | tee --append $OUTNAME;
}

while ((i < 120))
do
  update_file &
  sleep $INTERVAL;
  i=$i+1
done