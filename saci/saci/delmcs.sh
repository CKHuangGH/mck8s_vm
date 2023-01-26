kubectl get pod -o custom-columns=NAME:.metadata.name > mcsname
for i in $(cat mcsname)
do
    kubectl delete pod $i
done