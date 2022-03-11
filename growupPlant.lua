local grassLeftTopX = posX - sizeX/2
local grassLeftTopZ = posZ - sizeZ/2

-- Create a model to hold plant parts
local model = Instance.new("Model")
model.Name = "Plant"

-- growUpThisPlant
local function growUpAllPlants()
	local children = script.Parent:FindFirstChild(model.Name):GetChildren()
	for i = 1, #children do
		local randomAddSize = math.random(50,180)
		local child = children[i]
		for count = 1, 30 do
			-- grow Up
			local perc = count / 30
			child.Size = Vector3.new(.25, randomAddSize/100*count/8, .25)
			--child.Color = Color3.new(0, 1*perc, 0.498039*perc)
			--wait(.005)
		end
	end
end

-- create Plants on Parcel
local function createPlantsOnParcel() 
	for countZ = 1, sizeZ, 2 do	
		for count = 1, sizeX, 2 do
			local random = math.random(1,4)
			local color = Color3.new(0.0941176, 0.992157, 0.498039)	
			-- determinate color
			if(random<2) then
				color = Color3.new(0.0941176, 0.992157, 0.498039)
			elseif(random<3) then
				color = Color3.new(0.541176, 1, 0.376471)
			else
				color = Color3.new(0, 0.541176, 0.25098)
			end
			-- create part of Plant
			local part = Instance.new("Part")
			part.CanCollide = false
			part.Parent = model
			part.Size = Vector3.new(.2, .8, .2)
			part.Position = Vector3.new(grassLeftTopX+count, 13.25, grassLeftTopZ+countZ)
			part.Anchored = true
			part.Transparency = 0
			part.Color = color			
		end
	end
end

--growUpPlant
local function growUpPlant(plantType)
	-- create part of Plant
	local part2 = Instance.new("Part")
	part2.Parent = model
	part2.Size = Vector3.new(.5, 1, .5)
	part2.Position = Vector3.new(-1065, 13.25, -645.5)
	part2.Anchored = true
	part2.Transparency = 0
	part2.Color = Color3.new(0, 0.686275, 0.329412)
	
	-- create part of Plant
	local part = Instance.new("Part")
	part.Parent = model
	part.Size = Vector3.new(.5, 1, .5)
	part.Position = pos
	part.Anchored = true
	part.Transparency = 0
	part.Color = Color3.new(0, 1, 0.498039)
	-- Attach to parent part
	model.Parent = grass
	for count = 1, 150 do
		-- grow Up
		local perc = count / 150
		part.Size = Vector3.new(.5, count/16, .5)
		part.Color = Color3.new(0, 1*perc, 0.498039*perc)
		part2.Size = Vector3.new(.5, count/18, .5)
		part2.Color = Color3.new(0, 0.686275*perc,  0.329412*perc)
		wait(.1)
	end
	print('herbe')
end

-- execute growup Plant
createPlantsOnParcel() 
growUpPlant('Herbe')

print(grass.Position)
print(grass.Size)

growUpAllPlants()
