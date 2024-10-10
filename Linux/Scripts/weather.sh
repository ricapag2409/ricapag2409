#!/bin/bash

url="https://api.openweathermap.org/data/3.0/onecall?lat=-23.533773&lon=-46.625290&appid=357935ee5a3a3fcdb5ab3a331d58b979&units=metric&lang=pt_br"
response=$(curl -s "$url")
cod=$(echo "$response" | jq '.cod')

echo "$response" | jq '.' > ~/.cache/eleg-weather.json
icon_code=$(jq -r '.current.weather[0].icon' ~/.cache/eleg-weather.json)

# Construa a URL do ícone
icon_url="https://openweathermap.org/img/wn/${icon_code}@4x.png"

# Baixa o ícone
wget -O ~/.cache/weather_icon.png $icon_url

