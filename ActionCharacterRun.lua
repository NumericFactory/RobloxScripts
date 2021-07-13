local Player = game.Players.LocalPlayer
local character = Player.Character
local humanoid = character:FindFirstChild("Humanoid")

local ContextActionService = game:GetService("ContextActionService")

local animation = Instance.new("Animation")
animation.AnimationId = "rbxassetid://7090276952"
animation.Parent = humanoid
loadedAnimation = humanoid:LoadAnimation(animation)

local UserInputService = game:GetService("UserInputService")

-- Shift keys
local walkKeyL = Enum.KeyCode.Z
local walkKeyR = Enum.KeyCode.Up

-- Return whether left or right shift keys are down
local isWalkKeyPressed
local function IsWalkKeyDown()
	if UserInputService:IsKeyDown( Enum.KeyCode.Z) or UserInputService:IsKeyDown( Enum.KeyCode.Up) then
		isWalkKeyPressed = true
	else
		isWalkKeyPressed = false
	end
end

-- ********** --

local isM
local function isPlayerMoving()
	if humanoid.MoveDirection.Magnitude > 0 then -- Are we walking?
		isM = true
	else
		isM = false

	end
end

-- ChangeWalkspeed
local function ChangeWalkspeed(walkspeed)
	if character ~= nil then
		if humanoid ~= nil then
			isPlayerMoving()
			IsWalkKeyDown()
			print(isWalkKeyPressed)
			humanoid.WalkSpeed = walkspeed
			if walkspeed > 16 and isM  then
				loadedAnimation:Play()
			elseif walkspeed <= 16 and isM  then	
				loadedAnimation:Stop()
			end
		else 

		end
	end
end

-- SprintHandler
local function SprintHandler(actionName,userInputState,inputObject)
	--this recieves parameters from contextactionservice that we could use.
	if userInputState == Enum.UserInputState.Begin then
		ChangeWalkspeed(30)
	elseif userInputState == Enum.UserInputState.End then
		ChangeWalkspeed(16)

	end
end	

-- Action Running
ContextActionService:BindAction("Sprint",SprintHandler,true,Enum.KeyCode.LeftShift)
