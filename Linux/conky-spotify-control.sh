#!/bin/bash

action=$1

case "$action" in
  play-pause)
    dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify \
    /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause
  ;;
  next)
    dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify \
    /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next
  ;;
  previous)
    dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify \
    /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous
  ;;
esac 
