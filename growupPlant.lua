-- GrowUp Plant
-- @Author: FredL
-- Configuration of the tower
local grass = script.Parent
local pos = Vector3.new(-1067, 13.25, -649.5)
local towerBaseSize = 30

-- Decide on two colors that are different in hue
local hue = 1/2
local color0 = Color3.fromHSV(hue, 1, 1)
local color1 = Color3.fromHSV((hue + .35) % 1, 1, 1)

-- Create a model to hold plant parts
local model = Instance.new("Model")
model.Name = "Plant"

local function growUpPlant(plantType)
	-- create part of Plant
	local part = Instance.new("Part")
	part.Parent = model
	part.Size = Vector3.new(1/3, 1, 1/3)
	part.Position = pos
	part.Anchored = true
	part.Transparency = 0
	part.Color = Color3.new(0, 1, 0.498039)
  -- Attach to parent part
	model.Parent = grass
	for count = 1, 150 do
		-- grow Up
		local perc = count / 150
		part.Size = Vector3.new(1, count/16, 1)
		part.Color = Color3.new(0, 1*perc, 0.498039*perc)
		wait(.1)
	end
	print('herbe')
end

-- execute growup Plant
growUpPlant('Herbe')
