TimerForPodKS=1
NameForPodKS=kubetopPodKS.csv
PodKSTime=0
update_file_podks() {
  kubectl --context cluster0 top pod -n kube-system | tr -s '[:blank:]' ',' | tee --append $NameForPodKS;
  echo $(date +'%s.%N') | tee --append $NameForPodKS;
}

while ((PodKSTime < 6000))
do
  update_file_podks
  sleep $TimerForPodKS;
  PodKSTime=$PodKSTime+1
done