-- Required Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local Backpack = LocalPlayer:WaitForChild("Backpack")
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Configuration
local Config = {}
Config['Farm Fish'] = true

local function AutoFish()
    local RodName = ReplicatedStorage.playerstats[LocalPlayer.Name].Stats.rod.Value
	while Config['Farm Fish'] and task.wait() do
		LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(-3524.8, 132.5, 543.2)
        if game:GetService("Players").LocalPlayer.PlayerGui.hud.safezone.worldstatuses["3_cycle"].label.Text == "Day" then
            local TotemName = "Sundial Totem"
            if Backpack:FindFirstChild(RodName) then
                LocalPlayer.Character.Humanoid:EquipTool(Backpack:FindFirstChild(TotemName))
            end
            wait(0.1)
            game:GetService("VirtualUser"):Button1Down(Vector2.new(1, 1))
            game:GetService("VirtualUser"):Button1Up(Vector2.new(1, 1))
            wait(5)
            local TotemName1 = "Aurora Totem"
            if Backpack:FindFirstChild(RodName) then
                LocalPlayer.Character.Humanoid:EquipTool(Backpack:FindFirstChild(TotemName1))
            end
            wait(0.1)
            game:GetService("VirtualUser"):Button1Down(Vector2.new(1, 1))
            game:GetService("VirtualUser"):Button1Up(Vector2.new(1, 1))
        end
		if Backpack:FindFirstChild(RodName) then
			LocalPlayer.Character.Humanoid:EquipTool(Backpack:FindFirstChild(RodName))
		end
		if LocalPlayer.Character:FindFirstChild(RodName) and LocalPlayer.Character:FindFirstChild(RodName):FindFirstChild("bobber") then
			local XyzClone = game:GetService("ReplicatedStorage").resources.items.items.GPS.GPS.gpsMain.xyz:Clone()
			XyzClone.Parent = game.Players.LocalPlayer.PlayerGui:WaitForChild("hud"):WaitForChild("safezone"):WaitForChild("backpack")
			XyzClone.Name = "Lure"
			XyzClone.Text = "<font color='#ff4949'>Lure </font>: 0%"
			repeat
				pcall(function()
					PlayerGui:FindFirstChild("shakeui").safezone:FindFirstChild("button").Size = UDim2.new(1001, 0, 1001, 0)
					game:GetService("VirtualUser"):Button1Down(Vector2.new(1, 1))
					game:GetService("VirtualUser"):Button1Up(Vector2.new(1, 1))
				end)
				XyzClone.Text = "<font color='#ff4949'>Lure </font>: "..tostring(ExportValue(tostring(LocalPlayer.Character:FindFirstChild(RodName).values.lure.Value), 2)).."%"
				RunService.Heartbeat:Wait()
			until not LocalPlayer.Character:FindFirstChild(RodName) or LocalPlayer.Character:FindFirstChild(RodName).values.bite.Value or not Config['Farm Fish']
			XyzClone.Text = "<font color='#ff4949'>FISHING!</font>"
			delay(1.5, function()
				XyzClone:Destroy()
			end)
			repeat
				ReplicatedStorage.events.reelfinished:FireServer(1000000000000000000000000, true)
				task.wait(.5)
			until not LocalPlayer.Character:FindFirstChild(RodName) or not LocalPlayer.Character:FindFirstChild(RodName).values.bite.Value or not Config['Farm Fish']
		else
			LocalPlayer.Character:FindFirstChild(RodName).events.cast:FireServer(1000000000000000000000000)
			task.wait(2)
		end
	end
end

-- Run AutoFish
task.spawn(AutoFish)
