echo "1. check kube-system namespace"
echo "2. check monitoring namespace"
echo "3. check federation namespace"
echo "4. check federation status"
read -p "please input number:" function


if (( $function == 1 ))
then
read -p "please input start, end:" start end
for i in `seq $start $end`
do
	echo "cluster$i"
    kubectl --context cluster$i get pod -n kube-system
done
fi

if (( $function == 2 ))
then
read -p "please input start, end:" start end
for i in `seq $start $end`
do
	echo "cluster$i"
    kubectl --context cluster$i get pod -n monitoring
done
fi

if (( $function == 3 ))
then
	echo "cluster$i"
    kubectl --context cluster0 get pod -n kube-federation-system

fi

if (( $function == 4 ))
then
	echo "cluster0"
    kubectl --context cluster0 -n kube-federation-system get kubefedclusters
fi