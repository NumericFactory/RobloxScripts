-- Setting 1 : juste ChatBar but no Chat Window
-- Place it in "ReplicatedFirst"
local ChatService = game:GetService("Chat")
ChatService:RegisterChatCallback(Enum.ChatCallbackType.OnCreatingChatWindow, function()
	return {BubbleChatEnabled = true, ClassicChatEnabled = false}
end)


-- Setting 2 : disable Chat
-- Place it in "StarterGui"
--game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
