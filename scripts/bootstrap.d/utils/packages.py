#!/usr/bin/env python

# -----------------------------------------------------------------------------
# Name        : Caio Quinilato Teixeira
# Email       : caio.quinilato@gmail.com
# Repository  : https://github.com/github/dotfiles
# Description : Installs asdf pacages
# -----------------------------------------------------------------------------


def parse_packages(data):
    """Parse package information from YAML data"""
    packages = []
    for package in data['global']:
        package_info = {"package": package['name'], "version": package['versions']}
        packages.append(package_info)
    return packages

def main():
    # Load and parse the YAML file
    data = load_yaml(yaml_file_path)
    packages = parse_packages(data)

if __name__ == "__main__":
    main()
