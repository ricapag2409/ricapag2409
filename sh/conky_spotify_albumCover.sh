#!/bin/bash

if [[ "$(dbus-send --session --dest=org.freedesktop.DBus --type=method_call --print-reply /org/freedesktop/DBus org.freedesktop.DBus.ListNames)" == *org.mpris.MediaPlayer2.spotify* ]]; then

  # Get Playback Status
  playback_status=$(dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'PlaybackStatus' | awk '/variant/ {print $3}' | tr -d '"')

  if [[ "$playback_status" == "Playing" ]]; then

    # Cover URL
    coverUrl=$(dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata' | awk '/artUrl/{getline; split($0,a,"\""); print a[2]}')
    wget -O ~/.cache/cover.png "$coverUrl"
  fi
fi