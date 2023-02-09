lastlogs="$(whoami)"
j=0
while :  
do
    mcsname=$(kubectl get pod -o custom-columns=NAME:.metadata.name | grep multiclusterscheduler)
    #echo $mcsname
    logs="$(kubectl logs --tail=1 $mcsname)"
    echo $logs

    if [ "$logs" = "$lastlogs" ]; then
	    . /root/mck8s_vm/sasi/sasi/delmcs.sh $j
        if [ $j -eq 3 ]; then
            break
        fi
        j=$((j+1))
        sleep 60
    fi
    lastlogs=$logs
    sleep 120
done
