-- ================= KEY SYSTEM =================
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

-- Key system with username binding
local validKeys = {
    {Key = "A7F3K9", User = "tillahibillahi"},
    {Key = "X2B8M1", User = "warcrimeleaker"},
    {Key = "XgFvD-SFvdS", User = "kernelhookxyz1"},
    {Key = "XDTx$g-$@1fh", User = "utakke1234567890"},
    {Key = "H3D7C6", User = "Player5"}
}
local keyCorrect = false

-- ================= REALISTIC ADMIN CMD =================
local keyGui = Instance.new("ScreenGui", game.CoreGui)
keyGui.ResetOnSpawn = false

local frame = Instance.new("Frame", keyGui)
frame.Size = UDim2.fromOffset(500,250)
frame.Position = UDim2.fromScale(0.5,0.5)
frame.AnchorPoint = Vector2.new(0.5,0.5)
frame.BackgroundColor3 = Color3.fromRGB(40,40,40)
frame.BackgroundTransparency = 0.4
frame.BorderSizePixel = 0

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0,6)

-- Terminal output
local output = Instance.new("TextLabel", frame)
output.Size = UDim2.new(1,-20,1,-60)
output.Position = UDim2.fromOffset(10,10)
output.BackgroundTransparency = 1
output.TextColor3 = Color3.fromRGB(230,230,230)
output.Font = Enum.Font.Code
output.TextSize = 18
output.TextXAlignment = Enum.TextXAlignment.Left
output.TextYAlignment = Enum.TextYAlignment.Top
output.Text = "Kernel\nEnter your access key below:\n>"

-- Input box
local textbox = Instance.new("TextBox", frame)
textbox.Size = UDim2.fromOffset(480,35)
textbox.Position = UDim2.fromOffset(10,200)
textbox.BackgroundColor3 = Color3.fromRGB(30,30,30)
textbox.BackgroundTransparency = 0.2
textbox.TextColor3 = Color3.fromRGB(255,255,255)
textbox.ClearTextOnFocus = true
textbox.Font = Enum.Font.Code
textbox.TextSize = 18
textbox.PlaceholderText = "Enter Key Here"
textbox.BorderSizePixel = 0

-- Function to append text
local function appendOutput(text)
    output.Text = output.Text .. "\n" .. text
end

-- ================= DRAGGING FUNCTION =================
local dragging = false
local dragInput, dragStart, startPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Key submit logic with username verification
textbox.FocusLost:Connect(function(enterPressed)
    if not enterPressed then return end
    local input = textbox.Text:gsub("%s","")
    local valid = false
    local assignedUser = nil
    
    for _,data in ipairs(validKeys) do
        if input == data.Key then 
            valid = true
            assignedUser = data.User
            break 
        end
    end

    if valid then
        if LP.Name == assignedUser or LP.DisplayName == assignedUser then
            keyCorrect = true
            keyGui:Destroy()
            appendOutput("Key accepted. Welcome, "..(LP.DisplayName~="" and LP.DisplayName or LP.Name)..".")
            -- HAUNTER.cc animation
            local function playHaunterAnimation(callback)
                local animGui = Instance.new("ScreenGui", game.CoreGui)
                animGui.ResetOnSpawn = false

                local haunter = Instance.new("TextLabel", animGui)
                haunter.Size = UDim2.fromScale(0.5,0.2)
                haunter.Position = UDim2.fromScale(0.5,0.5)
                haunter.AnchorPoint = Vector2.new(0.5,0.5)
                haunter.BackgroundTransparency = 1
                haunter.Text = "Exodus"
                haunter.TextColor3 = Color3.fromRGB(200,0,200)
                haunter.Font = Enum.Font.GothamBold
                haunter.TextScaled = true
                haunter.TextStrokeTransparency = 0.6

                local tweenInfo = TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
                local tweenProps = {TextTransparency = 0.3, TextSize = 96}
                local tween = TweenService:Create(haunter, tweenInfo, tweenProps)
                tween:Play()

                task.delay(2.5, function()
                    tween:Cancel()
                    animGui:Destroy()
                    if callback then callback() end
                end)
            end

            playHaunterAnimation(function()
                initializeScript()
            end)
        else
            textbox.Text = ""
            appendOutput("> NOT YOUR KEY")
        end
    else
        textbox.Text = ""
        appendOutput("> INVALID KEY")
    end
end)

repeat task.wait() until keyCorrect

-- ================= MAIN SCRIPT =================
function initializeScript()
    -- SERVICES
    local Players = game:GetService("Players")
    local UIS = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local Camera = workspace.CurrentCamera
    local LP = Players.LocalPlayer
    local Mouse = LP:GetMouse()
    local HttpService = game:GetService("HttpService")

    -- SETTINGS
    local HitboxSettings = {Parts={"HumanoidRootPart"}, Size=Vector3.new(25,25,25), Transparency=1, CanCollide=false}
    local REFRESH_INTERVAL = 0.5
    local TRIGGER_DELAY = 0.05

    -- STATE
    local hitboxHeld = false
    local lastShot = 0
    local menuOpen = false
    local tracersEnabled = false
    local espEnabled = true
    local capsHeld = false
    local altHeld = false
    local originalWalkSpeed = 25
    local originalJumpPower = 50
    local SelectedPlayers = {}
    local TracerLines = {}
    local NameESP = {}
    local OriginalParts = {}
    local SettingsFileName = "HaunterSettings.json"
    local espPositionAboveHead = true -- New state for ESP position
    local triggerbotEnabled = true -- New state for triggerbot
    local speedKeybind = Enum.KeyCode.CapsLock -- Default keybind for speed
    local jumpKeybind = Enum.KeyCode.LeftAlt -- Default keybind for jump power

    -- ==================== UI (ImGui-style) ====================
    local gui = Instance.new("ScreenGui", game.CoreGui)
    gui.Enabled = false
    gui.Name = "HaunterImGui"

    -- Main window frame
    local window = Instance.new("Frame", gui)
    window.Size = UDim2.fromOffset(320, 560) -- Increased height for new elements
    window.Position = UDim2.fromScale(0.04, 0.18)
    window.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    window.BorderSizePixel = 0
    window.Active = true
    window.Draggable = false -- We'll implement custom dragging

    local windowCorner = Instance.new("UICorner", window)
    windowCorner.CornerRadius = UDim.new(0, 4)

    -- Title bar
    local titleBar = Instance.new("Frame", window)
    titleBar.Size = UDim2.new(1, 0, 0, 32)
    titleBar.Position = UDim2.fromOffset(0, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    titleBar.BorderSizePixel = 0

    local titleCorner = Instance.new("UICorner", titleBar)
    titleCorner.CornerRadius = UDim.new(0, 4)

    -- Title label
    local titleLabel = Instance.new("TextLabel", titleBar)
    titleLabel.Size = UDim2.new(1, -60, 1, 0)
    titleLabel.Position = UDim2.fromOffset(8, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "Exodus"
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.Font = Enum.Font.GothamSemibold
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Close button (X)
    local closeBtn = Instance.new("TextButton", titleBar)
    closeBtn.Size = UDim2.fromOffset(44, 32)
    closeBtn.Position = UDim2.new(1, -44, 0, 0)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "×"
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 20
    closeBtn.MouseButton1Click:Connect(function()
        menuOpen = false
        gui.Enabled = false
    end)

    -- Content container
    local content = Instance.new("Frame", window)
    content.Size = UDim2.new(1, 0, 1, -32)
    content.Position = UDim2.fromOffset(0, 32)
    content.BackgroundTransparency = 1

    -- Helper to create sections
    local function createSection(parent, y, text)
        local section = Instance.new("Frame", parent)
        section.Size = UDim2.new(1, -16, 0, 28)
        section.Position = UDim2.fromOffset(8, y)
        section.BackgroundTransparency = 1

        local label = Instance.new("TextLabel", section)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(180, 180, 180)
        label.Font = Enum.Font.Gotham
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        return section
    end

    -- Tracers toggle
    local tracersSection = createSection(content, 8, "Tracers")
    local tracersToggle = Instance.new("TextButton", tracersSection)
    tracersToggle.Size = UDim2.fromOffset(50, 20)
    tracersToggle.Position = UDim2.new(1, -50, 0, 4)
    tracersToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    tracersToggle.BorderSizePixel = 0
    tracersToggle.Text = ""
    local tracersCorner = Instance.new("UICorner", tracersToggle)
    tracersCorner.CornerRadius = UDim.new(0, 10)

    local function updateTracerToggle()
        tracersToggle.BackgroundColor3 = tracersEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 60)
    end

    tracersToggle.MouseButton1Click:Connect(function()
        tracersEnabled = not tracersEnabled
        updateTracerToggle()
        saveSettings()
    end)
    updateTracerToggle()

    -- ESP toggle
    local espSection = createSection(content, 36, "ESP")
    local espToggle = Instance.new("TextButton", espSection)
    espToggle.Size = UDim2.fromOffset(50, 20)
    espToggle.Position = UDim2.new(1, -50, 0, 4)
    espToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    espToggle.BorderSizePixel = 0
    espToggle.Text = ""
    local espCorner = Instance.new("UICorner", espToggle)
    espCorner.CornerRadius = UDim.new(0, 10)

    local function updateESPToggle()
        espToggle.BackgroundColor3 = espEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 60)
    end

    espToggle.MouseButton1Click:Connect(function()
        espEnabled = not espEnabled
        updateESPToggle()
        saveSettings()
    end)
    updateESPToggle()

    -- Triggerbot toggle
    local triggerbotSection = createSection(content, 64, "Triggerbot")
    local triggerbotToggle = Instance.new("TextButton", triggerbotSection)
    triggerbotToggle.Size = UDim2.fromOffset(50, 20)
    triggerbotToggle.Position = UDim2.new(1, -50, 0, 4)
    triggerbotToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    triggerbotToggle.BorderSizePixel = 0
    triggerbotToggle.Text = ""
    local triggerbotCorner = Instance.new("UICorner", triggerbotToggle)
    triggerbotCorner.CornerRadius = UDim.new(0, 10)

    local function updateTriggerbotToggle()
        triggerbotToggle.BackgroundColor3 = triggerbotEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 60)
    end

    triggerbotToggle.MouseButton1Click:Connect(function()
        triggerbotEnabled = not triggerbotEnabled
        updateTriggerbotToggle()
        saveSettings()
    end)
    updateTriggerbotToggle()

    -- ESP Position toggle (above/below head)
    local espPosSection = createSection(content, 92, "ESP Position")
    local espPosToggle = Instance.new("TextButton", espPosSection)
    espPosToggle.Size = UDim2.fromOffset(50, 20)
    espPosToggle.Position = UDim2.new(1, -50, 0, 4)
    espPosToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    espPosToggle.BorderSizePixel = 0
    espPosToggle.Text = ""
    local espPosCorner = Instance.new("UICorner", espPosToggle)
    espPosCorner.CornerRadius = UDim.new(0, 10)

    local function updateESPPosToggle()
        espPosToggle.BackgroundColor3 = espPositionAboveHead and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 60)
    end

    espPosToggle.MouseButton1Click:Connect(function()
        espPositionAboveHead = not espPositionAboveHead
        updateESPPosToggle()
        saveSettings()
    end)
    updateESPPosToggle()

    -- Silent FOV (Hitbox Size) slider
    local fovSection = createSection(content, 120, "Silent FOV")

    local sliderBg = Instance.new("Frame", fovSection)
    sliderBg.Size = UDim2.fromOffset(100, 4)
    sliderBg.Position = UDim2.new(1, -106, 0, 12)
    sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    sliderBg.BorderSizePixel = 0
    local sliderBgCorner = Instance.new("UICorner", sliderBg)
    sliderBgCorner.CornerRadius = UDim.new(1, 0)

    local fovLabel = Instance.new("TextLabel", fovSection)
    fovLabel.Size = UDim2.fromOffset(24, 20)
    fovLabel.Position = UDim2.new(1, -28, 0, 4)
    fovLabel.BackgroundTransparency = 1
    fovLabel.Text = "25"
    fovLabel.TextColor3 = Color3.new(1, 1, 1)
    fovLabel.Font = Enum.Font.Gotham
    fovLabel.TextSize = 14
    fovLabel.TextXAlignment = Enum.TextXAlignment.Right

    local sliderFill = Instance.new("Frame", sliderBg)
    sliderFill.Size = UDim2.new(0.3, 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(100, 50, 200)
    sliderFill.BorderSizePixel = 0
    local sliderFillCorner = Instance.new("UICorner", sliderFill)
    sliderFillCorner.CornerRadius = UDim.new(1, 0)

    local MIN_SIZE = 5
    local MAX_SIZE = 60
    local draggingSlider = false

    local function updateHitboxSizeFromSlider(xPos)
        local rel = math.clamp((xPos - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        sliderFill.Size = UDim2.new(rel, 0, 1, 0)
        local size = math.floor(MIN_SIZE + (MAX_SIZE - MIN_SIZE) * rel)
        HitboxSettings.Size = Vector3.new(size, size, size)
        fovLabel.Text = tostring(size)
        for plr in pairs(SelectedPlayers) do
            expandHitboxes(plr)
        end
        saveSettings()
    end

    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingSlider = true
            updateHitboxSizeFromSlider(input.Position.X)
        end
    end)

    sliderBg.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingSlider = false
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateHitboxSizeFromSlider(input.Position.X)
        end
    end)

    -- Keybind customization section
    local keybindSection = createSection(content, 152, "Keybinds")
    
   -- Speed keybind box
    local speedKeybindBox = Instance.new("TextButton", keybindSection)
    speedKeybindBox.Size = UDim2.fromOffset(50, 20)
    speedKeybindBox.Position = UDim2.new(1, -110, 0, 4)
    speedKeybindBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    speedKeybindBox.BorderSizePixel = 0
    speedKeybindBox.Text = speedKeybind.Name
    speedKeybindBox.TextColor3 = Color3.new(1, 1, 1)
    speedKeybindBox.Font = Enum.Font.Gotham
    speedKeybindBox.TextSize = 12
    local speedKeybindCorner = Instance.new("UICorner", speedKeybindBox)
    speedKeybindCorner.CornerRadius = UDim.new(0, 4)
    
    local speedKeybindLabel = Instance.new("TextLabel", keybindSection)
    speedKeybindLabel.Size = UDim2.fromOffset(50, 20)
    speedKeybindLabel.Position = UDim2.new(1, -55, 0, 4)
    speedKeybindLabel.BackgroundTransparency = 1
    speedKeybindLabel.Text = "Speed"
    speedKeybindLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    speedKeybindLabel.Font = Enum.Font.Gotham
    speedKeybindLabel.TextSize = 12
    speedKeybindLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Jump keybind box
    local jumpKeybindBox = Instance.new("TextButton", keybindSection)
    jumpKeybindBox.Size = UDim2.fromOffset(50, 20)
    jumpKeybindBox.Position = UDim2.new(1, -110, 0, 26)
    jumpKeybindBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    jumpKeybindBox.BorderSizePixel = 0
    jumpKeybindBox.Text = jumpKeybind.Name
    jumpKeybindBox.TextColor3 = Color3.new(1, 1, 1)
    jumpKeybindBox.Font = Enum.Font.Gotham
    jumpKeybindBox.TextSize = 12
    local jumpKeybindCorner = Instance.new("UICorner", jumpKeybindBox)
    jumpKeybindCorner.CornerRadius = UDim.new(0, 4)
    
    local jumpKeybindLabel = Instance.new("TextLabel", keybindSection)
    jumpKeybindLabel.Size = UDim2.fromOffset(50, 20)
    jumpKeybindLabel.Position = UDim2.new(1, -55, 0, 26)
    jumpKeybindLabel.BackgroundTransparency = 1
    jumpKeybindLabel.Text = "Jump"
    jumpKeybindLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    jumpKeybindLabel.Font = Enum.Font.Gotham
    jumpKeybindLabel.TextSize = 12
    jumpKeybindLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Keybind assignment logic
    local function assignKeybind(keybindBox, keybindType)
        keybindBox.BackgroundColor3 = Color3.fromRGB(80, 80, 40)
        keybindBox.Text = "..."
        
        local connection
        connection = UIS.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            
            if input.UserInputType == Enum.UserInputType.Keyboard then
                if keybindType == "speed" then
                    speedKeybind = input.KeyCode
                    keybindBox.Text = speedKeybind.Name
                elseif keybindType == "jump" then
                    jumpKeybind = input.KeyCode
                    keybindBox.Text = jumpKeybind.Name
                end
                
                keybindBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                connection:Disconnect()
                saveSettings()
            end
        end)
    end

    speedKeybindBox.MouseButton1Click:Connect(function()
        assignKeybind(speedKeybindBox, "speed")
    end)

    jumpKeybindBox.MouseButton1Click:Connect(function()
        assignKeybind(jumpKeybindBox, "jump")
    end)

    -- Separator line
    local separator = Instance.new("Frame", content)
    separator.Size = UDim2.new(1, -16, 0, 1)
    separator.Position = UDim2.fromOffset(8, 184)
    separator.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    separator.BorderSizePixel = 0

    -- Player list label
    local playerListLabel = Instance.new("TextLabel", content)
    playerListLabel.Size = UDim2.new(1, -16, 0, 20)
    playerListLabel.Position = UDim2.fromOffset(8, 192)
    playerListLabel.BackgroundTransparency = 1
    playerListLabel.Text = "Players"
    playerListLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    playerListLabel.Font = Enum.Font.GothamSemibold
    playerListLabel.TextSize = 14
    playerListLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Player list container
    local list = Instance.new("ScrollingFrame", content)
    list.Position = UDim2.fromOffset(8, 216)
    list.Size = UDim2.new(1, -16, 1, -216)
    list.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    list.BorderSizePixel = 0
    list.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
    list.ScrollBarThickness = 6

    local listCorner = Instance.new("UICorner", list)
    listCorner.CornerRadius = UDim.new(0, 4)

    local layout = Instance.new("UIListLayout", list)
    layout.Padding = UDim.new(0, 2)

    -- Custom dragging for the window
    local draggingWindow = false
    local dragStart, startPos

    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingWindow = true
            dragStart = input.Position
            startPos = window.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    draggingWindow = false
                end
            end)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and draggingWindow then
            local delta = input.Position - dragStart
            window.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    -- ==================== HELPERS ====================
    local function getHumanoid()
        local char = LP.Character
        return char and char:FindFirstChildOfClass("Humanoid")
    end

    local function applyCapsWalkSpeed()
        local hum = getHumanoid()
        if hum then hum.WalkSpeed = capsHeld and 400 or originalWalkSpeed end
    end

    local function applyAltJumpPower()
        local hum = getHumanoid()
        if hum then hum.JumpPower = altHeld and 400 or originalJumpPower end
    end

    -- HITBOX FUNCTIONS
    local function saveOriginal(char)
        OriginalParts[char] = OriginalParts[char] or {}
        for _,name in ipairs(HitboxSettings.Parts) do
            local p = char:FindFirstChild(name)
            if p and not OriginalParts[char][p] then
                OriginalParts[char][p] = {Size=p.Size, Transparency=p.Transparency, CanCollide=p.CanCollide}
            end
        end
    end

    local function expandHitboxes(plr)
        if not SelectedPlayers[plr] then return end
        local char = plr.Character
        if not char then return end
        saveOriginal(char)
        for _,name in ipairs(HitboxSettings.Parts) do
            local p = char:FindFirstChild(name)
            if p then
                p.Size = HitboxSettings.Size
                p.Transparency = HitboxSettings.Transparency
                p.CanCollide = false
            end
        end
    end

    local function restoreHitboxes(plr)
        local char = plr.Character
        if not char or not OriginalParts[char] then return end
        for part,data in pairs(OriginalParts[char]) do
            if part and part.Parent then
                part.Size = data.Size
                part.Transparency = data.Transparency
                part.CanCollide = data.CanCollide
            end
        end
        OriginalParts[char] = nil
    end

    -- ================= TRACERS =================
    local function createTracer(plr)
        if TracerLines[plr] then return end
        local l = Drawing.new("Line")
        l.Thickness = 1.5
        l.Color = Color3.fromRGB(255,0,0)
        l.Visible = false
        TracerLines[plr] = l
    end

    local function removeTracer(plr)
        if TracerLines[plr] then
            TracerLines[plr]:Remove()
            TracerLines[plr] = nil
        end
    end

    -- ================= NAME ESP =================
    local function createNameESP(plr)
        if NameESP[plr] then return end
        local t = Drawing.new("Text")
        t.Size = 8
        t.Center = true
        t.Outline = true
        t.Color = Color3.fromRGB(255,255,255)
        t.Visible = true
        NameESP[plr] = t
    end

    local function removeNameESP(plr)
        if NameESP[plr] then
            NameESP[plr]:Remove()
            NameESP[plr] = nil
        end
    end

    -- ================= RENDER =================
    RunService.RenderStepped:Connect(function()
        local center = Camera.ViewportSize / 2
        applyCapsWalkSpeed()
        applyAltJumpPower()

        -- Tracers
        for plr,line in pairs(TracerLines) do
            if not tracersEnabled then line.Visible=false continue end
            local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local pos,onScreen = Camera:WorldToViewportPoint(hrp.Position)
                line.Visible = onScreen
                line.From = Vector2.new(center.X,center.Y)
                line.To = Vector2.new(pos.X,pos.Y)
            else
                line.Visible = false
            end
        end

        -- Name ESP with position toggle
        for plr,txt in pairs(NameESP) do
            local head = plr.Character and plr.Character:FindFirstChild("Head")
            if head and txt then
                local offset = espPositionAboveHead and Vector3.new(0,1.5,0) or Vector3.new(0,-3.5,0)
                local pos,onScreen = Camera:WorldToViewportPoint(head.Position + offset)
                txt.Visible = onScreen and espEnabled
                txt.Position = Vector2.new(pos.X,pos.Y)
                txt.Text = plr.DisplayName ~= "" and plr.DisplayName or plr.Name
                
                if SelectedPlayers[plr] and hitboxHeld then
                    txt.Color = Color3.fromRGB(255,0,0)
                else
                    txt.Color = Color3.fromRGB(255,255,255)
                end
            end
        end
    end)

    -- ================= PLAYER LIST =================
    local function refreshPlayerList()
        for _,c in ipairs(list:GetChildren()) do if not c:IsA("UIListLayout") then c:Destroy() end end
        for _,plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP then
                createNameESP(plr)
                local btn = Instance.new("TextButton", list)
                btn.Size = UDim2.new(1, -4, 0, 24)
                btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                btn.BorderSizePixel = 0
                btn.Font = Enum.Font.Gotham
                btn.TextSize = 14
                btn.TextColor3 = Color3.new(1, 1, 1)
                btn.TextXAlignment = Enum.TextXAlignment.Left
                btn.Text = " " .. (plr.DisplayName ~= "" and plr.DisplayName or plr.Name)

                local btnCorner = Instance.new("UICorner", btn)
                btnCorner.CornerRadius = UDim.new(0, 4)

                local function update()
                    btn.BackgroundColor3 = SelectedPlayers[plr] and Color3.fromRGB(40, 80, 40) or Color3.fromRGB(30, 30, 30)
                end
                update()
                plr:GetPropertyChangedSignal("DisplayName"):Connect(function()
                    btn.Text = " " .. (plr.DisplayName ~= "" and plr.DisplayName or plr.Name)
                end)
                btn.MouseButton1Click:Connect(function()
                    SelectedPlayers[plr] = not SelectedPlayers[plr]
                    if SelectedPlayers[plr] then
                        expandHitboxes(plr)
                        createTracer(plr)
                    else
                        restoreHitboxes(plr)
                        removeTracer(plr)
                    end
                    update()
                    saveSettings()
                end)
            end
        end
        task.wait()
        list.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 4)
    end

    refreshPlayerList()
    Players.PlayerAdded:Connect(function(plr)
        refreshPlayerList()
        createNameESP(plr)
    end)
    Players.PlayerRemoving:Connect(function(plr)
        removeNameESP(plr)
    end)

    -- ================= TRIGGERBOT =================
    local function getTool()
        if not LP.Character then return end
        for _,v in ipairs(LP.Character:GetChildren()) do
            if v:IsA("Tool") then return v end
        end
    end

    RunService.RenderStepped:Connect(function()
        if not hitboxHeld or not triggerbotEnabled then return end
        local t = Mouse.Target
        if not t then return end
        local char = t:FindFirstAncestorOfClass("Model")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local plr = char and Players:GetPlayerFromCharacter(char)
        if hum and plr and SelectedPlayers[plr] and hum.Health > 0 then
            if tick() - lastShot >= TRIGGER_DELAY then
                lastShot = tick()
                local tool = getTool()
                if tool then tool:Activate() end
            end
        end
    end)

    -- ================= INPUT =================
    UIS.InputBegan:Connect(function(i, gp)
        if gp then return end
        if i.KeyCode == Enum.KeyCode.RightControl then
            menuOpen = not menuOpen
            gui.Enabled = menuOpen
            if menuOpen then refreshPlayerList() end
        end
        if i.KeyCode == speedKeybind then
            capsHeld = true
            applyCapsWalkSpeed()
        end
        if i.KeyCode == jumpKeybind then
            altHeld = true
            applyAltJumpPower()
        end
        if i.KeyCode == Enum.KeyCode.Insert then
            espPositionAboveHead = not espPositionAboveHead
            updateESPPosToggle()
            saveSettings()
        end
        if i.UserInputType == Enum.UserInputType.MouseButton2 then
            hitboxHeld = true
            task.spawn(function()
                while hitboxHeld do
                    for plr in pairs(SelectedPlayers) do expandHitboxes(plr) end
                    task.wait(REFRESH_INTERVAL)
                end
            end)
        end
    end)

    UIS.InputEnded:Connect(function(i)
        if i.KeyCode == speedKeybind then
            capsHeld = false
            applyCapsWalkSpeed()
        end
        if i.KeyCode == jumpKeybind then
            altHeld = false
            applyAltJumpPower()
        end
        if i.UserInputType == Enum.UserInputType.MouseButton2 then
            hitboxHeld = false
        end
    end)

    -- ================= ENSURE SPEED/POWER AFTER RESPAWN =================
    LP.CharacterAdded:Connect(function(char)
        task.wait(0.1)
        local hum = char:WaitForChild("Humanoid", 5)
        if hum then
            applyCapsWalkSpeed()
            applyAltJumpPower()
        end
    end)

    -- ================= SETTINGS SAVE/LOAD =================
    function saveSettings()
        local data = {
            HitboxSize = HitboxSettings.Size.X,
            Tracers = tracersEnabled,
            ESP = espEnabled,
            ESPPosAboveHead = espPositionAboveHead,
            Triggerbot = triggerbotEnabled,
            SpeedKeybind = speedKeybind.Name,
            JumpKeybind = jumpKeybind.Name,
            Selected = {}
        }
        for plr, _ in pairs(SelectedPlayers) do
            table.insert(data.Selected, plr.Name)
        end
        pcall(function()
            writefile(SettingsFileName, HttpService:JSONEncode(data))
        end)
    end

    function loadSettings()
        if not pcall(function() return readfile(SettingsFileName) end) then return end
        local content = readfile(SettingsFileName)
        local success, data = pcall(function() return HttpService:JSONDecode(content) end)
        if not success or not data then return end
        if data.HitboxSize then
            HitboxSettings.Size = Vector3.new(data.HitboxSize, data.HitboxSize, data.HitboxSize)
            fovLabel.Text = tostring(data.HitboxSize)
            local rel = (data.HitboxSize - MIN_SIZE) / (MAX_SIZE - MIN_SIZE)
            sliderFill.Size = UDim2.new(rel, 0, 1, 0)
        end
        if data.Tracers ~= nil then
            tracersEnabled = data.Tracers
            updateTracerToggle()
        end
        if data.ESP ~= nil then
            espEnabled = data.ESP
            updateESPToggle()
        end
        if data.ESPPosAboveHead ~= nil then
            espPositionAboveHead = data.ESPPosAboveHead
            updateESPPosToggle()
        end
        if data.Triggerbot ~= nil then
            triggerbotEnabled = data.Triggerbot
            updateTriggerbotToggle()
        end
        if data.SpeedKeybind then
            local success, key = pcall(function() return Enum.KeyCode[data.SpeedKeybind] end)
            if success and key then
                speedKeybind = key
                speedKeybindBox.Text = speedKeybind.Name
            end
        end
        if data.JumpKeybind then
            local success, key = pcall(function() return Enum.KeyCode[data.JumpKeybind] end)
           if success and key then
                jumpKeybind = key
                jumpKeybindBox.Text = jumpKeybind.Name
            end
        end
        if data.Selected then
            for _, name in ipairs(data.Selected) do
                local plr = Players:FindFirstChild(name)
                if plr then
                    SelectedPlayers[plr] = true
                    expandHitboxes(plr)
                    createTracer(plr)
                end
            end
        end
    end

    loadSettings()
end
