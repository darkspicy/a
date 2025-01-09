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

-- Notify Function (Optional)
local function Notify(Description)
    print("[Auto Fish] " .. Description)
end

-- Main Fishing Function
local function AutoFish()
    local RodName = ReplicatedStorage.playerstats[LocalPlayer.Name].Stats.rod.Value
    Notify("Starting Auto-Fishing...")

    while Config['Farm Fish'] and task.wait() do
        -- Teleport to fishing area
        LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(-3524.8, 132.5, 543.2)

        -- Handle totem usage during the day
        local WorldStatuses = PlayerGui.hud.safezone.worldstatuses["3_cycle"].label
        if WorldStatuses.Text == "Day" then
            local TotemNames = { "Sundial Totem", "Aurora Totem" }
            for _, TotemName in ipairs(TotemNames) do
                if Backpack:FindFirstChild(TotemName) then
                    LocalPlayer.Character:FindFirstChild("Humanoid"):EquipTool(Backpack:FindFirstChild(TotemName))
                    task.wait(0.1)
                    VirtualUser:Button1Down(Vector2.new(1, 1))
                    VirtualUser:Button1Up(Vector2.new(1, 1))
                    task.wait(5)
                end
            end
        end

        -- Equip the fishing rod
        if Backpack:FindFirstChild(RodName) then
            LocalPlayer.Character:FindFirstChild("Humanoid"):EquipTool(Backpack:FindFirstChild(RodName))
        end

        -- Cast and handle fishing process
        if LocalPlayer.Character:FindFirstChild(RodName) and LocalPlayer.Character[RodName]:FindFirstChild("bobber") then
            -- Add lure progress UI
            local LureUI = ReplicatedStorage.resources.items.items.GPS.GPS.gpsMain.xyz:Clone()
            LureUI.Parent = PlayerGui.hud.safezone.backpack
            LureUI.Name = "Lure"
            LureUI.Text = "<font color='#ff4949'>Lure </font>: 0%"

            Notify("Casting...")
            repeat
                pcall(function()
                    PlayerGui.shakeui.safezone.button.Size = UDim2.new(1001, 0, 1001, 0)
                    VirtualUser:Button1Down(Vector2.new(0, 0))
                    VirtualUser:Button1Up(Vector2.new(0, 0))
                end)
                LureUI.Text = "<font color='#ff4949'>Lure </font>: " ..
                    tostring(LocalPlayer.Character[RodName].values.lure.Value) .. "%"
                RunService.Heartbeat:Wait()
            until not Config['Farm Fish'] or LocalPlayer.Character[RodName].values.bite.Value

            -- Update UI for fishing
            LureUI.Text = "<font color='#ff4949'>FISHING!</font>"
            delay(1.5, function()
                LureUI:Destroy()
            end)

            -- Reel in the fish
            Notify("Reeling in fish...")
            repeat
                ReplicatedStorage.events.reelfinished:FireServer(100, true)
                task.wait(0.5)
            until not Config['Farm Fish'] or not LocalPlayer.Character[RodName].values.bite.Value
        else
            -- Recast if the rod is not properly equipped
            Notify("Recasting...")
            ReplicatedStorage.events.cast:FireServer(100)
            task.wait(2)
        end
    end

    Notify("Auto-Fishing Stopped.")
end

-- Run AutoFish
task.spawn(AutoFish)
