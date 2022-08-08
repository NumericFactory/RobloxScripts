-- @Author : Frederic LOSSIGNOL / Numeric Factory

-- INSTRUCTIONS ----------------------

-- 1 : create GUI in StarterGui folder
--      > Create a frame and name it "Background"
--      > Under "Background" Frame, Create a new frame, and name it StaminaDisplay
-- 2 : Under "StaminaDisplay" Frame, Create a LocalScript, and copy/paste the following script 

-- END INSTRUCTIONS -------------------
local numberIndicatorTextLabel
local player = game.Players.LocalPlayer
local character = player.Character

local UserInputService = game:GetService("UserInputService")

local sprintSpeed = 26
local walkSpeed = 16

local stamina = 100
local running = false

-- print bar with counter
withCounter = false

if withCounter then
	numberIndicatorTextLabel = script.Parent.Parent.NumberIndicatorLabel
end

--local bindableEvent = game.Workspace:WaitForChild("isPlayerRunningEvent")

stamina = math.clamp(stamina, 0, 100)

UserInputService.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.LeftControl then
		running = true
		--character.Humanoid.WalkSpeed = sprintSpeed
		while stamina > 0 and running do
			stamina = stamina - 0.5
			if stamina<=1  then
				stamina=0
			end
			script.Parent:TweenSize(UDim2.new(stamina/100,0,1,0),"Out","Linear", 0)
			
			if withCounter then
				if stamina == 0 then
					numberIndicatorTextLabel.Text = "0"
				else
					numberIndicatorTextLabel.Text = (math.floor(stamina+0.5))
				end
			end
			

			wait()
			if stamina == 0 then
				character.Humanoid.WalkSpeed = walkSpeed
				-------------------------
				--bindableEvent:Fire()
				-------------------------
			end

		end
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.LeftControl then
		running=false
		character.Humanoid.WalkSpeed = walkSpeed
		while stamina < 100 and not running do
			stamina = stamina + 0.75
			script.Parent:TweenSize(UDim2.new(stamina/100,0,1,0),"Out","Linear", 0)
			
			if withCounter then
				numberIndicatorTextLabel.Text = (math.floor(stamina)) 
			end
				
			wait()
			if stamina == 0  then
				character.Humanoid.WalkSpeed = walkSpeed
			end
		end

	end
end)
