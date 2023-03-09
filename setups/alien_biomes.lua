if mods["alien-biomes"] then
    local biome_settings = {
      "dirt-aubergine",
      "dirt-dustyrose",
      "grass-red",
      "grass-blue",
      "grass-mauve",
      "grass-orange",
      "grass-turquoise",
      "grass-violet",
      "sand-aubergine",
      "sand-dustyrose",
      "sand-purple",
      "sand-red",
      "volcanic-purple",
      "volcanic-blue",
    }

    for _, setting in pairs(biome_settings) do
        data.raw["string-setting"]["alien-biomes-include-"..setting].forced_value = "Disabled"
    end

    local all_biome_settings = {
      "dirt-aubergine",
      "dirt-beige",
      "dirt-black",
      "dirt-brown",
      "dirt-cream",
      "dirt-dustyrose",
      "dirt-grey",
      "dirt-purple",
      "dirt-red",
      "dirt-tan",
      "dirt-violet",
      "dirt-white",
      "frozen",
      "grass-blue",
      "grass-green",
      "grass-mauve",
      "grass-olive",
      "grass-orange",
      "grass-purple",
      "grass-red",
      "grass-turquoise",
      "grass-violet",
      "grass-yellow",
      "sand-aubergine",
      "sand-beige",
      "sand-black",
      "sand-brown",
      "sand-cream",
      "sand-dustyrose",
      "sand-grey",
      "sand-purple",
      "sand-red",
      "sand-tan",
      "sand-violet",
      "sand-white",
      "volcanic-blue",
      "volcanic-green",
      "volcanic-orange",
      "volcanic-purple",
    }

    for _, setting in pairs(all_biome_settings) do
        data.raw["string-setting"]["alien-biomes-include-"..setting].hidden = true
    end
end
