#!/usr/bin/env python

# -----------------------------------------------------------------------------
# Name        : Caio Quinilato Teixeira
# Email       : caio.quinilato@gmail.com
# Repository  : https://github.com/github/dotfiles
# Description : Installs asdf pacages
# -----------------------------------------------------------------------------

import logs import  setup_logsger

# Setup Logger
logger = setup_logger(__name__)

# Define vars
pacman_packages  = "scripts/bootstrap.d/packages/pacman.yaml"
packages = []

def load_yaml(pacman_packages):
    """Load YAML file from pacman.insttall"""
    with open(pacman_packages, 'r') as file:
        return yaml.safe_load(file)
