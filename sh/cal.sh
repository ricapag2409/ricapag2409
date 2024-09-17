#!/bin/bash

# Obtém o calendário atual e o dia de hoje
calendar=$(cal)
today=$(date +%-d)

# Destaca o dia atual no calendário
# Remove zeros à esquerda do dia atual
highlighted_calendar=$(echo "$calendar" | sed "s/\b$today\b/\${color red}&\${color white}/")

# Imprime o calendário formatado
echo "$highlighted_calendar"
 
