TimerForPodKF=1
NameForPodKF=kubetopPodKF.csv
PodKFTime=0
update_file_PodKF() {
  kubectl --context cluster0 top pod -n kube-federation-system | tr -s '[:blank:]' ',' | tee --append $NameForPodKF;
  echo $(date +'%s.%N') | tee --append $NameForPodKF;
}

while ((PodKFTime < 1800))
do
  update_file_PodKF
  sleep $TimerForPodKF;
  PodKFTime=$PodKFTime+1
done