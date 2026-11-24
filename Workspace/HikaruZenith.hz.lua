updateTime = "20:15:00 UTC+7"
updateDate = "05/10/2026"
currentVersion = "0.3.4K"
jLogsNotifier = false

Title.Text = "🔰 Hikaru Zenith v" .. currentVersion

friends = {}

function refreshFriends()
	friends = {}
	local plr = Players.LocalPlayer
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= plr and player:IsFriendsWith(plr.UserId) then
			friends["FRIEND_" .. player.UserId] = true
		end
	end
end

function formatConnection(player)
	local me = Players.LocalPlayer
	local isConnection = "⛔"
	if player:IsFriendsWith(me.UserId) then
		isConnection = "✅"
	end
	local result = formatUsername(player)
	local finalResult = isConnection.." "..result
	return finalResult
end

function formatConnectionTag(player)
	local me = Players.LocalPlayer
	local isConnection = "⛔"
	if player:IsFriendsWith(me.UserId) then
		isConnection = "✅"
	end
	-- local result = formatUsername(player)
	local finalResult = isConnection
	return finalResult
end

function Time()
	local HOUR = math.floor((tick() % 86400) / 3600)
	local MINUTE = math.floor((tick() % 3600) / 60)
	local SECOND = math.floor(tick() % 60)
	local AP = HOUR > 11 and 'PM' or 'AM'
	HOUR = (HOUR % 12 == 0 and 12 or HOUR % 12)
	HOUR = HOUR < 10 and '0' .. HOUR or HOUR
	MINUTE = MINUTE < 10 and '0' .. MINUTE or MINUTE
	SECOND = SECOND < 10 and '0' .. SECOND or SECOND
	return HOUR .. ':' .. MINUTE .. ':' .. SECOND .. ' ' .. AP
end

function getNow()
	local currentTime = os.time()
	local currentDate = os.date("%d/%m/%Y %H:%M:%S", currentTime)
	local now = currentDate
	return now
end

function getUsers()
	local currentPlayers = Players:GetPlayers()
	local playersCount = #currentPlayers
	local maxPlayers = Players.MaxPlayers
	local result = playersCount.."/"..maxPlayers
	return result
end

local Plugin = {
	["PluginName"] = "Hikaru Zenith AIO",
	["PluginDescription"] = "Addon made by Hikaru",
	["Commands"] = {
		["scsingle"] = {
			["ListName"] = "scsingle [file name]",
			["Description"] = "Load Single script",
			["Aliases"] = {},
			["Function"] = function(args,speaker)
				if args == nil then
					notify('Hikaru Ext-Script Single Script Loader','You must input the file name to be loaded correctly!\nYou can exclude the .lua')
				else
					local filename = args[1]
					local targetLink = "https://raw.githubusercontent.com/BlackID512/Ext-Scripts/refs/heads/main/Single/" .. filename .. ".lua"
					local link = targetLink
					local final = game:HttpGet(link)
					-- loadstring(game:HttpGet(link))()
					loadstring(final)()
				end
			end
		},
		["flinger"] = {
			["ListName"] = "flinger",
			["Description"] = "Op Fling by Hikaru",
			["Aliases"] = {},
			["Function"] = function(args,speaker)
				local filename = "OpFling"
				local targetLink = "https://raw.githubusercontent.com/BlackID512/Ext-Scripts/refs/heads/main/Single/" .. filename .. ".lua"
				local link = targetLink
				local final = game:HttpGet(link)
				-- loadstring(game:HttpGet(link))()
				loadstring(final)()
			end
		}
	}
}


CMDs1 = CMDs
CMDhz = {}
CMDhz[#CMDhz + 1] = {NAME = updateDate .. ' ' .. updateTime, DESC = ''}
CMDhz[#CMDhz + 1] = {NAME = '', DESC = ''}
CMDhz[#CMDhz + 1] = {NAME = 'about', DESC = 'About Hikaru Zenith'}
CMDhz[#CMDhz + 1] = {NAME = 'update', DESC = 'Hikaru Zenith Last Update Time'}
CMDhz[#CMDhz + 1] = {NAME = 'scriptload / scload [link]', DESC = 'Load another script'}
CMDhz[#CMDhz + 1] = {NAME = 'performance / perf / perfmon', DESC = 'Monitor your FPS & latency performance made by Hikaru'}
CMDhz[#CMDhz + 1] = {NAME = '', DESC = ''}
--[[
CMDhz[#CMDhz + 1] = {NAME = '', DESC = ''}
CMDhz[#CMDhz + 1] = {NAME = '', DESC = ''}
CMDhz[#CMDhz + 1] = {NAME = '', DESC = ''}
CMDhz[#CMDhz + 1] = {NAME = '', DESC = ''}
CMDhz[#CMDhz + 1] = {NAME = '', DESC = ''}
CMDhz[#CMDhz + 1] = {NAME = '', DESC = ''}
CMDhz[#CMDhz + 1] = {NAME = '', DESC = ''}
]]--
for _, cmd in ipairs(CMDs1) do
    CMDhz[#CMDhz + 1] = cmd
end
CMDs = {}
CMDs = CMDhz

return Plugin
