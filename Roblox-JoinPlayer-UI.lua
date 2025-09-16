-- LocalScript: StarterGui > ScreenGui
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- GUI หลัก
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "JoinPlayerUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 200)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Join Player"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 22
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Parent = mainFrame

-- ช่องกรอกชื่อ
local playerInput = Instance.new("TextBox")
playerInput.Size = UDim2.new(0.65, 0, 0, 40)
playerInput.Position = UDim2.new(0.05, 0, 0.2, 0)
playerInput.PlaceholderText = "กรอกชื่อผู้เล่น..."
playerInput.Text = ""
playerInput.TextSize = 20
playerInput.Font = Enum.Font.SourceSans
playerInput.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
playerInput.TextColor3 = Color3.fromRGB(255, 255, 255)
playerInput.Parent = mainFrame

-- ปุ่ม Join
local joinButton = Instance.new("TextButton")
joinButton.Size = UDim2.new(0.4, -10, 0, 40)
joinButton.Position = UDim2.new(0.05, 0, 0.75, 0)
joinButton.Text = "Join"
joinButton.Font = Enum.Font.SourceSansBold
joinButton.TextSize = 20
joinButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
joinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
joinButton.Parent = mainFrame

-- ปุ่ม Share
local shareButton = Instance.new("TextButton")
shareButton.Size = UDim2.new(0.4, -10, 0, 40)
shareButton.Position = UDim2.new(0.55, 0, 0.75, 0)
shareButton.Text = "Share"
shareButton.Font = Enum.Font.SourceSansBold
shareButton.TextSize = 20
shareButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
shareButton.TextColor3 = Color3.fromRGB(255, 255, 255)
shareButton.Parent = mainFrame

-- Label แสดงชื่อเกม
local gameNameLabel = Instance.new("TextLabel")
gameNameLabel.Size = UDim2.new(1, -20, 0, 30)
gameNameLabel.Position = UDim2.new(0.05, 0, 0.45, 0)
gameNameLabel.BackgroundTransparency = 1
gameNameLabel.Text = "ชื่อเกม: -"
gameNameLabel.Font = Enum.Font.SourceSans
gameNameLabel.TextSize = 18
gameNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
gameNameLabel.TextXAlignment = Enum.TextXAlignment.Left
gameNameLabel.Parent = mainFrame

-- Label สถานะ
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 30)
statusLabel.Position = UDim2.new(0.05, 0, 0.6, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "⚠ ยังไม่ได้เช็คผู้เล่น"
statusLabel.Font = Enum.Font.SourceSans
statusLabel.TextSize = 18
statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = mainFrame

-------------------------------------------------------
-- 🌟 ระบบจำลอง (Mock Data)
-------------------------------------------------------
local function mockCheckPlayer(username)
    if username == "" then
        return nil, "⚠ กรุณากรอกชื่อผู้เล่น"
    end

    -- สมมติว่าถ้าใส่ "Farhan" = อยู่ในเกมเดียวกัน
    if username == "Farhan" then
        return "My Test Game", "✅ ผู้เล่นอยู่ในเกมเดียวกัน"
    else
        return "Other Game", "⚠ ผู้เล่นไม่อยู่ในเกมเดียวกัน"
    end
end

-- Event กดปุ่ม Join
joinButton.MouseButton1Click:Connect(function()
    local username = playerInput.Text
    local gameName, status = mockCheckPlayer(username)

    if gameName then
        gameNameLabel.Text = "ชื่อเกม: " .. gameName
        statusLabel.Text = status
    else
        gameNameLabel.Text = "ชื่อเกม: -"
        statusLabel.Text = status
    end
end)

-- Event กดปุ่ม Share (ตัวอย่าง)
shareButton.MouseButton1Click:Connect(function()
    statusLabel.Text = "📢 แชร์ชื่อผู้เล่น: " .. (playerInput.Text ~= "" and playerInput.Text or "ไม่มี")
end)
