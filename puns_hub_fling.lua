--[[
    ╔═══════════════════════════════════════╗
    ║     Pun's Hub (My Loveee) ❤️          ║
    ║     Ultimate Fling Tool               ║
    ╚═══════════════════════════════════════╝
    
    ✨ Modern & Compact UI
    🎨 Beautiful Design
    ⚡ Smooth Animations
    💖 Made with Love
]]

-- ============================================================
-- SERVICES
-- ============================================================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Player = Players.LocalPlayer

-- ============================================================
-- SETTINGS
-- ============================================================
local CONFIG = {
    WaitTime = 0.5,
    FlingPower = 2500,
    ReturnToPosition = true
}

local THEME = {
    -- Gradient colors - Romantic theme
    Accent1 = Color3.fromRGB(255, 150, 200),  -- Soft Pink
    Accent2 = Color3.fromRGB(200, 150, 255),  -- Lavender
    Accent3 = Color3.fromRGB(255, 182, 193),  -- Light Pink
    
    -- Base colors - Softer tones
    BG = Color3.fromRGB(20, 15, 25),
    Surface = Color3.fromRGB(30, 25, 40),
    Border = Color3.fromRGB(60, 50, 80),
    
    -- Status colors - Pastel
    Success = Color3.fromRGB(150, 220, 180),
    Danger = Color3.fromRGB(255, 150, 170),
    Warning = Color3.fromRGB(255, 200, 150),
    
    -- Text
    Text = Color3.fromRGB(255, 245, 250),
    TextDim = Color3.fromRGB(200, 180, 210)
}

-- ============================================================
-- STATE
-- ============================================================
local SelectedTargets = {}
local PlayerCheckboxes = {}
local FlingActive = false
local SettingsOpen = false
local Minimized = false
getgenv().OldPos = nil
getgenv().FPDH = workspace.FallenPartsDestroyHeight

-- ============================================================
-- HELPERS
-- ============================================================
local function Tween(obj, props, time, style, direction)
    time = time or 0.3
    style = style or Enum.EasingStyle.Quint
    direction = direction or Enum.EasingDirection.Out
    TweenService:Create(obj, TweenInfo.new(time, style, direction), props):Play()
end

local function Corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 12)
    c.Parent = parent
    return c
end

local function Stroke(parent, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thickness or 1
    s.Transparency = 0.3
    s.Parent = parent
    return s
end

local function Gradient(parent, colors, rotation)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new(colors)
    g.Rotation = rotation or 90
    g.Parent = parent
    return g
end

local function Shadow(parent)
    local s = Instance.new("ImageLabel")
    s.Name = "Shadow"
    s.Size = UDim2.new(1, 50, 1, 50)
    s.Position = UDim2.new(0, -25, 0, -25)
    s.BackgroundTransparency = 1
    s.Image = "rbxassetid://5554236805"
    s.ImageColor3 = Color3.new(0, 0, 0)
    s.ImageTransparency = 0.7
    s.ScaleType = Enum.ScaleType.Slice
    s.SliceCenter = Rect.new(23, 23, 277, 277)
    s.ZIndex = -1
    s.Parent = parent
    return s
end

-- ============================================================
-- GUI CREATION
-- ============================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PunsHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

if Player.PlayerGui:FindFirstChild("PunsHub") then
    Player.PlayerGui:FindFirstChild("PunsHub"):Destroy()
end
ScreenGui.Parent = Player.PlayerGui

-- ============================================================
-- MAIN CONTAINER
-- ============================================================
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 280, 0, 380)
Main.Position = UDim2.new(0.5, -140, 0.5, -190)
Main.BackgroundColor3 = THEME.BG
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.ClipsDescendants = true
Main.Parent = ScreenGui

Corner(Main, 20)
Shadow(Main)

-- Romantic sparkles around frame
local SparkleContainer = Instance.new("Frame")
SparkleContainer.Size = UDim2.new(1, 60, 1, 60)
SparkleContainer.Position = UDim2.new(0, -30, 0, -30)
SparkleContainer.BackgroundTransparency = 1
SparkleContainer.ZIndex = 0
SparkleContainer.Parent = Main

task.spawn(function()
    while SparkleContainer and SparkleContainer.Parent do
        local sparkle = Instance.new("TextLabel")
        sparkle.Size = UDim2.new(0, 16, 0, 16)
        sparkle.Position = UDim2.new(math.random(0, 100) / 100, 0, math.random(0, 100) / 100, 0)
        sparkle.BackgroundTransparency = 1
        sparkle.Text = ({"✨", "⭐", "💫", "🌟"})[math.random(1, 4)]
        sparkle.TextSize = math.random(10, 16)
        sparkle.TextTransparency = 0
        sparkle.ZIndex = 0
        sparkle.Parent = SparkleContainer
        
        local randomRotation = math.random(-180, 180)
        
        Tween(sparkle, {
            TextTransparency = 1,
            Rotation = randomRotation,
            TextSize = 8
        }, 1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        
        task.delay(1.5, function()
            if sparkle then sparkle:Destroy() end
        end)
        
        task.wait(0.3)
    end
end)

-- Floating toggle button (appears when minimized)
local FloatingBtn = Instance.new("TextButton")
FloatingBtn.Name = "FloatingToggle"
FloatingBtn.Size = UDim2.new(0, 50, 0, 50)
FloatingBtn.Position = UDim2.new(0, 20, 0, 20)
FloatingBtn.BackgroundColor3 = THEME.Surface
FloatingBtn.Text = ""
FloatingBtn.AutoButtonColor = false
FloatingBtn.Visible = false
FloatingBtn.Active = true
FloatingBtn.Draggable = true
FloatingBtn.Parent = ScreenGui

Corner(FloatingBtn, 16)
Shadow(FloatingBtn)

-- Blue Archive style cat ears for floating button
local FloatLeftEar = Instance.new("Frame")
FloatLeftEar.Size = UDim2.new(0, 20, 0, 24)
FloatLeftEar.Position = UDim2.new(0.1, -4, 0.1, -10)
FloatLeftEar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
FloatLeftEar.BorderSizePixel = 0
FloatLeftEar.Rotation = -25
FloatLeftEar.ZIndex = 3
FloatLeftEar.Parent = FloatingBtn

Corner(FloatLeftEar, 5)
Stroke(FloatLeftEar, THEME.Accent1, 2)

local FloatLeftInner = Instance.new("Frame")
FloatLeftInner.Size = UDim2.new(0.5, 0, 0.5, 0)
FloatLeftInner.Position = UDim2.new(0.25, 0, 0.3, 0)
FloatLeftInner.BackgroundColor3 = Color3.fromRGB(255, 182, 193)
FloatLeftInner.BorderSizePixel = 0
FloatLeftInner.Parent = FloatLeftEar

Corner(FloatLeftInner, 3)

local FloatRightEar = Instance.new("Frame")
FloatRightEar.Size = UDim2.new(0, 20, 0, 24)
FloatRightEar.Position = UDim2.new(0.9, -16, 0.1, -10)
FloatRightEar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
FloatRightEar.BorderSizePixel = 0
FloatRightEar.Rotation = 25
FloatRightEar.ZIndex = 3
FloatRightEar.Parent = FloatingBtn

Corner(FloatRightEar, 5)
Stroke(FloatRightEar, THEME.Accent1, 2)

local FloatRightInner = Instance.new("Frame")
FloatRightInner.Size = UDim2.new(0.5, 0, 0.5, 0)
FloatRightInner.Position = UDim2.new(0.25, 0, 0.3, 0)
FloatRightInner.BackgroundColor3 = Color3.fromRGB(255, 182, 193)
FloatRightInner.BorderSizePixel = 0
FloatRightInner.Parent = FloatRightEar

Corner(FloatRightInner, 3)

local FloatingGradient = Instance.new("Frame")
FloatingGradient.Size = UDim2.new(1, 0, 1, 0)
FloatingGradient.BackgroundColor3 = THEME.Accent1
FloatingGradient.BackgroundTransparency = 0.3
FloatingGradient.BorderSizePixel = 0
FloatingGradient.ZIndex = 0
FloatingGradient.Parent = FloatingBtn

Corner(FloatingGradient, 16)
Gradient(FloatingGradient, {
    ColorSequenceKeypoint.new(0, THEME.Accent1),
    ColorSequenceKeypoint.new(0.5, THEME.Accent2),
    ColorSequenceKeypoint.new(1, THEME.Accent3)
}, 45)

local FloatingIcon = Instance.new("ImageLabel")
FloatingIcon.Size = UDim2.new(0.8, 0, 0.8, 0)
FloatingIcon.Position = UDim2.new(0.1, 0, 0.1, 0)
FloatingIcon.BackgroundTransparency = 1
FloatingIcon.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=0&width=150&height=150&format=png" -- Placeholder
FloatingIcon.ScaleType = Enum.ScaleType.Fit
FloatingIcon.ZIndex = 2
FloatingIcon.Parent = FloatingBtn

local FloatingCorner = Instance.new("UICorner")
FloatingCorner.CornerRadius = UDim.new(0.5, 0)
FloatingCorner.Parent = FloatingIcon

-- Get actual avatar for floating button
task.spawn(function()
    local success, userId = pcall(function()
        return Players:GetUserIdFromNameAsync("InTheSkyFunny")
    end)
    
    if success and userId then
        FloatingIcon.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. userId .. "&width=150&height=150&format=png"
    end
end)

-- Floating hearts animation
local HeartsContainer = Instance.new("Frame")
HeartsContainer.Size = UDim2.new(1, 100, 1, 100)
HeartsContainer.Position = UDim2.new(0, -50, 0, -50)
HeartsContainer.BackgroundTransparency = 1
HeartsContainer.ZIndex = 1
HeartsContainer.Parent = FloatingBtn

task.spawn(function()
    while FloatingBtn and FloatingBtn.Parent do
        if FloatingBtn.Visible then
            local heart = Instance.new("TextLabel")
            heart.Size = UDim2.new(0, 20, 0, 20)
            heart.Position = UDim2.new(0.5, math.random(-25, 25), 0.5, math.random(-25, 25))
            heart.BackgroundTransparency = 1
            heart.Text = "❤️"
            heart.TextSize = 16
            heart.TextTransparency = 0
            heart.ZIndex = 1
            heart.Parent = HeartsContainer
            
            local randomX = math.random(-30, 30)
            local randomY = math.random(-60, -40)
            
            Tween(heart, {
                Position = UDim2.new(0.5, randomX, 0.5, randomY),
                TextTransparency = 1,
                TextSize = 8
            }, 2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
            
            task.delay(2, function()
                if heart then heart:Destroy() end
            end)
            
            task.wait(0.8)
        else
            task.wait(0.1)
        end
    end
end)

-- Background gradient overlay
local BgGradient = Instance.new("Frame")
BgGradient.Size = UDim2.new(1, 0, 0.3, 0)
BgGradient.BackgroundColor3 = THEME.Accent1
BgGradient.BackgroundTransparency = 0.8
BgGradient.BorderSizePixel = 0
BgGradient.ZIndex = 0
BgGradient.Parent = Main

Corner(BgGradient, 20)
Gradient(BgGradient, {
    ColorSequenceKeypoint.new(0, THEME.Accent1),
    ColorSequenceKeypoint.new(0.5, THEME.Accent2),
    ColorSequenceKeypoint.new(1, THEME.Accent3)
}, 45)

-- Animated gradient rotation
task.spawn(function()
    local grad = BgGradient:FindFirstChildOfClass("UIGradient")
    while grad and grad.Parent do
        for i = 0, 360, 3 do
            if not grad or not grad.Parent then break end
            grad.Rotation = i
            task.wait(0.05)
        end
    end
end)

-- ============================================================
-- HEADER
-- ============================================================
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 55)
Header.BackgroundTransparency = 1
Header.Parent = Main

-- Logo/Icon - Roblox Avatar
local Logo = Instance.new("ImageLabel")
Logo.Size = UDim2.new(0, 40, 0, 40)
Logo.Position = UDim2.new(0, 10, 0, 8)
Logo.BackgroundColor3 = THEME.Surface
Logo.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=0&width=150&height=150&format=png" -- Placeholder
Logo.ScaleType = Enum.ScaleType.Fit
Logo.Parent = Header

-- Get actual avatar
task.spawn(function()
    local success, userId = pcall(function()
        return Players:GetUserIdFromNameAsync("InTheSkyFunny")
    end)
    
    if success and userId then
        Logo.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. userId .. "&width=150&height=150&format=png"
    end
end)

Corner(Logo, 14)
Stroke(Logo, THEME.Accent1, 2)

-- Blue Archive style cat ears
local LeftEar = Instance.new("Frame")
LeftEar.Size = UDim2.new(0, 16, 0, 20)
LeftEar.Position = UDim2.new(0, -3, 0, -8)
LeftEar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
LeftEar.BorderSizePixel = 0
LeftEar.Rotation = -25
LeftEar.ZIndex = 5
LeftEar.Parent = Logo

Corner(LeftEar, 4)
Stroke(LeftEar, THEME.Accent1, 1.5)

local LeftEarInner = Instance.new("Frame")
LeftEarInner.Size = UDim2.new(0.5, 0, 0.5, 0)
LeftEarInner.Position = UDim2.new(0.25, 0, 0.3, 0)
LeftEarInner.BackgroundColor3 = Color3.fromRGB(255, 182, 193)
LeftEarInner.BorderSizePixel = 0
LeftEarInner.Parent = LeftEar

Corner(LeftEarInner, 2)

local RightEar = Instance.new("Frame")
RightEar.Size = UDim2.new(0, 16, 0, 20)
RightEar.Position = UDim2.new(1, -13, 0, -8)
RightEar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
RightEar.BorderSizePixel = 0
RightEar.Rotation = 25
RightEar.ZIndex = 5
RightEar.Parent = Logo

Corner(RightEar, 4)
Stroke(RightEar, THEME.Accent1, 1.5)

local RightEarInner = Instance.new("Frame")
RightEarInner.Size = UDim2.new(0.5, 0, 0.5, 0)
RightEarInner.Position = UDim2.new(0.25, 0, 0.3, 0)
RightEarInner.BackgroundColor3 = Color3.fromRGB(255, 182, 193)
RightEarInner.BorderSizePixel = 0
RightEarInner.Parent = RightEar

Corner(RightEarInner, 2)

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -130, 0, 22)
Title.Position = UDim2.new(0, 55, 0, 10)
Title.BackgroundTransparency = 1
Title.Text = "Pun's Hub"
Title.TextColor3 = THEME.Text
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

Gradient(Title, {
    ColorSequenceKeypoint.new(0, THEME.Accent1),
    ColorSequenceKeypoint.new(0.5, THEME.Accent2),
    ColorSequenceKeypoint.new(1, THEME.Accent3)
}, 0)

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, -130, 0, 16)
Subtitle.Position = UDim2.new(0, 55, 0, 30)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "(My Loveee) ❤️"
Subtitle.TextColor3 = THEME.TextDim
Subtitle.TextSize = 11
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = Header

-- Toggle button
local Toggle = Instance.new("TextButton")
Toggle.Size = UDim2.new(0, 32, 0, 32)
Toggle.Position = UDim2.new(1, -40, 0, 12)
Toggle.BackgroundColor3 = THEME.Surface
Toggle.Text = "💝"
Toggle.TextColor3 = THEME.Accent1
Toggle.TextSize = 16
Toggle.Font = Enum.Font.GothamBold
Toggle.AutoButtonColor = false
Toggle.Parent = Header

Corner(Toggle, 10)
Stroke(Toggle, THEME.Border, 1.5)

Toggle.MouseEnter:Connect(function()
    Tween(Toggle, {BackgroundColor3 = THEME.Accent1}, 0.2)
    Toggle.Text = "💖"
end)

Toggle.MouseLeave:Connect(function()
    Tween(Toggle, {BackgroundColor3 = THEME.Surface}, 0.2)
    Toggle.Text = "💝"
end)

-- ============================================================
-- STATUS
-- ============================================================
local Status = Instance.new("Frame")
Status.Size = UDim2.new(1, -20, 0, 42)
Status.Position = UDim2.new(0, 10, 0, 62)
Status.BackgroundColor3 = THEME.Surface
Status.BorderSizePixel = 0
Status.Parent = Main

Corner(Status, 12)
Stroke(Status, THEME.Border, 1.5)

local StatusIcon = Instance.new("TextLabel")
StatusIcon.Size = UDim2.new(0, 35, 1, 0)
StatusIcon.BackgroundTransparency = 1
StatusIcon.Text = "⚡"
StatusIcon.TextSize = 18
StatusIcon.Parent = Status

local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.new(1, -90, 0, 18)
StatusText.Position = UDim2.new(0, 38, 0, 6)
StatusText.BackgroundTransparency = 1
StatusText.Text = "Ready"
StatusText.TextColor3 = THEME.Text
StatusText.TextSize = 12
StatusText.Font = Enum.Font.GothamBold
StatusText.TextXAlignment = Enum.TextXAlignment.Left
StatusText.Parent = Status

local StatusSub = Instance.new("TextLabel")
StatusSub.Size = UDim2.new(1, -90, 0, 14)
StatusSub.Position = UDim2.new(0, 38, 0, 22)
StatusSub.BackgroundTransparency = 1
StatusSub.Text = "Select targets"
StatusSub.TextColor3 = THEME.TextDim
StatusSub.TextSize = 10
StatusSub.Font = Enum.Font.Gotham
StatusSub.TextXAlignment = Enum.TextXAlignment.Left
StatusSub.Parent = Status

local StatusCount = Instance.new("TextLabel")
StatusCount.Size = UDim2.new(0, 45, 1, 0)
StatusCount.Position = UDim2.new(1, -48, 0, 0)
StatusCount.BackgroundTransparency = 1
StatusCount.Text = "0/0"
StatusCount.TextColor3 = THEME.Accent1
StatusCount.TextSize = 16
StatusCount.Font = Enum.Font.GothamBold
StatusCount.Parent = Status

-- ============================================================
-- SETTINGS DROPDOWN
-- ============================================================
local SettingsContainer = Instance.new("Frame")
SettingsContainer.Size = UDim2.new(1, -20, 0, 34)
SettingsContainer.Position = UDim2.new(0, 10, 0, 112)
SettingsContainer.BackgroundTransparency = 1
SettingsContainer.ClipsDescendants = false
SettingsContainer.ZIndex = 50
SettingsContainer.Parent = Main

local SettingsFrame = Instance.new("Frame")
SettingsFrame.Size = UDim2.new(1, 0, 0, 34)
SettingsFrame.BackgroundColor3 = THEME.Surface
SettingsFrame.BorderSizePixel = 0
SettingsFrame.ClipsDescendants = true
SettingsFrame.ZIndex = 51
SettingsFrame.Parent = SettingsContainer

Corner(SettingsFrame, 10)
Stroke(SettingsFrame, THEME.Border, 1.5)

local SettingsBtn = Instance.new("TextButton")
SettingsBtn.Size = UDim2.new(1, 0, 0, 34)
SettingsBtn.BackgroundTransparency = 1
SettingsBtn.Text = ""
SettingsBtn.ZIndex = 52
SettingsBtn.Parent = SettingsFrame

local SettingsIcon = Instance.new("TextLabel")
SettingsIcon.Size = UDim2.new(0, 34, 0, 34)
SettingsIcon.BackgroundTransparency = 1
SettingsIcon.Text = "⚙️"
SettingsIcon.TextSize = 15
SettingsIcon.ZIndex = 53
SettingsIcon.Parent = SettingsBtn

local SettingsLabel = Instance.new("TextLabel")
SettingsLabel.Size = UDim2.new(1, -70, 1, 0)
SettingsLabel.Position = UDim2.new(0, 34, 0, 0)
SettingsLabel.BackgroundTransparency = 1
SettingsLabel.Text = string.format("⏱️ %.1fs  •  ⚡ %d", CONFIG.WaitTime, CONFIG.FlingPower)
SettingsLabel.TextColor3 = THEME.Text
SettingsLabel.TextSize = 10
SettingsLabel.Font = Enum.Font.GothamBold
SettingsLabel.TextXAlignment = Enum.TextXAlignment.Left
SettingsLabel.ZIndex = 53
SettingsLabel.Parent = SettingsBtn

local SettingsArrow = Instance.new("TextLabel")
SettingsArrow.Size = UDim2.new(0, 34, 1, 0)
SettingsArrow.Position = UDim2.new(1, -34, 0, 0)
SettingsArrow.BackgroundTransparency = 1
SettingsArrow.Text = "▼"
SettingsArrow.TextColor3 = THEME.Accent2
SettingsArrow.TextSize = 10
SettingsArrow.Font = Enum.Font.GothamBold
SettingsArrow.ZIndex = 53
SettingsArrow.Parent = SettingsBtn

-- Settings content
local SettingsContent = Instance.new("Frame")
SettingsContent.Size = UDim2.new(1, 0, 0, 96)
SettingsContent.Position = UDim2.new(0, 0, 0, 38)
SettingsContent.BackgroundTransparency = 1
SettingsContent.ZIndex = 54
SettingsContent.Parent = SettingsFrame

-- Wait time slider
local WaitBox = Instance.new("Frame")
WaitBox.Size = UDim2.new(1, -14, 0, 40)
WaitBox.Position = UDim2.new(0, 7, 0, 4)
WaitBox.BackgroundColor3 = THEME.BG
WaitBox.BorderSizePixel = 0
WaitBox.ZIndex = 55
WaitBox.Parent = SettingsContent

Corner(WaitBox, 8)

local WaitLabel = Instance.new("TextLabel")
WaitLabel.Size = UDim2.new(1, -45, 0, 18)
WaitLabel.Position = UDim2.new(0, 8, 0, 4)
WaitLabel.BackgroundTransparency = 1
WaitLabel.Text = "⏱️ Wait Time"
WaitLabel.TextColor3 = THEME.Text
WaitLabel.TextSize = 10
WaitLabel.Font = Enum.Font.GothamBold
WaitLabel.TextXAlignment = Enum.TextXAlignment.Left
WaitLabel.ZIndex = 56
WaitLabel.Parent = WaitBox

local WaitValue = Instance.new("TextLabel")
WaitValue.Size = UDim2.new(0, 40, 0, 18)
WaitValue.Position = UDim2.new(1, -44, 0, 4)
WaitValue.BackgroundTransparency = 1
WaitValue.Text = string.format("%.1fs", CONFIG.WaitTime)
WaitValue.TextColor3 = THEME.Accent1
WaitValue.TextSize = 10
WaitValue.Font = Enum.Font.GothamBold
WaitValue.TextXAlignment = Enum.TextXAlignment.Right
WaitValue.ZIndex = 56
WaitValue.Parent = WaitBox

local WaitSlider = Instance.new("Frame")
WaitSlider.Size = UDim2.new(1, -16, 0, 3)
WaitSlider.Position = UDim2.new(0, 8, 0, 28)
WaitSlider.BackgroundColor3 = THEME.Border
WaitSlider.BorderSizePixel = 0
WaitSlider.ZIndex = 56
WaitSlider.Parent = WaitBox

Corner(WaitSlider, 2)

local WaitProgress = Instance.new("Frame")
WaitProgress.Size = UDim2.new(0.1, 0, 1, 0)
WaitProgress.BackgroundColor3 = THEME.Accent1
WaitProgress.BorderSizePixel = 0
WaitProgress.ZIndex = 57
WaitProgress.Parent = WaitSlider

Corner(WaitProgress, 2)

-- Power slider
local PowerBox = Instance.new("Frame")
PowerBox.Size = UDim2.new(1, -14, 0, 40)
PowerBox.Position = UDim2.new(0, 7, 0, 48)
PowerBox.BackgroundColor3 = THEME.BG
PowerBox.BorderSizePixel = 0
PowerBox.ZIndex = 55
PowerBox.Parent = SettingsContent

Corner(PowerBox, 8)

local PowerLabel = Instance.new("TextLabel")
PowerLabel.Size = UDim2.new(1, -50, 0, 18)
PowerLabel.Position = UDim2.new(0, 8, 0, 4)
PowerLabel.BackgroundTransparency = 1
PowerLabel.Text = "⚡ Fling Power"
PowerLabel.TextColor3 = THEME.Text
PowerLabel.TextSize = 10
PowerLabel.Font = Enum.Font.GothamBold
PowerLabel.TextXAlignment = Enum.TextXAlignment.Left
PowerLabel.ZIndex = 56
PowerLabel.Parent = PowerBox

local PowerValue = Instance.new("TextLabel")
PowerValue.Size = UDim2.new(0, 48, 0, 18)
PowerValue.Position = UDim2.new(1, -52, 0, 4)
PowerValue.BackgroundTransparency = 1
PowerValue.Text = tostring(CONFIG.FlingPower)
PowerValue.TextColor3 = THEME.Warning
PowerValue.TextSize = 10
PowerValue.Font = Enum.Font.GothamBold
PowerValue.TextXAlignment = Enum.TextXAlignment.Right
PowerValue.ZIndex = 56
PowerValue.Parent = PowerBox

local PowerSlider = Instance.new("Frame")
PowerSlider.Size = UDim2.new(1, -16, 0, 3)
PowerSlider.Position = UDim2.new(0, 8, 0, 28)
PowerSlider.BackgroundColor3 = THEME.Border
PowerSlider.BorderSizePixel = 0
PowerSlider.ZIndex = 56
PowerSlider.Parent = PowerBox

Corner(PowerSlider, 2)

local PowerProgress = Instance.new("Frame")
PowerProgress.Size = UDim2.new(0.5, 0, 1, 0)
PowerProgress.BackgroundColor3 = THEME.Warning
PowerProgress.BorderSizePixel = 0
PowerProgress.ZIndex = 57
PowerProgress.Parent = PowerSlider

Corner(PowerProgress, 2)

-- Slider interactions
local function MakeSlider(slider, progress, valueLabel, min, max, onChange)
    local dragging = false
    
    local function update(input)
        local relativeX = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
        local value = min + (max - min) * relativeX
        Tween(progress, {Size = UDim2.new(relativeX, 0, 1, 0)}, 0.1)
        onChange(value, relativeX)
    end
    
    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            update(input)
        end
    end)
    
    slider.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            update(input)
        end
    end)
end

MakeSlider(WaitSlider, WaitProgress, WaitValue, 0.1, 5, function(val)
    CONFIG.WaitTime = math.floor(val * 10) / 10
    WaitValue.Text = string.format("%.1fs", CONFIG.WaitTime)
    SettingsLabel.Text = string.format("⏱️ %.1fs  •  ⚡ %d", CONFIG.WaitTime, CONFIG.FlingPower)
end)

MakeSlider(PowerSlider, PowerProgress, PowerValue, 1000, 5000, function(val)
    CONFIG.FlingPower = math.floor(val / 100) * 100
    PowerValue.Text = tostring(CONFIG.FlingPower)
    SettingsLabel.Text = string.format("⏱️ %.1fs  •  ⚡ %d", CONFIG.WaitTime, CONFIG.FlingPower)
end)

-- Toggle settings
SettingsBtn.MouseButton1Click:Connect(function()
    SettingsOpen = not SettingsOpen
    if SettingsOpen then
        Tween(SettingsFrame, {Size = UDim2.new(1, 0, 0, 134)}, 0.3, Enum.EasingStyle.Back)
        Tween(SettingsArrow, {Rotation = 180}, 0.3)
    else
        Tween(SettingsFrame, {Size = UDim2.new(1, 0, 0, 34)}, 0.25)
        Tween(SettingsArrow, {Rotation = 0}, 0.25)
    end
end)

-- ============================================================
-- CONTROL BUTTONS
-- ============================================================
local Controls = Instance.new("Frame")
Controls.Size = UDim2.new(1, -20, 0, 72)
Controls.Position = UDim2.new(0, 10, 0, 154)
Controls.BackgroundTransparency = 1
Controls.Parent = Main

local function Btn(name, icon, text, pos, color)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0.48, 0, 0, 32)
    btn.Position = pos
    btn.BackgroundColor3 = color
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.Parent = Controls
    
    Corner(btn, 8)
    
    local ico = Instance.new("TextLabel")
    ico.Size = UDim2.new(0, 20, 0, 20)
    ico.Position = UDim2.new(0, 6, 0.5, -10)
    ico.BackgroundTransparency = 1
    ico.Text = icon
    ico.TextSize = 14
    ico.Parent = btn
    
    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1, -30, 1, 0)
    txt.Position = UDim2.new(0, 28, 0, 0)
    txt.BackgroundTransparency = 1
    txt.Text = text
    txt.TextColor3 = THEME.Text
    txt.TextSize = 11
    txt.Font = Enum.Font.GothamBold
    txt.TextXAlignment = Enum.TextXAlignment.Left
    txt.Parent = btn
    
    btn.MouseEnter:Connect(function()
        Tween(btn, {BackgroundColor3 = Color3.fromRGB(
            math.min(255, color.R * 255 * 1.2),
            math.min(255, color.G * 255 * 1.2),
            math.min(255, color.B * 255 * 1.2)
        )}, 0.2)
    end)
    
    btn.MouseLeave:Connect(function()
        Tween(btn, {BackgroundColor3 = color}, 0.2)
    end)
    
    return btn
end

local StartBtn = Btn("Start", "▶️", "START", UDim2.new(0, 0, 0, 0), THEME.Success)
local StopBtn = Btn("Stop", "⏹️", "STOP", UDim2.new(0.52, 0, 0, 0), THEME.Danger)
local SelectBtn = Btn("SelectAll", "✅", "ALL", UDim2.new(0, 0, 0, 37), THEME.Accent2)
local ClearBtn = Btn("Clear", "❌", "CLEAR", UDim2.new(0.52, 0, 0, 37), THEME.Warning)

-- ============================================================
-- PLAYER LIST
-- ============================================================
local ListHeader = Instance.new("Frame")
ListHeader.Size = UDim2.new(1, -20, 0, 26)
ListHeader.Position = UDim2.new(0, 10, 0, 234)
ListHeader.BackgroundColor3 = THEME.Surface
ListHeader.BorderSizePixel = 0
ListHeader.Parent = Main

Corner(ListHeader, 8)
Stroke(ListHeader, THEME.Border, 1.5)

local ListIcon = Instance.new("TextLabel")
ListIcon.Size = UDim2.new(0, 26, 1, 0)
ListIcon.BackgroundTransparency = 1
ListIcon.Text = "👥"
ListIcon.TextSize = 14
ListIcon.Parent = ListHeader

local ListTitle = Instance.new("TextLabel")
ListTitle.Size = UDim2.new(1, -60, 1, 0)
ListTitle.Position = UDim2.new(0, 26, 0, 0)
ListTitle.BackgroundTransparency = 1
ListTitle.Text = "PLAYERS"
ListTitle.TextColor3 = THEME.Text
ListTitle.TextSize = 11
ListTitle.Font = Enum.Font.GothamBold
ListTitle.TextXAlignment = Enum.TextXAlignment.Left
ListTitle.Parent = ListHeader

local ListCount = Instance.new("TextLabel")
ListCount.Size = UDim2.new(0, 45, 1, 0)
ListCount.Position = UDim2.new(1, -48, 0, 0)
ListCount.BackgroundTransparency = 1
ListCount.Text = "0/0"
ListCount.TextColor3 = THEME.Accent1
ListCount.TextSize = 11
ListCount.Font = Enum.Font.GothamBold
ListCount.Parent = ListHeader

local PlayerList = Instance.new("ScrollingFrame")
PlayerList.Size = UDim2.new(1, -20, 0, 110)
PlayerList.Position = UDim2.new(0, 10, 0, 265)
PlayerList.BackgroundColor3 = THEME.Surface
PlayerList.BorderSizePixel = 0
PlayerList.ScrollBarThickness = 3
PlayerList.ScrollBarImageColor3 = THEME.Accent1
PlayerList.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerList.Parent = Main

Corner(PlayerList, 12)
Stroke(PlayerList, THEME.Border, 1.5)

local ListLayout = Instance.new("UIListLayout")
ListLayout.SortOrder = Enum.SortOrder.Name
ListLayout.Padding = UDim.new(0, 4)
ListLayout.Parent = PlayerList

local ListPadding = Instance.new("UIPadding")
ListPadding.PaddingTop = UDim.new(0, 6)
ListPadding.PaddingBottom = UDim.new(0, 6)
ListPadding.PaddingLeft = UDim.new(0, 6)
ListPadding.PaddingRight = UDim.new(0, 6)
ListPadding.Parent = PlayerList

-- ============================================================
-- FUNCTIONS
-- ============================================================
local function CountSelected()
    local c = 0
    for _ in pairs(SelectedTargets) do c = c + 1 end
    return c
end

local function UpdateStatus()
    local sel = CountSelected()
    local total = #Players:GetPlayers() - 1
    
    ListCount.Text = string.format("%d/%d", sel, total)
    StatusCount.Text = string.format("%d/%d", sel, total)
    
    if FlingActive then
        StatusIcon.Text = "🔥"
        StatusText.Text = "FLINGING"
        StatusSub.Text = string.format("%d targets active", sel)
        Tween(StatusText, {TextColor3 = THEME.Danger}, 0.3)
    else
        if sel > 0 then
            StatusIcon.Text = "⚡"
            StatusText.Text = "READY"
            StatusSub.Text = string.format("%d selected", sel)
            Tween(StatusText, {TextColor3 = THEME.Success}, 0.3)
        else
            StatusIcon.Text = "💤"
            StatusText.Text = "WAITING"
            StatusSub.Text = "Select targets"
            Tween(StatusText, {TextColor3 = THEME.Text}, 0.3)
        end
    end
end

local function RefreshList()
    for _, child in pairs(PlayerList:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    PlayerCheckboxes = {}
    
    local players = Players:GetPlayers()
    table.sort(players, function(a, b) return a.Name:lower() < b.Name:lower() end)
    
    for _, p in ipairs(players) do
        if p ~= Player then
            local entry = Instance.new("Frame")
            entry.Size = UDim2.new(1, -8, 0, 28)
            entry.BackgroundColor3 = THEME.BG
            entry.BorderSizePixel = 0
            entry.Parent = PlayerList
            
            Corner(entry, 7)
            
            local check = Instance.new("Frame")
            check.Size = UDim2.new(0, 18, 0, 18)
            check.Position = UDim2.new(0, 5, 0.5, -9)
            check.BackgroundColor3 = THEME.Border
            check.BorderSizePixel = 0
            check.Parent = entry
            
            Corner(check, 4)
            
            local mark = Instance.new("TextLabel")
            mark.Size = UDim2.new(1, 0, 1, 0)
            mark.BackgroundTransparency = 1
            mark.Text = "✓"
            mark.TextColor3 = THEME.Success
            mark.TextSize = 13
            mark.Font = Enum.Font.GothamBold
            mark.Visible = SelectedTargets[p.Name] ~= nil
            mark.Parent = check
            
            -- MODIFIED: Display Name + Username
            local name = Instance.new("TextLabel")
            name.Size = UDim2.new(1, -32, 1, 0)
            name.Position = UDim2.new(0, 28, 0, 0)
            name.BackgroundTransparency = 1
            name.Text = p.DisplayName .. " (@" .. p.Name .. ")"
            name.TextColor3 = THEME.Text
            name.TextSize = 11
            name.Font = Enum.Font.GothamBold
            name.TextXAlignment = Enum.TextXAlignment.Left
            name.TextTruncate = Enum.TextTruncate.AtEnd
            name.Parent = entry
            
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 1, 0)
            btn.BackgroundTransparency = 1
            btn.Text = ""
            btn.ZIndex = 2
            btn.Parent = entry
            
            btn.MouseEnter:Connect(function()
                Tween(entry, {BackgroundColor3 = THEME.Surface}, 0.2)
            end)
            
            btn.MouseLeave:Connect(function()
                Tween(entry, {BackgroundColor3 = THEME.BG}, 0.2)
            end)
            
            btn.MouseButton1Click:Connect(function()
                if SelectedTargets[p.Name] then
                    SelectedTargets[p.Name] = nil
                    mark.Visible = false
                    Tween(check, {BackgroundColor3 = THEME.Border}, 0.2)
                else
                    SelectedTargets[p.Name] = p
                    mark.Visible = true
                    Tween(check, {BackgroundColor3 = THEME.Success}, 0.2)
                end
                UpdateStatus()
            end)
            
            PlayerCheckboxes[p.Name] = {
                Entry = entry,
                Check = check,
                Mark = mark
            }
        end
    end
    
    PlayerList.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 12)
    UpdateStatus()
end

local function ToggleAll(select)
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= Player then
            local data = PlayerCheckboxes[p.Name]
            if data then
                if select then
                    SelectedTargets[p.Name] = p
                    data.Mark.Visible = true
                    Tween(data.Check, {BackgroundColor3 = THEME.Success}, 0.2)
                else
                    SelectedTargets[p.Name] = nil
                    data.Mark.Visible = false
                    Tween(data.Check, {BackgroundColor3 = THEME.Border}, 0.2)
                end
            end
        end
    end
    UpdateStatus()
end

-- ============================================================
-- FLING
-- ============================================================
local function Fling(target)
    local char = Player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = hum and hum.RootPart
    local tchar = target.Character
    if not tchar then return end
    
    local thum = tchar:FindFirstChildOfClass("Humanoid")
    local troot = thum and thum.RootPart
    local thead = tchar:FindFirstChild("Head")
    local acc = tchar:FindFirstChildOfClass("Accessory")
    local handle = acc and acc:FindFirstChild("Handle")
    
    if char and hum and root then
        if root.Velocity.Magnitude < 50 then
            getgenv().OldPos = root.CFrame
        end
        
        if thum and thum.Sit then return end
        
        if thead then
            workspace.CurrentCamera.CameraSubject = thead
        elseif handle then
            workspace.CurrentCamera.CameraSubject = handle
        elseif thum and troot then
            workspace.CurrentCamera.CameraSubject = thum
        end
        
        if not tchar:FindFirstChildWhichIsA("BasePart") then return end
        
        local FPos = function(part, pos, ang)
            root.CFrame = CFrame.new(part.Position) * pos * ang
            char:SetPrimaryPartCFrame(CFrame.new(part.Position) * pos * ang)
            root.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
            root.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
        end
        
        local SFBase = function(part)
            local time = 2
            local t = tick()
            local ang = 0
            repeat
                if root and thum then
                    if part.Velocity.Magnitude < 50 then
                        ang = ang + 100
                        FPos(part, CFrame.new(0, 1.5, 0) + thum.MoveDirection * part.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(ang), 0, 0))
                        task.wait()
                        FPos(part, CFrame.new(0, -1.5, 0) + thum.MoveDirection * part.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(ang), 0, 0))
                        task.wait()
                        FPos(part, CFrame.new(0, 1.5, 0) + thum.MoveDirection * part.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(ang), 0, 0))
                        task.wait()
                        FPos(part, CFrame.new(0, -1.5, 0) + thum.MoveDirection * part.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(ang), 0, 0))
                        task.wait()
                        FPos(part, CFrame.new(0, 1.5, 0) + thum.MoveDirection, CFrame.Angles(math.rad(ang), 0, 0))
                        task.wait()
                        FPos(part, CFrame.new(0, -1.5, 0) + thum.MoveDirection, CFrame.Angles(math.rad(ang), 0, 0))
                        task.wait()
                    else
                        FPos(part, CFrame.new(0, 1.5, thum.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()
                        FPos(part, CFrame.new(0, -1.5, -thum.WalkSpeed), CFrame.Angles(0, 0, 0))
                        task.wait()
                        FPos(part, CFrame.new(0, 1.5, thum.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()
                        FPos(part, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()
                        FPos(part, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                        task.wait()
                        FPos(part, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()
                        FPos(part, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                        task.wait()
                    end
                end
            until t + time < tick() or not FlingActive
        end
        
        workspace.FallenPartsDestroyHeight = 0/0
        
        local bv = Instance.new("BodyVelocity")
        bv.Parent = root
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        
        hum:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
        
        if troot then
            SFBase(troot)
        elseif thead then
            SFBase(thead)
        elseif handle then
            SFBase(handle)
        end
        
        bv:Destroy()
        hum:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
        workspace.CurrentCamera.CameraSubject = hum
        
        if getgenv().OldPos and CONFIG.ReturnToPosition then
            repeat
                root.CFrame = getgenv().OldPos * CFrame.new(0, 0.5, 0)
                char:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, 0.5, 0))
                hum:ChangeState("GettingUp")
                for _, part in pairs(char:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.Velocity = Vector3.new()
                        part.RotVelocity = Vector3.new()
                    end
                end
                task.wait()
            until (root.Position - getgenv().OldPos.p).Magnitude < 25
            workspace.FallenPartsDestroyHeight = getgenv().FPDH
        end
    end
end

local function StartFling()
    if FlingActive then return end
    
    local count = CountSelected()
    if count == 0 then return end
    
    FlingActive = true
    UpdateStatus()
    
    spawn(function()
        while FlingActive do
            local valid = {}
            
            for name, p in pairs(SelectedTargets) do
                if p and p.Parent then
                    valid[name] = p
                else
                    SelectedTargets[name] = nil
                    local data = PlayerCheckboxes[name]
                    if data then data.Mark.Visible = false end
                end
            end
            
            for _, p in pairs(valid) do
                if FlingActive then
                    Fling(p)
                    wait(CONFIG.WaitTime)
                else
                    break
                end
            end
            
            UpdateStatus()
            wait(0.5)
        end
    end)
end

local function StopFling()
    if not FlingActive then return end
    FlingActive = false
    UpdateStatus()
end

-- ============================================================
-- EVENTS
-- ============================================================
StartBtn.MouseButton1Click:Connect(StartFling)
StopBtn.MouseButton1Click:Connect(StopFling)
SelectBtn.MouseButton1Click:Connect(function() ToggleAll(true) end)
ClearBtn.MouseButton1Click:Connect(function() ToggleAll(false) end)

-- Toggle minimize/maximize
local function ToggleGUI()
    Minimized = not Minimized
    
    if Minimized then
        -- Just hide
        Main.Visible = false
        FloatingBtn.Visible = true
    else
        -- Just show
        FloatingBtn.Visible = false
        Main.Visible = true
    end
end

Toggle.MouseButton1Click:Connect(ToggleGUI)
FloatingBtn.MouseButton1Click:Connect(ToggleGUI)

Players.PlayerAdded:Connect(RefreshList)
Players.PlayerRemoving:Connect(function(p)
    if SelectedTargets[p.Name] then
        SelectedTargets[p.Name] = nil
    end
    RefreshList()
    UpdateStatus()
end)

-- ============================================================
-- INIT
-- ============================================================
RefreshList()
UpdateStatus()

Main.Size = UDim2.new(0, 0, 0, 0)
Tween(Main, {Size = UDim2.new(0, 280, 0, 380)}, 0.5, Enum.EasingStyle.Back)
