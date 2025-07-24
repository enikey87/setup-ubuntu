#!/bin/bash

# Simple script to fetch Songsterr certificates from host and add to trusted store

set -e

echo "Fetching certificates from a2.ops.songsterr.com:4646..."

# Fetch the certificate chain from the host
openssl s_client -connect a2.ops.songsterr.com:4646 -servername a2.ops.songsterr.com -showcerts < /dev/null > /tmp/cert_chain.pem

echo "Extracting root and intermediate certificates..."

# Extract the root certificate (last certificate in chain)
openssl x509 -in /tmp/cert_chain.pem -outform PEM | tail -n +2 | grep -A 1000 "BEGIN CERTIFICATE" > /tmp/root.crt

# Extract the intermediate certificate (second to last certificate in chain)
openssl x509 -in /tmp/cert_chain.pem -outform PEM | grep -A 1000 "BEGIN CERTIFICATE" | tail -n +2 | head -n -1000 > /tmp/intermediate.crt

echo "Installing certificates to system trust store..."

# Copy to system trust store
sudo cp /tmp/root.crt /usr/local/share/ca-certificates/songsterr-ops-root.crt
sudo cp /tmp/intermediate.crt /usr/local/share/ca-certificates/songsterr-ops-intermediate.crt

# Update CA certificates
sudo update-ca-certificates

# Cleanup
rm -f /tmp/cert_chain.pem /tmp/root.crt /tmp/intermediate.crt

echo "Certificates installed successfully!" 