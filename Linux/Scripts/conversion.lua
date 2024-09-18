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
