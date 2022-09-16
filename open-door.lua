-- @Author : Fred Lossignol / NumericFactory
-- Instructions : 
-- 1 > create a door part, add a proximity prompt
-- 2 > add a script in doot part, and copy/past this code 

local Door = script.Parent
local startCFrame = Door.CFrame
local dX2 = Door.Size.X / 2
local isOpened = false

-- CUSTOM VARIABLES
local TIME_TO_OPEN = 1 -- number of seconds to open the door
local TIME_TO_CLOSE = 3 -- number of seconds to close the door
local EASING = 1 -- acceleration: Choose 1 for "FastToLow" | Choose 2 for "Linear"
local ANGLE = 100 -- angle de l'ouverture de la porte en degré (conseillé : 90° à 150° max)
-- END CUSTOM VARIABLES


local sounds = {
	doorOpen = script.Parent:WaitForChild("baldi door_open sound"),
	doorClose = script.Parent:WaitForChild("Door_Close_Sound"),
}


-- Utilities
function CFrameAtPercentage(p)
	return startCFrame 
		* CFrame.new(-dX2, 0, 0) 
		* CFrame.Angles(0, math.rad(ANGLE) * p, 0) 
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

----------------------
-- openDoor() Function
----------------------
function openDoor() 
	sounds.doorOpen:Play()
	local count = 0
	while true do
		-- déceleration animation
		if EASING==1 then
			i = LerpN(i, ANGLE, 1/TIME_TO_OPEN/10)
		-- OU animation vitesse lieaire
		else	
			i=i+ANGLE*0.33/TIME_TO_OPEN/10
		end
		
		Door.CFrame = CFrameAtPercentage(i/(ANGLE-5))
		count = count+1
		wait()
		if i>=ANGLE-5 then
			break
		end
	end
	print(count)
	Door.ProximityPrompt.ActionText = "Close"
end


-----------------------
-- closeDoor() Function
-----------------------
function closeDoor()
	sounds.doorOpen:Play()
	while true do
		-- déceleration animation
		if EASING==1 then
		i = LerpN(i,-5, 1/TIME_TO_CLOSE/10)
		-- OU animation vitesse lieaire
		else	
			i=i-ANGLE*0.33/TIME_TO_OPEN/10
		end
		Door.CFrame = CFrameAtPercentage(i/(ANGLE-5))
		wait()
		if i<=1 then
			break
		end
	end
	Door.ProximityPrompt.ActionText = "Open"
end
------------------------------------
-- Fin Function openDoor() et closeDoor()


---------------------------------------------------------
-- CODE PRINCIPAL : QUAND LE PROXIMITY PROMPT EST ACTIVÉ PÄR LE PLAYE
script.Parent.ProximityPrompt.Triggered:Connect(function()
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
