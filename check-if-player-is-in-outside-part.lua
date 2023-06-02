-- ******** INSTRUCTIONS ***************************** --
-- 1 create a part in workspace and name it "place1part" 
-- 2 past this code in localscript in StarterCharacterScripts
-- **************************************************** --

local place1part = workspace.place1part -- rename by the name of your own part

-- importations des services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Character = Players.LocalPlayer.Character


local function checkIfPlayerIsInPart(humanPartPosition, part)
	local relPos = part.CFrame:PointToObjectSpace(humanPartPosition)
	return (math.abs(relPos.X) <= part.Size.X / 2)
		   and (math.abs(relPos.Z) <= part.Size.Z / 2)
end -- Function that returns true if player is within part


--*********************************************************--
-- ***** START CHECK LOOP
-- ***** IF PLAYER IS INSIDE OR OUTSIDE OF THE PART ****** --
--*********************************************************--
local Step = os.clock()
local DelayTime = 1 -- how long between each check

RunService.Heartbeat:Connect(function()
	if os.clock() - Step >= DelayTime then -- if new time - last time checked is > than the DelayTime then continue
		Step = os.clock() -- set the last checked time to current time
		local humanoidRootPartPos = Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position
		local isPlayerOnPart = checkIfPlayerIsInPart(humanoidRootPartPos, place1part)
      
		if(isPlayerOnPart) then
			print(Players.LocalPlayer.Name .. 'entre')
		else
			print(Players.LocalPlayer.Name .. 'sort')
		end
      
	end
end)
-- END START CHECK LOOP
