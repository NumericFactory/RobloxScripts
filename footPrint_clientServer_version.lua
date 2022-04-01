-- Foot Print
-- @Author: @NumericFactory (Frederic LOSSIGNOL)
------------------------------------------------


-- FOLLOW THE INSTRUCTIONS----------------------

-- 1 SCRIPT PART 1
-- ** create a LocalScript in > StarterPlayer > StarterPlayerScripts, and rename it "footPrint"
-- ** copy/paste the "PART 1" of this script

-- 2 SCRIPT PART 2
-- ** create a Script in > ServerScriptService, and rename it "onFootPrint"
-- ** copy/paste the "PART 2" of this script

-- 3 CREATE REMOTE EVENT
-- ** in > "ReplicatedStorage", click "+" and create a RemoteEvent
-- ** Rename it "RemoteEventFootPrint"

-- 4 Fix your own parameters below

-- END INSTRUCTIONS ---------------------------


-----------------------------------------------
--	START SCRIPT PART 1 --
-----------------------------------------------

-----------------------------------
-- Fix your own parameters --------
-----------------------------------
local speedForFootPrint = 16 -- fix the minimum player speed, then foot will be print on the ground (default : if speedWalk > 12, then footprints)
local footPrintDelay = 10 -- fix number of seconds (delay before footprint disappear)
local acceptedMaterials = {"Grass", "Sand", "Ice", "SmoothPlastic"} -- add or remove Material Name (other materials don't print foot on the ground)
local footPrintTransparency = 0.75 -- transparency of footPrint - min 0, max 1 (full transparency)
----------------------------------
-- END Fix your own parameters ---
----------------------------------

----------------------------------
------- CODE ---------------------
----------------------------------
local replicatedStorage = game:GetService("ReplicatedStorage")
local remoteEventFootPrint = replicatedStorage:WaitForChild("RemoteEventFootPrint")

local player = game.Players.LocalPlayer
local char =  player.Character or player.CharacterAdded:Wait()
local h = char:FindFirstChild('Humanoid') or char:WaitForChild('Humanoid')
local humanSpeed = 0

----------------------------------------------
--	getPlayerHead()
--	@return : head part of localPlayer
--	(use it to have position of local player)
----------------------------------------------
local function getPlayerHead()
	local player  = game.Players.LocalPlayer
	local character = player.Character or player.CharacterAdded:Wait()
	local head = character:FindFirstChild('Head') or character:WaitForChild('Head')
	return head
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
					-- print(raycastResult.Position)	
					-- Server version : Fire the remote event
					remoteEventFootPrint:FireServer(
						head, 
						raycastResult.Position, 
						raycastResult.Instance,
						footPrintDelay, 
						acceptedMaterials, 
						footPrintTransparency)
				end
			end	
		end
		wait(0.3)
	end -- fin while
end

-----------------------------------
-- get speed of player in real time
-----------------------------------
h.Running:connect(function(speed)
	humanSpeed = speed
end)

-----------------------------------------------
--	END SCRIPT PART 1 --
-----------------------------------------------




-----------------------------------------------
--	START SCRIPT PART 2 --
-- (script 1 is in > StarterPlayer > StarterPlayerScripts, and named "footPrint")
-----------------------------------------------

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteEventFootPrint = ReplicatedStorage:WaitForChild("RemoteEventFootPrint")

local Debris = game:GetService("Debris")

-- Create a model to hold footPrint parts
local model = Instance.new("Model")
model.Name = "FootP"
-- Attach to parent part
model.Parent = workspace
------------------------

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


-- Create a new part
-------------------------------------------------------
--	footPrint()
--	create 2 parts seems like a footPrint
--	@param : humanPart (the head of player)
--	@param : raycastPosition = the hit position on the ground from workspace:Raycast() (from head of player)
--	@param : groundPart (the part of the ground under the player)
-------------------------------------------------
local function onFootPrint(player, humanPart, raycastPosition, groundPart, footPrintDelay, acceptedMaterials, footPrintTransparency)
	print("HOHEY")
	-- Verify if ground material is accepted (voir les paramètres en haut)
	if ( arrayContainsValue(acceptedMaterials, groundPart.Material.Name) and groundPart.Name ~= 'FootPrint' ) then

		local newGroupOf2FootPrints = Instance.new("Model")
		newGroupOf2FootPrints.Name = "TwoFeet"
		-- the heigh of the point of groundPart under the Player
		local raycastHeightPoint = raycastPosition.Y
		-- the orientation of Player
		local humanOrientationY = humanPart.Orientation.Y
		-- create footPrint Part
		local footPrint1 = Instance.new('Part')
		-- parameters of footPrint
		footPrint1.Name = 'FootPrint'
		footPrint1.Size = Vector3.new(0.8,0.0001,1)
		footPrint1.Material = Enum.Material.Sand
		footPrint1.Anchored = true
		footPrint1.Transparency = footPrintTransparency 
		footPrint1.CanCollide = false
		-- fix color of footPrint (the same color of groundPart, but more dark)
		local newColorR = (groundPart.Color.R-0.3 >= 0) and groundPart.Color.R-0.25 or 0
		local newColorG = (groundPart.Color.G-0.3 >= 0) and groundPart.Color.G-0.25 or 0
		local newColorB = (groundPart.Color.B-0.3 >= 0) and groundPart.Color.B-0.25 or 0
		newColorR = (newColorG > 0 and newColorB > 0) and newColorR or 0
		newColorG = (newColorR > 0 and newColorB > 0) and newColorG or 0
		newColorB = (newColorR > 0 and newColorG > 0) and newColorB or 0
		--footPrint1.Color = Color3.new(newColorR-0.1, newColorG-0.1, newColorB-0.1)
		footPrint1.Color = Color3.new(newColorR,newColorG,newColorB)

		-- CFRAME
		footPrint1.CFrame = CFrame.new(0,0,0)
		-- orientation of footprint
		footPrint1.Orientation = Vector3.new(groundPart.Orientation.X, groundPart.Orientation.Y, groundPart.Orientation.Z)
		-- position of footPrint (X,Z=coordinates of player, Y= coordinate of ground part+0.01)
		local posX = humanPart.Position.X
		local posZ = humanPart.Position.Z
		footPrint1.Position = Vector3.new(posX, raycastHeightPoint+0.01, posZ)

		-- create footprint2 (clone footPrint1) 
		local footPrint2 = footPrint1:Clone()
		-- fix position of footPrint1 and footPrint2 with CFrame
		footPrint1.Position = footPrint1.CFrame * Vector3.new(-0.9,0, 2)
		footPrint2.Position = footPrint1.CFrame * Vector3.new(0.9,0, -2)

		-- attach footPrint1 and footPrint2 to workspace
		footPrint1.Parent = newGroupOf2FootPrints
		footPrint2.Parent = newGroupOf2FootPrints
		newGroupOf2FootPrints.Parent = model
		-- fix CFrame box of model of 2 footPrints, and change orientation when player move
		local orientation, size = newGroupOf2FootPrints:GetBoundingBox()
		newGroupOf2FootPrints.PrimaryPart = footPrint1
		newGroupOf2FootPrints:SetPrimaryPartCFrame(newGroupOf2FootPrints:GetPrimaryPartCFrame() * CFrame.new(0.9 , 1, -2))
		newGroupOf2FootPrints:SetPrimaryPartCFrame(newGroupOf2FootPrints:GetPrimaryPartCFrame() * CFrame.Angles(0, math.rad(humanOrientationY), 0))

		-- add foorPrint model, and fix the delay. After this delay, footPrints disappear from workSpace
		Debris:AddItem(newGroupOf2FootPrints, footPrintDelay)

		---- attach script under footPrint Parts
		--local scr = replicatedStorage.LocalDisappearPart
		--local clonedScr = scr:Clone()
		--local clonedScr2 = scr:Clone()
		--clonedScr.Parent = footPrint1
		--clonedScr2.Parent = footPrint2
		--clonedScr.Disabled = false
		--clonedScr2.Disabled = false	
	end
end

-- Call "onCreatePart()" when the client fires the remote event
RemoteEventFootPrint.OnServerEvent:Connect(onFootPrint)

-----------------------------------------------
--	END SCRIPT PART 2 --
-----------------------------------------------
