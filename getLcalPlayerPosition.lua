-- GET position of local player
-- @Author: @NumericFactory (Frederic LOSSIGNOL)


-- When player move, get his POSITION
local function getPositionOfLocalPlayer()
	local player = game.Players.LocalPlayer
	local char = player.Character or player.CharacterAdded:Wait()
	local head = char:FindFirstChild("Head") or char:WaitForChild("Head")
	--local part = workspace.Part
	while true do
		print(head.Position)
		wait(5)
	end
end
