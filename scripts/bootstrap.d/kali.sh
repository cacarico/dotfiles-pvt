#!/usr/bin/env bash

BOOTSTRAP_DIR="scripts/bootstrap.d"

echo ""

# Install apt packages
echo sudo apt-get install -y $(cat packages/apt.install)
