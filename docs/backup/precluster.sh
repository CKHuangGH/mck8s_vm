for i in {1..30}
do
echo "  apiServerAddress: \"$(ifconfig eno1 |grep "inet " | cut -f 10 -d " ")"\" >> /root/mck8s/config/kind-example-config-$i.yaml
done

ssh-keyscan $1 >> /root/.ssh/known_hosts
sudo sysctl fs.inotify.max_user_watches=524288
sudo sysctl fs.inotify.max_user_instances=512