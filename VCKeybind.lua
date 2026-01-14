local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Macro = {}
Macro.__index = Macro

local Settings = {
    ActivationKey = Enum.KeyCode.V, -- Change Enum.KeyCode.V/F/etc. on at your discretion (any key)
    -- TargetPosition = Vector2.new(180, 25),
    TargetPosition = Vector2.new(180, -10),
    JiggleOffset = Vector2.new(-1, 1),
    ArrivalTimeout = 0.15
}

function Macro.new()
    local self = setmetatable({}, Macro)
    self.isExecuting = false
    self.connection = nil
    return self
end

function Macro:_executeSequence()
    self.isExecuting = true
    
    local initialMousePos = Vector2.new(Mouse.X, Mouse.Y)
    local targetPos = Settings.TargetPosition
    local jigglePos = targetPos + Settings.JiggleOffset

    pcall(function()
        mousemoveabs(targetPos.X, targetPos.Y)

        local elapsedTime = 0
        repeat
            elapsedTime = elapsedTime + RunService.Heartbeat:Wait()
        until (math.abs(Mouse.X - targetPos.X) < 1 and math.abs(Mouse.Y - targetPos.Y) < 1) or elapsedTime > Settings.ArrivalTimeout

        mousemoveabs(jigglePos.X, jigglePos.Y)
        task.wait()

        mouse1press()
        task.wait()
        mouse1release()

        task.wait()
        mousemoveabs(initialMousePos.X, initialMousePos.Y)
    end)

    self.isExecuting = false
end

function Macro:_onInputBegan(input)
    if self.isExecuting or input.KeyCode ~= Settings.ActivationKey or UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter then
        return
    end
    
    coroutine.wrap(function() self:_executeSequence() end)()
end

function Macro:Bind()
    if self.connection then
        self.connection:Disconnect()
    end
    self.connection = UserInputService.InputBegan:Connect(function(...) self:_onInputBegan(...) end)
end

local VCMacro = Macro.new()
VCMacro:Bind()
