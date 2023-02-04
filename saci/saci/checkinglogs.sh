lastlogs="$(whoami)"
j=0
while :  
do
    mcsname=$(kubectl get pod -o custom-columns=NAME:.metadata.name | grep multiclusterscheduler)
    #echo $mcsname
    logs="$(kubectl logs --tail=1 $mcsname)"
    echo $logs
    if [ "$logs" = "$lastlogs" ]; then
	    . /root/mck8s_vm/saci/saci/delmcs.sh $j
        j=$((j+1))
        sleep 60
    fi
    lastlogs=$logs
    sleep 120
done
