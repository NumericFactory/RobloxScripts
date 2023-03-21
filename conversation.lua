local Players = game:GetService("Players")
isOpened = false
local ia = script.Parent
local clickDetector = Instance.new('ClickDetector')
clickDetector.Parent = ia
local sentences = {}

-- CUSTOM VARIABLES CONVERSATION
sentences[1] = { 
	customText = `- Hello Nono comment vas-tu?`, 
	actionButton = true, 
	responseText = 'Je vais bien, merci'
}
sentences[2] = { 
	customText = `- Moi ça va super aussi ‎😃 Tu va build des montagnes Aujourd'hui ? `, 
	actionButton = true, 
	responseText = 'Oui'
}
sentences[3] = { 
	customText = `- Cool, bon build 👍`, 
	actionButton = true, 
	responseText = 'OK!'
}
sentences[4] = { 
	customText = `J'ai avancé sur la montagne !`, 
	actionButton = true, 
	responseText = 'Montre moi ça !!'
}
-- END CUSTOM CONVERSATION



-- ******************* CUSTOMIZE LOOK *************************************
local textSize = 14
local textColor = Color3.fromRGB(253, 253, 253)
local textFont = Enum.Font.Code
local cornerImage = 'http://www.roblox.com/asset/?id=12855208822' 
-- @Info : if replace, image must be a png 32X32 and be the top right corner
-- ******************* END CUSTOMIZE LOOK **********************************

local talkGUI


local function typeText(object, text)
	for i=1, #text, 1 do
		object.Text = string.sub(text, 1, i)
		wait(0.03)
	end
end

local function typingTextRoutine()
	return coroutine.wrap(function()
		--typeText(obj, text)
		print("Hello")
		wait(0.2)
		print("Hello")
		wait(0.2)
		print("Hello")
	end)
end


function createTalkGUI(plr)
	-- create instance screen gui
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "TalkGui"

	-- give this gui TalkGui properties
	local talkGui = Instance.new("Frame")
	talkGui.Name = "TalkGuiFrame"
	talkGui.Parent = screenGui
	talkGui.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	talkGui.BackgroundTransparency = 0.1
	talkGui.BorderSizePixel = 0
	talkGui.Position = UDim2.new(0.5, 0, 0.75, 0)
	talkGui.AnchorPoint = Vector2.new(0.5,0.5)
	talkGui.Size = UDim2.new(0, 350, 0, 90)
	
	
	-- CORNERS IMAGES
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
	uICorner.CornerRadius = UDim.new(0, 5)
	uICorner.Parent = talkGui
	
	local uiStroke = Instance.new("UIStroke")
	uiStroke.Color = Color3.fromRGB(149,149,149)
	uiStroke.Thickness = 0.8
	uiStroke.Parent = talkGui
	
	
	local actionsFrame = Instance.new('Frame')
	-- give actionsFrame properties width 350, height 32, positionY 88
	actionsFrame.Name = "ActionsFrame"
	actionsFrame.Parent = talkGui
	actionsFrame.Size = UDim2.new(0, 350, 0, 30)
	actionsFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	actionsFrame.BackgroundTransparency = 1
	actionsFrame.BorderSizePixel = 0
	actionsFrame.Position = UDim2.new(0, 0, 0, 93)
	
	local uiListLayout = Instance.new('UIListLayout')
	uiListLayout.Name = "UIListLayout"
	uiListLayout.Parent = actionsFrame
	uiListLayout.FillDirection = Enum.FillDirection.Horizontal
	
	local textBtn1 = Instance.new("TextButton")
	textBtn1.Text = ""
	textBtn1.Parent = uiListLayout
	textBtn1.Name = "Btn1"
	textBtn1.Size = UDim2.new(0, 175, 0, 30)
	textBtn1.BackgroundColor3 = Color3.fromRGB(35,34,45)
	textBtn1.BackgroundTransparency = 0.3
	textBtn1.BorderColor3 = Color3.fromRGB(149, 149, 149)
	textBtn1.TextColor3 = Color3.fromRGB(235,235,235)
	textBtn1.TextSize = 8
	textBtn1.Parent = uiListLayout.Parent
	
	local textBtn2 = Instance.new("TextButton")
	textBtn2.Text = "Leave"
	textBtn2.Parent = uiListLayout
	textBtn2.Name = "Btn2"
	textBtn2.Size = UDim2.new(0, 175, 0, 30)
	textBtn2.BackgroundColor3 = Color3.fromRGB(35,34,45)
	textBtn2.BackgroundTransparency = 0.3
	textBtn2.BorderColor3 = Color3.fromRGB(149, 149, 149)
	textBtn2.TextColor3 = Color3.fromRGB(235,235,235)
	textBtn2.TextSize = 8
	textBtn2.Parent = uiListLayout.Parent
	
	
	-- give this frame a TextBox Instance child
	local textBox = Instance.new("TextLabel")
	textBox.Name = "TextBox"
	textBox.Parent = talkGui
	textBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	textBox.BackgroundTransparency = 1.000
	textBox.BorderSizePixel = 0
	textBox.Position = UDim2.new(0.5, 0, 0.5, 0)
	textBox.AnchorPoint = Vector2.new(0.5,0.5)
	textBox.Size = UDim2.new(0, 315, 0, 90)
	textBox.TextWrapped = true
	textBox.TextXAlignment = Enum.TextXAlignment.Left
	--textBox.Text = customText
	textBox.TextColor3 = textColor
	textBox.TextSize = textSize
	textBox.Font = textFont

	return screenGui
end


clickDetector.MouseClick:Connect(function(plr)
	local sentenceIndex = 1
	local function f() 
		typeText(talkGUI.TalkGuiFrame.TextBox, sentences[sentenceIndex].customText)
	end
	local t = coroutine.create(f) --Create task.
	if(isOpened == false) then
		talkGUI = createTalkGUI(plr)
		talkGUI.Parent = plr.PlayerGui
		isOpened = true
		talkGUI.TalkGuiFrame.ActionsFrame.Btn1.Text = sentences[1].responseText
		--typeText(talkGUI.TalkGuiFrame.TextBox, sentences[1].customText)
		coroutine.resume(t) --Resume task.
		print(coroutine.status(t)) --'dead'

		-- CLICK BUTTON 1 ACTION
		talkGUI.TalkGuiFrame.ActionsFrame.Btn1.MouseButton1Click:Connect(function(plr)	
			coroutine.close(t)
			sentenceIndex = sentenceIndex + 1
			if(sentenceIndex > #sentences) then
				talkGUI:Remove()
				isOpened = false
			else
				--talkGUI.TalkGuiFrame.ActionsFrame.Btn1.Text = '...'
				talkGUI.TalkGuiFrame.ActionsFrame.Btn1.Text = sentences[sentenceIndex].responseText	
				t = coroutine.create(f) --Create task.
				if(coroutine.status(t) ~= 'dead') then
					coroutine.resume(t) --Resume task.
					print(coroutine.status(t)) --'dead'	
					print(coroutine.running())	
				end
			end
		end)
		-- END CLICK BUTTON 1 ACTION
		
		talkGUI.TalkGuiFrame.ActionsFrame.Btn2.MouseButton1Click:Connect(function(plr)
			talkGUI:Remove()
			isOpened = false
		end)
		
		while isOpened do
			if plr:DistanceFromCharacter(ia.Position) > 35 then
				talkGUI:Remove()
				isOpened = false
			end
			wait(0.5)
		end
	end
end)







