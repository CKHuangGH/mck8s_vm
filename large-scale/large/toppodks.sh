TimerForPodKS=1
NameForPodKS=kubetopPodKS.csv
NameForPodKS2=kubetopPodKS2.csv
PodKSTime=0
update_file_podks() {
  kubectl --context cluster0 top pod -n kube-system | tr -s '[:blank:]' ',' | tee --append $NameForPodKS;
  echo $(date +'%s.%N') | tee --append $NameForPodKS;
}
update_file_podks2() {
  kubectl --context cluster1 top pod -n kube-system | tr -s '[:blank:]' ',' | tee --append $NameForPodKS2;
  echo $(date +'%s.%N') | tee --append $NameForPodKS2;
}
while ((PodKSTime < 1200))
do
  update_file_podks
  update_file_podks2
  sleep $TimerForPodKS;
  PodKSTime=$PodKSTime+1
done