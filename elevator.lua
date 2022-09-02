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
local heightOfDoors = 11 -- height of the doors elevator (in studs)
local colorOfDoors = Color3.fromRGB(255, 255, 127) -- couleur des portes de l'ascenseur
local materialOfDoors = Enum.Material.SmoothPlastic
local wichSideOfDoors = "X" -- X or Z (choose the side of doors)
local openDoorsRange = 50 -- largeur d'ouverture des portes en % de la largeur
-- END CHANGE VARIABLES


-- -- CREATE SOUNDS
local soundElevator = Instance.new("Sound", bottomElevatorPart)
soundElevator.Name = "ElevatorSound"
soundElevator.SoundId = "rbxassetid://2712429387"  --10783941882

local bipElevator = Instance.new("Sound", bottomElevatorPart)
bipElevator.Name = "ElevatorBip"
bipElevator.SoundId = "rbxassetid://2478450878"  --10783937128

soundElevator.Volume = 0.4
bipElevator.Volume = 3.5
soundElevator.RollOffMaxDistance = 100
soundElevator.RollOffMinDistance = 10
bipElevator.RollOffMaxDistance = 30
bipElevator.RollOffMinDistance = 5
local soundState = "stopped"


-- CREATE ELEVATOR DOORS
local doorLeft = Instance.new("Part")
local doorRight = Instance.new("Part")
doorLeft.Name = "DoorLeft"
doorRight.Name = "DoorRight"
local elevatorPositionX = bottomElevatorPart.Position.X
local elevatorPositionY = bottomElevatorPart.Position.Y
local elevatorPositionZ = bottomElevatorPart.Position.Z

local elevatorWidthSize = 0

if wichSideOfDoors=="X" then
	elevatorWidthSize = bottomElevatorPart.Size.X
	doorLeft.Position = Vector3.new(elevatorPositionX+elevatorWidthSize/2,  elevatorPositionY+ heightOfDoors/2 , elevatorPositionZ+elevatorWidthSize/4)
	doorLeft.Size = Vector3.new(0.2, heightOfDoors, elevatorWidthSize/2) 
	doorRight.Position = Vector3.new(elevatorPositionX+elevatorWidthSize/2, elevatorPositionY+ heightOfDoors/2 , elevatorPositionZ-elevatorWidthSize/4)
	doorRight.Size = Vector3.new(0.2, heightOfDoors, elevatorWidthSize/2) 
else 
	elevatorSize = bottomElevatorPart.Size.Z
	doorLeft.Position = Vector3.new(elevatorPositionX, elevatorPositionY+bottomElevatorPart.Position.Y/2 , elevatorPositionZ-elevatorWidthSize/2)
	doorLeft.Size = Vector3.new(elevatorWidthSize/2, heightOfDoors, 0.2)
end

doorLeft.Anchored = true
doorLeft.Color = colorOfDoors
doorLeft.Material = materialOfDoors
doorLeft.Parent = elevator

doorRight.Anchored = true
doorRight.Color = colorOfDoors
doorRight.Material = materialOfDoors
doorRight.Parent = elevator




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


-----  OPEN/CLOSE DOORS FUNCTION
local function openCloseDoors()
	elevatorPositionY = bottomElevatorPart.Position.Y
	local doorPosLeft = doorLeft.Position.Z
	local doorPosRight = doorRight.Position.Z
	-- ouverture porte gauche et droite
	for i=1,openDoorsRange/2 do	
		doorPosLeft = doorPosLeft+0.1
		doorPosRight = doorPosRight-0.1
		doorLeft.Position = Vector3.new(elevatorPositionX+elevatorWidthSize/2, elevatorPositionY+ heightOfDoors/2 , doorPosLeft)
		doorRight.Position = Vector3.new(elevatorPositionX+elevatorWidthSize/2, elevatorPositionY+ heightOfDoors/2, doorPosRight)
		wait(0.004)
	end
	wait(elevatorWait)
	-- Fermeture porte gauche et droite
	for i=1,openDoorsRange/2 do	
		doorPosLeft = doorPosLeft-0.1
		doorPosRight = doorPosRight+0.1
		doorLeft.Position = Vector3.new(elevatorPositionX+elevatorWidthSize/2, elevatorPositionY+ heightOfDoors/2 , doorPosLeft)
		doorRight.Position = Vector3.new(elevatorPositionX+elevatorWidthSize/2, elevatorPositionY+ heightOfDoors/2 , doorPosRight)
		wait(0.004)
	end	
end



------ CODE PRINCIPAL / MAIN CODE ---------
local function launchElevator()
	elevatorState.isLaunched = true
	-- ELEVATOR GO UP : from step 0 => to step 1 
	if (elevatorState.isInMovement == false and elevatorState.step==0) then

		elevatorState.isInMovement = true

		local positionX = bottomElevatorPart.Position.X
		local positionY = bottomElevatorPart.Position.Y
		local positionZ = bottomElevatorPart.Position.Z

		elevatorPositionY = bottomElevatorPart.Position.Y
		local doorPosLeft = doorLeft.Position.Z
		local doorPosRight = doorRight.Position.Z
		
		
		soundPlay(bipElevator)
		openCloseDoors()
		
		
		soundPlay(soundElevator)
		for i=1,stepHeightInStuds*10 do	
			positionY = positionY+0.1
			elevator:SetPrimaryPartCFrame(CFrame.new(positionX, positionY, positionZ) ) -- move 20 studs in the y-axis from the origin and rotate 45 degrees in the y-axis
			wait(0.002)
		end
		soundStop(soundElevator)

		elevatorState.step = 1
		elevatorState.isInMovement = false
	end
	
	
	-- ELEVATOR GO DOWN : from step 1 => to step 0 
	if (elevatorState.isInMovement == false and elevatorState.step==1) then
		elevatorState.isInMovement = true

		local positionX = bottomElevatorPart.Position.X
		local positionY = bottomElevatorPart.Position.Y
		local positionZ = bottomElevatorPart.Position.Z
		
		soundPlay(bipElevator)
		openCloseDoors()

		soundPlay(soundElevator)
		for i=1,stepHeightInStuds*10 do	
			positionY = positionY-0.1
			elevator:SetPrimaryPartCFrame(CFrame.new(positionX, positionY, positionZ) ) -- move 20 studs in the y-axis from the origin and rotate 45 degrees in the y-axis
			wait(0.002)
		end
		soundStop(soundElevator)
		--soundPlay(bipElevator)
		--wait(elevatorWait)

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
