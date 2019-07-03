# Inden første start

Inden første start skal der genereres nye host keys.

Kør `init.sh` scriptet.

# Nye public keys

For at generere nye public keys kan `ssh-keygen` benyttes.

Kommandoen er

```shell
ssh-keygen -t rsa -b 4096
```

Nye public keys tilføjes i pub_keys mappen.  
Vær sikker på at du tilføjer din public key og IKKE din private key.

Når de er tilføjet skal ftp-serveren genstartes.

Dette gøres med 

```shell
make re-ftp
```
