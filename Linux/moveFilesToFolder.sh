 
#!/bin/bash

# Diretórios
origem="/home/live/Downloads/PN/Email/"
destino="/home/live/Downloads/PN/"

# Verificar se a pasta de destino existe, caso contrário, criá-la
[ ! -d "$destino" ] && mkdir -p "$destino"

# Loop para acessar cada pasta dentro da origem
for subpasta in "$origem"/*; do
  if [ -d "$subpasta" ]; then
    # Loop pelos arquivos da subpasta
    for arquivo in "$subpasta"/*; do
      if [ -f "$arquivo" ]; then
        nome_arquivo=$(basename "$arquivo")
        caminho_destino="$destino/$nome_arquivo"
        
        # Verificar se o arquivo já existe na pasta de destino
        if [ -f "$caminho_destino" ]; then
          contador=1
          # Gerar um novo nome se o arquivo já existir
          while [ -f "$destino/${nome_arquivo%.*}_$contador.${nome_arquivo##*.}" ]; do
            contador=$((contador + 1))
          done
          # Renomear o arquivo antes de mover
          caminho_destino="$destino/${nome_arquivo%.*}_$contador.${nome_arquivo##*.}"
        fi
        
        # Mover o arquivo para a pasta de destino
        mv "$arquivo" "$caminho_destino"
      fi
    done
  fi
done

echo "Arquivos movidos com sucesso!"