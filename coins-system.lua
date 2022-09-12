-----------------------------------------------------------------------
-- STEP 1 : in ServerScriptService, create a script, 
--          name it LeaderStatsScript, and copy/past the following code
-----------------------------------------------------------------------
local function onPlayerJoin(player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name="leaderstats"
	leaderstats.Parent = player
	
	local coins = Instance.new("IntValue")
	coins.Name="Coins"
	coins.Value = 0
end

game.Players.PlayerAdded:Connect(onPlayerJoin)

--------------------------------------------------------------------------------
-- STEP 2: create a part, name it "coin", 
--         create a new script in this part, and copy/paste thid following code
--------------------------------------------------------------------------------
-- Tween the position of a part when it's touched, then destroy it
local TweenService = game:GetService("TweenService")
local inTween = false

local coin = script.Parent
coin.Anchored = true
coin.CanCollide = false
local coinPosX = coin.Position.X
local coinPosY = coin.Position.Y
local coinPosZ = coin.Position.Z

local sound = Instance.new("Sound", game.Workspace)
sound.SoundId = "rbxassetid://3302699870"

-- Customizable variables
local TWEEN_TIME = 1.1 -- time in seconds for animation coin
local TWEEN_HIGH = 18 -- in percent (exemple 50 is 50%)

-- Tween variables
local tweenInfo = TweenInfo.new(
	TWEEN_TIME,  -- Timetyle?, easingDirection: Enum.EasingDirection?, repeatCount: number?, reverses: boolean?, delayTime: number?): TweenInfo
	Enum.EasingStyle.Linear,  -- EasingStyle
	Enum.EasingDirection.Out  -- EasingDirection
	--1, 
	--false
)

-------------------------
-- collectCoin() function
-------------------------
local function collectCoin(otherPart)
	if inTween == false then
		local humanoid = otherPart.Parent:FindFirstChild("Humanoid")
		if humanoid then
			-- Prevent further collisions on object since it has been picked u

			local player = game.Players:FindFirstChild(otherPart.Parent.Name)
			if player then
				
				sound:Play()
				player.leaderstats.Coins.Value = player.leaderstats.Coins.Value+1

				-- Create a tween and play it
				local tweenObject = TweenService:Create(coin, tweenInfo, 
					{
						Position = Vector3.new(coinPosX, coinPosY+TWEEN_HIGH, coinPosZ),
						Transparency = 0.9
					}
				)
				tweenObject:Play()
				inTween = true
				
				-- On tween completion, destroy object
				tweenObject.Completed:Connect(function()
					coin:Destroy()
				end)
			end
		end
	end	
end

coin.Touched:Connect(collect)
