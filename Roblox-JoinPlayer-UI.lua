-- LocalScript (StarterPlayerScripts)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- RemoteEvent สำหรับส่งข้อมูลไป Server
local JoinPlayerEvent = ReplicatedStorage:WaitForChild("JoinPlayerEvent")

-- UI
local player = Players.LocalPlayer
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "JoinPlayerUI"

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0.5, -150, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0

local title = Instance.new("TextLabel", frame)
title.Text = "Join Player"
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 24
title.TextColor3 = Color3.fromRGB(255, 255, 255)

local nameBox = Instance.new("TextBox", frame)
nameBox.PlaceholderText = "กรอกชื่อผู้เล่น..."
nameBox.Size = UDim2.new(1, -20, 0, 40)
nameBox.Position = UDim2.new(0, 10, 0, 50)
nameBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
nameBox.TextColor3 = Color3.fromRGB(255, 255, 255)

local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(1, -20, 0, 30)
status.Position = UDim2.new(0, 10, 0, 100)
status.BackgroundTransparency = 1
status.Font = Enum.Font.SourceSans
status.TextSize = 18
status.TextColor3 = Color3.fromRGB(255, 200, 0)
status.Text = "⚠️ ยังไม่ได้เช็คผู้เล่น"

local joinBtn = Instance.new("TextButton", frame)
joinBtn.Size = UDim2.new(0.45, 0, 0, 40)
joinBtn.Position = UDim2.new(0.05, 0, 1, -50)
joinBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
joinBtn.Text = "Join"
joinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
joinBtn.Font = Enum.Font.SourceSansBold
joinBtn.TextSize = 20

local shareBtn = Instance.new("TextButton", frame)
shareBtn.Size = UDim2.new(0.45, 0, 0, 40)
shareBtn.Position = UDim2.new(0.5, 0, 1, -50)
shareBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
shareBtn.Text = "Share"
shareBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
shareBtn.Font = Enum.Font.SourceSansBold
shareBtn.TextSize = 20

-- เมื่อกดปุ่ม Join
joinBtn.MouseButton1Click:Connect(function()
	if nameBox.Text ~= "" then
		status.Text = "🔍 กำลังเชื่อมต่อ..."
		JoinPlayerEvent:FireServer(nameBox.Text)
	else
		status.Text = "⚠️ กรุณากรอกชื่อผู้เล่น"
	end
end)

-- ฟังข้อความกลับจาก Server
JoinPlayerEvent.OnClientEvent:Connect(function(message)
	status.Text = message
end)
