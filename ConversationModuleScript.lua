--@Author : Frederic Lossignol
-- 1/ Create a ModuleScript in "ReplicatedStorage"
-- 2/ copy/paste the script below and rename file "ConversationModuleScript"
-- 3/ Usage : > create a part or folder NPCS, add into a new NPC (or new part), and mame it "Dummy"
--            > (go to the end of script to see the code if you want to create a conversation on the Dummy)

local isGuiConversationOpened = false

-- LES UTILITIES
-- *************
-- role : print text in the GUI
local function typeText(object, text)
	for i=1, #text, 1 do
		object.Text = string.sub(text, 1, i)
		wait(0.03)
	end
end


-- FIN UTILITIES


-- class ConversationModule / public class
-- ConversationModule is exported and othe sripts can use his methods
local ConversationModule = {}
ConversationModule.__index = ConversationModule

-- class Conversations / private class
local Conversations = {
	name='', 		-- name of the NPC (or part)
	state = 0, 		-- state is index of conversation
	conversations={}-- list of conversations
}
Conversations.__index = Conversations



-- ************************************** 
--	LES FUNCTIONS 
-- **************************************

-- function privée
function Conversations:new(ia, newTable)
	local newConv = setmetatable({},Conversations)
	newConv.name = ia.name 
	newConv.state = 0
	newConv.conversations = newTable
	return newConv
end

-- function public : Créer une nouvelle conversation depuis l'extérieur (un script)
function ConversationModule:new(ia, newConversations)
	local newConv = Conversations:new(ia, newConversations)
	return newConv
end

-- Conversations class methods
------------------------------
function Conversations:GetConversations()
	return self.conversations
end

function Conversations:GetConversation(index)
	local index = index or 1
	return self.conversations[index]
end

function Conversations:GetName()
	return self.name
end

function Conversations:GetState()
	return self.state
end

function Conversations:setState(indexConversation)
	self.state = indexConversation
end
-- END Conversations class methods
----------------------------------

function ConversationModule:GetConversation(index)
	--return self.conversations[index]
	return Conversations[index]
end


-- ************************************************************************
-- function GUIConversation
-- ******************* CUSTOMIZE LOOK *************************************
local textSize = 25
local textColor = Color3.fromRGB(168, 168, 168)
local textFont = Enum.Font.Cartoon
local cornerImage = 'rbxassetid://' 
-- @Info : if replace, image must be a png 32X32 and be the top right corner
-- END CUSTOMIZE LOOK

function ConversationModule:CreateGui(iaName, player)	
	-- create instance screen gui
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "TalkGui"

	-- give this gui TalkGui properties
	local talkGui = Instance.new("Frame")
	talkGui.Name = "TalkGuiFrame"
	talkGui.Parent = screenGui
	talkGui.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	talkGui.BackgroundTransparency = 0
	talkGui.BorderSizePixel = 0
	talkGui.Position = UDim2.new(0.5, 0, 0.80, 0)
	talkGui.AnchorPoint = Vector2.new(0.5,0.5)
	talkGui.Size = UDim2.new(0, 550, 0, 150)

	-- give imageLabel Corner
	local imgTopRightCorner = Instance.new('ImageLabel')
	imgTopRightCorner.Image = cornerImage
	imgTopRightCorner.BackgroundTransparency = 1
	imgTopRightCorner.Size = UDim2.new(0,32,0,32)
	imgTopRightCorner.AnchorPoint = Vector2.new(0.5,0.5)
	imgTopRightCorner.Position = UDim2.new(0, 334, 0, 16)
	imgTopRightCorner.Parent = talkGui

	-- give imageLabel Corner
	local imgBottomRightCorner = Instance.new('ImageLabel')
	imgBottomRightCorner.Image = cornerImage
	imgBottomRightCorner.BackgroundTransparency = 1
	imgBottomRightCorner.Size = UDim2.new(0,32,0,32)
	imgBottomRightCorner.Rotation = 90
	imgBottomRightCorner.AnchorPoint = Vector2.new(0.5,0.5)
	imgBottomRightCorner.Position = UDim2.new(0, 336, 0, 74)
	imgBottomRightCorner.Parent = talkGui

	-- give imageLabel Corner
	local imgBottomLeftCorner = Instance.new('ImageLabel')
	imgBottomLeftCorner.Image = cornerImage
	imgBottomLeftCorner.BackgroundTransparency = 1
	imgBottomLeftCorner.Size = UDim2.new(0,32,0,32)
	imgBottomLeftCorner.Rotation = 180
	imgBottomLeftCorner.AnchorPoint = Vector2.new(0.5,0.5)
	imgBottomLeftCorner.Position = UDim2.new(0, 16, 0, 76)
	imgBottomLeftCorner.Parent = talkGui

	-- give imageLabel Corner
	local imgTopLeftCorner = Instance.new('ImageLabel')
	imgTopLeftCorner.Image = cornerImage
	imgTopLeftCorner.BackgroundTransparency = 1
	imgTopLeftCorner.Size = UDim2.new(0,32,0,32)
	imgTopLeftCorner.Rotation = 270
	imgTopLeftCorner.AnchorPoint = Vector2.new(0.5,0.5)
	imgTopLeftCorner.Position = UDim2.new(0, 16, 0, 16)
	imgTopLeftCorner.Parent = talkGui
	-- CORNERS IMAGES

	-- give to talkGui a UICorner
	local uICorner = Instance.new("UICorner")
	uICorner.CornerRadius = UDim.new(0, 10)
	uICorner.Parent = talkGui

	local uiStroke = Instance.new("UIStroke")
	uiStroke.Color = Color3.fromRGB(7, 7, 7)
	uiStroke.Thickness = 10
	uiStroke.Parent = talkGui

	local actionsFrame = Instance.new('Frame')
	-- give actionsFrame properties width 350, height 32, positionY 88
	actionsFrame.Name = "ActionsFrame"
	actionsFrame.Parent = talkGui
	actionsFrame.Size = UDim2.new(0, 550, 0, 30)
	actionsFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	actionsFrame.BackgroundTransparency = 1
	actionsFrame.BorderSizePixel = 0
	actionsFrame.Position = UDim2.new(0, 0, 0, 175)
	local Grid = Instance.new ("UIGridLayout")
	Grid.CellSize = UDim2.new (0, 260, 0, 50)
	Grid.CellPadding = UDim2.new (0, 30, 0,5)
	Grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
	Grid.Parent = actionsFrame

	local uiListLayout = Instance.new('UIListLayout')
	uiListLayout.Name = "UIListLayout"
	uiListLayout.Parent = actionsFrame
	uiListLayout.FillDirection = Enum.FillDirection.Horizontal

	local textBtn1 = Instance.new("TextButton")
	textBtn1.Text = ""
	textBtn1.Parent = uiListLayout

	textBtn1.Name = "Btn1"
	textBtn1.Size = UDim2.new(0, 200, 0, 50)
	textBtn1.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	textBtn1.BackgroundTransparency = 0
	textBtn1.BorderColor3 = Color3.fromRGB(149, 149, 149)
	textBtn1.TextColor3 = Color3.fromRGB(168, 168, 168)
	textBtn1.TextSize = 20
	textBtn1.Font = Enum.Font.Cartoon
	local Btn1Stroke = Instance.new ("UIStroke")
	Btn1Stroke.Color = Color3.fromRGB(7, 7, 7)
	Btn1Stroke.Thickness = 8
	Btn1Stroke.ApplyStrokeMode = 1
	Btn1Stroke.Parent = textBtn1
	local Btn1Corner = Instance.new("UICorner")
	Btn1Corner.CornerRadius = UDim.new(0, 30)
	Btn1Corner.Parent = textBtn1
	textBtn1.Parent = uiListLayout.Parent

	local textBtn2 = Instance.new("TextButton")
	textBtn2.Text = "Leave"
	textBtn2.Parent = uiListLayout
	textBtn2.Name = "Btn2"
	textBtn2.Size = UDim2.new(0, 200, 0, 50)
	textBtn2.BackgroundColor3 = Color3.fromRGB(42, 42, 45)
	textBtn2.BackgroundTransparency = 0
	textBtn2.BorderColor3 = Color3.fromRGB(149, 149, 149)
	textBtn2.TextColor3 = Color3.fromRGB(168, 168, 168)
	textBtn2.TextSize = 20
	textBtn2.Font = Enum.Font.Cartoon
	local Btn2Stroke = Instance.new ("UIStroke")
	Btn2Stroke.Color = Color3.fromRGB(7, 7, 7)
	Btn2Stroke.Thickness = 8
	Btn2Stroke.ApplyStrokeMode = 1
	Btn2Stroke.Parent = textBtn2
	local Btn2Corner = Instance.new("UICorner")
	Btn2Corner.CornerRadius = UDim.new(0, 30)
	Btn2Corner.Parent = textBtn2
	textBtn2.Parent = uiListLayout.Parent

	-- give this frame a TextBox Instance child
	local textBox = Instance.new("TextLabel")
	textBox.Name = "TextBox"
	textBox.Parent = talkGui
	textBox.BackgroundColor3 = Color3.fromRGB(173, 173, 173)
	textBox.BackgroundTransparency = 1.000
	textBox.BorderSizePixel = 0
	textBox.Position = UDim2.new(0.5, 0, 0.5, 0)
	textBox.AnchorPoint = Vector2.new(0.5,0.5)
	textBox.Size = UDim2.new(0, 350, 0, 190)
	textBox.TextWrapped = true
	textBox.TextXAlignment = Enum.TextXAlignment.Center
	--textBox.Text = customText
	textBox.TextColor3 = textColor
	textBox.TextSize = textSize
	textBox.Font = textFont

	--NamePersonnage
	local textBox1 = Instance.new("TextLabel")
	textBox1.Name = "NamePerso"
	textBox1.Parent = talkGui
	textBox1.Position = UDim2.new(0.03, 0, 0.03, 0)
	textBox1.Size = UDim2.new(0, 120, 0, 20)
	textBox1.AnchorPoint = Vector2.new(0,0)
	textBox1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	textBox1.BackgroundTransparency = 1.000
	textBox1.TextXAlignment = Enum.TextXAlignment.Left
	textBox1.TextSize = 15
	textBox1.FontFace.Weight = Enum.FontWeight.Bold
	textBox1.TextColor3 = textColor
	textBox1.RichText = true
	textBox1.Font = Enum.Font.Cartoon
	textBox1.Text = "<u>" ..iaName.. "</u>"
	--	textBox1.FontFace = Enum.
	return screenGui
end


-- LAUNCH GUI Conversation
-- ***********************
local talkGUI = nil
function Conversations:LaunchConversationGUI(ia, player)
	--self.state -- conversationIndex
	print(self.state)
	self.state = self.state+1
	if(self.state > #self.conversations) then
		self.state = #self.conversations
	end
	
	local sentenceIndex = 1
	print('state', self.state)
	print('sentenceIndex',  sentenceIndex)

	--local conversation = ConversationModule.g 
	local conversation = self.conversations[self.state]
	print('convv', conversation)

	local function f() 
		typeText(talkGUI.TalkGuiFrame.TextBox, conversation.sentences[sentenceIndex].customText)
	end
	local t = coroutine.create(f) --Create task
	
	if(isGuiConversationOpened == false) then
		-- CREATE GUI CONVERSATION
		talkGUI = ConversationModule:CreateGui(self.name, player)
		talkGUI.Parent = player.PlayerGui
		isGuiConversationOpened = true
		talkGUI.TalkGuiFrame.ActionsFrame.Btn1.Text = conversation.sentences[1].responseText	
		coroutine.resume(t) --Resume task.
		print(coroutine.status(t)) --'dead'

		-- CLICK BUTTON 1 ACTION
		talkGUI.TalkGuiFrame.ActionsFrame.Btn1.MouseButton1Click:Connect(function()	
			print(player)
			coroutine.close(t)
			-- next sentence in the conversation
			sentenceIndex = sentenceIndex + 1
	
			if(sentenceIndex > #conversation.sentences) then
				if(self.state == #self.conversations) then
					talkGUI:Remove()
					isGuiConversationOpened = false	
					sentenceIndex = 1
					self.state = #self.conversations
					conversation = self.conversations[self.state]
				else
					talkGUI:Remove()
					isGuiConversationOpened = false	
					sentenceIndex = 1
					conversation = self.conversations[self.state]
				end
				
			else
				talkGUI.TalkGuiFrame.ActionsFrame.Btn1.Text = conversation.sentences[sentenceIndex].responseText	
				t = coroutine.create(f) --Create task.
				if(coroutine.status(t) ~= 'dead') then
					coroutine.resume(t) --Resume task.
					print(coroutine.status(t)) --'dead'	
					print(coroutine.running())	
				end
			end
			print('state', self.state)
			print('sentenceIndex',  sentenceIndex)
		end)
		-- END CLICK BUTTON 1 ACTION
		
		-- CLICK BUTTON 2 ACTION
		talkGUI.TalkGuiFrame.ActionsFrame.Btn2.MouseButton1Click:Connect(function(player)
			talkGUI:Remove()
			isGuiConversationOpened = false 
		end)
		
		-- player is more 15 studs from npc, close GUI
		while isGuiConversationOpened do
			if player:DistanceFromCharacter(ia.Torso.Position) > 15 then
				talkGUI:Remove()
				isGuiConversationOpened = false
			end
			wait(0.5)
		end
		
		
	end
end


return ConversationModule






-----------------------------------------
-- In StarterPlayer, create a localScript
-- and name it ConversationDummy
-- and copy/paste code below
-----------------------------------------
-- imports
local conversationModule = require(game:GetService("ReplicatedStorage"):WaitForChild("ConversationModuleScript"))

-- 1/ CUSTOMIZE : SELECT NPC 
--------------------------------------
local ia = workspace.NPCS.Dummy
-- END CUSTOMIZE NPC

-- create clickDetector on NPC
local clickDetector = Instance.new('ClickDetector')
clickDetector.MaxActivationDistance = 10
clickDetector.Parent = ia

local customConversations = {} 

-----------------------------
-- 2/ CUSTOMIZE CONVERSATIONS
-----------------------------

-- conversation 1
customConversations[1] = {
	condition = true,
	sentences = {
		{ 
			customText = `zzzzzzz `, 
			actionButton = true, 
			multiaction = true,
			responseText = 'Hello!'
		},

		{ 
			customText = `mmm... hello, mister, i have a mission for you... ?`, 
			actionButton = true, 
			responseText = 'I want to know!'
		},

		{ 
			customText = `I need a medical potion because i'm tired.`, 
			actionButton = true, 
			responseText = 'I would like help you',	
		},
		{ 
			customText = `You have to find the magician. He will give you my potion`, 
			actionButton = true, 
			responseText = 'Ok, i accept the quest'

		}
	}	
}


-- conversation 2
customConversations[2]={
	condition = false,
	sentences = {
		{ 
			customText = `... Have you got my potion ?  `, 
			actionButton = true, 
			responseText = 'Not yet'
		},

		{ 
			customText = `So, come back when you will have my potion.`, 
			actionButton = true, 
			responseText = 'Ok!'
		}
	}
}

-- conversation 3
customConversations[3]={
	condition = false,
	sentences = {
		{ 
			customText = `... Have you got my potion ?  `, 
			actionButton = true, 
			responseText = 'Yes'
		},

		{ 
			customText = `Thanks my hero :)`, 
			actionButton = true, 
			responseText = 'Super!'
		}
	}
}
------------------------------
-- END CUSTOMIZE CONVERSATIONS
------------------------------


--***********************************************************
-- PROGRAMM *************************************************
-- **********************************************************
-- CREATE THE NEW CONVERSATION 
local conv = conversationModule:new(ia, customConversations)

-- CREATE GUI Conversation
-- ***********************
local talkGUI

-- ********************************************
-- Event 'MouseClick' on NPC or PART 

-- role : when player click on NPC 
-- 		  OPEN talkGUI AND LAUNCH CONVERSATION
-- ********************************************
clickDetector.MouseClick:Connect(function(player)
	-- launch conversation
	conv:LaunchConversationGUI(ia, player)

end)

local Highlight
clickDetector.MouseHoverEnter:Connect(function(player)
	Highlight = Instance.new ("Highlight")
	Highlight.FillColor = Color3.fromRGB(43, 43, 43)
	Highlight.Parent = ia
	--	addQuestToGUI:FireClient(player, questFound, parentName)
end)


clickDetector.MouseHoverLeave:Connect(function(player)
	Highlight:Destroy()
end)
--***********************************************************
-- END PROGRAMM *********************************************
-- **********************************************************




