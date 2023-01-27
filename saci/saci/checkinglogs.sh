lastlogs="$(whoami)"
j=0
while :  
do
    mcsname=$(kubectl get pod -o custom-columns=NAME:.metadata.name | grep multiclusterscheduler)
    #echo $mcsname
    logs="$(kubectl logs --tail=1 $mcsname)"
    echo $logs
    if [ "$logs" = "$lastlogs" ]; then
	    ./ delmcs.sh $j
        j=$((j+1))
        sleep 30
    fi
    sleep 15
    lastlogs=$logs
done
