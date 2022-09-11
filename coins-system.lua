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
--          create a new script in this part, and copy/paste thid following code
--------------------------------------------------------------------------------
local coin = script.Parent
local sound = Instance.new("Sound", game.Workspace)
sound.SoundId = "rbxassetid://3302699870"

local function collect(otherPart)
	local player = game.Players:FindFirstChild(otherPart.Parent.Name)
	if player  then
		sound:Play()
		player.leaderstats.Coins.Value = player.leaderstats.Coins.Value+1
		coin:Destroy()
	end
end

coin.Touched:Connect(collect)
