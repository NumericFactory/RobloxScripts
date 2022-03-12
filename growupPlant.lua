-- GrowUp Plant
-- @Author: @NumericFactory (Frederic LOSSIGNOL)
-- Configuration of the parcel
local grass = script.Parent
local posX = -1067;
local posY = 13.25;
local posZ = -649.5;
local sizeX = 34
local sizeZ = 40
local pos = Vector3.new(posX, posY, posZ);
local towerBaseSize = 30

-- Decide on two colors that are different in hue
local hue = 1/2
local color0 = Color3.fromHSV(hue, 1, 1)
local color1 = Color3.fromHSV((hue + .35) % 1, 1, 1)

local grassLeftTopX = posX - sizeX/2
local grassLeftTopZ = posZ - sizeZ/2

-- Create a model to hold plant parts
local model = Instance.new("Model")
model.Name = "Plant"
-- Attach to parent part
model.Parent = grass

-- create Plants on Parcel
local function createPlantsOnParcel() 
	for countZ = 1, sizeZ, 2 do	
		for count = 1, sizeX, 2 do
			local randomAddSize = math.random(40,110)
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
			part.Size = Vector3.new(.2,randomAddSize/100*0.8, .2)
			part.Position = Vector3.new(grassLeftTopX+count, 13.25, grassLeftTopZ+countZ)
			part.Anchored = true
			part.Transparency = 0
			part.Color = color
			part:SetAttribute('randomAddSize', randomAddSize/100)	

		end
	end
end

-- growUpThisPlant
local function growUpAllPlants()
	wait(10)
	local children = script.Parent:FindFirstChild(model.Name):GetChildren()
	for count = 15, 120 do
		for i = 1, #children do		
			local child = children[i]
			--local addSize = child:GetAttribute("randomAddSize")
			--local size = tonumber(addSize)*tonumber(count/10)
			-- grow Up
			local perc = count / 30
			child.Size = Vector3.new(.2,  tonumber(child:GetAttribute("randomAddSize"))*tonumber(count/18), .2)
			--child.Color = Color3.new(0, 1*perc, 0.498039*perc)
		end
		wait(.1)
	end
end


print(grass.Position)
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
