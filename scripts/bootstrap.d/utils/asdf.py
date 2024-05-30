#!/usr/bin/env python

import subprocess
import yaml
from logs import setup_logger

# Set up logger
logger = setup_logger(__name__)

# Define the path to your YAML file
yaml_file_path = 'scripts/bootstrap.d/packages/asdf.yaml'
packages = []

def load_yaml(file_path):
    """Load YAML data from a file"""
    with open(file_path, 'r') as file:
        return yaml.safe_load(file)

def parse_packages(data):
    """Parse package information from YAML data"""
    packages = []
    for package in data['global']:
        package_info = {"package": package['name'], "version": package['versions']}
        packages.append(package_info)
    return packages

def install_package(package, version):
    """Install a specific version of a package using asdf"""
    add_plugin = f"asdf plugin add {package}"
    install_package = f"asdf install {package} {version}"
    set_package_global = f"asdf global {package} {version}"

    try:
        logger.info(f"Adding plugin for {package}")
        subprocess.run(add_plugin, shell=True, check=True)

        logger.info(f"Installing {package} version {version}")
        subprocess.run(install_package, shell=True, check=True)

        logger.info(f"Setting {package} version {version} globally")
        subprocess.run(set_package_global, shell=True, check=True)

        logger.info(f"Successfully installed {package} version {version}")
    except subprocess.CalledProcessError as e:
        logger.error(f"Failed to install {package} version {version}. Error: {e}")

def install_packages(packages):
    """Install all packages from the list"""
    for package in packages:
        versions = package['version']

        # Ensure versions is a list
        if not isinstance(versions, list):
            versions = [versions]

        for version in versions:
            install_package(package['package'], version)

def main():
    # Load and parse the YAML file
    data = load_yaml(yaml_file_path)
    packages = parse_packages(data)

    # Install all packages
    install_packages(packages)

if __name__ == "__main__":
    main()
