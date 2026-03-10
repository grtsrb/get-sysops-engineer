#!/bin/bash

file="prilog.txt"

if [[ ! -f "$file" ]]; then
  echo "File $file not found!"
  exit 1
fi

echo "====== 1. Creating files from $file ======"

while IFS= read -r line || [ -n "$line" ]; do
  filename=$(echo "$line" | tr -d '\r'| xargs)
  
  if [[ -n "$filename" ]]; then
    touch "$filename"
  fi
done < "$file"

ls *.kod  > /dev/null 2>&1

if [[ $? -ne 0 ]]; then
  echo "No .kod files found in the current directory."
  exit 0
fi

echo "====== 2. Checking format and files sorting in correct directories ======"

regex="^k([0-9a-fA-F]{8})\.kod$"

for f in *.kod; do
  if [[ $f =~ $regex ]]; then

    hex_value="${BASH_REMATCH[1]}"
    # k A B C D E F G H . k o d
    #   0 1 2 3 4 5 6 7 (hex_part index)
    
    E_digit="${hex_value:4:1}"
    G_digit="${hex_value:6:1}"

    G_decimal=$((16#$G_digit))

    if (( G_decimal % 2 == 0 )); then
      echo "$f - G digit is even (decimal: $G_decimal)"
      target_dir="${G_digit}0/${E_digit}0"
    else
      echo "$f - G digit is odd (decimal: $G_decimal)"
      X_decimal=$((G_decimal - 1))
      X_digit=$(printf "%x" $X_decimal)
      target_dir="${X_digit}0/${E_digit}0"
    fi

    mkdir -p "$target_dir"
    mv "$f" "$target_dir/"
    echo "Moved $f to $target_dir/"
  else
    echo "$f - Invalid format"
  fi
done