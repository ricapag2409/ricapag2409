#!/bin/bash

if [[ "$(dbus-send --session --dest=org.freedesktop.DBus --type=method_call --print-reply /org/freedesktop/DBus org.freedesktop.DBus.ListNames)" == *org.mpris.MediaPlayer2.spotify* ]]; then

  # Get Playback Status
  playback_status=$(dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'PlaybackStatus' | awk '/variant/ {print $3}' | tr -d '"')

  if [[ "$playback_status" == "Playing" ]]; then
    # Artist
    artist=$(dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata' | awk '/artist/{getline; getline; split($0,a,"\""); print a[2]}')

    # Song
    song=$(dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata' | awk '/title/{getline; split($0,a,"\""); print a[2]}')

    # Album
    album=$(dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata' | awk '/album/{getline; split($0,a,"\""); print a[2]}')

    # Duration
    duration=$(dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata' | awk '/length/{getline;print $3}')

    # Actual Time
    position=$(dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Position' | awk '/variant/ {print $3}')

    # Cover URL
    coverUrl=$(dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata' | awk '/artUrl/{getline; split($0,a,"\""); print a[2]}')

    if [[ -n "$duration" ]]; then
      minutes=$((duration / 1000000 / 60))
      seconds=$((duration / 1000000 % 60))
      length_formatted=$(printf "%d:%02d" $minutes $seconds)
    else
      length_formatted="N/A"
    fi

    if [[ -n "$position" ]]; then
      pos_seconds_total=$((position / 1000000))
      pos_minutes=$((pos_seconds_total / 60))
      pos_seconds=$((pos_seconds_total % 60))
      position_formatted=$(printf "%d:%02d" $pos_minutes $pos_seconds)
    else
      position_formatted="N/A"
    fi

    # Print
    echo "Artist: $artist"
    echo "Song: $song"
    echo "Album: $album"
    echo "Duration: $position_formatted / $length_formatted"
  else
    echo "Artist: "
    echo "Song: "
    echo "Album: "
    echo "Duration: 0:00 / 0:00"
  fi
else
  echo "Artist: "
  echo "Song: "
  echo "Album: "
  echo "Duration: 0:00 / 0:00"
fi