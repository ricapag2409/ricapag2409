#!/bin/bash

# Use dbus-send to get the metadata from Spotify
metadata=$(dbus-send --print-reply --session \
  --dest=org.mpris.MediaPlayer2.spotify \
  /org/mpris/MediaPlayer2 \
  org.freedesktop.DBus.Properties.Get \
  string:'org.mpris.MediaPlayer2.Player' \
  string:'Metadata')

# Extract the title and artist from the metadata
title=$(echo "$metadata" | grep -A 1 "xesam:title" | tail -1 | cut -d '"' -f 2)
artist=$(echo "$metadata" | grep -A 2 "xesam:artist" | tail -1 | cut -d '"' -f 2)
cover=$(echo "$metadata" | grep -A 1 "mpris:artUrl" | grep -oP '(http.*?)(?=")')

wget -O /home/live/Pictures/Covers/cover.png "$cover"

# Print the result
if [ -n "$title" ] && [ -n "$artist" ]; then
  echo "$title - $artist"
else
  echo "No song is playing"
fi
