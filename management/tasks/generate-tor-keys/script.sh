#!/usr/bin/env sh
# shellcheck shell=sh # POSIX

# Generate a private key for a tor service
nix shell 'nixpkgs#openssl' 'nixpkgs#basez' --command openssl genpkey -algorithm x25519 | grep -v ' PRIVATE KEY' | base64pem -d | tail --bytes=32 | base32 | sed 's/=//g'
