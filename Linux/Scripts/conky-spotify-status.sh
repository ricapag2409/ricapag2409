#!/bin/bash

# Obter informações da música atual
dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify \
    /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get \
    string:"org.mpris.MediaPlayer2.Player" string:"Metadata" | \
    grep -A 2 "xesam:title" | grep variant | awk '{print $3}' | tr -d '"'  
