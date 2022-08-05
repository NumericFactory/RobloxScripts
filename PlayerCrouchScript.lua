-- @Author Fred Lossignol / NumericFactory
-- place this script in StarterCharacterScript
--local CP = game:GetService("ContentProvider")
--local Animations = script:WaitForChild("Animations")

--warn("Preloading Animations...")
--CP:PreloadAsync(Animations:GetChildren())
--warn("Animations Loaded!")

local UIS = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")

-- variables for : player is crouched / player is sliding
local CrawlActive = false
local slideActive = false

local Players = game:GetService("Players")
local player = Players.LocalPlayer
-- local char = player.Character or player.CharacterAdded:Wait()
local char = script.Parent
local hum = char:WaitForChild("Humanoid")
local animator = hum:WaitForChild("Animator")

-- get controls userInputs for controls:Enable() and controls:Disable() when player slides
local playerScripts = player:WaitForChild("PlayerScripts")
local playerModule = require(playerScripts:WaitForChild("PlayerModule"))
local controls = playerModule:GetControls()
controls:Enable(true)


-- 3 animations : idle, walk, slide
local animationCrouchIdle = Instance.new("Animation", player.Character)
local animationCrounchWalk = Instance.new("Animation", player.Character)
local animationCrounchSlide = Instance.new("Animation", player.Character)

animationCrouchIdle.AnimationId = "rbxassetid://10478763943"
--animationCrouchIdle.AnimationId = "rbxassetid://3716468774"
animationCrounchWalk.AnimationId = "rbxassetid://10478710322"
animationCrounchSlide.AnimationId = "rbxassetid://10476960905"
local AnimationTrack

--for i, v in ipairs(script: GetChildren()) do

--	print(v.Name)
	
--end

local InitWalkSpeed = hum.WalkSpeed
local CrawlSpeed = InitWalkSpeed/1.8

--task.wait()
-- AnimationTrack = hum:LoadAnimation(animationCrouchIdle)
AnimationTrack = animator:LoadAnimation(animationCrouchIdle)
--repeat task.wait() until AnimationTrack.Length > 0

----------------------------------

local function PlayCrouchIdle(character, animation)
	local humanoid = char:WaitForChild("Humanoid")
	if humanoid then
		-- need to use animation object for server access
		local animator = humanoid:FindFirstChildOfClass("Animator")
		if animator then
			local animationTrack = animator:LoadAnimation(animationCrouchIdle)
			animationTrack:Play()
			return animationTrack
		end
	end
end


----------------------------------

-- when player press C key
UIS.InputBegan:Connect(function(key, i)
	--controls:Enable()

	if key.KeyCode == Enum.KeyCode.C then
		local speed = hum.MoveDirection.Magnitude
		-- if player is crouched, action stand up
		if CrawlActive then
			print("je me met debout")
			CrawlActive = false
			AnimationTrack:Stop()
			--animationCrouchIdle:Stop()
			hum.WalkSpeed = InitWalkSpeed
			hum.JumpPower = 50

			-- if player is standing, action crouch
		elseif CrawlActive == false and slideActive==false then 
			if(hum.WalkSpeed>20 and slideActive==false) then
				-- glissade / slide
				slideActive = true
				print("glissade")
				AnimationTrack = animator:LoadAnimation(animationCrounchSlide)
				hum.WalkSpeed = InitWalkSpeed*4

				local position  = (player.Character.HumanoidRootPart.CFrame.Position)
				print("position")
				print(position)

				local RaycastDirection = player.Character.HumanoidRootPart.CFrame.LookVector * 80
				print("raycast direction")
				print(RaycastDirection)
				-- or
				-- p.CFrame= game.Players[SomePlayer].Character.HumanoidRootPart*CFrame.new(0,0,-6)
				-- player:Move(Vector3.new(0, -1, -1.5), true)

				AnimationTrack:Play()
				controls:Disable()
				player:Move(RaycastDirection, false)

				local timer = 1.7

				for count = 0, 1.7, 0.1 do
					hum.WalkSpeed = hum.WalkSpeed - 4
					if hum.WalkSpeed <= 0 then
						break
					end
					wait(0.1)
				end


				--repeat
				--	hum.WalkSpeed = hum.WalkSpeed - 4
				--	wait(0.1)

				--until hum.WalkSpeed == 0 or 

				AnimationTrack:Stop()
				controls:Enable(true)
				slideActive = false
				hum.WalkSpeed = InitWalkSpeed
			else
				-- accroupissement / crouch
				CrawlActive = true
				-- on determine si le player bouge ou pas 
				-- et on charge la bonne animation
				if hum.MoveDirection ~= Vector3.new(0, 0, 0) then
					--print('i move')		
					AnimationTrack = animator:LoadAnimation(animationCrounchWalk)
				else
					AnimationTrack = animator:LoadAnimation(animationCrouchIdle)
					--PlayCrouchIdle()
				end
				AnimationTrack:Play()

				hum.WalkSpeed = CrawlSpeed
				hum.JumpPower = 0

				--while CrawlActive do

				--	if char.UpperTorso.Velocity == Vector3.new(0,0,0) then
				--		AnimationTrack:AdjustSpeed(0)
				--	else
				--		AnimationTrack:AdjustSpeed(1)
				--	end
				--	wait()

				--end

			end

		end
	end
end)



-- when player press Z, S, Q, D (W,S,A,D) keys 
-- if he is crouhced, change animation to crouch walk
UIS.InputBegan:Connect(function(key, i)

	if CrawlActive then
		print('je suis accroupi')
		print(key.KeyCode)
		if key.KeyCode == Enum.KeyCode.W or key.KeyCode == Enum.KeyCode.S or key.KeyCode == Enum.KeyCode.A or key.KeyCode == Enum.KeyCode.D
			or key.KeyCode == Enum.KeyCode.Up or key.KeyCode == Enum.KeyCode.Down then
			print("j'avance")
			AnimationTrack:Stop()
			AnimationTrack = animator:LoadAnimation(animationCrounchWalk)
			AnimationTrack:Play()

		elseif key.KeyCode == Enum.KeyCode.Space or key.KeyCode == Enum.KeyCode.LeftShift then
			print("je me relève")
			CrawlActive = false
			AnimationTrack:Stop()
			hum.WalkSpeed = InitWalkSpeed
			wait(0.5)
			hum.JumpPower = 50
		else
			print("j'arrete")
			AnimationTrack:Stop()
			AnimationTrack = animator:LoadAnimation(animationCrouchIdle)
			AnimationTrack:Play()
		end
	else
		print('je suis debout')
	end

end)



-- when player unpress Z, S, Q, D (W,S,A,D) keys 
-- if he is crouhced, change animation to crouch Idle
local function endWalk(input, gameProcessed)
	if not gameProcessed then
		if CrawlActive then
			wait(0.05)
			local speed = hum.MoveDirection.Magnitude
			if input.UserInputType == Enum.UserInputType.Keyboard then
				local keycode = input.KeyCode
				if keycode == Enum.KeyCode.W or keycode == Enum.KeyCode.S or keycode == Enum.KeyCode.A or keycode == Enum.KeyCode.D
					or keycode == Enum.KeyCode.Up or keycode == Enum.KeyCode.Down
					then

					--print("SPEED ")
					--print(speed)
					if(speed < 0.5) then
						--print("j'arrete")
						AnimationTrack:Stop()
						AnimationTrack = animator:LoadAnimation(animationCrouchIdle)
						AnimationTrack:Play()	
					else
						AnimationTrack:Stop()
						AnimationTrack = animator:LoadAnimation(animationCrounchWalk)
						AnimationTrack:Play()	
					end	

				end
			end

		end

	end
end

--local function beginWalk(input, gameProcessed)
--	if not gameProcessed then
--		if CrawlActive==false then
--			if input.UserInputType == Enum.UserInputType.Keyboard then
--				local keycode = input.KeyCode
--				if keycode == Enum.KeyCode.W or keycode == Enum.KeyCode.S or keycode == Enum.KeyCode.A or keycode == Enum.KeyCode.D
--					or keycode == Enum.KeyCode.Up or keycode == Enum.KeyCode.Down or keycode == Enum.KeyCode.Left or keycode == Enum.KeyCode.Right  then
--					print("j'arrete")
--					AnimationTrack:Stop()
--					AnimationTrack = hum:LoadAnimation(animationCrouchIdle)
--					AnimationTrack:Play()	
--				end
--			end

--		end
--	end
--end


--UIS.InputBegan:Connect(beginWalk)
UIS.InputEnded:Connect(endWalk)

