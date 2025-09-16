-- LocalScript

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer

-- GUI หลัก
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "JoinUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 150)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 12)
uiCorner.Parent = mainFrame

-- กล่องใส่ชื่อผู้เล่น
local nameBox = Instance.new("TextBox")
nameBox.Size = UDim2.new(0.65, -10, 0, 40)
nameBox.Position = UDim2.new(0.05, 0, 0.2, 0)
nameBox.PlaceholderText = "พิมพ์ชื่อผู้เล่น..."
nameBox.Text = ""
nameBox.TextSize = 18
nameBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
nameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
nameBox.Parent = mainFrame

local nameCorner = Instance.new("UICorner")
nameCorner.CornerRadius = UDim.new(0, 8)
nameCorner.Parent = nameBox

-- Avatar Image (วงกลมข้าง ๆ)
local avatarImage = Instance.new("ImageLabel")
avatarImage.Size = UDim2.new(0, 60, 0, 60)
avatarImage.Position = UDim2.new(0.75, 0, 0.18, 0)
avatarImage.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
avatarImage.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
avatarImage.Parent = mainFrame

local avatarCorner = Instance.new("UICorner")
avatarCorner.CornerRadius = UDim.new(1, 0)
avatarCorner.Parent = avatarImage

-- ปุ่ม Join
local joinButton = Instance.new("TextButton")
joinButton.Size = UDim2.new(0.9, 0, 0, 40)
joinButton.Position = UDim2.new(0.05, 0, 0.7, 0)
joinButton.Text = "Join Game"
joinButton.TextSize = 18
joinButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
joinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
joinButton.Parent = mainFrame

local joinCorner = Instance.new("UICorner")
joinCorner.CornerRadius = UDim.new(0, 8)
joinCorner.Parent = joinButton

-- ป้ายข้อความแจ้งเตือน
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.9, 0, 0, 20)
statusLabel.Position = UDim2.new(0.05, 0, 0.55, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = ""
statusLabel.TextSize = 16
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.Parent = mainFrame

-- ฟังก์ชันอัพเดต Avatar เวลาใส่ชื่อ
local function updateAvatar(username)
	local success, result = pcall(function()
		local userId = Players:GetUserIdFromNameAsync(username)
		if userId then
			local thumb, isReady = Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
			if isReady then
				avatarImage.Image = thumb
			end
		end
	end)

	if not success then
		avatarImage.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
	end
end

-- เวลาเปลี่ยนข้อความในช่อง จะโหลด Avatar
nameBox.FocusLost:Connect(function(enterPressed)
	if nameBox.Text ~= "" then
		updateAvatar(nameBox.Text)
	end
end)

-- ปุ่ม Join กดแล้วลอง Teleport หา player เป้าหมาย
joinButton.MouseButton1Click:Connect(function()
	local username = nameBox.Text
	if username == "" then
		statusLabel.Text = "⚠️ กรุณาใส่ชื่อผู้เล่น"
		return
	end

	local success, result = pcall(function()
		return Players:GetUserIdFromNameAsync(username)
	end)

	if success and result then
		-- เช็กว่า target player อยู่ในเกมไหม (จำลอง)
		local targetPlayer = Players:FindFirstChild(username)
		if targetPlayer then
			statusLabel.Text = "กำลังเข้าร่วมเกมของ " .. username
			-- ถ้าอยาก Teleport จริง ต้องใช้ TeleportService (ใช้ได้เฉพาะใน ServerScript)
			-- TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
		else
			statusLabel.Text = "❌ ผู้เล่นไม่อยู่ในเกมเดียวกัน"
		end
	else
		statusLabel.Text = "❌ ไม่พบผู้เล่นนี้"
	end
end)
