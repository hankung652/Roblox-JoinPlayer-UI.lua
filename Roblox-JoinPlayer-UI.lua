-- Roblox-JoinPlayer-UI.lua
-- LocalScript วางใน StarterGui

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer

-- สร้าง ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "JoinPlayerUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

-- 🔹 กล่องใส่ชื่อผู้เล่น
local nameBox = Instance.new("TextBox")
nameBox.Size = UDim2.new(0, 250, 0, 40)
nameBox.Position = UDim2.new(0.05, 0, 0.05, 0)
nameBox.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
nameBox.Text = ""
nameBox.PlaceholderText = "ชื่อผู้ใช้ที่เราจะจอยเข้าไป"
nameBox.TextScaled = true
nameBox.Parent = screenGui

-- 🔹 ชื่อเกมที่เราเล่นอยู่
local gameNameLabel = Instance.new("TextLabel")
gameNameLabel.Size = UDim2.new(0, 250, 0, 50)
gameNameLabel.Position = UDim2.new(0.05, 0, 0.15, 0)
gameNameLabel.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
gameNameLabel.Text = "ชื่อเกม: " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
gameNameLabel.TextScaled = true
gameNameLabel.Parent = screenGui

-- 🔹 วงกลมแสดงโปรไฟล์
local profileImage = Instance.new("ImageLabel")
profileImage.Size = UDim2.new(0, 120, 0, 120)
profileImage.Position = UDim2.new(0.55, 0, 0.05, 0)
profileImage.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
profileImage.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
profileImage.Parent = screenGui

-- ทำให้เป็นวงกลม
local uicorner = Instance.new("UICorner", profileImage)
uicorner.CornerRadius = UDim.new(1, 0)

-- 🔹 ปุ่ม Join (ปุ่มเล็ก)
local joinButton = Instance.new("TextButton")
joinButton.Size = UDim2.new(0, 120, 0, 40)
joinButton.Position = UDim2.new(0.55, 0, 0.25, 0)
joinButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
joinButton.Text = "Join"
joinButton.TextScaled = true
joinButton.Parent = screenGui

-- 🔹 ปุ่ม Share
local shareButton = Instance.new("TextButton")
shareButton.Size = UDim2.new(0, 120, 0, 40)
shareButton.Position = UDim2.new(0.55, 0, 0.35, 0)
shareButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
shareButton.Text = "แชร์"
shareButton.TextScaled = true
shareButton.Parent = screenGui

-- 🔹 แสดงสถานะ
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0, 300, 0, 40)
statusLabel.Position = UDim2.new(0.05, 0, 0.3, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "รอกรอกชื่อ..."
statusLabel.TextScaled = true
statusLabel.TextColor3 = Color3.new(1,1,1)
statusLabel.Parent = screenGui

-- ✅ ฟังก์ชัน Join
joinButton.MouseButton1Click:Connect(function()
	local targetName = nameBox.Text
	if targetName == "" then
		statusLabel.Text = "⚠️ กรุณากรอกชื่อผู้เล่น"
		return
	end

	statusLabel.Text = "🔎 กำลังค้นหา " .. targetName .. "..."

	local success, userId = pcall(function()
		return Players:GetUserIdFromNameAsync(targetName)
	end)

	if not success then
		statusLabel.Text = "❌ ไม่พบผู้เล่น"
		return
	end

	-- โหลดรูปโปรไฟล์
	local thumbType = Enum.ThumbnailType.HeadShot
	local thumbSize = Enum.ThumbnailSize.Size100x100
	local content = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)
	profileImage.Image = content

	-- หาผู้เล่นที่อยู่ในแมพเดียวกัน
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr.UserId == userId then
			local placeId = game.PlaceId
			local jobId = game.JobId
			if jobId and jobId ~= "" then
				statusLabel.Text = "✅ กำลังเข้าเซิฟเวอร์..."
				TeleportService:TeleportToPlaceInstance(placeId, jobId, player)
				return
			end
		end
	end

	statusLabel.Text = "⚠️ ผู้เล่นไม่อยู่ในเกมเดียวกัน"
end)

-- ปุ่ม Share (สามารถเพิ่มระบบ Copy ลิงก์ ได้)
shareButton.MouseButton1Click:Connect(function()
	setclipboard("roblox://placeId=" .. game.PlaceId)
	statusLabel.Text = "📋 คัดลอกลิงก์เกมแล้ว"
end)
