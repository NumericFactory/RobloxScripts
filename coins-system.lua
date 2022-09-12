-- @Author : Frederic Lossigno - @NumericFactory
-- Instructions : follow the 3 steps to create a coin system

-----------------------------------------------------------------------
-- STEP 1 : in ServerScriptService, create a script and name it LeaderStatsScript, 
--	    Then, copy/past the following code in this script file
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
----------------------------------- end STEP 1





--------------------------------------------------------------------------------
-- STEP 2: in workspace, create a folder, name it "coins"
--         in this folder "coins", create a part (or import mesh) and name it "MarioCoin", 
--         Then, create a new script in this part, and copy/paste thid following code
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
					sound:Destroy()
				end)
			end
		end
	end	
end

coin.Touched:Connect(collectCoin)
---------------------- end STEP 2



--------------------------------------------------------------------------------
-- STEP 3: in workspace, create a part and name it SurfaceCoinsPart
--         create a new script in this part, and copy/paste thid following code
--------------------------------------------------------------------------------
local surface = script.Parent
surface.Transparency = 0.8

local coins = workspace:WaitForChild("coins")
local originaCoin = coins.MarioCoin;

-- CUSTOM VARIABLES---------------------------------
local density = 10 -- number of coins on the surface
----------------------------------------------------

local x = surface.Size.X/2
local y = surface.Size.Y/2
local z = surface.Size.Z/2

local lastPositionCoin = Vector3.new(0,0,0)
local isOnRight = false
local isOnTop = false

local function simpleSpawnCoin()
	local copyCoin = originaCoin:Clone()
	copyCoin.Position = surface.Position + Vector3.new(math.random(-x, x), 2.5, math.random(-z, z))
	copyCoin.Name = "COIN"
	copyCoin.Anchored=true
	copyCoin.Parent = surface
	return copyCoin
end

for i=1,density do
	local newCoin = simpleSpawnCoin()
end
------ end STEP 3
