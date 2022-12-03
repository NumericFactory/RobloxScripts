-- in StarterPlayerScript, create a LocalScript
-- @Author : Frederic Lossignol / NumericFactory

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local head = character:WaitForChild("Head")
local torso = character:WaitForChild("Torso")
local mouse = player:GetMouse()
local camera = workspace.CurrentCamera

mouse.Move:Connect(function()
	--print((mouse.Origin.p - mouse.Hit.p).unit.x)
	local diff = camera.CFrame.LookVector:Dot(Vector3.new(0, 1, 0))
	local angle = 45 * diff
	print("diff" .. diff )
	
	torso["Neck"].C0 =  CFrame.new(0,1,0) * CFrame.Angles(-math.asin((mouse.Origin.p-mouse.Hit.p).Unit.y)+1.55,  3.15,  -math.asin(( mouse.Origin.p - mouse.Hit.p ).Unit.x) );
	torso["Right Shoulder"].C0 = CFrame.new(1,0.5,0) * CFrame.Angles(-math.asin((mouse.Origin.p - mouse.Hit.p).unit.y),1.55,0)
	torso["Left Shoulder"].C0 = CFrame.new(-1,0.5,0) * CFrame.Angles(-math.asin((mouse.Origin.p - mouse.Hit.p).unit.y),-1.55,0)
end)
