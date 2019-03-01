#!/usr/bin/env bash
set -e

echo "==> Vault (client)"

echo "--> Fetching"
install_from_url "vault" "${vault_url}"


echo "==> Vault is done!"