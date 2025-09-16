local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local MarketplaceService = game:GetService("MarketplaceService")
local player = Players.LocalPlayer

-- GUI หลัก
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "JoinPlayerUI"

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 260)
mainFrame.Position = UDim2.new(0.5, -160, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.BackgroundTransparency = 0.3
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 15)

-- รูปผู้เล่น
local playerImage = Instance.new("ImageLabel", mainFrame)
playerImage.Size = UDim2.new(0, 48, 0, 48)
playerImage.Position = UDim2.new(1, -56, 0.05, 0)
playerImage.BackgroundTransparency = 1
Instance.new("UICorner", playerImage).CornerRadius = UDim.new(1,0)

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

-- ฟังก์ชันเช็คผู้เล่น
local function checkPlayer(targetName)
	-- ดึง UserId
	local success, userId = pcall(function()
		return Players:GetUserIdFromNameAsync(targetName)
	end)
	if not success then
		statusLabel.Text = "❌ ไม่พบผู้เล่น"
		playerImage.Image = ""
		return
	end
	
	-- ดึงรูปโปรไฟล์
	local thumbSuccess, thumbUrl = pcall(function()
		return Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
	end)
	if thumbSuccess then
		playerImage.Image = thumbUrl
	else
		playerImage.Image = ""
	end

	-- เช็คว่าผู้เล่นอยู่ในเกมไหน
	local ok, placeId, instanceId = pcall(function()
		return Players:GetPlayerPlaceInstanceAsync(userId)
	end)

	if ok and placeId then
		if placeId == game.PlaceId then
			statusLabel.Text = "✅ ผู้เล่นอยู่ในเกมเดียวกัน"
		else
			local gameInfo = pcall(function()
				return MarketplaceService:GetProductInfo(placeId)
			end)
			if gameInfo then
				statusLabel.Text = "⚠️ ผู้เล่นอยู่ในเกม: " .. gameInfo.Name
			else
				statusLabel.Text = "⚠️ ผู้เล่นอยู่ในเกมอื่น"
			end
		end
	else
		-- ถ้าไม่ได้อยู่ในเกมปัจจุบัน แต่มีอยู่ในเกมอื่น/ออนไลน์
		local online = false
		for _, p in pairs(Players:GetPlayers()) do
			if p.UserId == userId then
				online = true
				break
			end
		end
		if online then
			statusLabel.Text = "⚠️ ผู้เล่นออนไลน์แต่ไม่อยู่ในเกม"
		else
			statusLabel.Text = "⚠️ ผู้เล่นออฟไลน์"
		end
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
		local success, userId = pcall(function()
			return Players:GetUserIdFromNameAsync(nameBox.Text)
		end)
		if success then
			local ok, placeId, instanceId = pcall(function()
				return Players:GetPlayerPlaceInstanceAsync(userId)
			end)
			if ok and placeId then
				TeleportService:TeleportToPlaceInstance(placeId, instanceId, player)
			else
				statusLabel.Text = "❌ ไม่สามารถเข้าร่วมได้"
			end
		end
	end
end)
