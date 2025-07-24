#!/bin/bash

echo "Generate private key to access Nomad CLI for a month"

mkdir -p $HOME/nomad/
cd $HOME/nomad/

USERNAME=`whoami`

echo "whoami:" $USERNAME

echo "Generate ec:384 private key"
openssl ecparam -name secp384r1 -genkey -noout -out privkey.pem

echo "Generate csr for ${USERNAME}.person.songsterr.com"
openssl req -new -key privkey.pem -out csr.pem -subj "/CN=${USERNAME}.person.songsterr.com"

echo "Send CSR to vault"
vault write -format=json pki_ops/sign/person csr=@csr.pem format=pem_bundle ttl="30d" > result.json

cat result.json | jq -r '.data.certificate' > cert.pem
cat result.json | jq -r '.data.ca_chain[]' > cachain.pem

rm result.json

echo "Done. Run nomad status:"

nomad status