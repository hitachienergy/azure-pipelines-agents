#!/bin/bash
set -e

print_header() {
  lightcyan='\033[1;36m'
  nocolor='\033[0m'
  echo -e "${lightcyan}$1${nocolor}"
}

create_directory() {
  if [ ! -d "$1" ]; then
    print_header "Creating directory $1"
    mkdir -p "$1"
  fi
}

create_empty_file() {
  if [ ! -f "$1" ]; then
    print_header "Creating file $1"
    touch "$1"
  fi
}

get_package_version() {
  dpkg-query --showformat='${Version}\n' --show "$1"
}

create_symlink() {
  print_header "Creating symlink from $1 to $2"
  ln -s "$1" "$2"
}

# Register python interpreters to be usable by Azure DevOps
for MINOR_VERSION in 3.7 3.10
  do
    # Version number should follow the format of 1.2.3
    PYTHON_VERSION=$(get_package_version python${MINOR_VERSION}  | grep -Eo '^[0-9]+\.[0-9]+\.[0-9]+')

    create_directory "${AGENT_TOOLSDIRECTORY}/Python/${PYTHON_VERSION}/x64"
    create_symlink "$(which python${MINOR_VERSION})" "${AGENT_TOOLSDIRECTORY}/Python/${PYTHON_VERSION}/x64/python"
    create_symlink "$(which python${MINOR_VERSION})" "${AGENT_TOOLSDIRECTORY}/Python/${PYTHON_VERSION}/x64/python3"

    # Mark specific Python version as installed
    create_empty_file "${AGENT_TOOLSDIRECTORY}/Python/${PYTHON_VERSION}/x64.complete"
  done