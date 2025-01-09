AllFuncs['Farm Fish'] = function()
    local RodName = ReplicatedStorage:WaitForChild("playerstats")[LocalPlayer.Name].Stats.rod.Value
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    local RunService = game:GetService("RunService")
    local VirtualUser = game:GetService("VirtualUser")
    local Backpack = LocalPlayer:WaitForChild("Backpack")

    while true do -- Infinite loop
        task.wait() -- Prevents script freezing by adding a slight delay

        -- Move to fishing position
        if LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-3524.8, 132.5, 543.2)
        end

        -- Check for daytime fishing logic
        local StatusLabel = PlayerGui:FindFirstChild("hud") and PlayerGui.hud.safezone.worldstatuses:FindFirstChild("3_cycle") and PlayerGui.hud.safezone.worldstatuses["3_cycle"].label
        if StatusLabel and StatusLabel.Text == "Day" then
            -- Use "Sundial Totem"
            local SundialTotem = Backpack:FindFirstChild("Sundial Totem")
            if SundialTotem then
                LocalPlayer.Character.Humanoid:EquipTool(SundialTotem)
                task.wait(0.1)
                VirtualUser:Button1Down(Vector2.new(1, 1))
                VirtualUser:Button1Up(Vector2.new(1, 1))
                task.wait(5)
            end

            -- Use "Aurora Totem"
            local AuroraTotem = Backpack:FindFirstChild("Aurora Totem")
            if AuroraTotem then
                LocalPlayer.Character.Humanoid:EquipTool(AuroraTotem)
                task.wait(0.1)
                VirtualUser:Button1Down(Vector2.new(1, 1))
                VirtualUser:Button1Up(Vector2.new(1, 1))
            end
        end

        -- Equip fishing rod
        local RodInBackpack = Backpack:FindFirstChild(RodName)
        if RodInBackpack then
            LocalPlayer.Character.Humanoid:EquipTool(RodInBackpack)
        end

        -- Check if fishing rod is equipped and has a bobber
        local RodEquipped = LocalPlayer.Character:FindFirstChild(RodName)
        if RodEquipped and RodEquipped:FindFirstChild("bobber") then
            -- Create Lure UI
            local XyzClone = game:GetService("ReplicatedStorage").resources.items.items.GPS.GPS.gpsMain.xyz:Clone()
            local Safezone = PlayerGui:WaitForChild("hud"):WaitForChild("safezone")
            XyzClone.Parent = Safezone:WaitForChild("backpack")
            XyzClone.Name = "Lure"
            XyzClone.Text = "<font color='#ff4949'>Lure </font>: 0%"

            repeat
                pcall(function()
                    local Button = PlayerGui:FindFirstChild("shakeui") and PlayerGui.shakeui.safezone:FindFirstChild("button")
                    if Button then
                        Button.Size = UDim2.new(1001, 0, 1001, 0)
                        VirtualUser:Button1Down(Vector2.new(1, 1))
                        VirtualUser:Button1Up(Vector2.new(1, 1))
                    end
                end)

                local LureValue = RodEquipped.values.lure.Value
                XyzClone.Text = string.format("<font color='#ff4949'>Lure </font>: %d%%", LureValue)
                RunService.Heartbeat:Wait()
            until not RodEquipped or RodEquipped.values.bite.Value

            -- Update Lure UI to indicate fishing
            XyzClone.Text = "<font color='#ff4949'>FISHING!</font>"
            delay(1.5, function()
                XyzClone:Destroy()
            end)

            -- Reel in the fish
            repeat
                ReplicatedStorage.events.reelfinished:FireServer(1000000000000000000000000, true)
                task.wait(0.5)
            until not RodEquipped or not RodEquipped.values.bite.Value
        else
            -- Cast the rod if it's equipped but not actively fishing
            if RodEquipped and RodEquipped:FindFirstChild("events") then
                RodEquipped.events.cast:FireServer(1000000000000000000000000)
            end
            task.wait(2)
        end
    end
end
