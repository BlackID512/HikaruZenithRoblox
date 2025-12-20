--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

------------------ REMOTE EVENT FOR SUGGESTIONS ------------------
local SuggestEvent = ReplicatedStorage:FindFirstChild("SendSuggestion")
if not SuggestEvent then
	SuggestEvent = Instance.new("RemoteEvent")
	SuggestEvent.Name = "SendSuggestion"
	SuggestEvent.Parent = ReplicatedStorage
end

------------------ LOAD RAYFIELD ------------------
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local Window = Rayfield:CreateWindow({
	Name = "A.D.M.I.N Hub",
	LoadingTitle = "A.D.M.I.N is loading!",
	LoadingSubtitle = "By ChatGPT - 20 Dec 2025",
	ConfigurationSaving = {Enabled = true, FolderName = nil, FileName = "A.D.M.I.N Hub"}
})

------------------ VARIABLES ------------------
local FreecamPCActive = false
local FreecamMobileActive = false
local bannedPlayers = {} -- key = player.UserId

------------------ LOCAL MESSAGE FUNCTION ------------------
local function displayLocalMessage(text)
	local msg = Instance.new("TextLabel", PlayerGui)
	msg.Size = UDim2.new(1,0,0,36)
	msg.Position = UDim2.fromScale(0,0.05)
	msg.BackgroundColor3 = Color3.fromRGB(0,0,0)
	msg.BackgroundTransparency = 0.5
	msg.Font = Enum.Font.Code
	msg.TextSize = 18
	msg.TextColor3 = Color3.fromRGB(255,0,0)
	msg.TextStrokeTransparency = 0
	msg.Text = text
	task.delay(3,function() msg:Destroy() end)
end

------------------ BAN FUNCTIONS ------------------
local function setCharacterVisible(player, visible)
	if not player.Character then return end
	for _, obj in pairs(player.Character:GetDescendants()) do
		if obj:IsA("BasePart") then
			obj.LocalTransparencyModifier = visible and 0 or 1
		end
	end
	if player.Character:FindFirstChild("HumanoidRootPart") then
		if visible then
			player.Character:SetPrimaryPartCFrame(CFrame.new(0,5,0))
		else
			player.Character:SetPrimaryPartCFrame(CFrame.new(9e14,9e14,9e14))
		end
	end
end

local function banPlayer(player)
	if not player.Character or bannedPlayers[player.UserId] then return end
	bannedPlayers[player.UserId] = true
	setCharacterVisible(player,false)
	displayLocalMessage(player.Name.." Has Been Banned!")
end

local function unbanPlayer(player)
	if not player.Character or not bannedPlayers[player.UserId] then return end
	bannedPlayers[player.UserId] = nil
	setCharacterVisible(player,true)
	displayLocalMessage(player.Name.." Has Been Unbanned!")
end

------------------ TAB: HOME ------------------
local HomeTab = Window:CreateTab("🏠 Home")

-- Ban All
HomeTab:CreateButton({
	Name = "Ban All",
	Callback = function()
		for _, plr in pairs(Players:GetPlayers()) do
			if plr ~= Player then
				banPlayer(plr)
			end
		end
	end
})

-- Unban All
HomeTab:CreateButton({
	Name = "Unban All",
	Callback = function()
		for _, plr in pairs(Players:GetPlayers()) do
			if plr ~= Player then
				unbanPlayer(plr)
			end
		end
	end
})

-- Freecam PC
HomeTab:CreateToggle({
	Name = "Freecam (PC)",
	CurrentValue = false,
	Callback = function(value)
		FreecamPCActive = value
		if value then
			local speed = 1
			local camInput = Vector3.new()
			RunService:BindToRenderStep("FreecamPC",Enum.RenderPriority.Camera.Value,function(dt)
				if FreecamPCActive then
					Camera.CFrame = Camera.CFrame:ToWorldSpace(CFrame.new(camInput*speed))
				end
			end)
			UserInputService.InputBegan:Connect(function(input)
				if input.KeyCode == Enum.KeyCode.W then camInput = camInput + Vector3.new(0,0,-1) end
				if input.KeyCode == Enum.KeyCode.S then camInput = camInput + Vector3.new(0,0,1) end
				if input.KeyCode == Enum.KeyCode.A then camInput = camInput + Vector3.new(-1,0,0) end
				if input.KeyCode == Enum.KeyCode.D then camInput = camInput + Vector3.new(1,0,0) end
			end)
			UserInputService.InputEnded:Connect(function(input)
				if input.KeyCode == Enum.KeyCode.W then camInput = camInput - Vector3.new(0,0,-1) end
				if input.KeyCode == Enum.KeyCode.S then camInput = camInput - Vector3.new(0,0,1) end
				if input.KeyCode == Enum.KeyCode.A then camInput = camInput - Vector3.new(-1,0,0) end
				if input.KeyCode == Enum.KeyCode.D then camInput = camInput - Vector3.new(1,0,0) end
			end)
		else
			RunService:UnbindFromRenderStep("FreecamPC")
		end
	end
})

-- Freecam Mobile
HomeTab:CreateToggle({
	Name = "Freecam (Mobile) (Useless now)",
	CurrentValue = false,
	Callback = function(value)
		FreecamMobileActive = value
		if value then
			local Joystick = Instance.new("Frame", PlayerGui)
			Joystick.Size = UDim2.fromOffset(120,120)
			Joystick.Position = UDim2.fromScale(0.05,0.8)
			Joystick.BackgroundColor3 = Color3.fromRGB(50,0,0)
			Joystick.BackgroundTransparency = 0.3
			Instance.new("UICorner", Joystick)
		else
			for _,v in pairs(PlayerGui:GetChildren()) do
				if v:IsA("Frame") and v.Size == UDim2.fromOffset(120,120) then
					v:Destroy()
				end
			end
		end
	end
})

-- Announcement
local AnnounceValue = ""
HomeTab:CreateInput({
	Name = "Announcement",
	PlaceholderText = "Type announcement",
	RemoveTextAfterFocusLost = false,
	Callback = function(value) AnnounceValue = value end
})
HomeTab:CreateButton({
	Name = "Send Announcement",
	Callback = function()
		if AnnounceValue ~= "" then
			local banner = Instance.new("TextLabel", PlayerGui)
			banner.Size = UDim2.new(1,0,0,36)
			banner.Position = UDim2.fromScale(0,0.05)
			banner.BackgroundColor3 = Color3.fromRGB(0,0,0)
			banner.BackgroundTransparency = 0.3
			banner.Font = Enum.Font.Code
			banner.TextSize = 20
			banner.TextColor3 = Color3.new(1,1,1)
			banner.TextStrokeTransparency = 0
			banner.Text = AnnounceValue
			task.delay(4,function() banner:Destroy() end)
			AnnounceValue = ""
		end
	end
})

-- Load Infinite Yield
HomeTab:CreateButton({
	Name = "Load Infinite Yield",
	Callback = function()
		local success, err = pcall(function()
			loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
		end)
		if not success then warn("Failed to load Infinite Yield: "..err) end
	end
})

------------------ TAB: SUGGEST ------------------
local SuggestTab = Window:CreateTab("📜 Suggest")

-- Warning above box
SuggestTab:CreateLabel("Please don't spam you fucking unemployed idiot.")

local SuggestInputValue = ""
SuggestTab:CreateInput({
	Name = "Suggestion",
	PlaceholderText = "Type suggestion or bug",
	RemoveTextAfterFocusLost = false,
	Callback = function(value) SuggestInputValue = value end
})
SuggestTab:CreateButton({
	Name = "Send Suggestion",
	Callback = function()
		if SuggestInputValue ~= "" then
			ReplicatedStorage.SendSuggestion:FireServer(SuggestInputValue)
			SuggestInputValue = ""
		end
	end
})

------------------ TAB: INFO ------------------
local InfoTab = Window:CreateTab("ℹ Info")
InfoTab:CreateLabel("Hello this was made by ChatGPT, made in 20 Dec 2025.")
InfoTab:CreateLabel("The suggestion box may be unstable, will fix soon.")
InfoTab:CreateLabel("Ban/Unban all is purely visual.")
InfoTab:CreateLabel("Adding Discord in this tab soon.")
