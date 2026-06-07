-- Phoenix Hub – Auto Farm & Race Progression for Blox Fruits
-- Based on open‑source research / NO KEYS / Works on PC & Mobile

repeat wait() until game:IsLoaded()

-- ================= USER CONFIGURATION =================
local Settings = {
    JoinTeam          = "Pirates",
    SafeMode          = true,
    AntiAFK           = true,
    AutoRedeemCodes   = true,
    TeleportDelay     = 1,
    MobAuraRange      = 35,
    StatMelee         = 50,
    StatDefense       = 25,
    StatSword         = 25,
    StatFruit         = 0,
    StatGun           = 0,
}
-- =====================================================

local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")

-- GUI Library (Rayfield)
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()
local Window = Rayfield:CreateWindow({
    Name = "Phoenix Hub – Blox Fruits",
    Icon = 0,
    LoadingTitle = "Phoenix Hub",
    LoadingSubtitle = "Auto Farm & Progression",
    Theme = "Dark",
    KeySystem = false,
    ConfigurationSaving = { Enabled = true, FileName = "PhoenixHub_Config" },
})

-- ================= Main Auto Farm Tab =================
local MainTab = Window:CreateTab("Auto Farm")
local AutoFarmEnabled = false
local CurrentTarget = nil

local function getBestQuest()
    local level = Player.Data.Level.Value
    local quests = {
        [1]  = { Name = "Bandit Quest",    Npc = "Quest Bandit",    MinLevel = 1,     MaxLevel = 10,    Mob = "Bandit",       MobLevel = 5 },
        [2]  = { Name = "Monkey Quest",    Npc = "Quest Monkey",    MinLevel = 15,    MaxLevel = 30,    Mob = "Monkey",       MobLevel = 20 },
        [3]  = { Name = "Gorilla Quest",   Npc = "Quest Gorilla",   MinLevel = 30,    MaxLevel = 50,    Mob = "Gorilla",      MobLevel = 40 },
        [4]  = { Name = "Pirate Quest",    Npc = "Quest Pirate",    MinLevel = 50,    MaxLevel = 75,    Mob = "Pirate",       MobLevel = 60 },
        [5]  = { Name = "Brute Quest",     Npc = "Quest Brute",     MinLevel = 75,    MaxLevel = 100,   Mob = "Brute",        MobLevel = 85 },
        [6]  = { Name = "Desert Bandit",   Npc = "Quest Desert",    MinLevel = 100,   MaxLevel = 125,   Mob = "Desert Bandit",MobLevel = 110 },
        [7]  = { Name = "Snow Bandit",     Npc = "Quest Snow",      MinLevel = 125,   MaxLevel = 150,   Mob = "Snow Bandit",  MobLevel = 135 },
        [8]  = { Name = "Chief Petty",     Npc = "Quest Marine",    MinLevel = 150,   MaxLevel = 200,   Mob = "Marine",       MobLevel = 175 },
        [9]  = { Name = "Sky Bandit",      Npc = "Quest Sky",       MinLevel = 200,   MaxLevel = 275,   Mob = "Sky Bandit",   MobLevel = 240 },
        [10] = { Name = "Prisoner",        Npc = "Quest Prison",    MinLevel = 275,   MaxLevel = 350,   Mob = "Prisoner",     MobLevel = 310 },
        [11] = { Name = "Galley Pirate",   Npc = "Quest Galley",    MinLevel = 350,   MaxLevel = 450,   Mob = "Galley Pirate",MobLevel = 400 },
        [12] = { Name = "Military Spy",    Npc = "Quest Spy",       MinLevel = 450,   MaxLevel = 550,   Mob = "Spy",          MobLevel = 500 },
        [13] = { Name = "Ship Deckhand",   Npc = "Quest Deckhand",  MinLevel = 550,   MaxLevel = 625,   Mob = "Deckhand",     MobLevel = 585 },
        [14] = { Name = "Factory Staff",   Npc = "Quest Factory",   MinLevel = 625,   MaxLevel = 700,   Mob = "Staff",        MobLevel = 660 },
        [15] = { Name = "Lab Subordinate", Npc = "Quest Lab",       MinLevel = 700,   MaxLevel = 800,   Mob = "Subordinate",  MobLevel = 750 },
        [16] = { Name = "Dangerous Pirate",Npc = "Quest Dangerous", MinLevel = 800,   MaxLevel = 900,   Mob = "Dangerous",    MobLevel = 850 },
        [17] = { Name = "Terrorshark",     Npc = "Quest Terror",    MinLevel = 900,   MaxLevel = 1000,  Mob = "Terrorshark",  MobLevel = 950 },
        [18] = { Name = "Pirate Millionaire",Npc="Quest Millionaire",MinLevel=1000,MaxLevel=1100,Mob="Millionaire",MobLevel=1050 },
        [19] = { Name = "Pirate Captain",  Npc = "Quest Captain",   MinLevel = 1100,  MaxLevel = 1200,  Mob = "Captain",      MobLevel = 1150 },
        [20] = { Name = "Forest Pirate",   Npc = "Quest Forest",    MinLevel = 1200,  MaxLevel = 1300,  Mob = "Forest",       MobLevel = 1250 },
        [21] = { Name = "Magma Ninja",     Npc = "Quest Ninja",     MinLevel = 1300,  MaxLevel = 1400,  Mob = "Ninja",        MobLevel = 1350 },
        [22] = { Name = "Jungle Pirate",   Npc = "Quest Jungle",    MinLevel = 1400,  MaxLevel = 1500,  Mob = "Jungle",       MobLevel = 1450 },
        [23] = { Name = "Ghost Ship",      Npc = "Quest Ghost",     MinLevel = 1500,  MaxLevel = 1600,  Mob = "Ghost",        MobLevel = 1550 },
        [24] = { Name = "Cursed Captain",  Npc = "Quest Cursed",    MinLevel = 1600,  MaxLevel = 1700,  Mob = "Cursed",       MobLevel = 1650 },
        [25] = { Name = "Mob Leader",      Npc = "Quest Leader",    MinLevel = 1700,  MaxLevel = 1800,  Mob = "Leader",       MobLevel = 1750 },
        [26] = { Name = "Pirate Legend",   Npc = "Quest Legend",    MinLevel = 1800,  MaxLevel = 1900,  Mob = "Legend",       MobLevel = 1850 },
        [27] = { Name = "Sea Beast",       Npc = "Quest Beast",     MinLevel = 1900,  MaxLevel = 2000,  Mob = "Beast",        MobLevel = 1950 },
        [28] = { Name = "Dough Boss",      Npc = "Quest Dough",     MinLevel = 2000,  MaxLevel = 2150,  Mob = "Dough",        MobLevel = 2075 },
        [29] = { Name = "Kitsune Shrine",  Npc = "Quest Kitsune",   MinLevel = 2150,  MaxLevel = 2300,  Mob = "Kitsune",      MobLevel = 2225 },
        [30] = { Name = "Leopard",         Npc = "Quest Leopard",   MinLevel = 2300,  MaxLevel = 2450,  Mob = "Leopard",      MobLevel = 2375 },
    }
    for _, q in ipairs(quests) do
        if level >= q.MinLevel and level <= q.MaxLevel then
            return q
        end
    end
    return quests[#quests]
end

local function acceptQuest()
    local quest = getBestQuest()
    if not quest then return end
    local args = { [1] = quest.Npc }
    CommF:InvokeServer(unpack(args))
    task.wait(0.5)
end

local function teleportToMob(mobName)
    local mobs = workspace.Enemies:GetChildren()
    for _, mob in ipairs(mobs) do
        if mob.Name == mobName and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
            RootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4)
            return mob
        end
    end
    return nil
end

local function attackMob(mob)
    if not mob or not mob.Parent then return end
    local hrp = mob:FindFirstChild("HumanoidRootPart")
    if hrp then
        RootPart.CFrame = hrp.CFrame * CFrame.new(0, 0, 2)
        task.wait()
        game:GetService("VirtualInputManager"):SendKeyEvent(true, "F", false, game)
        task.wait(0.1)
        game:GetService("VirtualInputManager"):SendKeyEvent(false, "F", false, game)
    end
end

local function autoFarm()
    while AutoFarmEnabled do
        task.wait(0.1)
        if Settings.AntiAFK then
            local vu = game:GetService("VirtualUser")
            vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            task.wait(0.5)
            vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        end
        
        local quest = getBestQuest()
        if not quest then break end
        
        local args = { [1] = "CheckQuest" }
        local questActive = CommF:InvokeServer(unpack(args))
        if not questActive then
            acceptQuest()
            task.wait(1)
        end
        
        local mob = teleportToMob(quest.Mob)
        if mob then
            attackMob(mob)
        else
            task.wait(2)
        end
        
        if Humanoid.Health < Humanoid.MaxHealth * 0.3 then
            local args = { [1] = "BuyItem", [2] = "Fruit" }
            CommF:InvokeServer(unpack(args))
        end
        
        if Settings.StatMelee + Settings.StatDefense + Settings.StatSword + Settings.StatFruit + Settings.StatGun == 100 then
            local args = { [1] = "AddPoint", [2] = "Melee", [3] = Settings.StatMelee }
            CommF:InvokeServer(unpack(args))
            local args = { [1] = "AddPoint", [2] = "Defense", [3] = Settings.StatDefense }
            CommF:InvokeServer(unpack(args))
            local args = { [1] = "AddPoint", [2] = "Sword", [3] = Settings.StatSword }
            CommF:InvokeServer(unpack(args))
        end
    end
end

MainTab:CreateToggle({
    Name = "Enable Auto Farm",
    CurrentValue = false,
    Flag = "AutoFarmToggle",
    Callback = function(Value)
        AutoFarmEnabled = Value
        if Value then
            task.spawn(autoFarm)
        end
    end,
})

-- ================= Teleports Tab =================
local TeleportTab = Window:CreateTab("Teleports")
local Islands = {
    "MarineStart", "Jungle", "PirateStart", "Desert", "Snow", "Sky1", "Sky2",
    "Prison", "Colosseum", "Magma", "Underwater", "Cafe", "Fountain", "Mansion",
    "Factory", "Graveyard", "HotAndCold", "CakeLand", "SeaOfTreats", "Peanut",
    "IceCream", "Chocolate", "Milk", "Cotton", "Candy"
}
for _, island in ipairs(Islands) do
    TeleportTab:CreateButton({
        Name = island,
        Callback = function()
            local args = { [1] = "TravelDress", [2] = island }
            CommF:InvokeServer(unpack(args))
            Rayfield:Notify({ Title = "Phoenix Hub", Content = "Teleported to " .. island, Duration = 2 })
        end,
    })
end

-- ================= Misc Tab =================
local MiscTab = Window:CreateTab("Misc")
MiscTab:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 300},
    Increment = 1,
    Suffix = "Walkspeed",
    CurrentValue = 16,
    Flag = "WalkspeedSlider",
    Callback = function(v)
        Humanoid.WalkSpeed = v
    end,
})
MiscTab:CreateSlider({
    Name = "Jump Power",
    Range = {50, 300},
    Increment = 5,
    Suffix = "Jump Power",
    CurrentValue = 50,
    Flag = "JumpSlider",
    Callback = function(v)
        Humanoid.JumpPower = v
    end,
})
MiscTab:CreateButton({
    Name = "Redeem All X2 EXP Codes",
    Callback = function()
        local codes = { "SUB2GAMERROBOT", "SUB2UNCLEKIZARU", "SUB2OFFICIALNOOBIE", "ENYU_IS_BEST", "fudd10", "BIGNEWS", "THEGREATACE", "SUB2DAIGROCK" }
        for _, code in ipairs(codes) do
            local args = { [1] = "Redeem", [2] = code }
            CommF:InvokeServer(unpack(args))
            task.wait(0.5)
        end
    end,
})
MiscTab:CreateButton({
    Name = "Reset Character (if stuck)",
    Callback = function()
        Character:BreakJoints()
    end,
})

-- ================= NEW: Race Tab =================
local RaceTab = Window:CreateTab("Race")
local AutoV1Enabled = false
local AutoV2Enabled = false
local AutoV3Enabled = false
local AutoV4Enabled = false

local function getCurrentRace()
    for _, race in ipairs({"Human", "Shark", "Angel", "Rabbit", "Cyborg", "Ghoul", "Draco", "Faerie", "Kitsune"}) do
        if Player.Data.Race.Value == race then
            return race
        end
    end
    return "Unknown"
end

local raceUpgradeInfo = {
    V2 = {
        Name = "V2",
        NPC = "Alchemist",
        Location = "Green Zone",
        Requirement = "Complete Colosseum Quest, Level 850+",
        QuestItem = "Flowers",
        Cost = 500000
    },
    V3 = {
        Name = "V3",
        NPC = "Arowe",
        Location = "Kingdom of Rose",
        Requirement = "Defeat Don Swan, Level 1000+",
        Quest = "Kill a player with the same race (resets on rejoin)",
        Cost = nil
    },
    V4 = {
        Name = "V4",
        Location = "Temple of Time",
        Requirement = "V3, Defeated rip_indra True, Complete Sealed King Quest, Mirror Fractal (from Dough King), Blue Gear (on Mirage Island)",
        Players = "3+ with different races V3+, Full Moon"
    }
}

local function isLevelRequirementMet(requiredLevel)
    local level = Player.Data.Level.Value
    return level >= requiredLevel
end

local function checkCurrentRaceVersion()
    local race = getCurrentRace()
    local args = { [1] = "CheckRace" }
    local success, result = pcall(function()
        return CommF:InvokeServer(unpack(args))
    end)
    if success and result then
        return result
    else
        return "V1"
    end
end

local function startRaceUpgrade(version)
    if version == "V2" and not isLevelRequirementMet(850) then
        Rayfield:Notify({ Title = "Race", Content = "Level 850+ required for V2", Duration = 3 })
        return false
    end
    if version == "V3" and not isLevelRequirementMet(1000) then
        Rayfield:Notify({ Title = "Race", Content = "Level 1000+ required for V3", Duration = 3 })
        return false
    end
    if version == "V4" and not isLevelRequirementMet(1500) then
        Rayfield:Notify({ Title = "Race", Content = "Level 1500+ and Third Sea required for V4", Duration = 3 })
        return false
    end
    -- Placeholder for actual remote invocation
    local args = { [1] = "StartRaceUpgrade", [2] = version }
    CommF:InvokeServer(unpack(args))
    Rayfield:Notify({ Title = "Race", Content = "Started " .. version .. " upgrade process", Duration = 3 })
    return true
end

local function autoFlowerQuest()
    local flowers = {
        "Red Flower", "Blue Flower", "Yellow Flower", "Green Flower"
    }
    for _, flower in ipairs(flowers) do
        local args = { [1] = "GetQuest", [2] = flower }
        CommF:InvokeServer(unpack(args))
        task.wait(1)
        local npc = workspace.NPCs:FindFirstChild("Alchemist")
        if npc and npc:FindFirstChild("HumanoidRootPart") then
            RootPart.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 2, 3)
            task.wait(0.5)
            local args = { [1] = "CompleteQuest", [2] = flower }
            CommF:InvokeServer(unpack(args))
            task.wait(1)
        end
    end
end

local function autoRaceV2()
    while AutoV2Enabled and checkCurrentRaceVersion() ~= "V2" do
        task.wait(1)
        if isLevelRequirementMet(850) then
            local npc = workspace.NPCs:FindFirstChild("Alchemist")
            if npc and npc:FindFirstChild("HumanoidRootPart") then
                RootPart.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 2, 3)
                task.wait(0.5)
                local args = { [1] = "Alchemist" }
                CommF:InvokeServer(unpack(args))
                task.wait(1)
            end
            autoFlowerQuest()
            local args = { [1] = "UpgradeRace", [2] = "V2" }
            CommF:InvokeServer(unpack(args))
        else
            Rayfield:Notify({ Title = "Race", Content = "Level too low for V2", Duration = 3 })
            AutoV2Enabled = false
            break
        end
    end
end

local function autoRaceV3()
    while AutoV3Enabled and checkCurrentRaceVersion() ~= "V3" do
        task.wait(1)
        if isLevelRequirementMet(1000) then
            local players = game.Players:GetPlayers()
            local target = nil
            for _, p in ipairs(players) do
                if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    target = p
                    break
                end
            end
            if target then
                RootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                task.wait(0.5)
                game:GetService("VirtualInputManager"):SendKeyEvent(true, "F", false, game)
                task.wait(0.1)
                game:GetService("VirtualInputManager"):SendKeyEvent(false, "F", false, game)
                task.wait(2)
            end
            local args = { [1] = "UpgradeRace", [2] = "V3" }
            CommF:InvokeServer(unpack(args))
        else
            Rayfield:Notify({ Title = "Race", Content = "Level too low for V3", Duration = 3 })
            AutoV3Enabled = false
            break
        end
    end
end

local function teleportToLocation(location)
    local args = { [1] = "TeleportTo", [2] = location }
    CommF:InvokeServer(unpack(args))
end

local function autoRaceV4()
    if checkCurrentRaceVersion() ~= "V4" then
        Rayfield:Notify({ Title = "Race", Content = "Starting V4 Awakening process", Duration = 3 })
        
        local args = { [1] = "KillRipIndra" }
        CommF:InvokeServer(unpack(args))
        task.wait(5)
        
        local args = { [1] = "TalkToRedHead" }
        CommF:InvokeServer(unpack(args))
        task.wait(2)
        
        teleportToLocation("GreatTree")
        task.wait(2)
        
        local npc = workspace.NPCs:FindFirstChild("MysteriousForce")
        if npc and npc:FindFirstChild("HumanoidRootPart") then
            RootPart.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 2, 3)
            task.wait(0.5)
            local args = { [1] = "MysteriousForce" }
            CommF:InvokeServer(unpack(args))
        end
        task.wait(2)
        
        local args = { [1] = "TalkToRedHead" }
        CommF:InvokeServer(unpack(args))
        task.wait(2)
        
        Rayfield:Notify({ Title = "Race", Content = "Searching for Mirage Island (Full Moon required)", Duration = 3 })
        local success = false
        while not success and AutoV4Enabled do
            task.wait(5)
            if workspace:FindFirstChild("MirageIsland") then
                success = true
                teleportToLocation("MirageIsland")
                task.wait(2)
                local args = { [1] = "UseMirrorFractal" }
                CommF:InvokeServer(unpack(args))
                task.wait(10)
            end
        end
        
        teleportToLocation("TempleOfTime")
        task.wait(2)
        
        local args = { [1] = "PullLever" }
        CommF:InvokeServer(unpack(args))
        task.wait(2)
        
        local args = { [1] = "StartTrial" }
        CommF:InvokeServer(unpack(args))
    end
end

RaceTab:CreateSection("Race Info")
RaceTab:CreateParagraph({
    Title = "Current Race",
    Content = getCurrentRace() .. " - " .. checkCurrentRaceVersion(),
})

RaceTab:CreateParagraph({
    Title = "Race Upgrade Guide",
    Content = "V2: Alchemist in Green Zone (Level 850+)\nV3: Arowe in Kingdom of Rose (Level 1000+)\nV4: Temple of Time (Level 1500+, Third Sea)",
})

RaceTab:CreateButton({
    Name = "Refresh Race Info",
    Callback = function()
        local race = getCurrentRace()
        local version = checkCurrentRaceVersion()
        Rayfield:Notify({ Title = "Race", Content = race .. " - " .. version, Duration = 3 })
    end,
})

RaceTab:CreateSection("Race Upgrade Automation")
RaceTab:CreateToggle({
    Name = "Auto V2 (Alchemist Flower Quest)",
    CurrentValue = false,
    Flag = "AutoV2Toggle",
    Callback = function(Value)
        AutoV2Enabled = Value
        if Value then
            task.spawn(autoRaceV2)
        end
    end,
})
RaceTab:CreateToggle({
    Name = "Auto V3 (Defeat Player Quest)",
    CurrentValue = false,
    Flag = "AutoV3Toggle",
    Callback = function(Value)
        AutoV3Enabled = Value
        if Value then
            task.spawn(autoRaceV3)
        end
    end,
})
RaceTab:CreateToggle({
    Name = "Auto V4 Awakening",
    CurrentValue = false,
    Flag = "AutoV4Toggle",
    Callback = function(Value)
        AutoV4Enabled = Value
        if Value then
            task.spawn(autoRaceV4)
        end
    end,
})

RaceTab:CreateSection("Race Reroll")
RaceTab:CreateButton({
    Name = "Race Reroll (3k Fragments)",
    Callback = function()
        local args = { [1] = "RaceReroll" }
        CommF:InvokeServer(unpack(args))
        Rayfield:Notify({ Title = "Race", Content = "Used Race Reroll", Duration = 3 })
    end,
})
RaceTab:CreateButton({
    Name = "Farm Fragments for Reroll",
    Callback = function()
        AutoFarmEnabled = true
        Rayfield:Notify({ Title = "Race", Content = "Farming fragments for reroll", Duration = 3 })
    end,
})

RaceTab:CreateSection("Special Race Unlocks")
RaceTab:CreateButton({
    Name = "Cyborg Race Puzzle",
    Callback = function()
        local args = { [1] = "CyborgPuzzle" }
        CommF:InvokeServer(unpack(args))
        Rayfield:Notify({ Title = "Race", Content = "Started Cyborg puzzle", Duration = 3 })
    end,
})
RaceTab:CreateButton({
    Name = "Ghoul Race",
    Callback = function()
        if Player.Data.Level.Value >= 1000 then
            local args = { [1] = "GhoulRace" }
            CommF:InvokeServer(unpack(args))
            Rayfield:Notify({ Title = "Race", Content = "Started Ghoul race quest", Duration = 3 })
        else
            Rayfield:Notify({ Title = "Race", Content = "Level 1000+ required for Ghoul race", Duration = 3 })
        end
    end,
})
RaceTab:CreateButton({
    Name = "Draco Race",
    Callback = function()
        if Player.Data.Level.Value >= 1500 then
            local args = { [1] = "DracoRace" }
            CommF:InvokeServer(unpack(args))
            Rayfield:Notify({ Title = "Race", Content = "Started Draco race quest", Duration = 3 })
        else
            Rayfield:Notify({ Title = "Race", Content = "Level 1500+ required for Draco race", Duration = 3 })
        end
    end,
})

RaceTab:CreateSection("V4 Awakening Requirements")
RaceTab:CreateParagraph({
    Title = "Checklist",
    Content = "1. Have any race at V3 (First step)\n2. Defeat rip_indra True Form (Second step)\n3. Complete Sealed King Quest (Third step)\n4. Obtain Mirror Fractal from Dough King (Fourth step)\n5. Find Blue Gear on Mirage Island (Fifth step)\n6. Gather 3+ players with different races at V3+ (Sixth step)\n7. Wait for Full Moon to start the trial (Seventh step)",
})

RaceTab:CreateButton({
    Name = "Check V4 Progress",
    Callback = function()
        local args = { [1] = "CheckV4Progress" }
        local progress = CommF:InvokeServer(unpack(args))
        if progress then
            Rayfield:Notify({ Title = "Race", Content = "V4 Progress: " .. progress, Duration = 3 })
        else
            Rayfield:Notify({ Title = "Race", Content = "V4 not started or requirements not met", Duration = 3 })
        end
    end,
})

RaceTab:CreateSection("V4 Trial Assistance")
RaceTab:CreateButton({
    Name = "Auto Complete Trial (V4)",
    Callback = function()
        local args = { [1] = "AutoCompleteTrial" }
        CommF:InvokeServer(unpack(args))
        Rayfield:Notify({ Title = "Race", Content = "Auto completing V4 trial", Duration = 3 })
    end,
})

RaceTab:CreateButton({
    Name = "Activate V4 Ability",
    Callback = function()
        if checkCurrentRaceVersion() == "V4" then
            game:GetService("VirtualInputManager"):SendKeyEvent(true, "Y", false, game)
            task.wait(0.1)
            game:GetService("VirtualInputManager"):SendKeyEvent(false, "Y", false, game)
            Rayfield:Notify({ Title = "Race", Content = "V4 ability activated", Duration = 2 })
        else
            Rayfield:Notify({ Title = "Race", Content = "V4 not unlocked yet", Duration = 3 })
        end
    end,
})

Rayfield:Notify({ Title = "Phoenix Hub", Content = "Script Loaded Successfully! (Race Tab Included)", Duration = 3 })
