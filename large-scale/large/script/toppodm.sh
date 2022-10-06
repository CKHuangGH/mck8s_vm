i=$1
TimerForPodM=1
NameForPodM=kubetopPodMcluster$i.csv

PodMTime=0
update_file_podm() {
  kubectl top pod -n monitoring | tr -s '[:blank:]' ',' | tee --append $NameForPodM;
  echo $(date +'%s.%N') | tee --append $NameForPodM;
}

while ((PodMTime < 60))
do
  update_file_podm
  sleep $TimerForPodM;
  PodMTime=$PodMTime+1
done