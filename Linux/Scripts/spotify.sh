#!/bin/sh
# spotify.sh
#
# CLI for control songs of Spotify
#
# Versão 1.0: Initial Build
#
# Ricardo Pagano, February 2023
#

###############################[ FUNCTIONS ]#################################

### Function to show bash options are avaliable

useOptions(){
  echo "Uso: $(basename "$0")
  OPÇÕES
   --play Toca a musica no Spotify caso esteja pausada

   --playpause Play e Pause em um único botão

   --pause Pausa a música caso esteja sendo tocada

   --next Pula para a proxima musica

   --openURI Abre link Spotify

   --previous Volta para a musica anterior" && exit 1
}

spotify_cmd(){
  dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.$1 1> /dev/null
}

#################[ Line command Treatments ]###############

# Test if '$1' exists in useOptions function
[ "$1" ] || { useOptions ; } 

# If exists '$1', continue and tests if string has value using while
while test -n "$1"
do
  case "$1" in
   --play)spotify_cmd Play;;
   --pause)spotify_cmd Pause;;
   --playpause)spotify_cmd PlayPause;;
   --next)spotify_cmd Next;;
   --openURI)
   [ "$2" ] || { echo "Necessário informar a URI para continuar" ; exit 1 ; }
      spotify_cmd "OpenUri string:$2";;
   --previous)spotify_cmd Previous;spotify_cmd Previous;;
      *) opcoes_de_uso ;;
  esac
  exit 0;
done
