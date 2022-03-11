-- on Touch Human Burn
-- @Author: FredL
-- Configuration of the tower
local grass = script.Parent
local pos = Vector3.new(-1067, 13.25, -649.5)
local towerBaseSize = 30

-- Decide on two colors that are different in hue
local hue = math.random()
hue = 1/2
local color0 = Color3.fromHSV(hue, 1, 1)
local color1 = Color3.fromHSV((hue + .35) % 1, 1, 1)

-- Create a model to hold tower parts
local model = Instance.new("Model")
model.Name = "Tower"

for i = towerBaseSize, 1, -2 do
	-- Create a part
	local part = Instance.new("Part")
	part.Parent = model
	part.Size = Vector3.new(i, 2, i)
	part.Position = pos
	part.Anchored = true
	-- Tween from color0 and color1
	local perc = i / towerBaseSize 
	part.Color = Color3.new(
		color0.r * perc + color1.r * (1 - perc),
		color0.g * perc + color1.g * (1 - perc),
		color0.b * perc + color1.b * (1 - perc)
	)
	-- Move up
	pos = pos + Vector3.new(0, part.Size.Y, 0)
end
model.Parent = grass
