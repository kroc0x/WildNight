local function setEnergyCost(recipe_name, energy_cost, expensive_cost)
  local recipe = data.raw.recipe[recipe_name]

  if recipe then
    if recipe.energy_required or not (recipe.normal == nil or recipe.expensive == nil) then
      recipe.energy_required = energy_cost
    elseif recipe.ingredients then
      recipe.energy_required = energy_cost
    end
    if recipe.normal then
      recipe.normal.energy_required = energy_cost
    end
    if recipe.expensive then
      recipe.expensive.energy_required = expensive_cost or energy_cost
    end
  end
end

setEnergyCost("low-density-structure", 10)
setEnergyCost("rocket-control-unit", 12)
setEnergyCost("rocket-fuel", 8)

data.raw["recipe"]["water-from-atmosphere"]["results"] = { { type = "fluid", name = "water", amount = 120 }}


