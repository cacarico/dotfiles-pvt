#!/usr/bin/env bash

# Enable fingerprint
echo "Enabling fingerprint for services:"
for service in sudo system-local-login; do
    if ! grep -q fprintd "/etc/pam.d/$service"; then
        sudo sed -i '/auth.*include/i auth            sufficient      pam_fprintd.so' "/etc/pam.d/$service"
    else
        echo "Fingerprint already configured for $service, skipping..."
    fi
done
