#!/usr/bin/env bash

# ===============================================================================
# Script: sherlock-setup
#
# Description: Automation tool for HTB Sherlock challenges. Sets up the directory 
# environment, downloads and extracts the challenge files. A simple Quality of 
# Life script.
#
# GitHub: https://github.com/MaxisFront/sherlock-setup
# Use: sherlock-setup.sh <MachineName> <URL> [password]
# ===============================================================================

sherlock-setup() {

  # Verify dependencies
  for cmd in 7z wget sha256sum; do 
    if ! command -v "$cmd" &>/dev/null; then
      echo -e "\e[31m[!] The command $cmd doesn't exist"
      return 1
    fi
  done

  if [[ -z  $1 || -z $2 ]]; then
     echo -e "\e[31m[!] URL or machine name not provided\e[0m"
    echo -e "Use: sherlock-setup.sh <\e[33mmachineName\e[0m> <\e[34mhttps://example.com/filename\e[0m> [password]"

    return 1
  fi

  # Variables
  local name="$1"
  local url="$2"
  local password="${3:-hacktheblue}"
  local filename="${name}.zip"
  local filepath="$name/artifacts/$filename"

  mkdir -p "$name"/{artifacts,exports,logs,src}

  # Download .zip file
  if wget -q --show-progress -O "$filepath" "$url" ; then

    # Decompress the .zip file (No output from the '7z' command)
    if 7z x -bso0 -y -p"$password" "$filepath" -o"$name/artifacts/"; then
      
      echo -e "\e[32m[+]${filename} downloaded and extracted successfully\e[0m"
      sha256sum "$filepath" > "$name/artifacts/checksum.txt"

      mv "$filepath" "$name/artifacts/checksum.txt" "$name/src/"
      
      # If the script is a function, the CD command is executed
      if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
        cd "$name" || return 1
      else 
        echo -e "\e[32m[+] Enviroment set up at $(pwd)/$name\e[0m"
      fi

    else
      echo -e "\e[31m[!] Verify the password or the $filename integrity\e[0m"
      return 1
    fi
    
  else
    echo -e "\e[31m[!] Couldn't download the $filename file\e[0m"
    return 1
  fi
}

# Verify for a standalone execution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  sherlock-setup "$@"
fi
