--[[
    WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function protectHumanoid(humanoid)
    -- Max y vida infinita desde el inicio
    humanoid.MaxHealth = math.huge
    humanoid.Health = math.huge

    -- Evita que el estado Dead se active
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)

    -- Refuerza constantemente
    task.spawn(function()
        while humanoid and humanoid.Parent do
            if humanoid.Health < math.huge then
                humanoid.MaxHealth = math.huge
                humanoid.Health = math.huge
            end
            -- Forzar estado vivo
            if humanoid:GetState() == Enum.HumanoidStateType.Dead then
                humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
            end
            task.wait()
        end
    end)
end

player.CharacterAdded:Connect(function(char)
    local humanoid = char:WaitForChild("Humanoid")
    protectHumanoid(humanoid)
end)

-- Si ya estás spawneado
if player.Character then
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        protectHumanoid(humanoid)
    end
end
