#!/usr/bin/env sh

USERNAME=`whoami`
VAULT_CACERT=""

echo "whoami:" $USERNAME

echo "Generate ec:384 private key"
openssl ecparam -name secp384r1 -genkey -noout -out privkey.pem

echo "Generate csr for ${USERNAME}.person.songsterr.com"
openssl req -new -key privkey.pem -out csr.pem -subj "/CN=${USERNAME}.person.songsterr.com"

echo "Send CSR to vault"
vault write -format=json pki_ops/sign/person csr=@csr.pem format=pem_bundle ttl="30d" > result.json

cat result.json | jq -r '.data.certificate' > cert.pem
cat result.json | jq -r '.data.ca_chain[]' > chain.pem

# -legacy to fix openssl v3 incompatibility in macOS https://stackoverflow.com/a/74792849
openssl pkcs12 -export -legacy -inkey privkey.pem -in cert.pem -passout pass:password -out person.p12

echo "Copy person.p12 to ~/.ssh"
cp person.p12 ~/.ssh

echo "Cleanup"
rm -f privkey.pem csr.pem cert.pem chain.pem person.p12 result.json

echo "All done. Now open chrome://settings/certificates and import person.p12 from .ssh directory. Password is literally 'password'"