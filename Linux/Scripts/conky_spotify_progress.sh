#!/bin/bash

if [[ "$(dbus-send --session --dest=org.freedesktop.DBus --type=method_call --print-reply /org/freedesktop/DBus org.freedesktop.DBus.ListNames)" == *org.mpris.MediaPlayer2.spotify* ]]; then
  playback_status=$(dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'PlaybackStatus' | awk '/variant/ {print $3}' | tr -d '"')

  if [[ "$playback_status" == "Playing" ]]; then
    duration=$(dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata' | awk '/length/{getline;print $3}')
    position=$(dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Position' | awk '/variant/ {print $3}')
    coverUrl=$(dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata' | awk '/artUrl/{getline; split($0,a,"\""); print a[2]}')

    if [[ -n "$duration" && -n "$position" ]]; then
      total_length_seconds=$((duration / 1000000))
      current_seconds=$((position / 1000000))
      progress=$((current_seconds * 100 / total_length_seconds))
      echo $progress
    else
      echo 0
    fi
  else
    echo 0
  fi
else
  echo 0
fi