#!/bin/bash

#functions

# Funções para colorir o texto
red() {
  if [ "$2" == "bold" ]; then
    echo -e "\033[1;31m$1\033[0m"
  else
    echo -e "\033[31m$1\033[0m"
  fi
}

green() {
  if [ "$2" == "bold" ]; then
    echo -e "\033[1;32m$1\033[0m"
  else
    echo -e "\033[32m$1\033[0m"
  fi
}

yellow() {
  if [ "$2" == "bold" ]; then
    echo -e "\033[1;33m$1\033[0m"
  else
    echo -e "\033[33m$1\033[0m"
  fi
}

blue() {
  if [ "$2" == "bold" ]; then
    echo -e "\033[1;34m$1\033[0m"
  else
    echo -e "\033[34m$1\033[0m"
  fi
}

# Step 1, ask to user which font extension is, allowed extensions -> ttf or otf.

blue "Qual a extensão da fonte que você deseja instalar? somente TTF ou OTF são permitidos!!"
read FONTEXTENSION
echo

# Convert the entered extension to lowercase
FONTEXTENSION=$(echo "$FONTEXTENSION" | tr '[:upper:]' '[:lower:]')

# Check if the entered extension is not ttf or otf
if [ "$FONTEXTENSION" != "ttf" ] && [ "$FONTEXTENSION" != "otf" ]; then
  red "Erro: Extensão inválida. Somente TTF ou OTF são permitidos." bold
  exit 1
fi

if [ "$FONTEXTENSION" = "ttf" ]; then
  LOCATIONDIR="/usr/share/fonts/TTF"
fi

if [ "$FONTEXTENSION" = "otf" ]; then
  LOCATIONDIR="/usr/share/fonts/OTF"
fi

# Step 2, ask to user where the fonts we want to install are
blue "Em qual diretório suas fontes estão?"
read FONTSDIR
echo

# Check if the directory is valid
if [ ! -d "$FONTSDIR" ]; then
  red "Erro: Diretório não existe ou não é válido." bold
  exit 1
fi

# Step 3, search for fonts in the specified directory with the given extension
FONTFILES=$(find "$FONTSDIR" -type f -iname "*.$FONTEXTENSION")

# Check if any font files were found
if [ -z "$FONTFILES" ]; then
  red "Erro: Nenhuma fonte com extensão .$FONTEXTENSION foi encontrada no diretório $FONTSDIR." bold
  exit 1
fi

# If everything is correct, you can proceed with the installation

cd "$FONTSDIR"
cp *."$FONTEXTENSION" "$LOCATIONDIR"

# Step 4, check if fonts are saved in the fontsdir
FONTFILESCOPIED=$(find "$LOCATIONDIR" -type f -iname "*.$FONTEXTENSION")

# If everything is correct, you can proceed with the installation
echo "As seguintes fontes abaixo foram copiadas com sucesso no $LOCATIONDIR, podemos prosseguir..."
echo

# Exibir apenas os nomes dos arquivos instalados, sem o caminho completo
echo "$FONTFILESCOPIED" | while IFS= read -r FILE; do
  echo "$(basename "$FILE")"
done

mkfontdir "$LOCATIONDIR"
mkfontscale "$LOCATIONDIR"
fc-cache -f -v

echo "Fontes instaladas com sucesso!"
