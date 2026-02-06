local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PerformanceMonitor"
screenGui.Parent = game:GetService("CoreGui")

local label = Instance.new("TextLabel", screenGui)
label.Size = UDim2.new(0, 300, 0, 20)
label.AnchorPoint = Vector2.new(1, 0)
label.Position = UDim2.new(0, 10, 0, 0)
label.BackgroundTransparency = 1
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.TextStrokeTransparency = 0.5
label.Font = Enum.Font.Code
label.TextSize = 16
label.TextXAlignment = Enum.TextXAlignment.Left
label.RichText = true
label.Text = "FPS: 0\nLatency: 0ms"

local lastTick = tick()
local frameCount = 0
local fps = 0

RunService.RenderStepped:Connect(function()
	frameCount += 1
	if tick() - lastTick >= 1 then
		fps = frameCount
		frameCount = 0
		lastTick = tick()
	end

	local ping = Stats.Network:FindFirstChild("ServerStatsItem")
		and Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
	ping = ping and math.floor(ping) or "?"

	-- local fpsColor = fps >= 60 and Color3.fromRGB(0, 255, 0)
	local fpsColor = fps >= 30 and Color3.fromRGB(0, 255, 0)
		-- or (fps >= 30 and Color3.fromRGB(255, 255, 0) or Color3.fromRGB(255, 0, 0))
		or (fps >= 15 and Color3.fromRGB(255, 255, 0) or Color3.fromRGB(255, 0, 0))
	local pingColor = ping ~= "?"
			and (ping <= 80 and Color3.fromRGB(0, 255, 0) or (ping <= 150 and Color3.fromRGB(255, 255, 0) or Color3.fromRGB(
				255,
				0,
				0
			)))
		or Color3.fromRGB(200, 200, 200)

	label.Text = string.format(
		'FPS: <font color="rgb(%d,%d,%d)">%d</font>\nLatency: <font color="rgb(%d,%d,%d)">%s</font>ms',
		fpsColor.R * 255,
		fpsColor.G * 255,
		fpsColor.B * 255,
		fps,
		pingColor.R * 255,
		pingColor.G * 255,
		pingColor.B * 255,
		ping
	)
end)
