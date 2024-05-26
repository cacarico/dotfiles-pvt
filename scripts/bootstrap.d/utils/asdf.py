#!/usr/bin/env python

import yaml

# Define the path to your YAML file
yaml_file_path = 'scripts/bootstrap.d/packages/asdf.yaml'
packages = []

# Read the YAML file
with open(yaml_file_path, 'r') as file:
    data = yaml.safe_load(file)
    for package in data['packages']:
        package_info = {"package": package['name'], "version": package['versions']}
        packages.append(package_info)

def install_packages():
    for package in packages:
        for version in package['versions']:
            print(f"{package['version']}")

    return None
