-- @Author : Fred Lossignol / NumericFactory
-- Instructions : 
-- 1 > create a door part, add a proximity prompt
-- 2 > add a script in doot part, and copy/past this code

local Door = script.Parent
local startCFrame = Door.CFrame
local dX2 = Door.Size.X / 2
local isOpened = false

-- CUSTOM VARIABLES
local TIME_TO_OPEN = 5 -- number of seconds to open the door
local TIME_TO_CLOSE = 1 -- number of seconds to close the door
-- END CUSTOM VARIABLES



local sounds = {
	doorOpen = script.Parent:WaitForChild("baldi door_open sound"),
	doorClose = script.Parent:WaitForChild("Door_Close_Sound"),
}


-- Utilities
function CFrameAtPercentage(p)
	return startCFrame 
		* CFrame.new(-dX2, 0, 0) 
		* CFrame.Angles(0, math.rad(90) * p, 0) 
		* CFrame.new(dX2, 0, 0)
end

function LerpN(a, b, t)
	return a + (b - a) * t
end

function LerpNInv(a, b, t)
	return a + (b + a) * t
end
-- utilities


------------------------------------
-- Function openDoor() et closeDoor()
local i = 0



function openDoor() 
	sounds.doorOpen:Play()
	local count = 0
	while true do
		i = LerpN(i, 90, 1/TIME_TO_OPEN/10)
		--print(i)
		Door.CFrame = CFrameAtPercentage(i/85)
		count = count+1
		wait()
		if i>=85 then
			break
		end
	end
	print(wait())
	print(count)
	Door.ProximityPrompt.ActionText = "Close"
	isOpened = true

end

function closeDoor()
	sounds.doorOpen:Play()
	while true do
		i = LerpN(i, -90, 1/TIME_TO_CLOSE/10)
		--print(i)
		Door.CFrame = CFrameAtPercentage(i/90)
		wait()
		if i<=1 then
			break
		end
	end
	Door.ProximityPrompt.ActionText = "Open"
	isOpened = false
end
------------------------------------
-- Fin Function openDoor() et closeDoor()


---------------------------------------------------------
-- CODE PRINCIPAL : QUAND LE PROXIMITY PROMPT EST ACTIVÉ PÄR LE PLAYE

script.Parent.ProximityPrompt.Triggered:Connect(function()
	--Door.CFrame=Door.CFrame*CFrame.Angles(0,45,0)
	if isOpened == false then
		
		openDoor()
		isOpened = true
		--print(isOpened)
		
	else
		
		closeDoor()
		isOpened = false
		--print(isOpened)
		
	end
	
end)





