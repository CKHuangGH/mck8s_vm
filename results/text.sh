curl http://10.158.0.2:30901/metrics > text
ls -alh text > plaintext
mv plaintext /root/mck8s_vm/results/results/plaintext