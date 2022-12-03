-- under a tool, create a LocalScript and copy/paste this script
-- @Author : Fred Lossignol / NumericFactory

-- IMPORTATIONS SERVICES et data
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jaugePowerEvent = ReplicatedStorage.jaugePowerEvent --fire
local PlayerIsEquippedEvent = ReplicatedStorage.PlayerIsEquippedEvent --fire
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local hrp = player.CharacterAdded:Wait():WaitForChild("HumanoidRootPart");

local mouse = player:GetMouse();
local UIP = game:GetService("UserInputService")
--rayResult(mousePos.X, mousePos.Y)

local tw = game:GetService("TweenService")
local Ball = script.Parent
local playerIsArmingBall = false 
local inputBeganEvent -- register event when mouse is clicked in a variable
local inputEndedEvent -- register event when mouse is clicked in a variable
local powerJauge -- number 0-100



-----------------------
-- LISTE DES ANIMATIONS
-----------------------
local animationEquiped = Instance.new("Animation")
animationEquiped.AnimationId = "rbxassetid://11707623700"
-- animation when player prepare his shoot
local armBall = Instance.new("Animation")
armBall.AnimationId = "rbxassetid://11708155622"
-- animation when player shoot
local launchBall = Instance.new("Animation")
launchBall.AnimationId = "rbxassetid://11708159168"
-- anmations track
local animationIdleTrack
local animationArmBallTrack
local animationLaunchTrack
-- FIN LISTE DES ANIMATIONS


--------------------------------
-- YOU CAN CHANGE VARIABLES HERE
--------------------------------
-- (customize properties of animations, distance & speed player can launch the ball,...)
local MAX_MOUSE_DISTANCE = 1000
local BALL_DISTANCE_PLAYER_CAN_LAUNCH = 125	-- distance in studs
local MAX_SPEED_BALL = 150 			-- speed max of the ball if 100% jauge power
local BALL_TIME_TO_GOAL = 1.5			-- time in seconds (greater number make the ball more slowly)
local ANIMATION_TIME_ARM = 1			-- temps de l'animation quand le player arme son tir (en secondes)
--------------------------------
-- Fin Custom variables


-------------------
-- FONCTIONS UTILES
-------------------
-- Play a certain animation with time we want
local function playAnimationForDuration(animationTrack, duration)
	local speed = animationTrack.Length / duration
	animationTrack:Play()
	animationTrack:AdjustSpeed(speed)
end

-- JaugePowerUp function
local function jaugePowerUp()
	-- upt 0 to 100 in 1 second
	for i=20,100,5  do
		powerJauge = i
		jaugePowerEvent:Fire(i)
		--print("power" .. powerJauge)
		wait(ANIMATION_TIME_ARM/16)
		if playerIsArmingBall == false then
			break
		end
	end	
end
-- https://create.roblox.com/docs/tutorials/scripting/intermediate-scripting/hit-detection-with-lasers
local function getWorldMousePosition()
	local mouseLocation = UIP:GetMouseLocation()
	-- Create a ray from the 2D mouseLocation
	local screenToWorldRay = workspace.CurrentCamera:ViewportPointToRay(mouseLocation.X, mouseLocation.Y)
	-- The unit direction vector of the ray multiplied by a maximum distance
	local directionVector = screenToWorldRay.Direction * MAX_MOUSE_DISTANCE
	-- Raycast from the ray's origin towards its direction
	local raycastResult = workspace:Raycast(screenToWorldRay.Origin, directionVector)
	if raycastResult then
		-- Return the 3D point of intersection
		return raycastResult.Position
	else
		-- No object was hit so calculate the position at the end of the ray
		return screenToWorldRay.Origin + directionVector
	end
end
-- Fin fonctions utiles

mouse.Move:Connect(function()
	local theplace = player.Character.Torso.CFrame:toObjectSpace(mouse.Hit).lookVector
	local value1 = CFrame.new(0,1.025,0) * CFrame.Angles(math.tan   (theplace.Y)+math.rad(-90),0,math.acos   (theplace.X)+math.rad(90))
end)


--*******************************************
--*****START PROGRAM FUNCTIONS***************

----------------------------------------------
-- PlayerIsEquipped() FUNCTION
-- 
-- This function is launched
-- when ball.equipped Event is fired (at the end of code)

-- > Play animations with ball 
-- * on click mouse button : armer le tir
-- * on unclick mouse button : lancer la balle
-----------------------------------------------
function PlayerIsEquipped() 
	-- jouer l'animation 
	print("J'ai la BALLE ")
	--UIP.MouseIconEnabled = true
	mouse.Icon = "rbxassetid://2151638245" 
	-- 3400146391 (classic) / 11232270732 (target circle white) / 358650765 (target crosshair pink) / 7527551515 (target purple neon)
	
	PlayerIsEquippedEvent:Fire(true)
	playerIsArmingBall = false
	wait()
	local Character = Ball.Parent
	local Humanoid = Character:FindFirstChildOfClass("Humanoid")
	
	animationIdleTrack = Humanoid:LoadAnimation(animationEquiped)
	animationArmBallTrack = Humanoid:LoadAnimation(armBall)
	animationLaunchTrack = Humanoid:LoadAnimation(launchBall)	
	animationIdleTrack.Priority = Enum.AnimationPriority.Action3
	animationArmBallTrack.Priority = Enum.AnimationPriority.Action4
	animationLaunchTrack.Priority = Enum.AnimationPriority.Action3
	
	-- PLAY IDLE WHEN PLAYER IS EQUIPPED WITH BALL
	animationIdleTrack:Play()
	animationArmBallTrack:Stop()
	animationLaunchTrack:Stop()
	
	-- ADD EVENT LISTENER CLICK MOUSE1 BUTTON (click enfoncé)
	inputBeganEvent = UIP.InputBegan:Connect(function(input)
			
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			playerIsArmingBall = not playerIsArmingBall
			if playerIsArmingBall then
				Ball.Ball.Transparency = 0
				-- PLAY PLAYER ANIMATION ARM BALL
				print("j'arme mon tir")
				coroutine.wrap(function()
					-- this will run independently
					jaugePowerUp()
				end)()
				
				animationLaunchTrack:Stop()
				playAnimationForDuration(animationArmBallTrack, ANIMATION_TIME_ARM) -- jouer l'animation (avec une durée 1 seconde)
				wait(ANIMATION_TIME_ARM - 0.05) -- (l'animation dure 1 seconde, on la stoppe juste avant : 0.99s)
				animationArmBallTrack:AdjustSpeed(0)
			end
		end
	end)
	
	
	-- ADD EVENT LISTENER UNCLICK MOUSE1 BUTTON (click relâché)
	inputEndedEvent = UIP.InputEnded:Connect(function(input)
		
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			Ball.Ball.Transparency = 1
			-- PLAY PLAYER ANIMATION SHOOT BALL
			playerIsArmingBall = false
			print("Je lance la balle ! ")
		
			animationArmBallTrack:Stop()
			wait()
			playAnimationForDuration(animationLaunchTrack, 0.3) -- jouer l'animation (avec une durée 0.3 seconde)
			
			------------------------
			--TIR - FRED SOLUTION --
			-- 1 get the player position / or get the mouseLocation
			-- 2 get a raycast direction vector and get the speed of the ball
			-- 3 compute position point for the ball at the end of animation
			-- 4 prepare params for animation
			-- 5 RayCast to determine if ball hit a part (human or decor) and stop the animation
			-- 6 create newBall in workspace and give properties to this ball
			-- 7 Animate
			------------------------
			
			
			local mouseLocation = getWorldMousePosition()
			-- Calculate a normalised direction vector and multiply by laser distance
			local targetDirection = (mouseLocation - Ball.Handle.Position).Unit

			-- The direction to fire the weapon multiplied by a maximum distance
			local RaycastDirection = targetDirection * BALL_DISTANCE_PLAYER_CAN_LAUNCH * powerJauge / 100

			-- Ignore the player's character to prevent them from damaging themselves
			--local weaponRaycastParams = RaycastParams.new()
			--weaponRaycastParams.FilterDescendantsInstances = {Players.LocalPlayer.Character}
			--local weaponRaycastResult = workspace:Raycast(Ball.Handle.Position, directionVector, weaponRaycastParams)
			
			
			--***************************--
			
			-- 1 get the player position
			-- local position  = (player.Character.HumanoidRootPart.CFrame.Position) -- player position
			local position = Ball.Handle.Position
			
			
			-- 2  get a raycast direction vector / un rayon pour la direction en face du regard du joueur + 55 studs de distance
			-- local RaycastDirection = player.Character.HumanoidRootPart.CFrame.LookVector * BALL_DISTANCE_PLAYER_CAN_LAUNCH * powerJauge / 100
			
			local ballSpeed = MAX_SPEED_BALL * powerJauge / 100
			--print("raycast direction")
			--print(RaycastDirection)
			
			-- 3  compute position point for the ball at the end of animation / calculer la position du point qu'atteindra la balle (à partir de la position du joueur)
			local properties = {
				Position = position + Vector3.new(RaycastDirection.X, RaycastDirection.Y-1, RaycastDirection.Z)
			}
			
			-- 4 prepare params for animation / préparer les paramètres de l'animation de la balle
			local tweenInfo = TweenInfo.new(
				BALL_DISTANCE_PLAYER_CAN_LAUNCH/MAX_SPEED_BALL, --time it takes to run
				Enum.EasingStyle.Linear, -- style of twwen
				Enum.EasingDirection.Out -- direction of Tween
				-- -1, -- repeat
				--true, -- tween reverse
				-- 1 -- Delay Time	
			)

			-- 5 RayCast to determine if ball hit a part (human or decor) and stop the animation
			-- > if raycast hit a part (human or decor)
			-- > stop the tween animation (how ? i modifiying the distance)
			-- (i do that because tweenAnimation is not able to stop object when collision)
			-- 5.1 Build a "RaycastParams" object
			local raycastParams = RaycastParams.new()
			raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
			raycastParams.FilterDescendantsInstances = {player.Character.HumanoidRootPart.Parent}
			raycastParams.IgnoreWater = true
			-- 5.2 Cast the ray
			local raycastResult = workspace:Raycast(position, Vector3.new(RaycastDirection.X, RaycastDirection.Y-2, RaycastDirection.Z), raycastParams)
			-- 5.3 Interpret the result
			if RaycastDirection then
				if(raycastResult and raycastResult.Instance:isA("Part") and raycastResult.Instance.CanCollide==true)  then
					--print("raycastresult position")
					--print(raycastResult.Position)
					local distance = raycastResult.Distance
					properties.Position = raycastResult.Position
					--ballSpeed = (BALL_DISTANCE_PLAYER_CAN_LAUNCH * powerJauge / 100) / BALL_TIME_TO_GOAL -- 125/1.5 = 83m/s
					print("******")
					print("******")
					print("******")
					print("power : ".. powerJauge)
					print("distance : " .. distance .. "m")
					print("vitesse : " .. ballSpeed .. "m/s")
					print("temps trajet balle : " .. distance/ballSpeed .. "seconds")
					print("*********************")
					print("part touchée : " ..  raycastResult.Instance.Name )
					tweenInfo =  TweenInfo.new(
						distance/ballSpeed, --time it takes to run (125m/1.5s = 83m/s)+
						Enum.EasingStyle.Linear, -- style of twwen
						Enum.EasingDirection.Out -- direction of Tween
						-- -1, -- repeat
						--true, -- tween reverse
						-- 1 -- Delay Time	
					)
				end
			end	
			
			-- 6 create newBall in workspace and give properties to this ball (when player shoot)
			local newBall = Instance.new("Part")
			newBall.Anchored = false
			newBall.Name = 'newBall'
			newBall.Shape = Enum.PartType.Ball
			newBall.Size = Vector3.new(1.7, 1.7, 1.7)
			newBall.Color = Color3.new(117, 0, 0)
			newBall.CanCollide = true
			newBall.Position = position + Vector3.new(0,0, 1) --
			newBall.Parent = workspace
			
			--controls:Disable()
			
			-- 7 play ball animation from player position -> to point
			local tween = tw:Create(newBall, tweenInfo, properties)
			newBall.Touched:Connect(function(otherPart)
				if otherPart.Parent.Name == "Tree" then
					newBall.Color = Color3.new(0.941176, 0.0941176, 1)
					tween:Pause()
				end
			end)
			tween:Play()
			powerJauge = 20
			jaugePowerEvent:Fire(powerJauge)
			--print("power" .. powerJauge)
			
			
			-- (and disappear ball in workspace after delay)
			game.Debris:AddItem(newBall,BALL_TIME_TO_GOAL+0.5) -- si la balle met 1seconde à arriver au but, elle mettre 1.5s à disparaitre du workspace
			
			-----------------------------
			-- FIN TIR - FRED SOLUTION --
			-----------------------------		
		end
	end)

end
-- END PlayerIsEquipped() function




-----------------------------------------------------------------
-- PlayerIsUnequipped() function
-- this function is launched when ball.unequipped Event is fired

-- Stop all animations of the ball 
-- and disconnect event click and unclick
-----------------------------------------------------------------
function PlayerIsUnequipped()
	-- when player is unequipped : stop all animations with ball
	mouse.Icon =""
	playerIsArmingBall = false
	PlayerIsEquippedEvent:Fire(false)
	animationIdleTrack:Stop()
	animationArmBallTrack:Stop()
	animationLaunchTrack:Stop()
	inputBeganEvent:Disconnect()
	inputEndedEvent:Disconnect()
end



-----------------------
-- ADD EVENT LISTENERS 
-----------------------
Ball.Equipped:Connect(PlayerIsEquipped)
Ball.Unequipped:Connect(PlayerIsUnequipped)
--Ball.Activated:Connect(Activated)
