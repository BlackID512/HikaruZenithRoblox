local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local plr = game.Players.LocalPlayer
local cam = workspace.CurrentCamera
local pg = plr:WaitForChild("PlayerGui")
local char = plr.Character or plr.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FreecamX"
screenGui.Parent = pg

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0,300,0,120)
mainFrame.Position = UDim2.new(0.5,-150,0.5,-60)
mainFrame.BackgroundColor3 = Color3.new(0,0,0)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
local cornerMain = Instance.new("UICorner")
cornerMain.CornerRadius = UDim.new(0,12)
cornerMain.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0.3,0)
title.BackgroundTransparency = 1
title.Text = "Choose Device"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansSemibold
title.TextScaled = true
title.Parent = mainFrame

local pcButton = Instance.new("TextButton")
pcButton.Size = UDim2.new(0.5,-5,0.7,0)
pcButton.Position = UDim2.new(0,0,0.3,0)
pcButton.BackgroundColor3 = Color3.new(0.1,0.1,0.1)
pcButton.Text = "PC"
pcButton.TextColor3 = Color3.new(1,1,1)
pcButton.Font = Enum.Font.SourceSansSemibold
pcButton.TextScaled = true
pcButton.Parent = mainFrame
local cornerPC = Instance.new("UICorner")
cornerPC.CornerRadius = UDim.new(0,8)
cornerPC.Parent = pcButton

local mobileButton = Instance.new("TextButton")
mobileButton.Size = UDim2.new(0.5,-5,0.7,0)
mobileButton.Position = UDim2.new(0.5,5,0.3,0)
mobileButton.BackgroundColor3 = Color3.new(0.1,0.1,0.1)
mobileButton.Text = "Mobile"
mobileButton.TextColor3 = Color3.new(1,1,1)
mobileButton.Font = Enum.Font.SourceSansSemibold
mobileButton.TextScaled = true
mobileButton.Parent = mainFrame
local cornerM = Instance.new("UICorner")
cornerM.CornerRadius = UDim.new(0,8)
cornerM.Parent = mobileButton

local freecam = false
local speed = 50
local lookSpeed = 0.002
local rotX,rotY = 0,0
local fov = 70
local defaultFOV = 70
local camPos
local rightHold = false
local speedFrame
local speedLabel
local dragging = false
local dragStart
local startPos
local mobileControls = {}
local moveVector = Vector3.zero
local lookTouch = nil
local lastPos

local function notify(msg)
    game.StarterGui:SetCore("SendNotification",{Title="FreecamX",Text=msg,Duration=6})
end

local function toggleFreecam()
    freecam = not freecam
    if freecam then
        cam.CameraType = Enum.CameraType.Scriptable
        hrp.Anchored = true
        camPos = cam.CFrame.Position
        rotX,rotY = 0,0
        cam.FieldOfView = fov
        if speedFrame then speedFrame.Visible = true end
        for _,v in pairs(mobileControls) do v.Visible = true end
    else
        cam.CameraType = Enum.CameraType.Custom
        hrp.Anchored = false
        cam.FieldOfView = defaultFOV
        if speedFrame then speedFrame.Visible = false end
        for _,v in pairs(mobileControls) do v.Visible = false end
    end
end

local function updateCamera(move,delta,dt)
    if rightHold or lookTouch then
        rotX = math.clamp(rotX - delta.Y * lookSpeed, -math.rad(89), math.rad(89))
        rotY = rotY - delta.X * lookSpeed
    end
    camPos += move * speed * dt
    local rot = CFrame.Angles(0,rotY,0) * CFrame.Angles(rotX,0,0)
    cam.CFrame = CFrame.new(camPos) * rot
end

local function makeDraggable(frame)
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    uis.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

local function createSpeedUI()
    speedFrame = Instance.new("Frame")
    speedFrame.Size = UDim2.new(0,180,0,60)
    speedFrame.Position = UDim2.new(0,10,0,10)
    speedFrame.BackgroundColor3 = Color3.new(0,0,0)
    speedFrame.BorderSizePixel = 0
    speedFrame.Visible = false
    speedFrame.Parent = screenGui
    local cornerS = Instance.new("UICorner")
    cornerS.CornerRadius = UDim.new(0,10)
    cornerS.Parent = speedFrame

    speedLabel = Instance.new("TextLabel")
    speedLabel.Size = UDim2.new(1,0,0.5,0)
    speedLabel.Position = UDim2.new(0,0,0,0)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "Camera Speed: "..tostring(speed)
    speedLabel.TextColor3 = Color3.new(1,1,1)
    speedLabel.Font = Enum.Font.SourceSansSemibold
    speedLabel.TextScaled = true
    speedLabel.Parent = speedFrame

    local speedUp = Instance.new("TextButton")
    speedUp.Size = UDim2.new(0.5,-5,0.5,0)
    speedUp.Position = UDim2.new(0,0,0.5,0)
    speedUp.BackgroundColor3 = Color3.new(0.2,0.2,0.2)
    speedUp.Text = "+"
    speedUp.TextColor3 = Color3.new(1,1,1)
    speedUp.Font = Enum.Font.SourceSansSemibold
    speedUp.TextScaled = true
    speedUp.Parent = speedFrame
    local cU = Instance.new("UICorner")
    cU.CornerRadius = UDim.new(0,8)
    cU.Parent = speedUp

    local speedDown = Instance.new("TextButton")
    speedDown.Size = UDim2.new(0.5,-5,0.5,0)
    speedDown.Position = UDim2.new(0.5,5,0.5,0)
    speedDown.BackgroundColor3 = Color3.new(0.2,0.2,0.2)
    speedDown.Text = "-"
    speedDown.TextColor3 = Color3.new(1,1,1)
    speedDown.Font = Enum.Font.SourceSansSemibold
    speedDown.TextScaled = true
    speedDown.Parent = speedFrame
    local cD = Instance.new("UICorner")
    cD.CornerRadius = UDim.new(0,8)
    cD.Parent = speedDown

    speedUp.MouseButton1Click:Connect(function()
        speed = speed + 10
        speedLabel.Text = "Camera Speed: "..tostring(speed)
    end)
    speedDown.MouseButton1Click:Connect(function()
        speed = math.max(5,speed-10)
        speedLabel.Text = "Camera Speed: "..tostring(speed)
    end)

    makeDraggable(speedFrame)
end

local function setupPC()
    mainFrame.Visible = false
    notify("F4=Toggle, Hold RMB=Look, WASD/QE=Move, Arrows=FOV")
    createSpeedUI()
    uis.InputBegan:Connect(function(input,gp)
        if gp then return end
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            rightHold = true
            uis.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
        elseif input.KeyCode == Enum.KeyCode.F4 then
            toggleFreecam()
        elseif input.KeyCode == Enum.KeyCode.Up and freecam then
            fov = math.clamp(fov+5,40,120)
            cam.FieldOfView = fov
        elseif input.KeyCode == Enum.KeyCode.Down and freecam then
            fov = math.clamp(fov-5,40,120)
            cam.FieldOfView = fov
        end
    end)
    uis.InputEnded:Connect(function(input,gp)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            rightHold = false
            uis.MouseBehavior = Enum.MouseBehavior.Default
        end
    end)
    rs.RenderStepped:Connect(function(dt)
        if freecam then
            local move = Vector3.zero
            if uis:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
            if uis:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
            if uis:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
            if uis:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
            if uis:IsKeyDown(Enum.KeyCode.E) then move += cam.CFrame.UpVector end
            if uis:IsKeyDown(Enum.KeyCode.Q) then move -= cam.CFrame.UpVector end
            local delta = uis:GetMouseDelta()
            updateCamera(move,delta,dt)
        end
    end)
end

local function setupMobile()
    mainFrame.Visible = false
    notify("Tap Toggle to enter/exit Freecam")
    createSpeedUI()

    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0,200,0,60)
    toggleButton.Position = UDim2.new(0.5,-100,1,-220)
    toggleButton.BackgroundColor3 = Color3.new(0.1,0.1,0.1)
    toggleButton.Text = "Freecam: OFF"
    toggleButton.TextColor3 = Color3.new(1,1,1)
    toggleButton.Font = Enum.Font.SourceSansSemibold
    toggleButton.TextScaled = true
    toggleButton.Parent = screenGui
    local cornerT = Instance.new("UICorner")
    cornerT.CornerRadius = UDim.new(0,10)
    cornerT.Parent = toggleButton

    local fovUp = Instance.new("TextButton")
    fovUp.Size = UDim2.new(0,100,0,50)
    fovUp.Position = UDim2.new(1,-110,1,-200)
    fovUp.BackgroundColor3 = Color3.new(0.2,0.2,0.2)
    fovUp.Text = "FOV +"
    fovUp.TextColor3 = Color3.new(1,1,1)
    fovUp.Font = Enum.Font.SourceSansSemibold
    fovUp.TextScaled = true
    fovUp.Parent = screenGui
    local cornerU = Instance.new("UICorner")
    cornerU.CornerRadius = UDim.new(0,8)
    cornerU.Parent = fovUp
    fovUp.Visible = false

    local fovDown = Instance.new("TextButton")
    fovDown.Size = UDim2.new(0,100,0,50)
    fovDown.Position = UDim2.new(1,-110,1,-140)
    fovDown.BackgroundColor3 = Color3.new(0.2,0.2,0.2)
    fovDown.Text = "FOV -"
    fovDown.TextColor3 = Color3.new(1,1,1)
    fovDown.Font = Enum.Font.SourceSansSemibold
    fovDown.TextScaled = true
    fovDown.Parent = screenGui
    local cornerD = Instance.new("UICorner")
    cornerD.CornerRadius = UDim.new(0,8)
    cornerD.Parent = fovDown
    fovDown.Visible = false

    local movePad = Instance.new("Frame")
    movePad.Size = UDim2.new(0,200,0,200)
    movePad.Position = UDim2.new(0,20,1,-220)
    movePad.BackgroundColor3 = Color3.fromRGB(20,20,20)
    movePad.BackgroundTransparency = 0.3
    movePad.Parent = screenGui
    local cornerMove = Instance.new("UICorner")
    cornerMove.CornerRadius = UDim.new(0,100)
    cornerMove.Parent = movePad
    movePad.Visible = false

    local lookPad = Instance.new("Frame")
    lookPad.Size = UDim2.new(0,200,0,200)
    lookPad.Position = UDim2.new(1,-220,1,-220)
    lookPad.BackgroundColor3 = Color3.fromRGB(20,20,20)
    lookPad.BackgroundTransparency = 0.3
    lookPad.Parent = screenGui
    local cornerLook = Instance.new("UICorner")
    cornerLook.CornerRadius = UDim.new(0,100)
    cornerLook.Parent = lookPad
    lookPad.Visible = false

    toggleButton.MouseButton1Click:Connect(function()
        toggleFreecam()
        toggleButton.Text = freecam and "Freecam: ON" or "Freecam: OFF"
        fovUp.Visible = freecam
        fovDown.Visible = freecam
        movePad.Visible = freecam
        lookPad.Visible = freecam
        if speedFrame then speedFrame.Visible = freecam end
    end)

    fovUp.MouseButton1Click:Connect(function()
        if freecam then
            fov = math.clamp(fov+5,40,120)
            cam.FieldOfView = fov
        end
    end)
    fovDown.MouseButton1Click:Connect(function()
        if freecam then
            fov = math.clamp(fov-5,40,120)
            cam.FieldOfView = fov
        end
    end)

    movePad.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            lastPos = input.Position
        end
    end)
    movePad.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            local delta = (input.Position - lastPos) / 50
            moveVector = Vector3.new(delta.X,0,-delta.Y)
        end
    end)
    movePad.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            moveVector = Vector3.zero
        end
    end)

    lookPad.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            lookTouch = input
            lastPos = input.Position
        end
    end)
    lookPad.InputChanged:Connect(function(input)
        if input == lookTouch then
            local delta = input.Position - lastPos
            lastPos = input.Position
            updateCamera(moveVector,Vector2.new(delta.X,delta.Y),rs.RenderStepped:Wait())
        end
    end)
    lookPad.InputEnded:Connect(function(input)
        if input == lookTouch then
            lookTouch = nil
        end
    end)

    rs.RenderStepped:Connect(function(dt)
        if freecam then
            updateCamera(moveVector,Vector2.new(),dt)
        end
    end)
end

pcButton.MouseButton1Click:Connect(setupPC)
mobileButton.MouseButton1Click:Connect(setupMobile)
