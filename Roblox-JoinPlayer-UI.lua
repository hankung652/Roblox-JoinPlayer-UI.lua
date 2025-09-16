local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local MarketplaceService = game:GetService("MarketplaceService")
local player = Players.LocalPlayer

-- GUI หลัก
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "JoinPlayerUI"

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 220)
mainFrame.Position = UDim2.new(0.5, -160, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.BackgroundTransparency = 0.3
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 15)

-- กล่องกรอกชื่อ
local nameBox = Instance.new("TextBox", mainFrame)
nameBox.Size = UDim2.new(0, 280, 0, 40)
nameBox.Position = UDim2.new(0.5, -140, 0.05, 0)
nameBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
nameBox.PlaceholderText = "กรอกชื่อผู้เล่น..."
nameBox.Text = ""
nameBox.TextScaled = true
nameBox.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", nameBox).CornerRadius = UDim.new(0, 10)

-- ชื่อเกมปัจจุบันเรา
local gameLabel = Instance.new("TextLabel", mainFrame)
gameLabel.Size = UDim2.new(0, 280, 0, 30)
gameLabel.Position = UDim2.new(0.5, -140, 0.3, 0)
gameLabel.BackgroundTransparency = 1
gameLabel.TextScaled = true
gameLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
gameLabel.Text = "ชื่อเกม: ..."
local success, info = pcall(function()
	return MarketplaceService:GetProductInfo(game.PlaceId)
end)
if success then
	gameLabel.Text = "ชื่อเกม: " .. info.Name
end

-- Label แสดงสถานะผู้เล่น
local statusLabel = Instance.new("TextLabel", mainFrame)
statusLabel.Size = UDim2.new(0, 280, 0, 30)
statusLabel.Position = UDim2.new(0.5, -140, 0.55, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.TextScaled = true
statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
statusLabel.Text = "⚠️ ยังไม่ได้เช็คผู้เล่น"

-- ปุ่ม Join
local joinButton = Instance.new("TextButton", mainFrame)
joinButton.Size = UDim2.new(0, 100, 0, 40)
joinButton.Position = UDim2.new(0.25, -50, 0.85, -20)
joinButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
joinButton.Text = "Join"
joinButton.TextScaled = true
joinButton.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", joinButton).CornerRadius = UDim.new(0, 10)

-- ปุ่ม Share
local shareButton = Instance.new("TextButton", mainFrame)
shareButton.Size = UDim2.new(0, 100, 0, 40)
shareButton.Position = UDim2.new(0.75, -50, 0.85, -20)
shareButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
shareButton.Text = "Share"
shareButton.TextScaled = true
shareButton.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", shareButton).CornerRadius = UDim.new(0, 10)

-- ฟังก์ชันเช็คผู้เล่น
local function checkPlayer(targetName)
	local success, userId = pcall(function()
		return Players:GetUserIdFromNameAsync(targetName)
	end)
	if not success then
		statusLabel.Text = "❌ ไม่พบผู้เล่น"
		return
	end

	local ok, placeId, instanceId = pcall(function()
		return Players:GetPlayerPlaceInstanceAsync(userId)
	end)

	if ok and placeId then
		if placeId == game.PlaceId then
			statusLabel.Text = "✅ ผู้เล่นอยู่ในเกมเดียวกัน"
		else
			local info = MarketplaceService:GetProductInfo(placeId)
			statusLabel.Text = "⚠️ ผู้เล่นอยู่ในเกม: " .. info.Name
		end
	else
		statusLabel.Text = "⚠️ ผู้เล่นไม่ออนไลน์"
	end
end

-- เมื่อกรอกชื่อเสร็จ กด Enter เช็ค
nameBox.FocusLost:Connect(function(enterPressed)
	if enterPressed and nameBox.Text ~= "" then
		checkPlayer(nameBox.Text)
	end
end)

-- ปุ่ม Join
joinButton.MouseButton1Click:Connect(function()
	if nameBox.Text ~= "" then
		checkPlayer(nameBox.Text)
		-- ถ้าอยู่ในเกมเดียวกันค่อย join
		local success, userId = pcall(function()
			return Players:GetUserIdFromNameAsync(nameBox.Text)
		end)
		if success then
			local ok, placeId, instanceId = pcall(function()
				return Players:GetPlayerPlaceInstanceAsync(userId)
			end)
			if ok and placeId then
				TeleportService:TeleportToPlaceInstance(placeId, instanceId, player)
			end
		end
	end
end)
