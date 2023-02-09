TimerForPodD=1
NameForPodD=kubetopPodD.csv
PodDTime=0
update_file_podD() {
  kubectl --context cluster0 top pod | tr -s '[:blank:]' ',' | tee --append $NameForPodD;
  echo $(date +'%s.%N') | tee --append $NameForPodD;
}

while ((PodDTime < 6000))
do
  update_file_podD
  sleep $TimerForPodD;
  PodDTime=$PodDTime+1
done