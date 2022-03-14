-- GrowUp Plant
-- @Author: @NumericFactory (Frederic LOSSIGNOL)
-- HOW TO USE : add this script on a part and fix your own parameters

-- FIX YOUR OWN PARAMETERS
local plantColor1 = Color3.new(0.0941176, 0.992157, 0.498039) 	-- Fix the color1 of your plants
local plantColor2 = Color3.new(0.541176, 1, 0.376471)			-- Fix the color2 of your plants
local plantColor3 = Color3.new(0, 0.541176, 0.25098)			-- Fix the color3 of your plants

local plantHeight = 7 			-- Fix average height size of your Plants. The height variation is 40% to 110%
local plantWidth = .1  			-- Fix average width  size of your plants. The width  variation is 90% to 110%
local spaceBetweenPlants = 1.8	-- Fix average space between your plants.
-- END FIX YOUR OWN PARAMETERS 

------------------------------

-- Get the coords of the parcel
local grass = script.Parent
local posX = grass.Position.X;
local posY = grass.Position.Y;
local posZ = grass.Position.Z;
local sizeX = grass.Size.X
local sizeZ = grass.Size.Z

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
		local randomSpacingVariation = math.random(90,110)
		for count = 1, sizeX, randomSpacingVariation/100*spaceBetweenPlants do
			local randomHeigthVariation = math.random(40,110)
			local randomWidthVariation = math.random(90,120)
			local random = math.random(1,4)
			local color = Color3.new(0.0941176, 0.992157, 0.498039)	
			-- determinate a random color
			if(random<2) then
				color = plantColor1
			elseif(random<3) then
				color = plantColor2
			else
				color = plantColor3	
			end
			-- create part of Plants with properties
			local part = Instance.new("Part")
			part.CanCollide = false
			part.Material = Enum.Material.SmoothPlastic
			part.Size = Vector3.new(randomWidthVariation/100*plantWidth, 0, randomWidthVariation/100*plantWidth)
			part.Position = Vector3.new(grassLeftTopX+count, 13.25, grassLeftTopZ+countZ)
			part.Anchored = true
			part.Transparency = 0
			part.Color = color
			part:SetAttribute('randomHeigthVariation', randomHeigthVariation/100)
			part:SetAttribute('randomWidthVariation', randomWidthVariation/100)
			part:SetAttribute('originalColor', color)
			part.Parent = model
		end
	end
end

-- grow up all Plants
local function growUpAllPlants()
	wait(5)
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
