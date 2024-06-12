#!/bin/bash

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <search_string> <replace_string>"
  exit 1
fi

search_string=$1
replace_string=$2

# Проход по всем файлам в текущей директории и поддиректориях
find . -type f -exec sed -i "s/${search_string}/${replace_string}/g" {} +

echo "Replacement complete for all files in the current directory and its subdirectories."
