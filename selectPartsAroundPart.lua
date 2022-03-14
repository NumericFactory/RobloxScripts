-- Select Parts around selected part in the same Parent Model
-- @Author: @NumericFactory (Frederic LOSSIGNOL)
-- HOW TO USE : Add this script below StarterPlayer.StarterPlayerScripts
--				and FIX your own parameters

------------------------------
-- FIX YOUR OWN PARAMETERS
local partParentName = 'Plant'
local radius = 2 						-- Fix the distance of selected plznt (all plants around this distance will be selected too)
local selectionColor = Color3.new(0.00784314, 0.521569, 1)  	-- Fix the color of Selection
local selectionNeon = true 					-- Fix if selection Material is neon (true or false)
-- END FIX YOUR OWN PARAMETERS 
------------------------------

local UIS = game:GetService('UserInputService')
local player = game.Players.LocalPlayer
local character = player.Character


local mouse = player:GetMouse()

-- collect parts and group them by tag
local Plants = game.Workspace:GetChildren('Plant')
print(Plants[1].name)

-- Check if pointB is in area of pointA (circle) 
-- With Pythagore we check if distance between these 2 points < than radius we determinate
local function checkIfPointIsInArea(pointAPosition, pointBPosition, rad)
	local distanceBetweenPoints = math.sqrt( (pointAPosition.X-pointBPosition.X)^2 + (pointAPosition.Z-pointBPosition.Z)^2 )
	if(distanceBetweenPoints<rad) then
		return true	
	end
	return false
end

-- When mouse move, detect position of selected part, and select other parts around
UIS.InputChanged:Connect(function()
	if mouse.Target then
		if(mouse.Target.Parent.Name == 'Plant') then	
			local allPlantParts = mouse.Target.Parent:GetChildren()
			local selectedPlantPosition	
			for i = 1, #allPlantParts do		
				local child = allPlantParts[i]
				child.Material = Enum.Material.SmoothPlastic
				allPlantParts[i].Color = allPlantParts[i]:GetAttribute("originalColor")
				if(child == mouse.Target)  then
					-- get the position of targeted plant
					selectedPlantPosition = child.Position
				end
			end
			--select all Plant around targeted plant
			for i = 1, #allPlantParts do
				if( checkIfPointIsInArea(selectedPlantPosition, allPlantParts[i].Position, radius) ) then
					if(selectionNeon) then
						allPlantParts[i].Material = Enum.Material.Neon	
					end
					allPlantParts[i].Color = selectionColor
				end
			end
			--player.PlayerGui.NameGui.Enabled = true
			--player.PlayerGui.NameGui.Adornee = mouse.Target
			--player.PlayerGui.NameGui.TextLabel.Text = mouse.Target.Name
			-- mouse.Target.Color = Color3.new(0.333333, 1, 1)
		else
			
		end
	end
end)
