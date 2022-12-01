-- under a tool, create a LocalScript and copy/paste this script
-- @Author : Fred Lossignol / NumericFactory

-- IMPORTATIONS SERVICES et data
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jaugePowerEvent = ReplicatedStorage.jaugePowerEvent --fire
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local hrp = player.CharacterAdded:Wait():WaitForChild("HumanoidRootPart");
local mouse = player:GetMouse();
local UIP = game:GetService("UserInputService")
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
	for i=20,100,4  do
		powerJauge = i
		jaugePowerEvent:Fire(i)
		--print("power" .. powerJauge)
		wait(0.05)
		if playerIsArmingBall == false then
			break
		end
	end	
end

-- JaugePowerDown function
local function jaugePowerDown()
	-- upt 0 to 100 in 1 second
	local waitTime = powerJauge * 0.3 /100
	for i=powerJauge,0,1  do
		powerJauge = i
		print("power" .. powerJauge)
	end	
end
-- Fin fonctions utiles


--------------------------------
-- YOU CAN CHANGE VARIABLES HERE
--------------------------------
-- (customize properties of animations, distance & speed player can launch the ball,...)
local BALL_DISTANCE_PLAYER_CAN_LAUNCH = 125 	-- distance in studs
local BALL_TIME_TO_GOAL = 1.5 				-- time in seconds (greater number make the ball more slowly)
local ANIMATION_TIME_ARM = 1               	-- temps de l'animation quand le player arme son tir (en secondes)
--------------------------------
-- Fin Custom variables


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
			
			-- PLAY PLAYER ANIMATION SHOOT BALL
			playerIsArmingBall = false
			print("Je lance la balle ! ")
		
			animationArmBallTrack:Stop()
			wait()
			playAnimationForDuration(animationLaunchTrack, 0.3) -- jouer l'animation (avec une durée 0.3 seconde)
			
			------------------------
			--TIR - FRED SOLUTION --
			-- 1 get the player position
			-- 2 get a raycast direction vector
			-- 3 compute position point for the ball at the end of animation
			-- 4 prepare params for animation
			-- 5 RayCast to determine if ball hit a part (human or decor) and stop the animation
			-- 6 create newBall in workspace and give properties to this ball
			-- 7 
			------------------------
			
			-- 1 get the player position
			local position  = (player.Character.HumanoidRootPart.CFrame.Position) -- player position
			--print("position")
			--print(position)
			
			-- 2  get a raycast direction vector / un rayon pour la direction en face du regard du joueur + 55 studs de distance
			local RaycastDirection = player.Character.HumanoidRootPart.CFrame.LookVector * BALL_DISTANCE_PLAYER_CAN_LAUNCH * powerJauge / 100
			--print("raycast direction")
			--print(RaycastDirection)
			
			-- 3  compute position point for the ball at the end of animation / calculer la position du point qu'atteindra la balle (à partir de la position du joueur)
			local properties = {
				Position = position + Vector3.new(RaycastDirection.X-1, RaycastDirection.Y+2.3, RaycastDirection.Z)
			}
			
			-- 4 prepare params for animation / préparer les paramètres de l'animation de la balle
			local tweenInfo = TweenInfo.new(
				BALL_TIME_TO_GOAL, --time it takes to run
				Enum.EasingStyle.Quart, -- style of twwen
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
			local raycastResult = workspace:Raycast(position, Vector3.new(RaycastDirection.X, RaycastDirection.Y+3, RaycastDirection.Z), raycastParams)
			-- 5.3 Interpret the result
			if RaycastDirection then
				if(raycastResult and raycastResult.Instance:isA("Part") and raycastResult.Instance.CanCollide==true)  then
					--print("raycastresult position")
					--print(raycastResult.Position)
					local distance = raycastResult.Position.Z - position.Z - 12
					properties.Position = raycastResult.Position
					tweenInfo =  TweenInfo.new(
						distance/BALL_DISTANCE_PLAYER_CAN_LAUNCH * BALL_TIME_TO_GOAL, --time it takes to run
						Enum.EasingStyle.Quad, -- style of twwen
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
			newBall.Position = position + Vector3.new(0,2, 2) --
			newBall.Parent = workspace
			--controls:Disable()
			
			-- 7 play ball animation from player position -> to point
			local tween = tw:Create(newBall, tweenInfo, properties)
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
