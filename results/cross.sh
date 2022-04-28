TimerForNode=1
NodeTime=0

while ((NodeTime < 600))
do
  tcpdump -i ens3 src port 31580 and host 10.158.4.2 -nn -q >> cross
  sleep $TimerForNode;
  NodeTime=$NodeTime+1
done