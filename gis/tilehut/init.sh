mkdir -p host_keys
ssh-keygen -t ed25519 -f host_keys/ssh_host_ed25519_key -N '' < /dev/null 2>&1 >/dev/null
ssh-keygen -t rsa -b 4096 -f host_keys/ssh_host_rsa_key -N '' < /dev/null 2>&1 >/dev/null

chmod 400 ./host_keys/ssh_host_ed25519_key
chmod 400 ./host_keys/ssh_host_rsa_key