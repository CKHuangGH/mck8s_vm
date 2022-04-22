for i in {1..20}
do
echo "  apiServerAddress: \"$(ifconfig eno1 |grep "inet " | cut -f 10 -d " ")"\" >> /root/mck8s_lsv/remote_script/config_01/kind-example-config-$i.yaml
echo "  apiServerAddress: \"$(ifconfig eno1 |grep "inet " | cut -f 10 -d " ")"\" >> /root/mck8s_lsv/remote_script/config_02/kind-example-config-$i.yaml
echo "  apiServerAddress: \"$(ifconfig eno1 |grep "inet " | cut -f 10 -d " ")"\" >> /root/mck8s_lsv/remote_script/config_03/kind-example-config-$i.yaml
done

ssh-keyscan $1 >> /root/.ssh/known_hosts
sudo sysctl fs.inotify.max_user_watches=524288
sudo sysctl fs.inotify.max_user_instances=512