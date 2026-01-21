local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/SynioxStudios/ByYusufGui-Syniox/refs/heads/main/SynioxGui.lua%20(3).txt", true))()
local displayName = game.Players.LocalPlayer.DisplayName

local window = library:AddWindow("Syniox Public | Muscle Legends || HELLO - ".. displayName, {
    title_bar = {
        Color3.fromRGB(160, 0, 0), 
        Color3.fromRGB(40, 0, 0),  
        Color3.fromRGB(0, 0, 0)    
    }, 
    title_bar_transparency = 0.1, 
    background = {
        Color3.fromRGB(0, 0, 0), 
        Color3.fromRGB(10, 10, 10), 
        Color3.fromRGB(20, 20, 20)
    }, 
    background_transparency = 0.1, 
    main_color = Color3.fromRGB(160, 0, 0), 
    min_size = Vector2.new(450, 450), 
    can_resize = true 
})

local AutoFarm = window:AddTab("Farm")
AutoFarm:AddLabel("Op Farm")

_G.repToggle = false
AutoFarm:AddSwitch("💪 Auto Farm (Equip Any tool)", function(state)
    _G.repToggle = state
    task.spawn(function()
        while _G.repToggle do
            local event = game:GetService("Players").LocalPlayer:FindFirstChild("muscleEvent")
            if event then
                event:FireServer("rep")
            end
            task.wait(0.1)
        end
    end)
end)

local folder1 = AutoFarm:AddFolder("Tools")

local function manageTool(toolName)
    task.spawn(function()
        while _G[toolName.."On"] do
            local player = game.Players.LocalPlayer
            local character = player.Character
            if character then
                local tool = player.Backpack:FindFirstChild(toolName) or character:FindFirstChild(toolName)
                
                if tool then
                    if tool.Parent ~= character then
                        tool.Parent = character
                    end
                    
                    local event = player:FindFirstChild("muscleEvent")
                    if event then
                        event:FireServer("rep")
                    else
                        tool:Activate()
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end

folder1:AddSwitch("🏋️ Weight", function(bool)
    _G.WeightOn = bool
    if bool then manageTool("Weight") end
end)

folder1:AddSwitch("💪 Pushups", function(bool)
    _G.PushupsOn = bool
    if bool then manageTool("Pushups") end
end)

folder1:AddSwitch("🤸 Handstands", function(bool)
    _G.HandstandsOn = bool
    if bool then manageTool("Handstands") end
end)

folder1:AddSwitch("🧘 Situps", function(bool)
    _G.SitupsOn = bool
    if bool then manageTool("Situps") end
end)

local VirtualInputManager = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer

local Locations = {
    {name = "🌿 Jungle Treadmill +8 xp", pos = Vector3.new(-8131.86, 25.77, 2818.17)},
    {name = "🔱 Legends Treadmill +7 xp", pos = Vector3.new(4365.82, 997.14, -3632.9)},
    {name = "✨ Mythical Treadmill +6 xp", pos = Vector3.new(2661.67, 19.41, 932.09)},
    {name = "🏠 Spawn Treadmill +5 xp", pos = Vector3.new(-230.43, 8.16, -102.18)},
    {name = "👟 Tiny Treadmill +1 xp", pos = Vector3.new(55.64, 5.16, 1947.60)}
}

local posLockConnection = nil

local function lockAndSimulate(targetCFrame)
    if posLockConnection then posLockConnection:Disconnect() end
    posLockConnection = RunService.Heartbeat:Connect(function()
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            Player.Character.HumanoidRootPart.CFrame = targetCFrame
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.W, false, game)
        end
    end)
end

local function stopAll()
    if posLockConnection then
        posLockConnection:Disconnect()
        posLockConnection = nil
    end
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, game)
end

local FarmFolder = AutoFarm:AddFolder("Treadmill")

for _, loc in ipairs(Locations) do
    FarmFolder:AddSwitch(loc.name, function(bool)
        if bool then
            local hrp = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = CFrame.new(loc.pos + Vector3.new(0, 3, 0))
                task.wait(0.3)
                lockAndSimulate(hrp.CFrame)
            end
        else
            stopAll()
        end
    end)
end

local JungleFolder = AutoFarm:AddFolder("Jungle Gym")

local VIM = game:GetService("VirtualInputManager")
local function pressEKey()
    VIM:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    task.wait(0.05)
    VIM:SendKeyEvent(false, Enum.KeyCode.E, false, game)
end

local function startJungleFarm(toggleName, cframeValue, eventName)
    local active = false
    JungleFolder:AddSwitch(toggleName, function(bool)
        active = bool
        if bool then
            task.spawn(function()
                while active do
                    local char = game.Players.LocalPlayer.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    
                    if root then
                        if (root.Position - cframeValue.p).Magnitude > 5 then
                            root.CFrame = cframeValue
                            task.wait(0.3)
                            pressEKey()
                        end
                        
                        game:GetService("Players").LocalPlayer.muscleEvent:FireServer(eventName)
                    end
                    task.wait(0.05)
                end
            end)
        end
    end)
end

startJungleFarm("🌴 Auto Jungle Lift", CFrame.new(-8652.85, 45.22, 2088.99), "rep")
startJungleFarm("🏋️ Auto Bench Press", CFrame.new(-8173.23, 83.82, 1907.40), "rep")
startJungleFarm("🦵 Auto Squat", CFrame.new(-8377.55, 48.71, 2864.90), "rep")
startJungleFarm("💢 Auto Boulder", CFrame.new(-8614.81, 51.90, 2677.37), "rep")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local toolFolder = AutoFarm:AddFolder("Auto Tools")

local function manageTool(toolName)
    task.spawn(function()
        while _G[toolName.."On"] do
            local character = LocalPlayer.Character
            if character then
                local tool = LocalPlayer.Backpack:FindFirstChild(toolName) or character:FindFirstChild(toolName)
                if tool then
                    if tool.Parent ~= character then
                        tool.Parent = character
                    end
                    if toolName == "Punch" then
                        if tool:FindFirstChild("attackTime") then
                            tool.attackTime.Value = 0
                        end
                        tool:Activate()
                    else
                        local event = LocalPlayer:FindFirstChild("muscleEvent")
                        if event then
                            event:FireServer("rep")
                        else
                            tool:Activate()
                        end
                    end
                end
            end
            task.wait(0.05)
        end
    end)
end

toolFolder:AddSwitch("🏋️ Weight + 🥊 Punch", function(bool)
    _G.WeightOn = bool
    _G.PunchOn = bool
    if bool then 
        manageTool("Weight")
        manageTool("Punch")
    else
        local wTool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Weight")
        local pTool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Punch")
        if wTool then wTool.Parent = LocalPlayer.Backpack end
        if pTool then pTool.Parent = LocalPlayer.Backpack end
    end
end)

toolFolder:AddSwitch("💪 Pushups + 🥊 Punch", function(bool)
    _G.PushupsOn = bool
    _G.PunchOn = bool
    if bool then 
        manageTool("Pushups")
        manageTool("Punch")
    else
        local pTool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Pushups")
        local puTool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Punch")
        if pTool then pTool.Parent = LocalPlayer.Backpack end
        if puTool then puTool.Parent = LocalPlayer.Backpack end
    end
end)

toolFolder:AddSwitch("🤸 Handstand + 🥊 Punch", function(bool)
    _G.HandstandOn = bool
    _G.PunchOn = bool
    if bool then 
        manageTool("Handstand")
        manageTool("Punch")
    else
        local hTool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Handstand")
        local pTool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Punch")
        if hTool then hTool.Parent = LocalPlayer.Backpack end
        if pTool then pTool.Parent = LocalPlayer.Backpack end
    end
end)

toolFolder:AddSwitch("🧘 Situps + 🥊 Punch", function(bool)
    _G.SitupsOn = bool
    _G.PunchOn = bool
    if bool then 
        manageTool("Situps")
        manageTool("Punch")
    else
        local sTool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Situps")
        local pTool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Punch")
        if sTool then sTool.Parent = LocalPlayer.Backpack end
        if pTool then pTool.Parent = LocalPlayer.Backpack end
    end
end)

local rebirths = window:AddTab("Rebirths")

rebirths:AddTextBox("Rebirth Target", function(text)
    local newValue = tonumber(text)
    if newValue and newValue > 0 then
        targetRebirthValue = newValue
        updateStats() -- Call the stats update function
        
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Objetivo Actualizado",
            Text = "Nuevo objetivo: " .. tostring(targetRebirthValue) .. " renacimientos",
            Duration = 0
        })
    else
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Size",
            Text = "Put a size larger than 0",
            Duration = 0
        })
    end
end)

local infiniteSwitch

local targetSwitch = rebirths:AddSwitch("🔄 Auto Rebirth Target", function(bool)
    _G.targetRebirthActive = bool
    
    if bool then
        if _G.infiniteRebirthActive and infiniteSwitch then
            infiniteSwitch:Set(false)
            _G.infiniteRebirthActive = false
        end
        
        spawn(function()
            while _G.targetRebirthActive and wait(0.1) do
                local currentRebirths = game.Players.LocalPlayer.leaderstats.Rebirths.Value
                
                if currentRebirths >= targetRebirthValue then
                    targetSwitch:Set(false)
                    _G.targetRebirthActive = false
                    
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡Objetivo Alcanzado!",
                        Text = "Has alcanzado " .. tostring(targetRebirthValue) .. " renacimientos",
                        Duration = 5
                    })
                    
                    break
                end
                
                game:GetService("ReplicatedStorage").rEvents.rebirthRemote:InvokeServer("rebirthRequest")
            end
        end)
    end
end, "automatic rebirth until reaching the goal")

infiniteSwitch = rebirths:AddSwitch("♾️ Auto Rebirth (Infinitely)", function(bool)
    _G.infiniteRebirthActive = bool
    
    if bool then
        if _G.targetRebirthActive and targetSwitch then
            targetSwitch:Set(false)
            _G.targetRebirthActive = false
        end
        
        spawn(function()
            while _G.infiniteRebirthActive and wait(0.1) do
                game:GetService("ReplicatedStorage").rEvents.rebirthRemote:InvokeServer("rebirthRequest")
            end
        end)
    end
end, "rebirth infinitely")

local sizeSwitch = rebirths:AddSwitch("Auto Size 1📏", function(bool)
    _G.autoSizeActive = bool
    
    if bool then
        spawn(function()
            while _G.autoSizeActive and wait() do
                game:GetService("ReplicatedStorage").rEvents.changeSpeedSizeRemote:InvokeServer("changeSize", 1)
            end
        end)
    end
end, "Size 1")

local sizeSwitch = rebirths:AddSwitch("Auto Size 2📏", function(bool)
    _G.autoSizeActive = bool
    
    if bool then
        spawn(function()
            while _G.autoSizeActive and wait() do
                game:GetService("ReplicatedStorage").rEvents.changeSpeedSizeRemote:InvokeServer("changeSize", 2)
            end
        end)
    end
end, "Size 2")

local teleportSwitch = rebirths:AddSwitch("👑 Auto Teleport to Muscle King", function(bool)
    _G.teleportActive = bool
    
    if bool then
        spawn(function()
            while _G.teleportActive and wait() do
                if game.Players.LocalPlayer.Character then
                    game.Players.LocalPlayer.Character:MoveTo(Vector3.new(-8646, 17, -5738))
                end
            end
        end)
    end
end, "Tp to Mk")

-- Egg yeme
local function eatProteinEgg()
    local backpack = player:WaitForChild("Backpack")
    local character = player.Character or player.CharacterAdded:Wait()
    local egg = backpack:FindFirstChild("Protein Egg")
    if egg then
        egg.Parent = character
        pcall(function()
            egg:Activate()
        end)
    end
end

-- 30 Dakikalık Döngü
task.spawn(function()
    while true do
        if autoEat30Enabled then
            eatProteinEgg()
            task.wait(1800) -- 30 Dakika
        end
        task.wait(1)
    end
end)

rebirths:AddSwitch("🥚 Auto Eat Egg 30 Min", function(state)
    autoEat30Enabled = state
end)

-- 60 Dakikalık Döngü
task.spawn(function()
    while true do
        if autoEat60Enabled then
            eatProteinEgg()
            task.wait(3600) -- 60 Dakika
        end
        task.wait(1)
    end
end)

rebirths:AddSwitch("🥚 Auto Eat Egg 60 Min", function(state)
    autoEat60Enabled = state
end)

rebirths:AddSwitch("👁️‍🗨️ Hide All Frames", function(bool)
    local rSto = game:GetService("ReplicatedStorage")
    for _, obj in pairs(rSto:GetChildren()) do
        if obj.Name:match("Frame$") then
            obj.Visible = not bool
        end
    end
end)

local autoEquipToolsFolder = rebirths:AddFolder("Auto Equip Tools")

autoEquipToolsFolder:AddButton("💎 Gamepass AutoLift", function()
    local gamepassFolder = game:GetService("ReplicatedStorage").gamepassIds
    local player = game:GetService("Players").LocalPlayer
    for _, gamepass in pairs(gamepassFolder:GetChildren()) do
        local value = Instance.new("IntValue")
        value.Name = gamepass.Name
        value.Value = gamepass.Value
        value.Parent = player.ownedGamepasses
    end
end, "🔓 Unlock AutoLift Passe")

autoEquipToolsFolder:AddSwitch("💪 Auto Weight", function(Value)
    _G.AutoWeight = Value
    
    if Value then
        local weightTool = game.Players.LocalPlayer.Backpack:FindFirstChild("Weight")
        if weightTool then
            game.Players.LocalPlayer.Character.Humanoid:EquipTool(weightTool)
        end
    else
        local character = game.Players.LocalPlayer.Character
        local equipped = character:FindFirstChild("Weight")
        if equipped then
            equipped.Parent = game.Players.LocalPlayer.Backpack
        end
    end
    
    task.spawn(function()
        while _G.AutoWeight do
            if not _G.AutoWeight then break end
            game:GetService("Players").LocalPlayer.muscleEvent:FireServer("rep")
            task.wait(0.1)
        end
    end)
end, "Auto Weight")

autoEquipToolsFolder:AddSwitch("⚡ Auto Pushups", function(Value)
    _G.AutoPushups = Value
    
    if Value then
        local pushupsTool = game.Players.LocalPlayer.Backpack:FindFirstChild("Pushups")
        if pushupsTool then
            game.Players.LocalPlayer.Character.Humanoid:EquipTool(pushupsTool)
        end
    else
        local character = game.Players.LocalPlayer.Character
        local equipped = character:FindFirstChild("Pushups")
        if equipped then
            equipped.Parent = game.Players.LocalPlayer.Backpack
        end
    end
    
    task.spawn(function()
        while _G.AutoPushups do
            if not _G.AutoPushups then break end
            game:GetService("Players").LocalPlayer.muscleEvent:FireServer("rep")
            task.wait(0.1)
        end
    end)
end, "Auto Pushups")

autoEquipToolsFolder:AddSwitch("🤸‍♀️ Auto Handstands", function(Value)
    _G.AutoHandstands = Value
    
    if Value then
        local handstandsTool = game.Players.LocalPlayer.Backpack:FindFirstChild("Handstands")
        if handstandsTool then
            game.Players.LocalPlayer.Character.Humanoid:EquipTool(handstandsTool)
        end
    else
        local character = game.Players.LocalPlayer.Character
        local equipped = character:FindFirstChild("Handstands")
        if equipped then
            equipped.Parent = game.Players.LocalPlayer.Backpack
        end
    end
    
    task.spawn(function()
        while _G.AutoHandstands do
            if not _G.AutoHandstands then break end
            game:GetService("Players").LocalPlayer.muscleEvent:FireServer("rep")
            task.wait(0.1)
        end
    end)
end, "Auto Handstands")

autoEquipToolsFolder:AddSwitch("🦵 Auto Situps", function(Value)
    _G.AutoSitups = Value

    
    if Value then
        local situpsTool = game.Players.LocalPlayer.Backpack:FindFirstChild("Situps")
        if situpsTool then
            game.Players.LocalPlayer.Character.Humanoid:EquipTool(situpsTool)
        end
    else
        local character = game.Players.LocalPlayer.Character
        local equipped = character:FindFirstChild("Situps")
        if equipped then
            equipped.Parent = game.Players.LocalPlayer.Backpack
        end
    end
    
    task.spawn(function()
        while _G.AutoSitups do
            if not _G.AutoSitups then break end
            game:GetService("Players").LocalPlayer.muscleEvent:FireServer("rep")
            task.wait(0.1)
        end
    end)
end, "Auto Abdominals")

autoEquipToolsFolder:AddSwitch("🥊 Auto Punch", function(Value)
    _G.fastHitActive = Value
    
    if Value then
        task.spawn(function()
            while _G.fastHitActive do
                if not _G.fastHitActive then break end
                
                local player = game.Players.LocalPlayer
                local punch = player.Backpack:FindFirstChild("Punch")
                if punch then
                    punch.Parent = player.Character
                    if punch:FindFirstChild("attackTime") then
                        punch.attackTime.Value = 0
                    end
                end
                task.wait(0.1)
            end
        end)
        
        task.spawn(function()
            while _G.fastHitActive do
                if not _G.fastHitActive then break end
                
                local player = game.Players.LocalPlayer
                player.muscleEvent:FireServer("punch", "rightHand")
                player.muscleEvent:FireServer("punch", "leftHand")
                
                local character = player.Character
                if character then
                    local punchTool = character:FindFirstChild("Punch")
                    if punchTool then
                        punchTool:Activate()
                    end
                end
                task.wait(0)
            end
        end)
    else
        local character = game.Players.LocalPlayer.Character
        local equipped = character:FindFirstChild("Punch")
        if equipped then
            equipped.Parent = game.Players.LocalPlayer.Backpack
        end
    end
end, "Auto Punch")

autoEquipToolsFolder:AddSwitch("⚡ Fast Tools", function(Value)
    _G.FastTools = Value
    
    local defaultSpeeds = {
        {
            "Punch",
            "attackTime",
            Value and 0 or 0.35
        },
        {
            "Ground Slam",
            "attackTime",
            Value and 0 or 6
        },
        {
            "Stomp",
            "attackTime",
            Value and 0 or 7
        },
        {
            "Handstands",
            "repTime",
            Value and 0 or 1
        },
        {
            "Pushups",
            "repTime",
            Value and 0 or 1
        },
        {
            "Weight",
            "repTime",
            Value and 0 or 1
        },
        {
            "Situps",
            "repTime",
            Value and 0 or 1
        }
    }
    
    local player = game.Players.LocalPlayer
    local backpack = player:WaitForChild("Backpack")
    
    for _, toolInfo in ipairs(defaultSpeeds) do
        local tool = backpack:FindFirstChild(toolInfo[1])
        if tool and tool:FindFirstChild(toolInfo[2]) then
            tool[toolInfo[2]].Value = toolInfo[3]
        end
        
        local equippedTool = player.Character and player.Character:FindFirstChild(toolInfo[1])
        if equippedTool and equippedTool:FindFirstChild(toolInfo[2]) then
            equippedTool[toolInfo[2]].Value = toolInfo[3]
        end
    end
end, "Speed up all tools")

local sessionStartTime = os.time()
local sessionStartStrength = 0
local sessionStartDurability = 0
local sessionStartKills = 0
local sessionStartRebirths = 0
local sessionStartBrawls = 0
local hasStartedTracking = false

local Killer = window:AddTab("Kill")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local playerWhitelist = {}
local targetPlayerNames = {}
local autoGoodKarma = false
local autoBadKarma = false
local autoKill = false
local killTarget = false
local spying = false
local autoEquipPunch = false
local autoPunchNoAnim = false
local targetDropdownItems = {}
local availableTargets = {}

Killer:AddSwitch("😇 Auto Good Karma", function(bool)
    autoGoodKarma = bool
    task.spawn(function()
        while autoGoodKarma do
            local playerChar = LocalPlayer.Character
            local rightHand = playerChar and playerChar:FindFirstChild("RightHand")
            local leftHand = playerChar and playerChar:FindFirstChild("LeftHand")
            if playerChar and rightHand and leftHand then
                for _, target in ipairs(Players:GetPlayers()) do
                    if target ~= LocalPlayer then
                        local evilKarma = target:FindFirstChild("evilKarma")
                        local goodKarma = target:FindFirstChild("goodKarma")
                        if evilKarma and goodKarma and evilKarma:IsA("IntValue") and goodKarma:IsA("IntValue") and evilKarma.Value > goodKarma.Value then
                            local rootPart = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
                            if rootPart then
                                firetouchinterest(rightHand, rootPart, 1)
                                firetouchinterest(leftHand, rootPart, 1)
                                firetouchinterest(rightHand, rootPart, 0)
                                firetouchinterest(leftHand, rootPart, 0)
                            end
                        end
                    end
                end
            end
            task.wait(0.01)
        end
    end)
end)

Killer:AddSwitch("😈 Auto Bad Karma", function(bool)
    autoBadKarma = bool
    task.spawn(function()
        while autoBadKarma do
            local playerChar = LocalPlayer.Character
            local rightHand = playerChar and playerChar:FindFirstChild("RightHand")
            local leftHand = playerChar and playerChar:FindFirstChild("LeftHand")
            if playerChar and rightHand and leftHand then
                for _, target in ipairs(Players:GetPlayers()) do
                    if target ~= LocalPlayer then
                        local evilKarma = target:FindFirstChild("evilKarma")
                        local goodKarma = target:FindFirstChild("goodKarma")
                        if evilKarma and goodKarma and evilKarma:IsA("IntValue") and goodKarma:IsA("IntValue") and goodKarma.Value > evilKarma.Value then
                            local rootPart = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
                            if rootPart then
                                firetouchinterest(rightHand, rootPart, 1)
                                firetouchinterest(leftHand, rootPart, 1)
                                firetouchinterest(rightHand, rootPart, 0)
                                firetouchinterest(leftHand, rootPart, 0)
                            end
                        end
                    end
                end
            end
            task.wait(0.01)
        end
    end)
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local friendWhitelistActive = false

Killer:AddSwitch("🛡️ Auto Whitelist Friends", function(state)
    friendWhitelistActive = state

    if state then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and LocalPlayer:IsFriendsWith(player.UserId) then
                playerWhitelist[player.Name] = true
            end
        end

        Players.PlayerAdded:Connect(function(player)
            if friendWhitelistActive and player ~= LocalPlayer and LocalPlayer:IsFriendsWith(player.UserId) then
                playerWhitelist[player.Name] = true
            end
        end)
    else
        for name in pairs(playerWhitelist) do
            local friend = Players:FindFirstChild(name)
            if friend and LocalPlayer:IsFriendsWith(friend.UserId) then
                playerWhitelist[name] = nil
            end
        end
    end
end)

Killer:AddTextBox("Whitelist", function(text)
    local target = Players:FindFirstChild(text)
    if target then
        playerWhitelist[target.Name] = true
    end
end)

Killer:AddTextBox("UnWhitelist", function(text)
    local target = Players:FindFirstChild(text)
    if target then
        playerWhitelist[target.Name] = nil
    end
end)

Killer:AddSwitch("⚔️ Auto Kill", function(bool)
    autoKill = bool

    task.spawn(function()
        while autoKill do
            local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local rightHand = character:FindFirstChild("RightHand")
            local leftHand = character:FindFirstChild("LeftHand")

            local punch = LocalPlayer.Backpack:FindFirstChild("Punch")
            if punch and not character:FindFirstChild("Punch") then
                punch.Parent = character
            end

            if rightHand and leftHand then
                for _, target in ipairs(Players:GetPlayers()) do
                    if target ~= LocalPlayer and not playerWhitelist[target.Name] then
                        local targetChar = target.Character
                        local rootPart = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
                        if rootPart then
                            pcall(function()
                                firetouchinterest(rightHand, rootPart, 1)
                                firetouchinterest(leftHand, rootPart, 1)
                                firetouchinterest(rightHand, rootPart, 0)
                                firetouchinterest(leftHand, rootPart, 0)
                            end)
                        end
                    end
                end
            end

            task.wait(0.05)
        end
    end)
end)

local targetDropdown = Killer:AddDropdown("Select Target", function(name)
    if name and not table.find(targetPlayerNames, name) then
        table.insert(targetPlayerNames, name)
    end
end)

Killer:AddTextBox("Remove Target", function(name)
    for i, v in ipairs(targetPlayerNames) do
        if v == name then
            table.remove(targetPlayerNames, i)
            break
        end
    end
end)

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        targetDropdown:Add(player.Name)
        targetDropdownItems[player.Name] = true
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        targetDropdown:Add(player.Name)
        targetDropdownItems[player.Name] = true
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if targetDropdownItems[player.Name] then
        targetDropdownItems[player.Name] = nil
        targetDropdown:Clear()
        for name in pairs(targetDropdownItems) do
            targetDropdown:Add(name)
        end
    end

    for i = #targetPlayerNames, 1, -1 do
        if targetPlayerNames[i] == player.Name then
            table.remove(targetPlayerNames, i)
        end
    end
end)

Killer:AddSwitch("🎯 Start Kill Target", function(state)
    killTarget = state

    task.spawn(function()
        while killTarget do
            local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

            local punch = LocalPlayer.Backpack:FindFirstChild("Punch")
            if punch and not character:FindFirstChild("Punch") then
                punch.Parent = character
            end

            local rightHand = character:WaitForChild("RightHand", 5)
            local leftHand = character:WaitForChild("LeftHand", 5)

            if rightHand and leftHand then
                for _, name in ipairs(targetPlayerNames) do
                    local target = Players:FindFirstChild(name)
                    if target and target ~= LocalPlayer then
                        local rootPart = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
                        if rootPart then
                            pcall(function()
                                firetouchinterest(rightHand, rootPart, 1)
                                firetouchinterest(leftHand, rootPart, 1)
                                firetouchinterest(rightHand, rootPart, 0)
                                firetouchinterest(leftHand, rootPart, 0)
                            end)
                        end
                    end
                end
            end

            task.wait(0.05)
        end
    end)
end)

local spyTargetDropdown = Killer:AddDropdown("Select View Target", function(name)
    targetPlayerName = name
end)

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        spyTargetDropdown:Add(player.Name)
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        spyTargetDropdown:Add(player.Name)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if player ~= LocalPlayer then
        spyTargetDropdown:Clear()
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                spyTargetDropdown:Add(plr.Name)
            end
        end
    end
end)

Killer:AddSwitch("👁️ View Player", function(bool)
    spying = bool
    if not spying then
        local cam = workspace.CurrentCamera
        cam.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") or LocalPlayer
        return
    end
    task.spawn(function()
        while spying do
            local target = Players:FindFirstChild(targetPlayerName)
            if target and target ~= LocalPlayer then
                local humanoid = target.Character and target.Character:FindFirstChild("Humanoid")
                if humanoid then
                    workspace.CurrentCamera.CameraSubject = humanoid
                end
            end
            task.wait(0.1)
        end
    end)
end)

local button = Killer:AddButton("🚫 Remove Punch Anim", function()
    local blockedAnimations = {
        ["rbxassetid://3638729053"] = true,
        ["rbxassetid://3638767427"] = true,
    }

    local function setupAnimationBlocking()
        local char = game.Players.LocalPlayer.Character
        if not char or not char:FindFirstChild("Humanoid") then return end

        local humanoid = char:FindFirstChild("Humanoid")

        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
            if track.Animation then
                local animId = track.Animation.AnimationId
                local animName = track.Name:lower()

                if blockedAnimations[animId] or
                    animName:match("punch") or
                    animName:match("attack") or
                    animName:match("right") then
                    track:Stop()
                end
            end
        end

        if not _G.AnimBlockConnection then
            local connection = humanoid.AnimationPlayed:Connect(function(track)
                if track.Animation then
                    local animId = track.Animation.AnimationId
                    local animName = track.Name:lower()

                    if blockedAnimations[animId] or
                        animName:match("punch") or
                        animName:match("attack") or
                        animName:match("right") then
                        track:Stop()
                    end
                end
            end)

            _G.AnimBlockConnection = connection
        end
    end

    setupAnimationBlocking()

    local function overrideToolActivation()
        local function processTool(tool)
            if tool and (tool.Name == "Punch" or tool.Name:match("Attack") or tool.Name:match("Right")) then
                if not tool:GetAttribute("ActivatedOverride") then
                    tool:SetAttribute("ActivatedOverride", true)

                    local connection = tool.Activated:Connect(function()
                        task.wait(0.05)

                        local char = game.Players.LocalPlayer.Character
                        if char and char:FindFirstChild("Humanoid") then
                            for _, track in pairs(char.Humanoid:GetPlayingAnimationTracks()) do
                                if track.Animation then
                                    local animId = track.Animation.AnimationId
                                    local animName = track.Name:lower()

                                    if blockedAnimations[animId] or
                                        animName:match("punch") or
                                        animName:match("attack") or
                                        animName:match("right") then
                                        track:Stop()
                                    end
                                end
                            end
                        end
                    end)

                    if not _G.ToolConnections then
                        _G.ToolConnections = {}
                    end
                    _G.ToolConnections[tool] = connection
                end
            end
        end

        for _, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
            processTool(tool)
        end

        local char = game.Players.LocalPlayer.Character
        if char then
            for _, tool in pairs(char:GetChildren()) do
                if tool:IsA("Tool") then
                    processTool(tool)
                end
            end
        end

        if not _G.BackpackAddedConnection then
            _G.BackpackAddedConnection = game.Players.LocalPlayer.Backpack.ChildAdded:Connect(function(child)
                if child:IsA("Tool") then
                    task.wait(0.1)
                    processTool(child)
                end
            end)
        end

        if not _G.CharacterToolAddedConnection and char then
            _G.CharacterToolAddedConnection = char.ChildAdded:Connect(function(child)
                if child:IsA("Tool") then
                    task.wait(0.1)
                    processTool(child)
                end
            end)
        end
    end

    overrideToolActivation()

    if not _G.AnimMonitorConnection then
        _G.AnimMonitorConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if tick() % 0.5 < 0.01 then
                local char = game.Players.LocalPlayer.Character
                if char and char:FindFirstChild("Humanoid") then
                    for _, track in pairs(char.Humanoid:GetPlayingAnimationTracks()) do
                        if track.Animation then
                            local animId = track.Animation.AnimationId
                            local animName = track.Name:lower()

                            if blockedAnimations[animId] or
                                animName:match("punch") or
                                animName:match("attack") or
                                animName:match("right") then
                                track:Stop()
                            end
                        end
                    end
                end
            end
        end)
    end

    if not _G.CharacterAddedConnection then
        _G.CharacterAddedConnection = game.Players.LocalPlayer.CharacterAdded:Connect(function(newChar)
            task.wait(1)
            setupAnimationBlocking()
            overrideToolActivation()

            if _G.CharacterToolAddedConnection then
                _G.CharacterToolAddedConnection:Disconnect()
            end

            _G.CharacterToolAddedConnection = newChar.ChildAdded:Connect(function(child)
                if child:IsA("Tool") then
                    task.wait(0.1)
                    processTool(child)
                end
            end)
        end)
    end
end)

function RecoveryPunch()
    if _G.AnimBlockConnection then
        _G.AnimBlockConnection:Disconnect()
        _G.AnimBlockConnection = nil
    end
    if _G.AnimMonitorConnection then
        _G.AnimMonitorConnection:Disconnect()
        _G.AnimMonitorConnection = nil
    end
    if _G.ToolConnections then
        for _, conn in pairs(_G.ToolConnections) do
            if conn then conn:Disconnect() end
        end
        _G.ToolConnections = nil
    end
    if _G.BackpackAddedConnection then
        _G.BackpackAddedConnection:Disconnect()
        _G.BackpackAddedConnection = nil
    end
    if _G.CharacterToolAddedConnection then
        _G.CharacterToolAddedConnection:Disconnect()
        _G.CharacterToolAddedConnection = nil
    end
    if _G.CharacterAddedConnection then
        _G.CharacterAddedConnection:Disconnect()
        _G.CharacterAddedConnection = nil
    end
end

Killer:AddButton("🔄 Recover Punch Anim", function()
    RecoveryPunch()
end)

Killer:AddSwitch("Auto Equip Punch", function(state)
	autoEquipPunch = state
	task.spawn(function()
		while autoEquipPunch do
			local punch = LocalPlayer.Backpack:FindFirstChild("Punch")
			if punch then
				punch.Parent = LocalPlayer.Character
			end
			task.wait(0.1)
		end
	end)
end)

Killer:AddSwitch("🥊 Auto Punch [No Animation]", function(state)
	autoPunchNoAnim = state
	task.spawn(function()
		while autoPunchNoAnim do
			local punch = LocalPlayer.Backpack:FindFirstChild("Punch") or LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Punch")
			if punch then
				if punch.Parent ~= LocalPlayer.Character then
					punch.Parent = LocalPlayer.Character
				end
				LocalPlayer.muscleEvent:FireServer("punch", "rightHand")
				LocalPlayer.muscleEvent:FireServer("punch", "leftHand")
			else
				autoPunchNoAnim = false
			end
			task.wait(0.01)
		end
	end)
end)

Killer:AddSwitch("🧨 Auto Punch", function(state)
	_G.fastHitActive = state
	if state then
		task.spawn(function()
			while _G.fastHitActive do
				local punch = LocalPlayer.Backpack:FindFirstChild("Punch")
				if punch then
					punch.Parent = LocalPlayer.Character
					if punch:FindFirstChild("attackTime") then
						punch.attackTime.Value = 0
					end
				end
				task.wait(0.1)
			end
		end)
		task.spawn(function()
			while _G.fastHitActive do
				local punch = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Punch")
				if punch then
					punch:Activate()
				end
				task.wait(0.1)
			end
		end)
	else
		local punch = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Punch")
		if punch then
			punch.Parent = LocalPlayer.Backpack
		end
	end
end)

Killer:AddSwitch("⚡ Fast Punch", function(state)
	_G.autoPunchActive = state
	if state then
		task.spawn(function()
			while _G.autoPunchActive do
				local punch = LocalPlayer.Backpack:FindFirstChild("Punch")
				if punch then
					punch.Parent = LocalPlayer.Character
					if punch:FindFirstChild("attackTime") then
						punch.attackTime.Value = 0
					end
				end
				task.wait()
			end
		end)
		task.spawn(function()
			while _G.autoPunchActive do
				local punch = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Punch")
				if punch then
					punch:Activate()
				end
				task.wait()
			end
		end)
	else
		local punch = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Punch")
		if punch then
			punch.Parent = LocalPlayer.Backpack
		end
	end
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local killsShown = false
local killsGui = nil

local showKillsButton = Killer:AddButton("📊 Kill Counter UI", function()
	if killsShown then
		if not killsGui then
			killsGui = Instance.new("ScreenGui")
			killsGui.Name = "KillsGui"
			killsGui.ResetOnSpawn = false
			killsGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

			local killsFrame = Instance.new("Frame")
			killsFrame.Size = UDim2.new(0, 180, 0, 55)
			killsFrame.Position = UDim2.new(0.5, -90, 0, 60)
			killsFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			killsFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			killsFrame.Active = true
			killsFrame.Draggable = true
			killsFrame.Parent = killsGui

			local titleLabel = Instance.new("TextLabel")
			titleLabel.Size = UDim2.new(1, 0, 0, 20)
			titleLabel.Position = UDim2.new(0, 0, 0, 0)
			titleLabel.BackgroundTransparency = 1
			titleLabel.Text = "Syniox Kill"
			titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			titleLabel.Font = Enum.Font.SourceSansBold
			titleLabel.TextScaled = true
			titleLabel.Parent = killsFrame

			local killsLabel = Instance.new("TextLabel")
			killsLabel.Size = UDim2.new(1, 0, 0, 35)
			killsLabel.Position = UDim2.new(0, 0, 0, 20)
			killsLabel.BackgroundTransparency = 1
			killsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			killsLabel.TextScaled = true
			killsLabel.Font = Enum.Font.SourceSansBold
			killsLabel.Parent = killsFrame

			coroutine.wrap(function()
				while killsGui and killsGui.Parent do
					local kills = LocalPlayer:FindFirstChild("leaderstats") and LocalPlayer.leaderstats:FindFirstChild("Kills")
					if kills then
						killsLabel.Text = "Kills: " .. tostring(kills.Value)
					else
						killsLabel.Text = "Kills: 0"
					end
					task.wait(0.2)
				end
			end)()
		else
			killsGui.Enabled = true
		end
	else
		if killsGui then
			killsGui.Enabled = false
		end
	end
end)

showKillsButton.TextColor3 = Color3.fromRGB(255, 255, 255)

local LookDura = window:AddTab("Stats")
local SelectPlayerName = ""

local PlayerDrop = LookDura:AddDropdown("Select Player", function(Value)
    SelectPlayerName = Value:match("| (.+)")
    previousValues = {}
end)

local Playerslist = {}
for _, Plr in pairs(game:GetService("Players"):GetPlayers()) do
    local displayName = Plr.DisplayName .. " | " .. Plr.Name
    table.insert(Playerslist, displayName)
end
for _, AddPlr in ipairs(Playerslist) do
    PlayerDrop:Add(AddPlr)
end

local function FormatNumberWithCommas(number)
    local formatted = tostring(number):reverse():gsub("(%d%d%d)", "%1,"):reverse()
    return formatted:gsub("^,", "")
end

local function FormatAbbreviated(number)
    local abbreviations = {"", "K", "M", "B", "T", "Qa", "Qi"}
    local abbreviationIndex = 1
    while number >= 1000 and abbreviationIndex < #abbreviations do
        number = number / 1000
        abbreviationIndex = abbreviationIndex + 1
    end
    return string.format("%.2f", number) .. abbreviations[abbreviationIndex]
end

local function FormatDisplay(value)
    local normal = FormatNumberWithCommas(value)
    local abbreviated = FormatAbbreviated(value)
    return "[ " .. normal .. " | " .. abbreviated .. " ]"
end

local previousValues = {}

local Update = LookDura:AddLabel("")
local Update1 = LookDura:AddLabel("")
local Update2 = LookDura:AddLabel("")
local Update3 = LookDura:AddLabel("")
local Update4 = LookDura:AddLabel("")
local Update5 = LookDura:AddLabel("")
local Update6 = LookDura:AddLabel("")
local Update9 = LookDura:AddLabel("")
local Update10 = LookDura:AddLabel("")
local Update11 = LookDura:AddLabel("")
local Update12 = LookDura:AddLabel("")
local Update13 = LookDura:AddLabel("")
local UpdateHTK = LookDura:AddLabel("")

task.spawn(function()
    while task.wait(0.2) do
        if SelectPlayerName ~= "" then
            local player = game.Players:FindFirstChild(SelectPlayerName)
            local localPlayer = game.Players.LocalPlayer
            if player and localPlayer then
                if player:FindFirstChild("Gems") then
                    Update1.Text = "💎 Gems: " .. FormatDisplay(player.Gems.Value)
                end
                if player:FindFirstChild("Agility") then
                    Update3.Text = "⚡ Agility: " .. FormatDisplay(player.Agility.Value)
                end
                if player:FindFirstChild("Durability") then
                    Update4.Text = "🛡️ Durability: " .. FormatDisplay(player.Durability.Value)
                end
                if player:FindFirstChild("muscleKingTime") then
                    Update6.Text = "👑 Muscle King Time: " .. FormatDisplay(player.muscleKingTime.Value)
                end
                if player:FindFirstChild("customSize") then
                    Update10.Text = "📏 Custom Size: " .. FormatDisplay(player.customSize.Value)
                end
                if player:FindFirstChild("customSpeed") then
                    Update11.Text = "🏎️ Custom Speed: " .. FormatDisplay(player.customSpeed.Value)
                end
                if player:FindFirstChild("evilKarma") then
                    Update12.Text = "😈 Evil Karma: " .. FormatDisplay(player.evilKarma.Value)
                end
                if player:FindFirstChild("goodKarma") then
                    Update13.Text = "✨ Good Karma: " .. FormatDisplay(player.goodKarma.Value)
                end

                local leaderstats = player:FindFirstChild("leaderstats")
                if leaderstats then
                    if leaderstats:FindFirstChild("Strength") then
                        Update.Text = "💪 Strength: " .. FormatDisplay(leaderstats.Strength.Value)
                    end
                    if leaderstats:FindFirstChild("Rebirths") then
                        Update2.Text = "🔄 Rebirth: " .. FormatDisplay(leaderstats.Rebirths.Value)
                    end
                    if leaderstats:FindFirstChild("Kills") then
                        Update5.Text = "💀 Kills: " .. FormatDisplay(leaderstats.Kills.Value)
                    end
                end

                if player:FindFirstChild("currentMap") then
                    Update9.Text = "📍 Map: " .. tostring(player.currentMap.Value)
                else
                    Update9.Text = "📍 Map: Unknown"
                end

                local myStr = localPlayer.leaderstats:FindFirstChild("Strength") and localPlayer.leaderstats.Strength.Value or 1
                local tarDur = player:FindFirstChild("Durability") and player.Durability.Value or 1
                local htkCalc = math.ceil(tarDur / myStr)
                if htkCalc < 1 then htkCalc = 1 end
                UpdateHTK.Text = "🥊 Hits To Kill: " .. FormatNumberWithCommas(htkCalc)
            end
        end
    end
end)

local Rock = window:AddTab("Rock")

function gettool()
    for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if v.Name == "Punch" and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid:EquipTool(v)
        end
    end
    -- Eventleri 2 kez ateşleyerek hızı artırıyoruz
    game:GetService("Players").LocalPlayer.muscleEvent:FireServer("punch", "leftHand")
    game:GetService("Players").LocalPlayer.muscleEvent:FireServer("punch", "rightHand")
    game:GetService("Players").LocalPlayer.muscleEvent:FireServer("punch", "leftHand")
    game:GetService("Players").LocalPlayer.muscleEvent:FireServer("punch", "rightHand")
end

-- Hızlandırılmış Rock Switchleri
Rock:AddSwitch("💎 Tiny Rock 0", function(Value)
    selectrock = "Tiny Island Rock"
    getgenv().autoFarm = Value
    task.spawn(function()
        while getgenv().autoFarm do
            task.wait(0.01) -- Bekleme süresinin 
            if not getgenv().autoFarm then break end
            if game:GetService("Players").LocalPlayer.Durability.Value >= 0 then
                for i, v in pairs(game:GetService("Workspace").machinesFolder:GetDescendants()) do
                    if v.Name == "neededDurability" and v.Value == 0 and game.Players.LocalPlayer.Character:FindFirstChild("LeftHand") and game.Players.LocalPlayer.Character:FindFirstChild("RightHand") then
                        -- Vuruş hızı x3 yapıldı
                        for _ = 1, 3 do
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 0)
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 1)
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 0)
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 1)
                        end
                        gettool()
                    end
                end
            end
        end
    end)
end)

Rock:AddSwitch("🔥 Starter Rock 100", function(Value)
    selectrock = "Starter Island Rock"
    getgenv().autoFarm = Value
    task.spawn(function()
        while getgenv().autoFarm do
            task.wait(0.01)
            if not getgenv().autoFarm then break end
            if game:GetService("Players").LocalPlayer.Durability.Value >= 100 then
                for i, v in pairs(game:GetService("Workspace").machinesFolder:GetDescendants()) do
                    if v.Name == "neededDurability" and v.Value == 100 and game.Players.LocalPlayer.Character:FindFirstChild("LeftHand") and game.Players.LocalPlayer.Character:FindFirstChild("RightHand") then
                        for _ = 1, 3 do
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 0)
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 1)
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 0)
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 1)
                        end
                        gettool()
                    end
                end
            end
        end
    end)
end)

Rock:AddSwitch("🏝️ Legend Beach Rock 5K", function(Value)
    selectrock = "Legend Beach Rock"
    getgenv().autoFarm = Value
    task.spawn(function()
        while getgenv().autoFarm do
            task.wait(0.01)
            if not getgenv().autoFarm then break end
            if game:GetService("Players").LocalPlayer.Durability.Value >= 5000 then
                for i, v in pairs(game:GetService("Workspace").machinesFolder:GetDescendants()) do
                    if v.Name == "neededDurability" and v.Value == 5000 and game.Players.LocalPlayer.Character:FindFirstChild("LeftHand") and game.Players.LocalPlayer.Character:FindFirstChild("RightHand") then
                        for _ = 1, 3 do
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 0)
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 1)
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 0)
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 1)
                        end
                        gettool()
                    end
                end
            end
        end
    end)
end)

Rock:AddSwitch("❄️ Frozen Rock 150K", function(Value)
    selectrock = "Frost Gym Rock"
    getgenv().autoFarm = Value
    task.spawn(function()
        while getgenv().autoFarm do
            task.wait(0.01)
            if not getgenv().autoFarm then break end
            if game:GetService("Players").LocalPlayer.Durability.Value >= 150000 then
                for i, v in pairs(game:GetService("Workspace").machinesFolder:GetDescendants()) do
                    if v.Name == "neededDurability" and v.Value == 150000 and game.Players.LocalPlayer.Character:FindFirstChild("LeftHand") and game.Players.LocalPlayer.Character:FindFirstChild("RightHand") then
                        for _ = 1, 3 do
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 0)
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 1)
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 0)
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 1)
                        end
                        gettool()
                    end
                end
            end
        end
    end)
end)

Rock:AddSwitch("✨ Mythical Rock 400K", function(Value)
    selectrock = "Mythical Gym Rock"
    getgenv().autoFarm = Value
    task.spawn(function()
        while getgenv().autoFarm do
            task.wait(0.01)
            if not getgenv().autoFarm then break end
            if game:GetService("Players").LocalPlayer.Durability.Value >= 400000 then
                for i, v in pairs(game:GetService("Workspace").machinesFolder:GetDescendants()) do
                    if v.Name == "neededDurability" and v.Value == 400000 and game.Players.LocalPlayer.Character:FindFirstChild("LeftHand") and game.Players.LocalPlayer.Character:FindFirstChild("RightHand") then
                        for _ = 1, 3 do
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 0)
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 1)
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 0)
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 1)
                        end
                        gettool()
                    end
                end
            end
        end
    end)
end)

Rock:AddSwitch("🌀 Eternal Rock 750K", function(Value)
    selectrock = "Eternal Gym Rock"
    getgenv().autoFarm = Value
    task.spawn(function()
        while getgenv().autoFarm do
            task.wait(0.01)
            if not getgenv().autoFarm then break end
            if game:GetService("Players").LocalPlayer.Durability.Value >= 750000 then
                for i, v in pairs(game:GetService("Workspace").machinesFolder:GetDescendants()) do
                    if v.Name == "neededDurability" and v.Value == 750000 and game.Players.LocalPlayer.Character:FindFirstChild("LeftHand") and game.Players.LocalPlayer.Character:FindFirstChild("RightHand") then
                        for _ = 1, 3 do
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 0)
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 1)
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 0)
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 1)
                        end
                        gettool()
                    end
                end
            end
        end
    end)
end)

Rock:AddSwitch("🏆 Legend Rock 1M", function(Value)
    selectrock = "Legend Gym Rock"
    getgenv().autoFarm = Value
    task.spawn(function()
        while getgenv().autoFarm do
            task.wait(0.01)
            if not getgenv().autoFarm then break end
            if game:GetService("Players").LocalPlayer.Durability.Value >= 1000000 then
                for i, v in pairs(game:GetService("Workspace").machinesFolder:GetDescendants()) do
                    if v.Name == "neededDurability" and v.Value == 1000000 and game.Players.LocalPlayer.Character:FindFirstChild("LeftHand") and game.Players.LocalPlayer.Character:FindFirstChild("RightHand") then
                        for _ = 1, 3 do
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 0)
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 1)
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 0)
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 1)
                        end
                        gettool()
                    end
                end
            end
        end
    end)
end)

Rock:AddSwitch("👑 Muscle King Rock 5M", function(Value)
    selectrock = "Muscle King Gym Rock"
    getgenv().autoFarm = Value
    task.spawn(function()
        while getgenv().autoFarm do
            task.wait(0.01)
            if not getgenv().autoFarm then break end
            if game:GetService("Players").LocalPlayer.Durability.Value >= 5000000 then
                for i, v in pairs(game:GetService("Workspace").machinesFolder:GetDescendants()) do
                    if v.Name == "neededDurability" and v.Value == 5000000 and game.Players.LocalPlayer.Character:FindFirstChild("LeftHand") and game.Players.LocalPlayer.Character:FindFirstChild("RightHand") then
                        for _ = 1, 3 do
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 0)
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 1)
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 0)
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 1)
                        end
                        gettool()
                    end
                end
            end
        end
    end)
end)

Rock:AddSwitch("🌳 Jungle Rock 10M", function(Value)
    selectrock = "Ancient Jungle Rock"
    getgenv().autoFarm = Value
    task.spawn(function()
        while getgenv().autoFarm do
            task.wait(0.01)
            if not getgenv().autoFarm then break end
            if game:GetService("Players").LocalPlayer.Durability.Value >= 10000000 then
                for i, v in pairs(game:GetService("Workspace").machinesFolder:GetDescendants()) do
                    if v.Name == "neededDurability" and v.Value == 10000000 and game.Players.LocalPlayer.Character:FindFirstChild("LeftHand") and game.Players.LocalPlayer.Character:FindFirstChild("RightHand") then
                        for _ = 1, 3 do
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 0)
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.RightHand, 1)
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 0)
                            firetouchinterest(v.Parent.Rock, game:GetService("Players").LocalPlayer.Character.LeftHand, 1)
                        end
                        gettool()
                    end
                end
            end
        end
    end)
end)

local pets = window:AddTab("Pets")
pets:AddLabel("💰 Auto Buy")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local selectedPet = "Neon Guardian"
local petDropdown = pets:AddDropdown("Select Pet", function(text)
    selectedPet = text
end)

petDropdown:Add("Neon Guardian")
petDropdown:Add("Blue Birdie")
petDropdown:Add("Blue Bunny")
petDropdown:Add("Blue Firecaster")
petDropdown:Add("Blue Pheonix")
petDropdown:Add("Crimson Falcon")
petDropdown:Add("Cybernetic Showdown Dragon")
petDropdown:Add("Dark Golem")
petDropdown:Add("Dark Legends Manticore")
petDropdown:Add("Dark Vampy")
petDropdown:Add("Darkstar Hunter")
petDropdown:Add("Eternal Strike Leviathan")
petDropdown:Add("Frostwave Legends Penguin")
petDropdown:Add("Gold Warrior")
petDropdown:Add("Golden Pheonix")
petDropdown:Add("Golden Viking")
petDropdown:Add("Green Butterfly")
petDropdown:Add("Green Firecaster")
petDropdown:Add("Infernal Dragon")
petDropdown:Add("Lightning Strike Phantom")
petDropdown:Add("Magic Butterfly")
petDropdown:Add("Muscle Sensei")
petDropdown:Add("Orange Hedgehog")
petDropdown:Add("Orange Pegasus")
petDropdown:Add("Phantom Genesis Dragon")
petDropdown:Add("Purple Dragon")
petDropdown:Add("Purple Falcon")
petDropdown:Add("Red Dragon")
petDropdown:Add("Red Firecaster")
petDropdown:Add("Red Kitty")
petDropdown:Add("Silver Dog")
petDropdown:Add("Ultimate Supernova Pegasus")
petDropdown:Add("Ultra Birdie")
petDropdown:Add("White Pegasus")
petDropdown:Add("White Pheonix")
petDropdown:Add("Yellow Butterfly")

pets:AddSwitch("Auto Open Pet", function(bool)
    _G.AutoHatchPet = bool
    if bool then
        spawn(function()
            while _G.AutoHatchPet and selectedPet ~= "" do
                local petToOpen = ReplicatedStorage.cPetShopFolder:FindFirstChild(selectedPet)
                if petToOpen then
                    ReplicatedStorage.cPetShopRemote:InvokeServer(petToOpen)
                end
                task.wait(0.1)
            end
        end)
    end
end)

local selectedAura = "Blue Aura"
local auraDropdown = pets:AddDropdown("Select Aura", function(text)
    selectedAura = text
end)

auraDropdown:Add("Entropic Blast")
auraDropdown:Add("Azure Tundra")
auraDropdown:Add("Blue Aura")
auraDropdown:Add("Dark Electro")
auraDropdown:Add("Dark Lightning")
auraDropdown:Add("Dark Storm")
auraDropdown:Add("Electro")
auraDropdown:Add("Enchanted Mirage")
auraDropdown:Add("Astral Electro")
auraDropdown:Add("Eternal Megastrike")
auraDropdown:Add("Grand Supernova")
auraDropdown:Add("Green Aura")
auraDropdown:Add("Inferno")
auraDropdown:Add("Lightning")
auraDropdown:Add("Muscle King")
auraDropdown:Add("Power Lightning")
auraDropdown:Add("Purple Aura")
auraDropdown:Add("Purple Nova")
auraDropdown:Add("Red Aura")
auraDropdown:Add("Supernova")
auraDropdown:Add("Ultra Inferno")
auraDropdown:Add("Ultra Mirage")
auraDropdown:Add("Unstable Mirage")
auraDropdown:Add("Yellow Aura")

pets:AddSwitch("Auto Open Aura", function(bool)
    _G.AutoHatchAura = bool
    if bool then
        spawn(function()
            while _G.AutoHatchAura and selectedAura ~= "" do
                local auraToOpen = ReplicatedStorage.cPetShopFolder:FindFirstChild(selectedAura)
                if auraToOpen then
                    ReplicatedStorage.cPetShopRemote:InvokeServer(auraToOpen)
                end
                task.wait(0.1)
            end
        end)
    end
end)

pets:AddLabel("----------------------------")
pets:AddLabel("✨ Auto Evolve Pet")

local pets = pets
local selectedEvolvePet = ""
local autoEvolvePet = false

local evolvePetDropdown = pets:AddDropdown("Select Pet to Evolve", function(text)
    selectedEvolvePet = text
end)

evolvePetDropdown:Add("Blue Birdie (Basic)")
evolvePetDropdown:Add("Orange Hedgehog (Basic)")
evolvePetDropdown:Add("Red Kitty (Basic)")
evolvePetDropdown:Add("Blue Bunny (Basic)")
evolvePetDropdown:Add("Silver Dog (Basic)")
evolvePetDropdown:Add("Dark Vampy (Advanced)")
evolvePetDropdown:Add("Dark Golem (Advanced)")
evolvePetDropdown:Add("Green Butterfly (Advanced)")
evolvePetDropdown:Add("Yellow Butterfly (Advanced)")
evolvePetDropdown:Add("Crimson Falcon (Rare)")
evolvePetDropdown:Add("Purple Dragon (Rare)")
evolvePetDropdown:Add("Orange Pegasus (Rare)")
evolvePetDropdown:Add("Purple Falcon (Rare)")
evolvePetDropdown:Add("Red Dragon (Rare)")
evolvePetDropdown:Add("White Pegasus (Rare)")
evolvePetDropdown:Add("Frostwave Legends Penguin (Rare)")
evolvePetDropdown:Add("Phantom Genesis Dragon (Rare)")
evolvePetDropdown:Add("Eternal Strike Leviathan (Rare)")
evolvePetDropdown:Add("Blue Pheonix (Epic)")
evolvePetDropdown:Add("Blue Firecaster (Epic)")
evolvePetDropdown:Add("Golden Pheonix (Epic)")
evolvePetDropdown:Add("Red Firecaster (Epic)")
evolvePetDropdown:Add("Green Firecaster (Epic)")
evolvePetDropdown:Add("White Pheonix (Epic)")
evolvePetDropdown:Add("Dark Legends Manticore (Epic)")
evolvePetDropdown:Add("Ultimate Supernova Pegasus (Epic)")
evolvePetDropdown:Add("Lightning Strike Phantom (Epic)")
evolvePetDropdown:Add("Golden Viking (Epic)")
evolvePetDropdown:Add("Infernal Dragon (Unique)")
evolvePetDropdown:Add("Ultra Birdie (Unique)")
evolvePetDropdown:Add("Magic Butterfly (Unique)")
evolvePetDropdown:Add("Aether Spirit Bunny (Unique)")
evolvePetDropdown:Add("Cybernetic Showdown Dragon (Unique)")
evolvePetDropdown:Add("Darkstar Hunter (Unique)")
evolvePetDropdown:Add("Muscle Sensei (Unique)")
evolvePetDropdown:Add("Neon Guardian (Unique)")
evolvePetDropdown:Add("Blue Aura (Basic)")
evolvePetDropdown:Add("Green Aura (Basic)")
evolvePetDropdown:Add("Purple Aura (Basic)")
evolvePetDropdown:Add("Red Aura (Basic)")
evolvePetDropdown:Add("Yellow Aura (Basic)")
evolvePetDropdown:Add("Ultra Inferno (Rare)")
evolvePetDropdown:Add("Azure Tundra (Epic)")
evolvePetDropdown:Add("Grand Supernova (Epic)")
evolvePetDropdown:Add("Muscle King (Unique)")
evolvePetDropdown:Add("Entropic Blast (Unique)")
evolvePetDropdown:Add("Eternal Megastrike (Unique)")

pets:AddSwitch("🎯 Auto Evolve Selected Pet", function(state)
    autoEvolvePet = state
    if state then
        if selectedEvolvePet == "" then
            return
        end
        local petName = selectedEvolvePet:match("^(.-)%s*%(")
        if not petName then
            petName = selectedEvolvePet
        end
        task.spawn(function()
            local maxAttempts = 1000
            while autoEvolvePet do
                pcall(function()
                    game:GetService("ReplicatedStorage").rEvents.petEvolveEvent:FireServer(
                        "evolvePet",
                        petName
                    )
                end)
                task.wait(0.5)
                if maxAttempts <= 0 then
                    autoEvolvePet = false
                    break
                end
                maxAttempts = maxAttempts - 1
            end
        end)
    end
end)

pets:AddButton("⚡ Quick Evolve (1x)", function()
    if selectedEvolvePet == "" then
        return
    end
    local petName = selectedEvolvePet:match("^(.-)%s*%(")
    if not petName then
        petName = selectedEvolvePet
    end
    pcall(function()
        game:GetService("ReplicatedStorage").rEvents.petEvolveEvent:FireServer(
            "evolvePet",
            petName
        )
    end)
end)

pets:AddButton("💥 Quick Evolve (10x)", function()
    if selectedEvolvePet == "" then
        return
    end
    local petName = selectedEvolvePet:match("^(.-)%s*%(")
    if not petName then
        petName = selectedEvolvePet
    end
    for i = 1, 10 do
        pcall(function()
            game:GetService("ReplicatedStorage").rEvents.petEvolveEvent:FireServer(
                "evolvePet",
                petName
            )
        end)
        task.wait(0.1)
    end
end)

local running = false
local selectedTarget = nil
local selectedPet = nil

pets:AddLabel("----------------------------")
pets:AddLabel("💎 Trade System")

local playerDropdown = pets:AddDropdown("Choose Player", function(name)
    local username = name:match(" | (.+)") or name
    selectedTarget = game:GetService("Players"):FindFirstChild(username)
end)

local function updatePlayerList(p)
    if p ~= game:GetService("Players").LocalPlayer then
        playerDropdown:Add(p.DisplayName .. " | " .. p.Name)
    end
end

for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
    updatePlayerList(player)
end

game:GetService("Players").PlayerAdded:Connect(updatePlayerList)

local petDropdown = pets:AddDropdown("Choose Pet", function(text) 
    selectedPet = text 
end)

local petList = {
    "Blue Birdie", "Orange Hedgehog", "Red Kitty", "Blue Bunny", "Silver Dog",
    "Dark Vampy", "Dark Golem", "Green Butterfly", "Yellow Butterfly",
    "Crimson Falcon", "Purple Dragon", "Orange Pegasus", "Purple Falcon", "Red Dragon",
    "White Pegasus", "Frostwave Legends Penguin", "Phantom Genesis Dragon", "Eternal Strike Leviathan",
    "Blue Pheonix", "Blue Firecaster", "Golden Pheonix", "Red Firecaster", "Green Firecaster",
    "White Pheonix", "Dark Legends Manticore", "Ultimate Supernova Pegasus", "Lightning Strike Phantom", "Golden Viking",
    "Infernal Dragon", "Ultra Birdie", "Magic Butterfly", "Aether Spirit Bunny",
    "Cybernetic Showdown Dragon", "Darkstar Hunter", "Muscle Sensei", "Neon Guardian"
}

for _, name in ipairs(petList) do 
    petDropdown:Add(name) 
end

pets:AddSwitch("Auto Trade", function(state)
    running = state
    if not state then return end

    task.spawn(function()
        while running do
            if selectedTarget and selectedPet then
                local tradingEvent = game:GetService("ReplicatedStorage").rEvents.tradingEvent
                local localPlayer = game:GetService("Players").LocalPlayer
                local pf = localPlayer:FindFirstChild("petsFolder")

                if pf then
                    local folders = {
                        pf:FindFirstChild("Basic"),
                        pf:FindFirstChild("Advanced"),
                        pf:FindFirstChild("Rare"),
                        pf:FindFirstChild("Epic"),
                        pf:FindFirstChild("Unique")
                    }

                    tradingEvent:FireServer("sendTradeRequest", selectedTarget)
                    task.wait(1.5) 

                    local offered = 0
                    
                    for _, folder in ipairs(folders) do
                        if folder and running and offered < 6 then
                            local petsToOffer = folder:GetChildren()
                            for i = 1, #petsToOffer do
                                local pet = petsToOffer[i]
                                if not running or offered >= 6 then break end

                                if pet.Name == selectedPet then
                                    tradingEvent:FireServer("offerItem", pet)
                                    offered = offered + 1
                                    task.wait(0.5) 
                                end
                            end
                        end
                    end

                    task.wait(1.2) 

                    if running then
                        tradingEvent:FireServer("acceptTrade")
                    end
                end
            end
            task.wait(2.5) 
        end
    end)
end)

local GymTab = window:AddTab("Gym")

local VIM = game:GetService("VirtualInputManager")
local function pressEKey()
    VIM:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    task.wait(0.05)
    VIM:SendKeyEvent(false, Enum.KeyCode.E, false, game)
end

local function createFarm(folder, toggleName, cframeValue, eventName)
    local active = false
    folder:AddSwitch(toggleName, function(bool)
        active = bool
        if bool then
            task.spawn(function()
                while active do
                    local char = game.Players.LocalPlayer.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    if root then
                        if (root.Position - cframeValue.p).Magnitude > 5 then
                            root.CFrame = cframeValue
                            task.wait(0.3)
                            pressEKey()
                        end
                        local event = game:GetService("Players").LocalPlayer:FindFirstChild("muscleEvent")
                        if event then
                            event:FireServer(eventName)
                        end
                    end
                    task.wait(0.05)
                end
            end)
        end
    end)
end

-- 1. JUNGLE GYM
local JungleFolder = GymTab:AddFolder("Jungle Gym")
createFarm(JungleFolder, "🏋️ Auto Jungle Lift", CFrame.new(-8652.85, 45.22, 2088.99), "rep")
createFarm(JungleFolder, "💪 Auto Bench Press", CFrame.new(-8173.23, 83.82, 1907.40), "rep")
createFarm(JungleFolder, "🦵 Auto Squat", CFrame.new(-8377.55, 48.71, 2864.90), "rep")
createFarm(JungleFolder, "Auto Boulder", CFrame.new(-8614.81, 51.90, 2677.37), "rep")

-- 2. MUSCLE KING
local MuscleKingFolder = GymTab:AddFolder("Muscle King")
createFarm(MuscleKingFolder, "🏋️ Auto Lift", CFrame.new(-8774.03, 52.15, -5664.10), "rep")
createFarm(MuscleKingFolder, "💪 Auto Bench Press", CFrame.new(-8589.43, 58.00, -6044.57), "rep")
createFarm(MuscleKingFolder, "🦵 Auto Squat", CFrame.new(-8759.62, 46.50, -6041.16), "rep")
createFarm(MuscleKingFolder, "Auto Boulder", CFrame.new(-8942.97, 60.71, -5692.74), "rep")

-- 3. LEGENDS GYM
local LegendsFolder = GymTab:AddFolder("Legends Gym")
createFarm(LegendsFolder, "🏋️ Auto Lift", CFrame.new(4532.02, 1025.80, -4002.15), "rep")
createFarm(LegendsFolder, "💪 Auto Bench Press", CFrame.new(4109.20, 1035.67, -3802.88), "rep")
createFarm(LegendsFolder, "🦵 Auto Squat", CFrame.new(4438.74, 1021.38, -4058.46), "rep")
createFarm(LegendsFolder, "Auto Boulder", CFrame.new(4188.75, 1019.85, -3905.19), "rep")

-- 4. MYTHICAL GYM
local MythicalFolder = GymTab:AddFolder("Mythical Gym")
createFarm(MythicalFolder, "🏋️ Auto Lift", CFrame.new(2486.75, 31.91, 847.89), "rep")
createFarm(MythicalFolder, "💪 Auto Bench Press", CFrame.new(2370.74, 57.09, 1243.37), "rep")
createFarm(MythicalFolder, "Auto Boulder", CFrame.new(2667.31, 58.88, 1202.46), "rep")

-- 5. FROST GYM
local FrostFolder = GymTab:AddFolder("Frost Gym")
createFarm(FrostFolder, "🏋️ Auto Lift", CFrame.new(-2917.62, 42.60, -211.29), "rep")
createFarm(FrostFolder, "💪 Auto Bench Press", CFrame.new(-3022.97, 41.31, -197.51), "rep")
createFarm(FrostFolder, "🦵 Auto Squat", CFrame.new(-2720.66, 27.85, -590.72), "rep")

local Misc = window:AddTab("Misc")

Misc:AddButton("🚀 FPS Booster", function()
    local lighting = game:GetService("Lighting")
    local terrain = game:GetService("Workspace"):FindFirstChildOfClass('Terrain')

    -- Güneş ışığını ve gölgeleri hafiflet (Kapatmaz, sadece azaltır)
    lighting.Brightness = 0.5
    lighting.OutdoorAmbient = Color3.fromRGB(120, 120, 120)
    lighting.Ambient = Color3.fromRGB(120, 120, 120)
    lighting.ClockTime = 14

    -- Su detaylarını optimize et
    if terrain then
        terrain.WaterWaveSize = 0
        terrain.WaterWaveSpeed = 0
        terrain.WaterReflectance = 0
    end
    
    -- Partikülleri ve gereksiz efektleri temizle
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Enabled = false
        elseif v:IsA("BlurEffect") or v:IsA("SunRaysEffect") then
            v.Enabled = false
        end
    end

    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Syniox Hub",
        Text = "FPS Boosted & Lighting Balanced!",
        Duration = 3
    })
end)

Misc:AddSwitch("⏳ Anti Afk", function(Value)
    if Value then
        _G.AntiAfkActive = true
        
        -- Anti-AFK Mekanizması
        local vu = game:GetService("VirtualUser")
        antiAfkConnection = game:GetService("Players").LocalPlayer.Idled:Connect(function()
            if _G.AntiAfkActive then
                vu:CaptureController()
                vu:ClickButton2(Vector2.new())
            end
        end)

        -- GUI Oluşturma
        local ScreenGui = Instance.new("ScreenGui")
        local MainFrame = Instance.new("Frame")
        local UICorner = Instance.new("UICorner")
        local Title = Instance.new("TextLabel")
        local Separator = Instance.new("Frame")
        local TimerLabel = Instance.new("TextLabel")
        local FPSLabel = Instance.new("TextLabel")
        local MSLabel = Instance.new("TextLabel")
        local UIStroke = Instance.new("UIStroke")

        ScreenGui.Name = "Syniox_AntiAFK"
        ScreenGui.Parent = game:GetService("CoreGui")
        
        MainFrame.Parent = ScreenGui
        MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) 
        MainFrame.BackgroundTransparency = 0.1
        MainFrame.Position = UDim2.new(0.05, 0, 0.4, 0)
        MainFrame.Size = UDim2.new(0, 120, 0, 125)
        MainFrame.Active = true
        MainFrame.Draggable = true 

        UICorner.CornerRadius = UDim.new(0, 8)
        UICorner.Parent = MainFrame

        UIStroke.Parent = MainFrame
        UIStroke.Color = Color3.fromRGB(150, 0, 0) 
        UIStroke.Thickness = 1.5

        Title.Parent = MainFrame
        Title.Size = UDim2.new(1, 0, 0, 28)
        Title.Text = "Syniox Anti-Afk" 
        Title.TextColor3 = Color3.fromRGB(200, 0, 0)
        Title.BackgroundTransparency = 1
        Title.TextSize = 15
        Title.Font = Enum.Font.SourceSansBold

        Separator.Parent = MainFrame
        Separator.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        Separator.BorderSizePixel = 0
        Separator.Position = UDim2.new(0.1, 0, 0, 28)
        Separator.Size = UDim2.new(0.8, 0, 0, 1)

        local function SetupLabel(lbl, text, pos)
            lbl.Parent = MainFrame
            lbl.Position = pos
            lbl.Size = UDim2.new(1, 0, 0, 25)
            lbl.Text = text
            lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
            lbl.BackgroundTransparency = 1
            lbl.TextSize = 16
            lbl.Font = Enum.Font.SourceSansBold
            lbl.TextXAlignment = Enum.TextXAlignment.Center
        end

        SetupLabel(TimerLabel, "⏳ Time: 00:00:00", UDim2.new(0, 0, 0, 35))
        SetupLabel(FPSLabel, "🚀 FPS: 0", UDim2.new(0, 0, 0, 62))
        SetupLabel(MSLabel, "📡 MS: 0", UDim2.new(0, 0, 0, 89))

        -- Güncelleme Döngüsü (Geliştirilmiş)
        local startTime = os.time()
        local RunService = game:GetService("RunService")
        local Stats = game:GetService("Stats")
        
        task.spawn(function()
            while _G.AntiAfkActive do
                -- Zaman hesaplama
                local diff = os.time() - startTime
                TimerLabel.Text = string.format("⏳ Time: %02d:%02d:%02d", math.floor(diff/3600), math.floor((diff%3600)/60), diff%60)
                
                -- FPS Hesaplama (RenderStepped ile en doğru sonucu verir)
                local fps = math.floor(1 / RunService.RenderStepped:Wait())
                FPSLabel.Text = "🚀 FPS: " .. fps
                
                -- Ping (MS) Hesaplama
                local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
                MSLabel.Text = "📡 MS: " .. ping
                
                task.wait(0.5) -- Her yarım saniyede bir güncelle (Performans için)
            end
        end)

    else
        _G.AntiAfkActive = false
        if antiAfkConnection then antiAfkConnection:Disconnect() end
        local oldGui = game:GetService("CoreGui"):FindFirstChild("Syniox_AntiAFK")
        if oldGui then oldGui:Destroy() end
    end
end)

local switch = Misc:AddSwitch("🔒 Lock Position", function(Value)
    if Value then
        
        local currentPos = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        getgenv().posLock = game:GetService("RunService").Heartbeat:Connect(function()
            if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = currentPos
            end
        end)
    else
        
        if getgenv().posLock then
            getgenv().posLock:Disconnect()
            getgenv().posLock = nil
        end
    end
end)

Misc:AddSwitch("🎰 Auto Fortune Wheel", function(Value)
    _G.autoFortuneWheelActive = Value
    if Value then
        local function openFortuneWheel()
            while _G.autoFortuneWheelActive do
                local args = {
                    [1] = "openFortuneWheel",
                    [2] = game:GetService("ReplicatedStorage"):WaitForChild("fortuneWheelChances"):WaitForChild("Fortune Wheel")
                }
                game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("openFortuneWheelRemote"):InvokeServer(unpack(args))
                wait(0)
            end
        end
        coroutine.wrap(openFortuneWheel)()
    else
        _G.autoFortuneWheelActive = false
    end
end)

local timeDropdown = Misc:AddDropdown("Change Time", function(selection)
    local lighting = game:GetService("Lighting")
    
    if selection == "Night" then
        lighting.ClockTime = 0
    elseif selection == "Day" then
        lighting.ClockTime = 12
    elseif selection == "Midnight" then
        lighting.ClockTime = 6
    end
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Changed Time",
        Text = "the time has been changed: " .. selection,
        Duration = 0
    })
end)

timeDropdown:Add("Night")
timeDropdown:Add("Day")
timeDropdown:Add("Midnight")

local scriptFolder = Misc:AddFolder("📜 External Scripts")

scriptFolder:AddButton("⚡ Infinite Yield", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Syniox Hub",
        Text = "Infinite Yield Loaded!",
        Duration = 3
    })
end)

scriptFolder:AddButton("🕺 Emote Script", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/7yd7/Hub/refs/heads/Branch/GUIS/Emotes.lua"))()
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Syniox Hub V2",
        Text = "Emote Script Activated!",
        Duration = 5
    })
end)

Misc:AddSwitch("🌊 Full Walk on Water", function(bool)
    if bool then
        createParts()
    else
        makePartsWalkthrough()
    end
end)

local autoEatBoostsEnabled = false

local boostsList = {
    "ULTRA Shake",
    "TOUGH Bar",
    "Protein Shake",
    "Energy Shake",
    "Protein Bar",
    "Energy Bar",
}

local function eatAllBoosts()
    local player = game.Players.LocalPlayer
    local backpack = player:WaitForChild("Backpack")
    local character = player.Character or player.CharacterAdded:Wait()

    for _, boostName in ipairs(boostsList) do
        local boost = backpack:FindFirstChild(boostName)
        while boost do
            boost.Parent = character
            pcall(function()
                boost:Activate()
            end)
            task.wait(0)
            boost = backpack:FindFirstChild(boostName)
        end
    end
end

task.spawn(function()
    while true do
        if autoEatBoostsEnabled then
            eatAllBoosts()
            task.wait(2)
        else
            task.wait(1)
        end
    end
end)

Misc:AddSwitch("🍴 Auto Eat All (No Egg)", function(state)
    autoEatBoostsEnabled = state
end)

Misc:AddSwitch("⬆️ Infinite Jump", function(state)
    getgenv().InfiniteJump = state
    game:GetService("UserInputService").JumpRequest:connect(function()
        if getgenv().InfiniteJump then
            local Humanoid = game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if Humanoid then
                Humanoid:ChangeState("Jumping")
            end
        end
    end)
end)

Misc:AddButton("🔄 Rejoin Game", function()
    local ScreenGui = Instance.new("ScreenGui")
    local Frame = Instance.new("Frame")
    local TextLabel = Instance.new("TextLabel")
    local YesButton = Instance.new("TextButton")
    local NoButton = Instance.new("TextButton")
    local UICorner = Instance.new("UICorner")

    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.Name = "RejoinConfirm"

    Frame.Name = "MainFrame"
    Frame.Parent = ScreenGui
    Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Frame.Position = UDim2.new(0.5, -125, 0.5, -75)
    Frame.Size = UDim2.new(0, 250, 0, 150)
    Frame.BorderSizePixel = 0
    Frame.Active = true
    Frame.Draggable = true 
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)

    TextLabel.Parent = Frame
    TextLabel.BackgroundTransparency = 1
    TextLabel.Position = UDim2.new(0, 10, 0, 20)
    TextLabel.Size = UDim2.new(0, 230, 0, 50)
    TextLabel.Font = Enum.Font.GothamBold
    TextLabel.Text = "Are you sure you want to rejoin?"
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.TextSize = 16
    TextLabel.TextWrapped = true

    YesButton.Name = "YesButton"
    YesButton.Parent = Frame
    YesButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0) -- SUCCESS butonundaki yeşil tonu
    YesButton.Position = UDim2.new(0, 25, 0, 90)
    YesButton.Size = UDim2.new(0, 85, 0, 35)
    YesButton.Font = Enum.Font.GothamBold
    YesButton.Text = "YES"
    YesButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    YesButton.TextSize = 14
    Instance.new("UICorner", YesButton).CornerRadius = UDim.new(0, 6)

    NoButton.Name = "NoButton"
    NoButton.Parent = Frame
    NoButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0) -- GET KEY butonundaki kırmızı tonu
    NoButton.Position = UDim2.new(0, 140, 0, 90)
    NoButton.Size = UDim2.new(0, 85, 0, 35)
    NoButton.Font = Enum.Font.GothamBold
    NoButton.Text = "NO"
    NoButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    NoButton.TextSize = 14
    Instance.new("UICorner", NoButton).CornerRadius = UDim.new(0, 6)

    YesButton.MouseButton1Click:Connect(function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
    end)

    NoButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
end)

Misc:AddSwitch("🧱 Anti Knockback", function(Value)
    if Value then
        local playerName = game.Players.LocalPlayer.Name
        local rootPart = game.Workspace:FindFirstChild(playerName):FindFirstChild("HumanoidRootPart")
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(100000, 0, 100000)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.P = 1250
        bodyVelocity.Parent = rootPart
    else
        local playerName = game.Players.LocalPlayer.Name
        local rootPart = game.Workspace:FindFirstChild(playerName):FindFirstChild("HumanoidRootPart")
        local existingVelocity = rootPart:FindFirstChild("BodyVelocity")
        if existingVelocity and existingVelocity.MaxForce == Vector3.new(100000, 0, 100000) then
            existingVelocity:Destroy()
        end
    end
end)

local teleport = window:AddTab("Teleport")

teleport:AddButton("📍Spawn", function()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    humanoidRootPart.CFrame = CFrame.new(2, 8, 115)
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Teletransporte",
        Text = "Teleported to Spawn",
        Duration = 0
    })
end)

teleport:AddButton("📍Secret Area", function()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    humanoidRootPart.CFrame = CFrame.new(1947, 2, 6191)
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Teletransporte",
        Text = "Teleported to Secret Area",
        Duration = 0
    })
end)

teleport:AddButton("📍Tiny Island", function()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    humanoidRootPart.CFrame = CFrame.new(-34, 7, 1903)
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Teletransporte",
        Text = "Teleported to Tiny Island",
        Duration = 0
    })
end)

teleport:AddButton("📍Frozen Island", function()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    humanoidRootPart.CFrame = CFrame.new(- 2600.00244, 3.67686558, - 403.884369, 0.0873617008, 1.0482899e-09, 0.99617666, 3.07204253e-08, 1, - 3.7464023e-09, - 0.99617666, 3.09302628e-08, 0.0873617008)
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Teletransporte",
        Text = "Teleported to Frozen Island",
        Duration = 0
    })
end)

teleport:AddButton("📍Mythical Island", function()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    humanoidRootPart.CFrame = CFrame.new(2255, 7, 1071)
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Teletransporte",
        Text = "Teleported to Mythical Island",
        Duration = 0
    })
end)

teleport:AddButton("📍Hell Island", function()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    humanoidRootPart.CFrame = CFrame.new(-6768, 7, -1287)
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Teletransporte",
        Text = "Teleported to Hell Island",
        Duration = 0
    })
end)

teleport:AddButton("📍Legend Island", function()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    humanoidRootPart.CFrame = CFrame.new(4604, 991, -3887)
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Teletransporte",
        Text = "Teleported to Legend Island",
        Duration = 0
    })
end)

teleport:AddButton("📍Muscle King Island", function()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    humanoidRootPart.CFrame = CFrame.new(-8646, 17, -5738)
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Teletransporte",
        Text = "Teleported to Muscle King",
        Duration = 0
    })
end)

teleport:AddButton("📍Jungle Island", function()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    humanoidRootPart.CFrame = CFrame.new(-8659, 6, 2384)
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Teletransporte",
        Text = "Teleported to Jungle Island",
        Duration = 0
    })
end)

teleport:AddButton("📍Brawl Lava", function()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    humanoidRootPart.CFrame = CFrame.new(4471, 119, -8836)
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Teletransporte",
        Text = "Teleported to Brawl Lava",
        Duration = 0
    })
end)

teleport:AddButton("📍Brawl Desert", function()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    humanoidRootPart.CFrame = CFrame.new(960, 17, -7398)
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Teletransporte",
        Text = "Teleported to Brawl Desert",
        Duration = 0
    })
end)

teleport:AddButton("📍Brawl Regular", function()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    humanoidRootPart.CFrame = CFrame.new(-1849, 20, -6335)
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Teletransporte",
        Text = "Teleported to Brawl Regular",
        Duration = 0
    })
end)

local credits = window:AddTab("Credits")

credits:AddLabel("✨ Syniox Hub V2")
credits:AddLabel("👤 Developer: Yusuf")
credits:AddLabel("--------------------------")
credits:AddLabel("🤝 Special Thanks to: Halis & Henne")
credits:AddLabel("❤️ Thanks for the support!")
credits:AddLabel("--------------------------")
credits:AddLabel("🙏 Thank you for using Syniox Hub!")
credits:AddLabel("👇 My Discord Server Link Here")
credits:AddButton("Discord Link", function()
    setclipboard("https://discord.gg/DbAU5Z6HPd")
end)
