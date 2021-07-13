-- on Touch Human Burn
-- @Author: FredL
local lava = script.Parent
local debounce = false


local function fire(otherPart)
	if(not debounce) then
		debounce = true
		-- fire
		local partParent = otherPart.Parent
		local humanoid = partParent:FindFirstChild("Humanoid")
		local fireEffect = Instance.new('Fire')
		fireEffect.Parent = otherPart
		-- fire
		local timeRemaining = 10
		while timeRemaining > 0 do
			if humanoid then
				humanoid.Health -= 5
			end
			wait(1)
			timeRemaining = timeRemaining - 1	
		end
		otherPart.Fire:Destroy()
		debounce = false
	end
end

lava.Touched:Connect(fire)
