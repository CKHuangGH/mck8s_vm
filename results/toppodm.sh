TimerForPodM=1
NameForPodM=kubetopPodM.csv
PodMTime=0
update_file_podm() {
  kubectl --context cluster0 top pod -n monitoring | tr -s '[:blank:]' ',' | tee --append $NameForPodM;
  echo $(date +'%s.%N') | tee --append $NameForPodM;
}

while ((PodMTime < 600))
do
  update_file_podm
  sleep $TimerForPodM;
  PodMTime=$PodMTime+1
done