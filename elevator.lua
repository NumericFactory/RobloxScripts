-- @Author : Fred Lossignol / @NumericFactory

-- INSTRUCTIONS

--		1 create a part and name it "BottomPart" (this part is the ground of elevator)
--		2 rightclick on this "BottomPart" in explorer and click "Group" in menu. This action will create a Model. Name it "Elevator"
-- 		3 into the "BottomPart", create a script and copy/paste this script into
--		4 you can modify variables below ( stepHeightInStuds, elevatorWait, soundElevatorVolume, bipElevatorVolume )

-- END INSTRUCTIONS

local bottomElevatorPart = script.Parent
local elevator = script.Parent.Parent
elevator.PrimaryPart = bottomElevatorPart


-- YOU CAN CHANGE VARIABLES HERE
local stepHeightInStuds = 28 -- hauteur de l'étage (en studs)
local elevatorWait = 3 -- attente entre les departs (en secondes)
local soundElevatorVolume = 0.4 -- volume of sound elevator (0.4/10)
local bipElevatorVolume = 3  -- volume of bip elevator (3/10)
-- END CHANGE VARIABLES


-- -- create sounds
local soundElevator = Instance.new("Sound", bottomElevatorPart)
soundElevator.Name = "ElevatorSound"
soundElevator.SoundId = "rbxassetid://2712429387"  --10783941882

local bipElevator = Instance.new("Sound", bottomElevatorPart)
bipElevator.Name = "ElevatorBip"
bipElevator.SoundId = "rbxassetid://2478450878"  --10783937128
local soundState = "stopped"
soundElevator.Volume = 0.4
bipElevator.Volume = 3.5
soundElevator.RollOffMaxDistance = 100
soundElevator.RollOffMinDistance = 10
bipElevator.RollOffMaxDistance = 20
bipElevator.RollOffMinDistance = 5


----- ELEVATOR STATE ------
local elevatorState = {
	isLaunched = false,
	isInMovement = false,
	step = 0,
	peopleIn = 0
}


------ SOUNDS FUNCTIONS PLAY/STOP -------------
local function soundPlay(sound)
	if(soundState == "stopped") then	
		sound:Play()
		for x = 0,0.2,0.01 do
			sound.Volume = x/2
			wait(0.05)
		end
	end
end


local function soundStop(sound)
	sound:Stop()
end
------ END SOUNDS FUNCTIONS ---------



------ CODE PRINCIPAL / MAIN CODE ---------
local function launchElevator()
	elevatorState.isLaunched = true
	-- ELEVATOR GO UP : from step 0 => to step 1 
	if (elevatorState.isInMovement == false and elevatorState.step==0) then

		elevatorState.isInMovement = true

		local positionX = bottomElevatorPart.Position.X
		local positionY = bottomElevatorPart.Position.Y
		local positionZ = bottomElevatorPart.Position.Z

		soundPlay(soundElevator)	
		for i=1,stepHeightInStuds*10 do	
			positionY = positionY+0.1
			elevator:SetPrimaryPartCFrame(CFrame.new(positionX, positionY, positionZ) ) -- move 20 studs in the y-axis from the origin and rotate 45 degrees in the y-axis
			wait(0.002)
		end
		soundStop(soundElevator)
		soundPlay(bipElevator)
		wait(elevatorWait)

		elevatorState.step = 1
		elevatorState.isInMovement = false
	end
	
	
	-- ELEVATOR GO DOWN : from step 1 => to step 0 
	if (elevatorState.isInMovement == false and elevatorState.step==1) then
		elevatorState.isInMovement = true

		local positionX = bottomElevatorPart.Position.X
		local positionY = bottomElevatorPart.Position.Y
		local positionZ = bottomElevatorPart.Position.Z

		soundPlay(soundElevator)
		for i=1,stepHeightInStuds*10 do	
			positionY = positionY-0.1
			elevator:SetPrimaryPartCFrame(CFrame.new(positionX, positionY, positionZ) ) -- move 20 studs in the y-axis from the origin and rotate 45 degrees in the y-axis
			wait(0.002)
		end
		soundStop(soundElevator)
		soundPlay(bipElevator)
		wait(elevatorWait)

		elevatorState.step = 0
		elevatorState.isInMovement = false
		-- relaunch elevator
		launchElevator()
		
	end
end

-- when player touch the bottom part of elevator
bottomElevatorPart.Touched:Connect(function (part)
	if elevatorState.isLaunched==false then
		launchElevator()
	end
end)
