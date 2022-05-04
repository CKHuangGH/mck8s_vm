TimerForPodM=1
NameForPodM=kubetopPodM.csv
NameForPodM2=kubetopPodM2.csv
PodMTime=0
update_file_podm() {
  kubectl --context cluster0 top pod -n monitoring | tr -s '[:blank:]' ',' | tee --append $NameForPodM;
  echo $(date +'%s.%N') | tee --append $NameForPodM;
}

update_file_podm2() {
  kubectl --context cluster1 top pod -n monitoring | tr -s '[:blank:]' ',' | tee --append $NameForPodM2;
  echo $(date +'%s.%N') | tee --append $NameForPodM2;
}

while ((PodMTime < 1200))
do
  update_file_podm
  update_file_podm2
  sleep $TimerForPodM;
  PodMTime=$PodMTime+1
done