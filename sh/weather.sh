#!/bin/bash

url="api.openweathermap.org/data/2.5/weather?id=3448439&appid=357935ee5a3a3fcdb5ab3a331d58b979&units=metric&lang=pt_br"
response=$(curl -s "$url")
cod=$(echo "$response" | jq '.cod')

if [ "$cod" -ne 401 ]; then
  echo "$response" | jq '.' > ~/.cache/eleg-weather.json
  icon_code=$(jq -r '.weather[0].icon' ~/.cache/eleg-weather.json)

  # Construa a URL do ícone
  icon_url="https://openweathermap.org/img/wn/${icon_code}@4x.png"

  # Baixa o ícone
  wget -O ~/.cache/weather_icon.png $icon_url
else
  echo "Invalid API key. Response code: $cod"
fi
