-- Foot Sound
-- @Author: @NumericFactory (Frederic LOSSIGNOL)
------------------------------------------------
-- Instructions
-- put this script in > StarterPlayer > StarterPlayerScripts

local player = game.Players.LocalPlayer
local char =  player.Character or player.CharacterAdded:Wait()
local Humanoid = char:FindFirstChild('Humanoid') or char:WaitForChild('Humanoid')
local Walk = char.HumanoidRootPart:FindFirstChild("Running")
while true do
	wait()
	
	if Humanoid then
		if Humanoid.FloorMaterial == Enum.Material.Grass then
			Walk.SoundId = "rbxassetid://252965149"
			Walk.PlaybackSpeed = 1.5
			Humanoid.WalkSpeed = 14
		
		elseif Humanoid.FloorMaterial == Enum.Material.Sand then
			Walk.SoundId = "rbxassetid://1083174706"
			Walk.PlaybackSpeed = 1.5
			Humanoid.WalkSpeed = 12
		
		elseif Humanoid.FloorMaterial == Enum.Material.Concrete then
			Walk.SoundId = "rbxassetid://833564121"
			Walk.PlaybackSpeed = 1.5  
			Walk.Volume = 2
			Humanoid.WalkSpeed = 16
		
		elseif Humanoid.FloorMaterial == Enum.Material.Plastic then
			Walk.SoundId = "rbxassetid://833564121"
			Walk.PlaybackSpeed = 1.5
			Walk.Volume = 2
			Humanoid.WalkSpeed = 16
			
		elseif Humanoid.FloorMaterial == Enum.Material.Wood then
			Walk.SoundId = "rbxassetid://9083826864"
			Walk.PlaybackSpeed = 1
			Walk.Volume = 2
			Humanoid.WalkSpeed = 14
			
		elseif Humanoid.FloorMaterial == Enum.Material.Ice then
			Walk.SoundId = "rbxassetid://1078976955"
			Walk.PlaybackSpeed = 1
			Walk.Volume = 2
			Humanoid.WalkSpeed = 16
			
		else
			Walk.SoundId = "rbxassetid://833564121"
			Walk.Volume = 2
			Walk.PlaybackSpeed = 1.5
			Humanoid.WalkSpeed = 16
		end
	end
end
