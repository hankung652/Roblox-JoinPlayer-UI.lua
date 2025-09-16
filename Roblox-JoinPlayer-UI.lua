-- LocalScript (StarterGui > ScreenGui)
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer

-- UI Object (สมมติว่ามี TextBox ชื่อ PlayerInput, TextLabel ชื่อ GameNameLabel, TextLabel ชื่อ StatusLabel, ปุ่ม Join)
local screenGui = script.Parent
local playerInput = screenGui:WaitForChild("PlayerInput")
local gameNameLabel = screenGui:WaitForChild("GameNameLabel")
local statusLabel = screenGui:WaitForChild("StatusLabel")
local joinButton = screenGui:WaitForChild("JoinButton")

-- ฟังก์ชันดึงข้อมูล Game ของผู้เล่น
local function getPlayerGame(username)
    local success, result = pcall(function()
        local userId = HttpService:JSONDecode(
            game:HttpGet("https://api.roblox.com/users/get-by-username?username="..username)
        ).Id

        if not userId then return nil end

        local presence = HttpService:JSONDecode(
            game:HttpGet("https://presence.roblox.com/v1/presence/users", true, {
                users = {userId}
            })
        )

        return presence
    end)

    if success and result then
        return result
    else
        return nil
    end
end

-- ปุ่ม Join
joinButton.MouseButton1Click:Connect(function()
    local username = playerInput.Text
    if username == "" then return end

    statusLabel.Text = "⏳ กำลังเช็คผู้เล่น..."
    local data = getPlayerGame(username)

    if not data or not data.userPresences or #data.userPresences == 0 then
        statusLabel.Text = "⚠ ไม่พบผู้เล่น"
        return
    end

    local presence = data.userPresences[1]
    if presence.placeId and presence.rootPlaceId then
        if presence.rootPlaceId == game.PlaceId then
            gameNameLabel.Text = "ชื่อเกม: ".. game:GetService("MarketplaceService"):GetProductInfo(presence.rootPlaceId).Name
            statusLabel.Text = "✅ ผู้เล่นอยู่ในเกมเดียวกัน"
        else
            gameNameLabel.Text = "ชื่อเกม: ".. game:GetService("MarketplaceService"):GetProductInfo(presence.rootPlaceId).Name
            statusLabel.Text = "⚠ ผู้เล่นไม่อยู่ในเกมเดียวกัน"
        end
    else
        statusLabel.Text = "⚠ ผู้เล่นไม่ได้อยู่ในเกม"
    end
end)
