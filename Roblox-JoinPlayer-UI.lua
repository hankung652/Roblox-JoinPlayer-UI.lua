-- LocalScript (วางใน StarterPlayerScripts)

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- รอให้ PlayerGui โหลด
local playerGui = player:WaitForChild("PlayerGui")

-- สร้าง GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "JoinUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 180)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -90)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 12)
uiCorner.Parent = mainFrame

-- ชื่อผู้เล่น
local nameBox = Instance.new("TextBox")
nameBox.Size = UDim2.new(0.65, -10, 0, 40)
nameBox.Position = UDim2.new(0.05, 0, 0.2, 0)
nameBox.PlaceholderText = "พิมพ์ชื่อผู้เล่น..."
nameBox.TextSize = 18
nameBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
nameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
nameBox.ClearTextOnFocus = false
nameBox.Parent = mainFrame

local nameCorner = Instance.new("UICorner")
nameCorner.CornerRadius = UDim.new(0, 8)
nameCorner.Parent = nameBox

-- Avatar Image
local avatarImage = Instance.new("ImageLabel")
avatarImage.Size = UDim2.new(0, 60, 0, 60)
avatarImage.Position = UDim2.new(0.75, 0, 0.18, 0)
avatarImage.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
avatarImage.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
avatarImage.Parent = mainFrame

local avatarCorner = Instance.new("UICorner")
avatarCorner.CornerRadius = UDim.new(1, 0)
avatarCorner.Parent = avatarImage

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.9, 0, 0, 20)
statusLabel.Position = UDim2.new(0.05, 0, 0.55, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.TextSize = 16
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.TextWrapped = true
statusLabel.Parent = mainFrame

-- Join Button
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

-- ฟังก์ชันอัปเดต Avatar
local function updateAvatar(username)
	coroutine.wrap(function()
		local success, userId = pcall(function()
			return Players:GetUserIdFromNameAsync(username)
		end)
		if success and userId then
			local thumbSuccess, thumb = pcall(function()
				return Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
			end)
			if thumbSuccess and thumb then
				avatarImage.Image = thumb
				statusLabel.Text = "✅ โหลด Avatar สำเร็จ"
			else
				avatarImage.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
				statusLabel.Text = "⚠️ โหลด Avatar ล้มเหลว"
			end
		else
			avatarImage.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
			statusLabel.Text = "❌ ไม่พบผู้เล่นนี้"
		end
	end)()
end

-- โหลด Avatar แบบเรียลไทม์เมื่อพิมพ์
nameBox:GetPropertyChangedSignal("Text"):Connect(function()
	if nameBox.Text ~= "" then
		updateAvatar(nameBox.Text)
	end
end)

-- ปุ่ม Join
joinButton.MouseButton1Click:Connect(function()
	local username = nameBox.Text
	if username == "" then
		statusLabel.Text = "⚠️ กรุณาใส่ชื่อผู้เล่น"
		return
	end

	local success, userId = pcall(function()
		return Players:GetUserIdFromNameAsync(username)
	end)

	if success and userId then
		local targetPlayer = Players:FindFirstChild(username)
		if targetPlayer then
			statusLabel.Text = "กำลังเข้าร่วมเกมของ " .. username .. " (จำลอง)"
		else
			statusLabel.Text = "❌ ผู้เล่นไม่อยู่ในเกมเดียวกัน"
		end
	else
		statusLabel.Text = "❌ ไม่พบผู้เล่นนี้"
	end
end)
