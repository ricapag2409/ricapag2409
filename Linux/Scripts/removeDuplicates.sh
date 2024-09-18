#!/bin/bash

# Caminho para o arquivo de texto que contém a lista de arquivos
file="duplicates.txt"

# Verifica se o arquivo existe
if [[ ! -f $file ]]; then
  echo "Arquivo $file não encontrado!"
  exit 1
fi

# Lê cada linha do arquivo e remove o arquivo correspondente
while IFS= read -r line; do
  if [[ -f $line ]]; then
    echo "Removendo arquivo: $line"
    rm "$line"
  else
    echo "Arquivo não encontrado ou já removido: $line"
  fi
done < "$file"

echo "Processo de remoção concluído."
