for j in $(cat node_list)
do
  max=0
  ssh root@$j kind get clusters | cut -f 2 -d "r" > worker
  for i in $(cat worker)
  do
    if [ $i -gt $max ];then
      max=$i
    fi
  done
  echo $max

  min=1000
  for i in $(cat worker)
  do
    if [ $i -lt $min ];then
      min=$i
    fi
  done
  echo $min

ssh root@$j sh /root/mck8s_lsv/worker_node_patch.sh $min $max $j &
done