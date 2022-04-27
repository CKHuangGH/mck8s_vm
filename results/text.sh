curl 10.158.0.2 > text
ls -l --block-size=m text > plaintext
mv plaintext /root/mck8s_vm/results/results/plaintext