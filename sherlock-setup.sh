#!/usr/bin/env bash

# ===============================================================================
# Script: sherlock-setup
#
# Description: Automation tool for HTB Sherlock challenges. Sets up the directory 
# environment, downloads and extracts the challenge files. A simple Quality of 
# Life script.
#
# GitHub: https://github.com/MaxisFront/sherlock-setup
# Use: setup_case <MachineName> <URL> [password]
# ===============================================================================

sherlock-setup() {

  # Verificar existencia de dependencias
  for cmd in 7z wget sha256sum; do 
    # Verificar si existe el comando "7z"
    if ! command -v "$cmd" &>/dev/null; then # Enviar cualquier mensaje a /dev/null
      echo -e "\e[31m[!] El comando $cmd no existe. Por favor, instálelo\e[0m"
      return 1
    fi
  done

  # Verificar si el usuario insertó la URL
  if [[ -z  $1 || -z $2 ]]; then # Verifica si $1 está vacío (-z)
    echo -e "\e[31m[!] No se integró una URL o el nombre de la máquina\e[0m"
    echo -e "Uso: setup_case <\e[33mmachineName\e[0m> <\e[34mhttps://example.com/filename\e[0m> [password]"

    return 1 # Finaliza la ejecución con un valor de error
  fi

  # Variables
  local name="$1"
  local url="$2"
  local password="${3:-hacktheblue}"
  local filename="${name}.zip"
  local filepath="$name/artifacts/$filename"

  # Creación de carpetas
  mkdir -p "$name"/{artifacts,exports,logs,src}

  # Descarga del archivo .zip
  if wget -q --show-progress -O "$filepath" "$url" ; then

  # Descomprimir .zip (-bso0 para no mostrar información alguna en la terminal)
    if 7z x -bso0 -y -p"$password" "$filepath" -o"$name/artifacts/"; then # "-y" si el usuario descarga nuevamente el .zip

      echo -e "\e[32m[+] El archivo ${filename} ha sido descargado y extraído satisfactoriamente\e[0m"
      sha256sum "$filepath" > "$name/artifacts/checksum.txt"

      mv "$filepath" "$name/artifacts/checksum.txt" "$name/src/"

      cd "$name" || return 1
    else # Si el archivo .zip no existe...
      echo -e "\e[31m[!] Verificar la contraseña o integridad del archivo $filename\e[0m" 
      return 1
    fi
    
  else  # Si no fue posible obtener el archivo .zp...
    echo -e "\e[31m[!] No fue posible obtener el archivo ${filename}\e[0m"
    return 1
  fi
}
