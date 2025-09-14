---- STRUCTURE DU SYTEME DE SHOP + INVENTAIRE

---- EVENTS
---- ReplicatedStorage
---- ├── EquipEmote (RemoteEvent) -- déjà fait
---- ├── BuyItem (RemoteEvent)    -- nouvel event achat
---- ├── InventoryUpdated (RemoteEvent) -- nouvel event mise à jour inventaire
---- ├── GetShop (RemoteFunctions) -- pour obtenir le shop serveur->client
---- ├── GetInventory (RemoteFunction) -- pour obtenir l'inventaire serveur->client

---- SERVEUR
---- ServerScriptService
---- └── ShopManager (Script)     -- gère shop + inventaires


---- CLIENT
---- StarterGui
---- └── LobbyGui        -- déjà fait (il contient les boutons shop et inventory)
---- └── ShopGui         --  (nouveau Gui) 
----     └── ShopFrame       --  (à créer sans propriété car géré par le code) 
---- └── InventoryGui    --  (nouveau Gui) 
----     └── InventoryFrame  --  (à créer sans propriété car géré par le code) 





-- ***********************************
-- ServerScriptService/ShopManager.lua
-- (Script serveur qui gère le shop global et l'inventaire des joueurs)
-- ***********************************

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

-- RemoteEvent achat
local BuyEvent = ReplicatedStorage:FindFirstChild("BuyItem")
if not BuyEvent then
	BuyEvent = Instance.new("RemoteEvent")
	BuyEvent.Name = "BuyItem"
	BuyEvent.Parent = ReplicatedStorage
end

-- RemoteFunction pour obtenir le shop
local GetShop = ReplicatedStorage:FindFirstChild("GetShop")
if not GetShop then
	GetShop = Instance.new("RemoteFunction")
	GetShop.Name = "GetShop"
	GetShop.Parent = ReplicatedStorage
end

-- RemoteFunction pour obtenir l'inventaire
local GetInventory = ReplicatedStorage:FindFirstChild("GetInventory")
if not GetInventory then
	GetInventory = Instance.new("RemoteFunction")
	GetInventory.Name = "GetInventory"
	GetInventory.Parent = ReplicatedStorage
end

-- RemoteEvent pour mettre à jour l’inventaire côté client
local InventoryUpdated = ReplicatedStorage:FindFirstChild("InventoryUpdated")
if not InventoryUpdated then
	InventoryUpdated = Instance.new("RemoteEvent")
	InventoryUpdated.Name = "InventoryUpdated"
	InventoryUpdated.Parent = ReplicatedStorage
end

-- DataStore pour inventaires
local InventoryStore = DataStoreService:GetDataStore("PlayerInventory")

-- SHOP GLOBAL
local Shop = {
	{name = "Dance1", type = "Emote", price = 50},
	{name = "Dance2", type = "Emote", price = 75},
	{name = "Dance3", type = "Emote", price = 100},
	{name = "Wave", type = "Emote", price = 60},
	{name = "Laugh", type = "Emote", price = 80},
	{name = "Clap", type = "Emote", price = 120},
	{name = "Point", type = "Emote", price = 150},
	{name = "Backflip", type = "Emote", price = 200},
	{name = "Sit", type = "Emote", price = 90},
	{name = "Cheer", type = "Emote", price = 110},
}

-- Inventaires en mémoire
local PlayerInventories = {}

-- Charger inventaire
local function LoadInventory(player)
	local data
	local success, err = pcall(function()
		data = InventoryStore:GetAsync(player.UserId)
	end)
	if not success then
		warn("Erreur chargement inventaire: " .. err)
	end
	if not data then
		data = {Inventory = {}}
	end
	print('INVENTAIRE : ', data.Inventory)
	return data.Inventory
end

-- Sauvegarder inventaire
local function SaveInventory(player, inventory)
	local success, err = pcall(function()
		InventoryStore:SetAsync(player.UserId, {Inventory = inventory})
	end)
	if not success then
		warn("Erreur sauvegarde inventaire: " .. err)
	end
end

-- Vérifier si joueur possède déjà un item
local function HasItem(inventory, itemName)
	for _, it in ipairs(inventory) do
		if it.name == itemName then
			return true
		end
	end
	return false
end

-- Achat d’un item
BuyEvent.OnServerEvent:Connect(function(player, itemName)
	local inventory = PlayerInventories[player.UserId]
	if not inventory then return end

	-- Trouver item dans le shop
	local itemData
	for _, shopItem in ipairs(Shop) do
		if shopItem.name == itemName then
			itemData = shopItem
			break
		end
	end
	if not itemData then return end

	-- Déjà possédé ?
	if HasItem(inventory, itemName) then
		return
	end

	-- Vérifier argent
	local money = player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Money")
	if not money then return end

	if money.Value < itemData.price then
		return
	end

	-- Retirer argent
	money.Value -= itemData.price

	-- Ajouter item
	table.insert(inventory, {name = itemData.name, type = itemData.type})

	-- Envoyer inventaire mis à jour au client
	InventoryUpdated:FireClient(player, inventory)

	print(player.Name .. " a acheté " .. itemName .. " pour " .. itemData.price)
end)

-- RemoteFunction : obtenir le Shop
GetShop.OnServerInvoke = function(player)
	print('GET SHOP : ', Shop)
	return Shop
end

-- RemoteFunction : obtenir inventaire
GetInventory.OnServerInvoke = function(player)
	print('GET INVENTORY FROM FUNCTION : ',PlayerInventories[player.UserId]  )
	return PlayerInventories[player.UserId] or {}
end

-- Cycle joueur
Players.PlayerAdded:Connect(function(player)
	local inv = LoadInventory(player)
	PlayerInventories[player.UserId] = inv
	-- Envoi initial de l'inventaire
	InventoryUpdated:FireClient(player, inv)
end)

Players.PlayerRemoving:Connect(function(player)
	local inv = PlayerInventories[player.UserId]
	if inv then
		SaveInventory(player, inv)
		PlayerInventories[player.UserId] = nil
	end
end)

game:BindToClose(function()
	for _, player in ipairs(Players:GetPlayers()) do
		local inv = PlayerInventories[player.UserId]
		if inv then
			SaveInventory(player, inv)
		end
	end
end)







-- ***********************************
-- On suppose qu'il y a déjà les GUI Button : 
-- StarterGui
---- └── LobbyGui (Gui)
----     └── Main (frame)
----        └── InventoryFrame
----            └── ImageButton
----        └── ShopFrame
----            └── ImageButton

-- on crée le local script "ShopClientScript"
-- StarterGui/LobbyGui/ShopClientScript (localscript)
-- (Script client qui gère les Gui Shop et Inventory)
-- ***********************************

-- LocalScript sous ton ScreenGui

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GetShop = ReplicatedStorage:WaitForChild("GetShop")
local GetInventory = ReplicatedStorage:WaitForChild("GetInventory")
local BuyEvent = ReplicatedStorage:WaitForChild("BuyItem")
local InventoryUpdated = ReplicatedStorage:WaitForChild("InventoryUpdated")

-- Références GUI
local screenGui = script.Parent.Parent.Parent
local shopFrame = screenGui.ShopGui:WaitForChild("ShopFrame")
local invFrame = screenGui.InventoryGui:WaitForChild("InventoryFrame")

-- References boutons
local mainGui = script.Parent
local shopButton = mainGui.ShopFrame:WaitForChild("ImageButton")
local inventoryButton = mainGui.InventoryFrame:WaitForChild("ImageButton")

-- Config utilitaire pour les Frames
local function SetupFrame(frame)
	frame:ClearAllChildren()

	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Vertical
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 5)
	layout.Parent = frame

	return frame
end

-- Crée et affiche le Shop
local function DisplayShop(shopList)
	SetupFrame(shopFrame)

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0, 0, 40)
	title.Text = "Shop des Emotes"
	title.BackgroundTransparency = 1
	title.TextScaled = true
	title.Font = Enum.Font.SourceSansBold
	title.TextColor3 = Color3.new(1,1,1)
	title.Parent = shopFrame

	for _, itemData in ipairs(shopList) do
		local button = Instance.new("TextButton")
		button.Size = UDim2.new(1, -10, 0, 35)
		button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		button.TextColor3 = Color3.new(1,1,1)
		button.TextScaled = true
		button.Font = Enum.Font.SourceSans
		button.Text = itemData.name .. " - " .. itemData.price .. "$"
		button.Parent = shopFrame

		button.MouseButton1Click:Connect(function()
			BuyEvent:FireServer(itemData.name)
		end)
	end
end

-- Crée et affiche l’Inventaire
local function DisplayInventory(inventory)
	SetupFrame(invFrame)

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0, 0, 40)
	title.Text = "Mon Inventaire"
	title.BackgroundTransparency = 1
	title.TextScaled = true
	title.Font = Enum.Font.SourceSansBold
	title.TextColor3 = Color3.new(1,1,1)
	title.Parent = invFrame

	if #inventory == 0 then
		local lbl = Instance.new("TextLabel")
		lbl.Size = UDim2.new(1, 0, 0, 30)
		lbl.Text = "Inventaire vide"
		lbl.BackgroundTransparency = 1
		lbl.TextScaled = true
		lbl.Font = Enum.Font.SourceSansItalic
		lbl.TextColor3 = Color3.fromRGB(200,200,200)
		lbl.Parent = invFrame
	else
		for _, it in ipairs(inventory) do
			local lbl = Instance.new("TextLabel")
			lbl.Size = UDim2.new(1, -10, 0, 30)
			lbl.Text = "• " .. it.name
			lbl.BackgroundTransparency = 1
			lbl.TextScaled = true
			lbl.Font = Enum.Font.SourceSans
			lbl.TextColor3 = Color3.fromRGB(220,220,220)
			lbl.Parent = invFrame
		end
	end
end

-- Masquer frames au départ
shopFrame.Visible = false
invFrame.Visible = false

-- Bouton Shop
shopButton.MouseButton1Click:Connect(function()
	shopFrame.Visible = not shopFrame.Visible
	invFrame.Visible = false

	if shopFrame.Visible then
		local shopList = GetShop:InvokeServer()
		DisplayShop(shopList)
	end
end)

-- Bouton Inventory
inventoryButton.MouseButton1Click:Connect(function()
	invFrame.Visible = not invFrame.Visible
	shopFrame.Visible = false

	if invFrame.Visible then
		local inventory = GetInventory:InvokeServer()
		DisplayInventory(inventory)
	end
end)

-- Quand le serveur actualise l’inventaire
InventoryUpdated.OnClientEvent:Connect(function(newInventory)
	if invFrame.Visible then
		DisplayInventory(newInventory)
	end
end)











--******* ORGANISATION FINALE DU JEU (optionnel et à voir selon votre structure) **********
--******************************************************************************************

-- ServerScriptService
-- * MoneyScript (ou ton script actuel qui gère la monnaie)
-- * ShopManager (le script complet serveur qui est donné +haut)

-- ReplicatedStorage
-- * MoneyEvent (remoteEvent)
-- * BuyItem (remoteEvent)
-- * GetShop (remoteFunction)
-- * GetInventory (remoteFunction)
-- * InventoryUpdated 

-- StarterGui
-- * LobbyGui
--   * Main
--     * ShopClientScript (localScript que je t’ai donné en dernier, qui contient tout le code UI)
--     * InventoryFrame (menu qui contient un imageButton)
--     * ShopFrame (menu qui contient un imageButton)



-- Credits - Script and GUI Created By : Noah & Fred Lossignol
