-- GrowUp Plant
-- @Author: @NumericFactory (Frederic LOSSIGNOL)

-- FIX YOUR OWN PARAMETERS
local plantColor1 = Color3.new(0.0941176, 0.992157, 0.498039) 	-- Fix the color1 of your plants
local plantColor2 = Color3.new(0.541176, 1, 0.376471)		-- Fix the color2 of your plants
local plantColor3 = Color3.new(0, 0.541176, 0.25098)		-- Fix the color3 of your plants

local plantHeight = 7 			-- Fix average height size of your Plants. The height variation is 40% to 110%
local plantWidth = .1  			-- Fix average width  size of your plants. The width  variation is 90% to 120%
local spaceBetweenPlants = 1.7		-- Fix average space between your plants.
-- END FIX YOUR OWN PARAMETERS 

------------------------------

-- Get the coords of the parcel
local grass = script.Parent
local posX = grass.Position.X;
local posY = grass.Position.X;
local posZ = grass.Position.Z;
local sizeX = grass.Size.X
local sizeZ = grass.Size.Z
local pos = Vector3.new(posX, posY, posZ);

local grassLeftTopX = posX - sizeX/2
local grassLeftTopZ = posZ - sizeZ/2

-- Create a model to hold plant parts
local model = Instance.new("Model")
model.Name = "Plant"
-- Attach to parent part
model.Parent = grass

-- create Plants on Parcel
local function createPlantsOnParcel() 
	for countZ = 1, sizeZ, plantWidth+spaceBetweenPlants do	
		for count = 1, sizeX, plantWidth+spaceBetweenPlants do
			local randomHeigthVariation = math.random(40,110)
			local randomWidthVariation = math.random(90,120)
			local random = math.random(1,4)
			local color = Color3.new(0.0941176, 0.992157, 0.498039)	
			-- determinate color
			if(random<2) then
				color = plantColor1
			elseif(random<3) then
				color = plantColor2
			else
				color = plantColor3
			end
			-- create part of Plant
			local part = Instance.new("Part")
			part.CanCollide = false
			part.Parent = model
			part.Size = Vector3.new(randomWidthVariation/100*plantWidth, randomHeigthVariation/100*0.8, randomWidthVariation/100*plantWidth)
			part.Position = Vector3.new(grassLeftTopX+count, 13.25, grassLeftTopZ+countZ)
			part.Anchored = true
			part.Transparency = 0
			part.Color = color
			part:SetAttribute('randomHeigthVariation', randomHeigthVariation/100)
			part:SetAttribute('randomWidthVariation', randomWidthVariation/100)
		end
	end
end

-- grow up all Plants
local function growUpAllPlants()
	wait(10)
	local children = script.Parent:FindFirstChild(model.Name):GetChildren()
	for count = 15, 120 do
		for i = 1, #children do		
			local child = children[i]
			-- grow Up
			local perc = count / 30
			child.Size = Vector3.new( 
				tonumber(child:GetAttribute("randomWidthVariation")) * tonumber(plantWidth), 
				tonumber(child:GetAttribute("randomHeigthVariation"))*tonumber(count/(120/plantHeight)), 
				tonumber(child:GetAttribute("randomWidthVariation")) * tonumber(plantWidth)
			)
			--child.Color = Color3.new(0, 1*perc, 0.498039*perc)
		end
		wait(.1)
	end
end


print(grass.Position.X)
print(grass.Size)
-- execute create and grow up Plants
createPlantsOnParcel() 
growUpAllPlants()

----------------


-- TEST
--growUpPlant
--local function growUpPlant(plantType)
--	-- create part of Plant
--	local part2 = Instance.new("Part")
--	part2.Parent = model
--	part2.Size = Vector3.new(.5, 1, .5)
--	part2.Position = Vector3.new(-1065, 13.25, -645.5)
--	part2.Anchored = true
--	part2.Transparency = 0
--	part2.Color = Color3.new(0, 0.686275, 0.329412)
--	part2:SetAttribute('randomAddSize', 100/100)

--	-- create part of Plant
--	local part = Instance.new("Part")
--	part.Parent = model
--	part.Size = Vector3.new(.5, 1, .5)
--	part.Position = pos
--	part.Anchored = true
--	part.Transparency = 0
--	part.Color = Color3.new(0, 1, 0.498039)
--	part:SetAttribute('randomAddSize', 100/100)
--	-- Attach to parent part
--	model.Parent = grass
--	for count = 1, 150 do
--		-- grow Up
--		local perc = count / 150
--		part.Size = Vector3.new(.5, count/16, .5)
--		part.Color = Color3.new(0, 1*perc, 0.498039*perc)
--		part2.Size = Vector3.new(.5, count/18, .5)
--		part2.Color = Color3.new(0, 0.686275*perc,  0.329412*perc)
--		wait(.1)
--	end
--	print('herbe')
--end
