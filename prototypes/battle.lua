------------------------------------------------
-- combat robot
data.raw["combat-robot"]["defender"]["time_to_live"]=60*60*10
data.raw["combat-robot"]["defender"]["max_health"] = 150
data.raw["combat-robot"]["defender"]["follows_player"]=false
data.raw["combat-robot"]["defender"]["light"]= {intensity = 0.3, size = 12, color={r=1, g=0.9}}
data.raw["combat-robot"]["defender"]["speed"] = 0

data.raw["combat-robot"]["distractor"]["max_health"] = 200
data.raw["combat-robot"]["distractor"]["time_to_live"]=60*60*15
data.raw["combat-robot"]["distractor"]["light"]= {intensity = 0.2, size = 14, color={r=1, g=0.9, b=0.5}}

data.raw["combat-robot"]["destroyer"]["max_health"]= 300
data.raw["combat-robot"]["destroyer"]["time_to_live"]=60*60*30
data.raw["combat-robot"]["destroyer"]["light"]= {intensity = 0.2, size = 16, color={r=1, g=0.9, b=0.8}}
data.raw["combat-robot"]["destroyer"]["follows_player"]=false
data.raw["combat-robot"]["destroyer"]["speed"] = 0
data.raw["combat-robot"]["distractor"].attack_parameters.range = 25
data.raw["combat-robot"]["destroyer"].attack_parameters.range = 30

local ingredients_table_magazine =
{
	{"coal", 1},
	{"iron-plate", 1},
	{"copper-plate", 1},
}

data.raw["recipe"]["rifle-magazine"]["ingredients"]= ingredients_table_magazine

local ingredients_table_defender =
{
	{"rifle-magazine", 2},
	{"iron-gear-wheel", 2},
    {"copper-cable", 2}
}

data.raw["recipe"]["defender-capsule"]["ingredients"]= ingredients_table_defender
data.raw["recipe"]["defender-capsule"]["energy_required"] = 5

local ingredients_table_distractor =
{
    {"glass", 2},
    {"electronic-circuit", 2},
    {"defender-capsule", 2},
}

data.raw["recipe"]["distractor-capsule"]["ingredients"]= ingredients_table_distractor
data.raw["recipe"]["distractor-capsule"]["energy_required"] = 5

local ingredients_table_destroyerr =
{
    {"electronic-components", 2},
    {"advanced-circuit", 2},
    {"distractor-capsule", 2},
}

data.raw["recipe"]["destroyer-capsule"]["ingredients"]= ingredients_table_destroyerr
data.raw["recipe"]["distractor-capsule"]["energy_required"] = 5


data.raw["projectile"]["defender-capsule"].action.action_delivery.target_effects =  {
  entity_name = "defender",
  show_in_tooltip = true,
  offsets = {
    {
      0.3,
      0.3
    },
    {
      -0.3,
      -0.3
    }
  },
  type = "create-entity"
}
data.raw["projectile"]["destroyer-capsule"].action.action_delivery.target_effects =  {
  entity_name = "destroyer",
  show_in_tooltip = true,
  offsets = {
    {
      0.4,
      -0.4
    },
    {
      -0.4,
      -0.4
    },
    {
      -0.4,
      0.4
    },
    {
      0.4,
      0.4
    },
  },
  type = "create-entity"
}



------------------------------------------------
-- railgun
data.raw["recipe"]["kr-railgun-turret"]["ingredients"]= {
    {"rare-metals", 20},
    {"steel-beam", 10},
    {"processing-unit", 4},
    {"low-density-structure", 4},
    {"gun-turret", 4},
}
data.raw["recipe"]["basic-railgun-shell"]["ingredients"]= {
    {"steel-plate", 4},
    {"electronic-circuit", 1},
}
data.raw["recipe"]["basic-railgun-shell"]["energy_required"]= 4


data.raw["recipe"]["explosion-railgun-shell"]["ingredients"]= {
    {"explosives", 1},
    {"basic-railgun-shell", 1},
}
data.raw["recipe"]["explosion-railgun-shell"]["energy_required"]= 4


data.raw["recipe"]["kr-rocket-turret"]["ingredients"]= {
    {"rare-metals", 20},
    {"steel-beam", 10},
    {"processing-unit", 10},
    {"low-density-structure", 4},
    {"rocket-launcher", 8},
}
data.raw["recipe"]["explosive-turret-rocket"]["ingredients"]= {
    {"steel-plate", 4},
    {"explosives", 2},
    {"electronic-circuit", 2},
}
data.raw["recipe"]["explosive-turret-rocket"]["energy_required"]= 6

------------------------------------------------
data.raw["recipe"]["battery-equipment"]["energy_required"]= 4
data.raw["recipe"]["big-battery-equipment"]["energy_required"]= 6
data.raw["recipe"]["big-battery-mk2-equipment"]["energy_required"]= 12
data.raw["recipe"]["big-battery-mk3-equipment"]["energy_required"]= 12
------------------------------------------------

-- data.raw["ammo-turret"]["gun-turret"].inventory_size = 50
--


data.raw["electric-turret"]["laser-turret"].max_health = 750
data.raw["electric-turret"]["laser-turret"].call_for_help_radius = 40
data.raw["electric-turret"]["laser-turret"].energy_source = {
  type = "electric",
  buffer_capacity = "1000kJ",
  input_flow_limit = "2000kW",
  drain = "50kW",
  usage_priority = "primary-input",
}

data.raw["electric-turret"]["laser-turret"].attack_parameters = {
  type = "beam",
  cooldown = 30,
  range = 40,
  source_direction_count = 64,
  source_offset = { 0, -3.423489 / 4 },
  damage_modifier = 3,
  ammo_type = {
    category = "laser",
    energy_consumption = "625kJ",
    action = {
      type = "direct",
      action_delivery = {
        type = "beam",
        beam = "laser-beam",
        max_length = 40,
        duration = 30,
        source_offset = { 0, -1.31439 },
      },
    },
  },
}

------------------------------------------------
-- robot
for _, robot in pairs(data.raw["construction-robot"]) do

    robot.resistances = {}
    for damageType, _ in pairs(data.raw["damage-type"]) do
        robot.resistances[damageType] = {
            type = damageType,
            percent = 100
        }
    end
end


data.raw["ammo"]["firearm-magazine"].stack_size=50
data.raw["ammo"]["firearm-magazine"].magazine_size=45

data.raw["ammo"]["rifle-magazine"].stack_size=50
data.raw["ammo"]["rifle-magazine"].magazine_size=45

data.raw["ammo"]["armor-piercing-rifle-magazine"].stack_size=50
data.raw["ammo"]["armor-piercing-rifle-magazine"].magazine_size=45


data.raw["ammo"]["uranium-rifle-magazine"].stack_size=50
data.raw["ammo"]["uranium-rifle-magazine"].magazine_size=45

data.raw["ammo"]["imersite-rifle-magazine"].stack_size=50
data.raw["ammo"]["imersite-rifle-magazine"].magazine_size=45

data.raw["gun"]["anti-material-rifle"].attack_parameters.range=80
