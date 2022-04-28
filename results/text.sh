TimerForNode=1
NodeTime=0

while ((NodeTime < 600))
do
  curl http://10.158.0.2:30901/metrics > text 
  ls -al text >> plaintext
  sleep $TimerForNode;
  NodeTime=$NodeTime+1
done