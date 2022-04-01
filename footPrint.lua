-- Foot Print
-- @Author: @NumericFactory (Frederic LOSSIGNOL)
-- Instructions : 
-- 1 Place this script in StarterPlayer/StarterPlayerScripts
-- 2 Fix your own parameters below

-----------------------------------
-- Fix your own parameters --------
-----------------------------------
local footPrintDelay = 10 -- fix number of seconds (delay before footprint disappear)
local speedForFootPrint = 17 -- fix the minimum speed of human, then foot will be print on the ground (default : if speedWalk=12, then footprints)
local acceptedMaterials = {"Grass", "Sand", "Ice", "SmoothPlastic"} -- add or remove Material Name (other materials dont print foot on the ground)
local footPrinttransparency = 0.7 -- transparency of footPrint (min 0, max 1)
----------------------------------
-- END Fix your own parameters ---
----------------------------------


-- UTILS FUNCTIONS 
local function utils_set(list)
	local set = {}
	for _, l in ipairs(list) do set[l] = true end
	return set
end
-- verify if a value is in list 
-- use it to verify if groundPart's Material is in AcceptedList
local function arrayContainsValue(arr, val)
	local _set = utils_set(arr)
	return _set[val]~= nil 
end
-- END UTILS FUNCTIONS



----------------------------------
------- CODE ---------------------
----------------------------------
local Debris = game:GetService("Debris")
local player = game.Players.LocalPlayer
local char =  player.Character or player.CharacterAdded:Wait()
local h = char:FindFirstChild('Humanoid') or char:WaitForChild('Humanoid')
local humanSpeed = 0
-- Create a model to hold footPrint parts
local model = Instance.new("Model")
model.Name = "FootP"
-- Attach to parent part
model.Parent = workspace


----------------------------------------------
--	getPlayerHead
--	@return head part of localPlayer
--	(use it to have position of local player)
----------------------------------------------
local function getPlayerHead()
	local player  = game.Players.LocalPlayer
	local character = player.Character or player.CharacterAdded:Wait()
	local head = character:FindFirstChild('Head') or character:WaitForChild('Head')
	return head
end

-------------------------------------------------------
--	footPrint()
--	create 2 parts seems like a footPrint
--	@param : humanPart (the head of player)
--	@param : raycastPosition = the hit position on the ground from workspace:Raycast() (from head of player)
--	@param : groundPart (the part of the ground under the player)
-------------------------------------------------
local function footPrint(humanPart, raycastPosition, groundPart)
	-- Verifier SI le material du sol est accepté (voir les paramètres en haut)
	if ( arrayContainsValue(acceptedMaterials, groundPart.Material.Name) and groundPart.Name ~= 'FootPrint' ) then
		--print("CONTIENT LE MATERIAL ? ")
		--print(arrayContainsValue(acceptedMaterials, groundPart.Material.Name))
		--print(groundPart.Material.Name)
		local newGroupOf2FootPrints = Instance.new("Model")
		newGroupOf2FootPrints.Name = "TwoFeet"
		-- the orientation of Player
		local humanOrientationY = humanPart.Orientation.Y
		-- create footPrint Part
		local footPrint1 = Instance.new('Part')
		-- parameters of footPrint
		footPrint1.Name = 'FootPrint'
		footPrint1.Size = Vector3.new(0.8,0.0001,1)
		footPrint1.Material = Enum.Material.Sand
		footPrint1.Anchored = true
		footPrint1.Transparency = footPrinttransparency 
		footPrint1.CanCollide = false
		-- fix color of footPrint (the same color of groundPart, but more dark)
		local newColorR = groundPart.Color.R
		local newColorG = groundPart.Color.G
		local newColorB = groundPart.Color.B
		--footPrint1.Color = Color3.new(newColorR-0.1, newColorG-0.1, newColorB-0.1)
		footPrint1.Color = Color3.new(0, 0, 0)
		
		-- CFRAME
		footPrint1.CFrame = CFrame.new(0,0,0)
		-- orientation of footprint
		footPrint1.Orientation = Vector3.new(groundPart.Orientation.X, groundPart.Orientation.Y, groundPart.Orientation.Z)
		-- position of footPrint
		local posX = humanPart.Position.X
		local posZ = humanPart.Position.Z
		footPrint1.Position = Vector3.new(raycastPosition.X, raycastPosition.Y+0.01, raycastPosition.Z)
		
		-- create footprint2 (clone footPrint1) 
		local footPrint2 = footPrint1:Clone()
		-- fix position of footPrint1 and footPrint2 
		footPrint1.Position = footPrint1.CFrame * Vector3.new(-0.9,0, 2)
		footPrint2.Position = footPrint1.CFrame * Vector3.new(0.9,0, -2)
		
		-- attach footPrint1 and footPrint2 to workspace
		footPrint1.Parent = newGroupOf2FootPrints
		footPrint2.Parent = newGroupOf2FootPrints
		newGroupOf2FootPrints.Parent = model
		-- fix CFrame box of model of 2 footPrints, and change orientation when player move
		local orientation, size = newGroupOf2FootPrints:GetBoundingBox()
		newGroupOf2FootPrints.PrimaryPart = footPrint1
		newGroupOf2FootPrints:SetPrimaryPartCFrame(newGroupOf2FootPrints:GetPrimaryPartCFrame() * CFrame.new(0.9 , 0, -2))
		newGroupOf2FootPrints:SetPrimaryPartCFrame(newGroupOf2FootPrints:GetPrimaryPartCFrame() * CFrame.Angles(0, math.rad(humanOrientationY), 0))
		
		-- add foorPrint model, and fix the delay. After this delay, footPrints disappear from workSpace
		Debris:AddItem(newGroupOf2FootPrints, footPrintDelay)
	end
end


--------------------------------------------------------------------
-- 	createFootPrint() 
--	when the local player walk at minimum speed (fixed on parameters), 
--	create a footPrint every 0.33second at the positon of local player
---------------------------------------------------------------------
local function createFootPrint()
	while true do
		if(humanSpeed > speedForFootPrint) then	
			local head = getPlayerHead()
			-- 1  Build a "RaycastParams" object
			local raycastParams = RaycastParams.new()
			raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
			raycastParams.FilterDescendantsInstances = {head.Parent}
			raycastParams.IgnoreWater = true
			-- 2 Cast the ray
			local raycastResult = workspace:Raycast(head.Position, Vector3.new(0, -10, 0), raycastParams)
			-- 3 Interpret the result
			if raycastResult then
				if(raycastResult.Instance:isA("Part") and raycastResult.Instance.CanCollide==true)  then
					--print(raycastResult.Position)
					footPrint(head, raycastResult.Position, raycastResult.Instance)	
				end
			end	
		end
		wait(0.33)
	end -- fin while
end

-----------------------------------
-- get speed of player in real time
-----------------------------------
h.Running:connect(function(speed)
	humanSpeed = speed
end)

--------------------
-- Execute Footprint
--------------------
createFootPrint()
