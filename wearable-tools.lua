--@Author ; Fred Lossignol / NumericFactory

------------------------------------------------------
-- Instructions
------------------------------------------------------

-- 1 Launch Play, and copy/past your player in workspace

-- 2 Create Tool, name it "Lantern" and duplicate it

-- 3 Create an Accessory in workSpace and rename it LanternAccessory
--   > Copy/paste all the parts of duplicated tool into the LanternAccessory

-- 4 Copy a bodyPart Attachment of player (ex: RightHand>RightGripAttachment)
--   > paste it into LanternAccessory Handle

-- 5 On the edition tool, place LanternAccessory and the attachement point like you want on the player copy

-- 6 Create folder "HolderSystem" in ServerScriptService and in...
--   > create a new script, name it :  "RespawnHandler"
--   > create a new module script, name it : "HolsteringModule"

-- 7 Create folder "Items" in ServerStorage, in ...
--	 > create a folder named "Accessories", and copy/paste the duplicated accessory "LanternAccessory"
--   > create a folder named "Tools", and copy/paste the tool named "lantern"

-- 8 Copy/paste the following 2 scripts in : 
--   > "RespawnHandler"
-- 	 > "HolsteringModule"

------------------------------------------------------
-- FIN Instructions
------------------------------------------------------




------------------------------------------------------
-- ServerScriptService / HolsterSystem/ RespawnHandler
------------------------------------------------------
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
	
local Items = ServerStorage.Items

local HolsteringSystem = require(script.Parent.HolsteringModule)

local function ItemHolstering(player)
	player.CharacterAdded:Connect(function(Character)
		
		player.CharacterRemoving:Connect(function(char)
			char:Destroy()
		end)
		
		
		
		local Backpack = player:WaitForChild("Backpack")
		
		
		
		Character.ChildAdded:Connect(function(NewItem)
			
			if NewItem:IsA("Tool")  then
				
				local AccessoryCheck = Character:FindFirstChild(NewItem.Name.."Accessory")
				
				if AccessoryCheck then
					HolsteringSystem.Holster(AccessoryCheck,1)
				
				elseif not AccessoryCheck then
					
					local ToolList = HolsteringSystem.GetToolList()
					
					if ToolList then
						
						local TableCheck = table.find(ToolList, NewItem.Name)
						local Accessories = Items:FindFirstChild("Accessories")
						
						if TableCheck and Accessories then
							
							local Accessory = Accessories:FindFirstChild(NewItem.Name.."Accessory")
							local Humanoid = Character:FindFirstChild("Humanoid")
							
							if Accessory and Humanoid  then
								
								local cloneAccessory = Accessory:Clone()
								HolsteringSystem.Holster(cloneAccessory, 1, true, Humanoid)
								
							end
							
						end
					end
					
				end
				
			end
			
		end)
		
		
		
		
		
		
		local function ItemRemoved (OldItem, OldContainer)
			if OldItem:IsA("Tool") then
				local AccessoryCheck = Character:FindFirstChild(OldItem.Name.."Accessory")
				
				if AccessoryCheck and OldContainer==Backpack then
					
					if OldItem.Parent == Character then
						warn(OldItem.Name.."has left the Backpack and it's not the character. It is being destroyed")
						AccessoryCheck:Destroy()
					end
					
				elseif AccessoryCheck and OldContainer == Character then
					if OldItem.Parent ~= Backpack then
						warn(OldItem.Name.."has left the Character and it's not the backpack. It is being destroyed")
						AccessoryCheck:Destroy()
						
					elseif OldItem.Parent == Backpack then
							HolsteringSystem.Holster(AccessoryCheck,0)
					end
		
				end
				
			end
		end
		
		
		
		
		Character.ChildRemoved:Connect(function(OldItem)
			ItemRemoved(OldItem, Character)
		end)
		
		
		Backpack.ChildRemoved:Connect(function(OldItem)
			ItemRemoved(OldItem, Backpack)
		end)
		
		
	end)
end


for _,player in ipairs(Players:GetPlayers()) do
	coroutine.wrap(ItemHolstering)(player)
end

Players.PlayerAdded:Connect(ItemHolstering)

----------------------------------------------------------
-- Fin ServerScriptService / HolsterSystem/ RespawnHandler
----------------------------------------------------------






















---------------------------------------------------------
-- ServerScriptService / HolsterSystem / HolsteringModule
---------------------------------------------------------

--local ServerStorage = game:GetService("ServerStorage")
--local Items = ServerStorage.Items

--local ToolList = {}

--local function UpdateItemList(NewItem)
--	local ToolsFolder = Items:FindFirstChild("Tools")
--	if ToolsFolder  then
--		if NewItem and not table.find(ToolList, NewItem.Name) then
--			table.insert(ToolList, NewItem.Name)
--		else
--			for _,Tool in ipairs(ToolsFolder:GetChildren()) do
--				if not table.find(ToolList, Tool.Name) then
--					table.insert(ToolList, Tool.Name)
--				end
--			end
--		end
--	end

--end



--UpdateItemList()



--Items.Tools.ChildAdded:Connect(function(NewItem)
--	if NewItem:IsA("Tool") then
--		UpdateItemList(NewItem)
--	end
--end)




--local HolsterSystem = {}


--function HolsterSystem.GetToolList()
--	return ToolList
--end

--function HolsterSystem.Holster(Accessory, Transparency, AddToCharacter, Humanoid)
--	local AccesoryCheck = typeof(Accessory) == "Instance" and Accessory:IsA("Accessory")
--	local TransparencyCheck = typeof(Transparency) == "number" and Transparency >= 0 and Transparency <= 1

--	if AccesoryCheck and TransparencyCheck then

--		for _,Item in ipairs(Accessory:GetDescendants()) do
--			if Item:IsA("BasePart") then
--				Item.Transparency = Transparency
--			end
--		end

--	end

--	local AddToCharacterCheck = typeof(AddToCharacter)=="boolean" and AddToCharacter 
--	local HumanoidCheck = typeof(Humanoid) == "Instance" and Humanoid:IsA("Humanoid")

--	if 	AccesoryCheck 
--		and AddToCharacterCheck 
--		and HumanoidCheck then

--		Humanoid:AddAccessory(Accessory)

--	end

--end

--return HolsterSystem


-------------------------------------------------------------
-- FIN ServerScriptService / HolsterSystem / HolsteringModule
-------------------------------------------------------------


	
	
