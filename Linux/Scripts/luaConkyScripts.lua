local io = require("io")

local function execute_command(command)
  local handle = io.popen(command)
  local result = handle:read("*a")
  handle:close()
  return result
end

function download_album_cover(cover_url, save_path)
  local command = string.format('wget -q "%s" -O "%s"', cover_url, save_path)
  os.execute(command)
end

function conky_convert_gib_to_mb()
  local mem = conky_parse('${mem}')
  local memtotal = conky_parse('${memmax}')
  local gib_number = tonumber(mem:match("([%d%.]+)"))
  local gib_number_total = tonumber(memtotal:match("([%d%.]+)"))
  if gib_number and gib_number_total then
    local mb_value = gib_number * 1024
    local mb_value_total = gib_number_total * 1024
    return string.format("%.0f", mb_value) .. " mb / " .. string.format("%.0f", mb_value_total) .. " mb"
  else
    return "N/A"
  end
end

function conky_spotify_progress()
  -- Variáveis para armazenar os dados
  local duration, currentPositionSong
  local in_duration = false

  local commandInfos = 'dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:"org.mpris.MediaPlayer2.Player" string:"Metadata"'
  local resultInfos = execute_command(commandInfos)

  local commandCurrentPosition = 'dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:"org.mpris.MediaPlayer2.Player" string:"Position"'
  local resultCurrent = execute_command(commandCurrentPosition)

  -- Processa a saída de resultInfos linha por linha
  for line in resultInfos:gmatch("[^\r\n]+") do
    if line:find('mpris:length') then
      in_duration = true
    elseif in_duration and line:find('uint64') then
      duration = line:match('uint64%s+([%d]+)')
      in_duration = false  -- Reinicia o flag após capturar a duração
    end
  end

  -- Captura a posição atual diretamente
  currentPositionSong = resultCurrent:match('int64%s+([%d]+)')

  -- Converte duração de microssegundos para segundos e, em seguida, para o formato m:ss
  if duration and currentPositionSong then
    local duration_in_seconds = math.floor(tonumber(duration) / 1000000)
    local currentPositionSong_in_seconds = math.floor(tonumber(currentPositionSong) / 1000000)

    percentagemSong = ((currentPositionSong_in_seconds / duration_in_seconds) * 100)
    return percentagemSong
  else
    return 0
  end
end

function conky_spotify_lua()
  -- Variáveis para armazenar os dados
  local artist, song, album, duration, currentPositionSong, cover
  local in_artist, in_song, in_album, in_duration, in_cover = false, false, false, false, false

  local commandInfos = 'dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:"org.mpris.MediaPlayer2.Player" string:"Metadata"'
  local resultInfos = execute_command(commandInfos)

  local commandCurrentPosition = 'dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:"org.mpris.MediaPlayer2.Player" string:"Position"'
  local resultCurrent = execute_command(commandCurrentPosition)

  -- Processa a saída de resultInfos linha por linha
  for line in resultInfos:gmatch("[^\r\n]+") do
    if line:find('xesam:artist') then
      in_artist = true
    elseif line:find('xesam:title') then
      in_song = true
    elseif line:find('xesam:album') and not line:find('xesam:albumArtist') then
      in_album = true
    elseif line:find('mpris:length') then
      in_duration = true
    elseif line:find('mpris:artUrl') then
      in_cover = true
    elseif in_artist and line:find('string') then
      artist = line:match('string%s+"([^"]+)"')
      in_artist = false  -- Reinicia o flag após capturar o artista
    elseif in_song and line:find('string') then
      song = line:match('string%s+"([^"]+)"')
      in_song = false  -- Reinicia o flag após capturar o título
    elseif in_album and line:find('string') then
      album = line:match('string%s+"([^"]+)"')
      in_album = false  -- Reinicia o flag após capturar o álbum
    elseif in_duration and line:find('uint64') then
      duration = line:match('uint64%s+([%d]+)')
      in_duration = false  -- Reinicia o flag após capturar a duração
    elseif in_cover and line:find('string') then
      cover = line:match('string%s+"([^"]+)"')
      in_cover = false  -- Reinicia o flag após capturar a capa
    end
  end

  -- Captura a posição atual diretamente
  currentPositionSong = resultCurrent:match('int64%s+([%d]+)')

  -- Converte duração de microssegundos para segundos e, em seguida, para o formato m:ss
  if duration then
    local duration_in_seconds = math.floor(tonumber(duration) / 1000000)
    local minutes = math.floor(duration_in_seconds / 60)
    local seconds = duration_in_seconds % 60
    duration = string.format("%d:%02d", minutes, seconds)
  end

  -- Converte duração de microssegundos para segundos e, em seguida, para o formato m:ss
  if currentPositionSong then
    local duration_in_seconds = math.floor(tonumber(currentPositionSong) / 1000000)
    local minutes = math.floor(duration_in_seconds / 60)
    local seconds = duration_in_seconds % 60
    currentPositionSong = string.format("%d:%02d", minutes, seconds)
  end

  -- Verifica se os dados necessários foram encontrados
  if artist and song and album and duration and currentPositionSong then
    -- Baixa a capa do álbum
    download_album_cover(cover, "/home/live/.cache/cover.png")
    return string.format("Artist: %s\nSong: %s\nAlbum: %s\nDuration: %s / %s",artist, song, album, currentPositionSong, duration) .. conky_parse("${image ~/.cache/cover.png -p 80,595 -s 120x120 -n -f 1}") .. conky_parse("${voffset 125}")
  else
    return "No song is playing"
  end
end