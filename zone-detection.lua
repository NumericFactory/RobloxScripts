-- @Author : Fred Lossignol (NumericFactory)
-- isPlayerInZone() / 
-- script qui vérifie quand le localPlayer entre ou sort d'une zone
-- dans StarterPlayer/StarterPlayerScripts

-- selectionner la part autour de laquelle on définira une zone
local part = workspace:WaitForChild('grass1');

--------------------------------------------------
-- FONCTIONS UTILES
--------------------------------------------------

-- Récupérer la position du localPlayer
local function getPlayerPosition()
	local player  = game.Players.LocalPlayer
	local character = player.Character or player.CharacterAdded:Wait()
	local head = character:FindFirstChild('Head') or character:WaitForChild('Head')
	return head.Position
end

-- Verifier SI le player est dans la zone de part "grass1"
local function checkIfPlayerIsInArea(playerPosition, part)
	local distance = math.sqrt( 
		(playerPosition.X-part.Position.X)^2 + (playerPosition.Z-part.Position.Z)^2
	)
	-- Determiner le rayon du cercle (la zone)
	local radius = 0
	if (part.Size.X > part.Size.Y) then
		radius = (part.Size.X/2) + 10
	else
		radius = (part.Size.Z/2) + 10
	end
	-- Verifier si le player est dans la zone
	if (distance < radius) then
		--print("VOUS ETES ENTRE DANS LA ZONE")
		return true
	else 
		--print("VOUS ETES HORS DE LA ZONE")
		return false
	end
end

--------------------------------------------------
--FONCTION PRINCIPALE
--------------------------------------------------

-- Vérifier SI le Player ENTRE ou SORT d'une Zone
-- QUAND le player ENTRE, on affiche "VOUS ETES ENTRE"
-- QUAND le player SORT, on affiche "VOUIS ETES SORTI"
local function isPlayerInZone()
	local playerIsInZone = false
	
	-- SCAN VERIFIE QUAND LE PLAYER ENTRE DANS LA ZONE
	while playerIsInZone == false do
		--print("SCAN PLAYER IN")
		playerIsInZone = checkIfPlayerIsInArea( getPlayerPosition() , part)
		if(playerIsInZone) then
			print("VOUS ETES ENTRE")
			part.Material = Enum.Material.Neon
		end
		wait(1)
	end
	
	-- SCAN VERIGIER QUAND LE PLAYER SORT DE LA ZONE
	while playerIsInZone do
		--print("SCAN PLAYER OUT")
		playerIsInZone = checkIfPlayerIsInArea( getPlayerPosition() , part)
		if(playerIsInZone == false) then
			print("VOUS ETES SORTI")
			part.Material = Enum.Material.SmoothPlastic
		end
		wait(1)
	end
	
	isPlayerInZone()

end


isPlayerInZone()
