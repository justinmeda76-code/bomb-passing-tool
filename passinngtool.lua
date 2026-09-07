local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- CONFIGURATION
local MAIN_ACCOUNT_NAME = "chillguyyy000" -- Put your main account's exact username here
local SAFE_DISTANCE = Vector3.new(0, 12, -5) -- Keeps the alt 12 studs above and 5 studs behind the main account

-- Function to safely grab the bomb item if it is dropped/stuck in the map
local function autoGrabBomb()
    local character = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    
    if character and backpack then
        -- Check if you already have the bomb equipped or in your backpack
        local hasBomb = character:FindFirstChild("Bomb") or backpack:FindFirstChild("Bomb")
        
        if not hasBomb then
            -- Search the map workspace for the bomb object
            for _, item in ipairs(workspace:GetChildren()) do
                -- Adjust "Bomb" if the game calls the item something else (e.g., "TimeBomb")
                if item:IsA("Tool") and (item.Name == "Bomb" or item:FindFirstChild("TouchTransmitter")) then
                    -- Bring the bomb directly into your backpack
                    item.Parent = backpack
                    break
                end
            end
        end
    end
end

-- Function to position the alt account safely near the main account
local function safeTeleportAndSpin(character)
    local root = character:WaitForChild("HumanoidRootPart", 5)
    if not root then return end
    
    local connection
    connection = RunService.Heartbeat:Connect(function()
        if not root or not root.Parent then 
            connection:Disconnect()
            return 
        end
        
        -- Find your main account in the server
        local mainPlayer = Players:FindFirstChild(MAIN_ACCOUNT_NAME)
        if mainPlayer and mainPlayer.Character and mainPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local mainRoot = mainPlayer.Character.HumanoidRootPart
            
            -- Keep the alt at a safe distance and spin it to farm the ankle breaks
            local targetCFrame = mainRoot.CFrame * CFrame.new(SAFE_DISTANCE)
            root.CFrame = targetCFrame * CFrame.Angles(0, math.rad(20), 0)
            
            -- Automatically try to grab the bomb item while teleported
            autoGrabBomb()
        else
            -- If your main account isn't in the server yet, just spin in place
            root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(20), 0)
        end
    end)
end

if LocalPlayer.Character then safeTeleportAndSpin(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(safeTeleportAndSpin)
