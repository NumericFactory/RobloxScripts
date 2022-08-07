-- @Author : Fred Lossignol / NumericFactory
-- Instructions : 
-- 1 > create a door part, add a proxiumity prompt
-- 2 > copy/past this script under door part

-- Variables 
local Door = script.Parent
local startCFrame = Door.CFrame
local dX2 = Door.Size.X / 2
local isOpened = false

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
-- utilities


--------------------------------------
-- Function openDoor() et closeDoor()
local i = 0

function openDoor() 
	while true do
		i = LerpN(i, 90, 0.05)
		print(i)
		Door.CFrame = CFrameAtPercentage(i/90)
		wait()
		if i>=89 then
			break
		end
	end
end

function closeDoor()
	while true do
		i = LerpN(i, -90, 0.05)
		print(i)
		Door.CFrame = CFrameAtPercentage(i/90)
		wait()
		if i<=1 then
			break
		end
	end
end
-----------------------------------------
-- Fin Function openDoor() et closeDoor()


-----------------------------------------------------
-- CODE PRINCIPAL : 
-- QUAND LE PROXIMITY PROMPT EST ACTIVÉ PAR LE PLAYER
-----------------------------------------------------
script.Parent.ProximityPrompt.Triggered:Connect(function()
	--Door.CFrame=Door.CFrame*CFrame.Angles(0,45,0)
	if isOpened == false then
		
		openDoor()
		isOpened = true
		print(isOpened)
		
	else
		
		closeDoor()
		isOpened = false
		print(isOpened)
		
	end
	
end)




