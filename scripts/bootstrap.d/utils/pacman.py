#!/usr/bin/env python

# -----------------------------------------------------------------------------
# Name        : Caio Quinilato Teixeira
# Email       : caio.quinilato@gmail.com
# Repository  : https://github.com/github/dotfiles
# Description : Installs asdf packages
# -----------------------------------------------------------------------------

import subprocess
from logs import  setup_logger
import yaml

# Setup Logger
logger = setup_logger(__name__)

# Define vars
packages_file  = "scripts/bootstrap.d/packages/pacman.yaml"
packages = []

def load_packages(packages_file):
    """Load YAML file from scripts/bootstrap.d/packages/pacman.yaml"""
    with open(packages_file, 'r') as file:
        load_yaml = yaml.safe_load(file)
        for package in load_yaml['global']:
            packages.append(package)
        return packages

def install_packages():
    """
    Install pacman packages from scripts/bootstrap.d/packages/pacman.yaml.
    The packages don't take version, they are always installed in the latest version available.
    """
    packages = load_packages(packages_file)

    pacman_install = f"sudo cat {packages_file} | tail -n +2 | sed  's/^[ \t]*- *//' | sed 's/^[ \t]*//' |  sudo pacman -S --needed --noconfirm -"
    try:
        logger.info("Installing pacman packages")
        logger.debug(f"The following packages will be installed with pacman: {packages}")
        subprocess_run = subprocess.run(pacman_install, shell=True, check=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
        logger.debug(f"Running command: {pacman_install} \n{subprocess_run.stdout}")
    except Exception as e:
        logger.error(f"Failed to install pacman packages. Error: {e}")

def update_system():
    pacman_syu = "pacman -Syu"
    try:
        logger.info(f"Updating system:")
        subprocess_run = subprocess.run(pacman_syu, shell=True, check=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
        logger.debug(f"Running command: {pacman_syu} \n{subprocess_run.stdout}")
    except Exception as e:
        logger.error(f"Failed to update. \n{e}. \n{e.output}")

def main():
    # install_packages()
    update_system()

if __name__ == "__main__":
    main()
