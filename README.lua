-- ============================================================
-- 🎮 СВОЯ ПАНЕЛЬ | 20 игр | Каждая игра = своя панель
-- ЧАСТЬ 1 из 4: UI + создание элементов (с Toggle-кнопками)
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

_G.StopAll = false
_G.Toggles = _G.Toggles or {}
_G.Connections = _G.Connections or {}

-- ============================================================
-- СОЗДАНИЕ ГЛАВНОЙ ПАНЕЛИ
-- ============================================================
local function CreateMainPanel()
    local old = CoreGui:FindFirstChild("MyCheatPanel")
    if old then old:Destroy() end

    local screen = Instance.new("ScreenGui")
    screen.Name = "MyCheatPanel"
    screen.ResetOnSpawn = false
    screen.Parent = CoreGui

    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Size = UDim2.new(0, 520, 0, 400)
    main.Position = UDim2.new(0.5, -260, 0.5, -200)
    main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    main.BorderSizePixel = 0
    main.Active = true
    main.Draggable = true
    main.Parent = screen

    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 10)
    mainCorner.Parent = main

    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Color3.fromRGB(0, 255, 150)
    mainStroke.Thickness = 2
    mainStroke.Parent = main

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 35)
    title.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
    title.BackgroundTransparency = 0.85
    title.Text = "🎮 MY CHEAT PANEL | 20 GAMES"
    title.TextColor3 = Color3.fromRGB(0, 255, 150)
    title.TextSize = 16
    title.Font = Enum.Font.GothamBold
    title.Parent = main

    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = title

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 2)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 14
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = title
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = closeBtn
    closeBtn.MouseButton1Click:Connect(function()
        screen.Enabled = false
    end)

    local gameList = Instance.new("ScrollingFrame")
    gameList.Name = "GameList"
    gameList.Size = UDim2.new(0, 160, 1, -45)
    gameList.Position = UDim2.new(0, 5, 0, 40)
    gameList.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    gameList.BorderSizePixel = 0
    gameList.ScrollBarThickness = 4
    gameList.CanvasSize = UDim2.new(0, 0, 0, 0)
    gameList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    gameList.Parent = main
    local glCorner = Instance.new("UICorner")
    glCorner.CornerRadius = UDim.new(0, 6)
    glCorner.Parent = gameList

    local glLayout = Instance.new("UIListLayout")
    glLayout.Padding = UDim.new(0, 4)
    glLayout.SortOrder = Enum.SortOrder.LayoutOrder
    glLayout.Parent = gameList

    local funcList = Instance.new("ScrollingFrame")
    funcList.Name = "FuncList"
    funcList.Size = UDim2.new(1, -175, 1, -45)
    funcList.Position = UDim2.new(0, 170, 0, 40)
    funcList.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    funcList.BorderSizePixel = 0
    funcList.ScrollBarThickness = 4
    funcList.CanvasSize = UDim2.new(0, 0, 0, 0)
    funcList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    funcList.Parent = main
    local flCorner = Instance.new("UICorner")
    flCorner.CornerRadius = UDim.new(0, 6)
    flCorner.Parent = funcList

    local flLayout = Instance.new("UIListLayout")
    flLayout.Padding = UDim.new(0, 6)
    flLayout.SortOrder = Enum.SortOrder.LayoutOrder
    flLayout.Parent = funcList

    local flPadding = Instance.new("UIPadding")
    flPadding.PaddingLeft = UDim.new(0, 8)
    flPadding.PaddingRight = UDim.new(0, 8)
    flPadding.PaddingTop = UDim.new(0, 8)
    flPadding.Parent = funcList

    return screen, main, gameList, funcList
end

-- ============================================================
-- СОЗДАНИЕ КНОПОК
-- ============================================================
local function CreateGameButton(parent, gameName, order, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -8, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    btn.Text = gameName
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 12
    btn.Font = Enum.Font.Gotham
    btn.BorderSizePixel = 0
    btn.LayoutOrder = order
    btn.Parent = parent

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = btn

    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
        btn.TextColor3 = Color3.fromRGB(0, 0, 0)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    end)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function CreateToggleButton(parent, id, text, order, onFunc, offFunc)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.TextColor3 = Color3.fromRGB(0, 0, 0)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.LayoutOrder = order
    btn.Parent = parent

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = btn

    _G.Toggles[id] = _G.Toggles[id] or false

    local function UpdateVisual()
        if _G.Toggles[id] then
            btn.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
            btn.Text = "🟢 " .. text
        else
            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            btn.Text = "⚫ " .. text
        end
    end

    UpdateVisual()

    btn.MouseEnter:Connect(function()
        if _G.Toggles[id] then
            btn.BackgroundColor3 = Color3.fromRGB(0, 200, 120)
        else
            btn.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
        end
    end)
    btn.MouseLeave:Connect(function()
        UpdateVisual()
    end)

    btn.MouseButton1Click:Connect(function()
        _G.Toggles[id] = not _G.Toggles[id]
        UpdateVisual()
        if _G.Toggles[id] then
            if onFunc then onFunc() end
            print(text .. ": ВКЛ")
        else
            if offFunc then offFunc() end
            print(text .. ": ВЫКЛ")
        end
    end)

    return btn
end

local function CreateFuncLabel(parent, text, order)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 26)
    lbl.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(0, 255, 150)
    lbl.TextSize = 13
    lbl.Font = Enum.Font.GothamBold
    lbl.BorderSizePixel = 0
    lbl.LayoutOrder = order
    lbl.Parent = parent

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = lbl
    return lbl
end-- ============================================================
-- ЧАСТЬ 2 из 4: игры 1-5
-- ============================================================

-- 1. УКРАДИ БРЕЙНРОТ
local function Panel_Brainrot(parent)
    local order = 0
    local function addLbl(t) order = order + 1; CreateFuncLabel(parent, t, order) end
    local function addTog(id, t, onF, offF)
        order = order + 1
        CreateToggleButton(parent, id, t, order, onF, offF)
    end

    addLbl("🧠 УКРАДИ БРЕЙНРОТ")

    addTog("brainrot_platform", "Прозрачная платформа",
        function()
            local old = workspace:FindFirstChild("BrainrotPlatform")
            if old then old:Destroy() end
            local p = Instance.new("Part")
            p.Size = Vector3.new(12, 1, 12)
            p.Anchored = true
            p.CanCollide = true
            p.Transparency = 0.7
            p.Color = Color3.fromRGB(0, 255, 150)
            p.Material = Enum.Material.Neon
            p.Name = "BrainrotPlatform"
            p.Parent = workspace
            local conn
            conn = RunService.Heartbeat:Connect(function()
                if not p or not p.Parent then
                    if conn then conn:Disconnect() end
                    return
                end
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    p.CFrame = CFrame.new(char.HumanoidRootPart.Position - Vector3.new(0, 3, 0))
                    p.CFrame = p.CFrame * CFrame.new(0, 0.5, 0)
                end
            end)
            _G.Connections["brainrot_platform"] = conn
        end,
        function()
            if _G.Connections["brainrot_platform"] then
                _G.Connections["brainrot_platform"]:Disconnect()
                _G.Connections["brainrot_platform"] = nil
            end
            local p = workspace:FindFirstChild("BrainrotPlatform")
            if p then p:Destroy() end
        end
    )

    addTog("brainrot_speed", "Скорость 50",
        function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 50
            end
        end,
        function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 16
            end
        end
    )

    addTog("brainrot_base", "Прозрачность баз",
        function()
            for _, v in ipairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and (v.Name:lower():find("base") or v.Name:lower():find("wall")) then
                    v:SetAttribute("OldTrans", v.Transparency)
                    v.Transparency = 0.5
                end
            end
        end,
        function()
            for _, v in ipairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and v:GetAttribute("OldTrans") then
                    v.Transparency = v:GetAttribute("OldTrans")
                    v:SetAttribute("OldTrans", nil)
                end
            end
        end
    )
end

-- 2. БРОКХЕВЕН
local function Panel_Brookhaven(parent)
    local order = 0
    local function addLbl(t) order = order + 1; CreateFuncLabel(parent, t, order) end
    local function addTog(id, t, onF, offF)
        order = order + 1
        CreateToggleButton(parent, id, t, order, onF, offF)
    end

    addLbl("🏠 БРОКХЕВЕН RP")

    addTog("bh_fly", "Fly",
        function()
            local conn
            conn = RunService.Heartbeat:Connect(function()
                if not _G.Toggles["bh_fly"] then
                    if conn then conn:Disconnect() end
                    return
                end
                local char = LocalPlayer.Character
                if char then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then hrp.Velocity = Vector3.new(0, 50, 0) end
                end
            end)
            _G.Connections["bh_fly"] = conn
        end,
        function()
            if _G.Connections["bh_fly"] then
                _G.Connections["bh_fly"]:Disconnect()
                _G.Connections["bh_fly"] = nil
            end
        end
    )

    addTog("bh_noclip", "NoClip",
        function()
            local conn
            conn = RunService.Stepped:Connect(function()
                if not _G.Toggles["bh_noclip"] then
                    if conn then conn:Disconnect() end
                    return
                end
                local char = LocalPlayer.Character
                if char then
                    for _, p in ipairs(char:GetDescendants()) do
                        if p:IsA("BasePart") then p.CanCollide = false end
                    end
                end
            end)
            _G.Connections["bh_noclip"] = conn
        end,
        function()
            if _G.Connections["bh_noclip"] then
                _G.Connections["bh_noclip"]:Disconnect()
                _G.Connections["bh_noclip"] = nil
            end
            local char = LocalPlayer.Character
            if char then
                for _, p in ipairs(char:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = true end
                end
            end
        end
    )

    addTog("bh_esp", "ESP игроков",
        function()
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    if not plr.Character:FindFirstChild("ESP_HL") then
                        local hl = Instance.new("Highlight")
                        hl.Name = "ESP_HL"
                        hl.FillColor = Color3.fromRGB(255, 0, 0)
                        hl.Parent = plr.Character
                    end
                end
            end
        end,
        function()
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr.Character then
                    local hl = plr.Character:FindFirstChild("ESP_HL")
                    if hl then hl:Destroy() end
                end
            end
        end
    )

    addTog("bh_speed", "Скорость 100",
        function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 100
            end
        end,
        function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 16
            end
        end
    )
end

-- 3. MM2
local function Panel_MM2(parent)
    local order = 0
    local function addLbl(t) order = order + 1; CreateFuncLabel(parent, t, order) end
    local function addTog(id, t, onF, offF)
        order = order + 1
        CreateToggleButton(parent, id, t, order, onF, offF)
    end

    addLbl("🔪 MURDER MYSTERY 2")

    local AIM_SMOOTH = 0.15
    local AIM_FOV = 200

    local function GetClosestTarget()
        local myChar = LocalPlayer.Character
        if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return nil end
        local myPos = myChar.HumanoidRootPart.Position
        local closest, closestDist = nil, AIM_FOV
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                local hum = plr.Character:FindFirstChild("Humanoid")
                if hrp and hum and hum.Health > 0 then
                    local dist = (hrp.Position - myPos).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closest = plr
                    end
                end
            end
        end
        return closest
    end

    addTog("mm2_aim", "Аимбот",
        function()
            local conn
            conn = RunService.RenderStepped:Connect(function()
                if not _G.Toggles["mm2_aim"] then
                    if conn then conn:Disconnect() end
                    return
                end
                local t = GetClosestTarget()
                if t and t.Character then
                    local targetHRP = t.Character:FindFirstChild("HumanoidRootPart")
                    local myChar = LocalPlayer.Character
                    if targetHRP and myChar then
                        local myHRP = myChar:FindFirstChild("HumanoidRootPart")
                        if myHRP then
                            local targetPos = targetHRP.Position + Vector3.new(0, 2.5, 0)
                            local dir = (targetPos - myHRP.Position).Unit
                            local look = CFrame.new(myHRP.Position, myHRP.Position + dir)
                            myHRP.CFrame = myHRP.CFrame:Lerp(look, AIM_SMOOTH)
                        end
                    end
                end
            end)
            _G.Connections["mm2_aim"] = conn
        end,
        function()
            if _G.Connections["mm2_aim"] then
                _G.Connections["mm2_aim"]:Disconnect()
                _G.Connections["mm2_aim"] = nil
            end
        end
    )

    addTog("mm2_esp", "ESP игроков",
        function()
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    if not plr.Character:FindFirstChild("ESP_HL") then
                        local hl = Instance.new("Highlight")
                        hl.Name = "ESP_HL"
                        hl.FillColor = Color3.fromRGB(0, 255, 0)
                        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                        hl.Parent = plr.Character
                    end
                end
            end
        end,
        function()
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr.Character then
                    local hl = plr.Character:FindFirstChild("ESP_HL")
                    if hl then hl:Destroy() end
                end
            end
        end
    )

    addTog("mm2_coins", "Авто-сбор монет",
        function()
            local conn
            conn = RunService.Heartbeat:Connect(function()
                if not _G.Toggles["mm2_coins"] then
                    if conn then conn:Disconnect() end
                    return
                end
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and obj.Name:lower():find("coin") then
                        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then hrp.CFrame = obj.CFrame end
                    end
                end
            end)
            _G.Connections["mm2_coins"] = conn
        end,
        function()
            if _G.Connections["mm2_coins"] then
                _G.Connections["mm2_coins"]:Disconnect()
                _G.Connections["mm2_coins"] = nil
            end
        end
    )

    addTog("mm2_noclip", "NoClip",
        function()
            local conn
            conn = RunService.Stepped:Connect(function()
                if not _G.Toggles["mm2_noclip"] then
                    if conn then conn:Disconnect() end
                    return
                end
                local char = LocalPlayer.Character
                if char then
                    for _, p in ipairs(char:GetDescendants()) do
                        if p:IsA("BasePart") then p.CanCollide = false end
                    end
                end
            end)
            _G.Connections["mm2_noclip"] = conn
        end,
        function()
            if _G.Connections["mm2_noclip"] then
                _G.Connections["mm2_noclip"]:Disconnect()
                _G.Connections["mm2_noclip"] = nil
            end
            local char = LocalPlayer.Character
            if char then
                for _, p in ipairs(char:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = true end
                end
            end
        end
    )
end

-- 4. BLOX FRUITS
local function Panel_BloxFruits(parent)
    local order = 0
    local function addLbl(t) order = order + 1; CreateFuncLabel(parent, t, order) end
    local function addTog(id, t, onF, offF)
        order = order + 1
        CreateToggleButton(parent, id, t, order, onF, offF)
    end

    addLbl("🍇 BLOX FRUITS")

    addTog("bf_speed", "Скорость 80",
        function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 80
            end
        end,
        function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 16
            end
        end
    )

    addTog("bf_esp", "ESP врагов",
        function()
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj ~= LocalPlayer.Character then
                    if not obj:FindFirstChild("ESP_HL") then
                        local hl = Instance.new("Highlight")
                        hl.Name = "ESP_HL"
                        hl.FillColor = Color3.fromRGB(255, 100, 0)
                        hl.Parent = obj
                    end
                end
            end
        end,
        function()
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("Model") then
                    local hl = obj:FindFirstChild("ESP_HL")
                    if hl then hl:Destroy() end
                end
            end
        end
    )

    addTog("bf_jump", "Супер-прыжок",
        function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.UseJumpPower = true
                LocalPlayer.Character.Humanoid.JumpPower = 200
            end
        end,
        function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.JumpPower = 50
            end
        end
    )
end

-- 5. ADOPT ME
local function Panel_AdoptMe(parent)
    local order = 0
    local function addLbl(t) order = order + 1; CreateFuncLabel(parent, t, order) end
    local function addTog(id, t, onF, offF)
        order = order + 1
        CreateToggleButton(parent, id, t, order, onF, offF)
    end

    addLbl("🐾 ADOPT ME!")

    addTog("am_speed", "Скорость 60",
        function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 60
            end
        end,
        function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 16
            end
        end
    )

    addTog("am_eggs", "Прозрачность яиц",
        function()
            for _, v in ipairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and v.Name:lower():find("egg") then
                    v:SetAttribute("OldTrans", v.Transparency)
                    v.Transparency = 0.5
                end
            end
        end,
        function()
            for _, v in ipairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and v:GetAttribute("OldTrans") then
                    v.Transparency = v:GetAttribute("OldTrans")
                    v:SetAttribute("OldTrans", nil)
                end
            end
        end
    )
end-- ============================================================
-- ЧАСТЬ 3 из 4: игры 6-15
-- ============================================================

-- 6. GROW A GARDEN
local function Panel_GrowGarden(parent)
    local order = 0
    local function addLbl(t) order = order + 1; CreateFuncLabel(parent, t, order) end
    local function addTog(id, t, onF, offF)
        order = order + 1
        CreateToggleButton(parent, id, t, order, onF, offF)
    end

    addLbl("🌱 GROW A GARDEN")

    addTog("gg_speed", "Скорость 50",
        function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 50
            end
        end,
        function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 16
            end
        end
    )

    addTog("gg_noclip", "NoClip",
        function()
            local conn
            conn = RunService.Stepped:Connect(function()
                if not _G.Toggles["gg_noclip"] then
                    if conn then conn:Disconnect() end
                    return
                end
                local char = LocalPlayer.Character
                if char then
                    for _, p in ipairs(char:GetDescendants()) do
                        if p:IsA("BasePart") then p.CanCollide = false end
                    end
                end
            end)
            _G.Connections["gg_noclip"] = conn
        end,
        function()
            if _G.Connections["gg_noclip"] then
                _G.Connections["gg_noclip"]:Disconnect()
                _G.Connections["gg_noclip"] = nil
            end
        end
    )
end

-- 7. 99 НОЧЕЙ В ЛЕСУ
local function Panel_99Nights(parent)
    local order = 0
    local function addLbl(t) order = order + 1; CreateFuncLabel(parent, t, order) end
    local function addTog(id, t, onF, offF)
        order = order + 1
        CreateToggleButton(parent, id, t, order, onF, offF)
    end

    addLbl("🌲 99 НОЧЕЙ В ЛЕСУ")

    addTog("n99_fly", "Fly",
        function()
            local conn
            conn = RunService.Heartbeat:Connect(function()
                if not _G.Toggles["n99_fly"] then
                    if conn then conn:Disconnect() end
                    return
                end
                local char = LocalPlayer.Character
                if char then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then hrp.Velocity = Vector3.new(0, 30, 0) end
                end
            end)
            _G.Connections["n99_fly"] = conn
        end,
        function()
            if _G.Connections["n99_fly"] then
                _G.Connections["n99_fly"]:Disconnect()
                _G.Connections["n99_fly"] = nil
            end
        end
    )

    addTog("n99_noclip", "NoClip",
        function()
            local conn
            conn = RunService.Stepped:Connect(function()
                if not _G.Toggles["n99_noclip"] then
                    if conn then conn:Disconnect() end
                    return
                end
                local char = LocalPlayer.Character
                if char then
                    for _, p in ipairs(char:GetDescendants()) do
                        if p:IsA("BasePart") then p.CanCollide = false end
                    end
                end
            end)
            _G.Connections["n99_noclip"] = conn
        end,
        function()
            if _G.Connections["n99_noclip"] then
                _G.Connections["n99_noclip"]:Disconnect()
                _G.Connections["n99_noclip"] = nil
            end
        end
    )
end

-- 8. TOWER OF HELL
local function Panel_TOH(parent)
    local order = 0
    local function addLbl(t) order = order + 1; CreateFuncLabel(parent, t, order) end
    local function addTog(id, t, onF, offF)
        order = order + 1
        CreateToggleButton(parent, id, t, order, onF, offF)
    end

    addLbl("🗼 TOWER OF HELL")

    addTog("toh_speed", "Скорость 100",
        function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 100
            end
        end,
        function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 16
            end
        end
    )

    addTog("toh_jump", "Прыжок 200",
        function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.UseJumpPower = true
                LocalPlayer.Character.Humanoid.JumpPower = 200
            end
        end,
        function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.JumpPower = 50
            end
        end
    )
end

-- 9. THE STRONGEST BATTLEGROUNDS
local function Panel_TSB(parent)
    local order = 0
    local function addLbl(t) order = order + 1; CreateFuncLabel(parent, t, order) end
    local function addTog(id, t, onF, offF)
        order = order + 1
        CreateToggleButton(parent, id, t, order, onF, offF)
    end

    addLbl("💪 THE STRONGEST BATTLEGROUNDS")

    addTog("tsb_esp", "ESP игроков",
        function()
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    if not plr.Character:FindFirstChild("ESP_HL") then
                        local hl = Instance.new("Highlight")
                        hl.Name = "ESP_HL"
                        hl.FillColor = Color3.fromRGB(255, 0, 0)
                        hl.Parent = plr.Character
                    end
                end
            end
        end,
        function()
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr.Character then
                    local hl = plr.Character:FindFirstChild("ESP_HL")
                    if hl then hl:Destroy() end
                end
            end
        end
    )

    addTog("tsb_speed", "Скорость 60",
        function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 60
            end
        end,
        function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 16
            end
        end
    )
end

-- 10. RIVALS
local function Panel_Rivals(parent)
    local order = 0
    local function addLbl(t) order = order + 1; CreateFuncLabel(parent, t, order) end
    local function addTog(id, t, onF, offF)
        order = order + 1
        CreateToggleButton(parent, id, t, order, onF, offF)
    end

    addLbl("🔫 RIVALS")

    addTog("riv_esp", "ESP",
        function()
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    if not plr.Character:FindFirstChild("ESP_HL") then
                        local hl = Instance.new("Highlight")
                        hl.Name = "ESP_HL"
                        hl.FillColor = Color3.fromRGB(255, 50, 50)
                        hl.Parent = plr.Character
                    end
                end
            end
        end,
        function()
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr.Character then
                    local hl = plr.Character:FindFirstChild("ESP_HL")
                    if hl then hl:Destroy() end
                end
            end
        end
    )

    addTog("riv_aim", "Аимбот",
        function()
            local conn
            conn = RunService.RenderStepped:Connect(function()
                if not _G.Toggles["riv_aim"] then
                    if conn then conn:Disconnect() end
                    return
                end
                local myChar = LocalPlayer.Character
                if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
                local myPos = myChar.HumanoidRootPart.Position
                local closest, dist = nil, 200
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer and plr.Character then
                        local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            local d = (hrp.Position - myPos).Magnitude
                            if d < dist then dist = d; closest = hrp end
                        end
                    end
                end
                if closest then
                    local hrp = myChar.HumanoidRootPart
                    local target = closest.Position + Vector3.new(0, 2, 0)
                    hrp.CFrame = hrp.CFrame:Lerp(CFrame.new(hrp.Position, target), 0.2)
                end
            end)
            _G.Connections["riv_aim"] = conn
        end,
        function()
            if _G.Connections["riv_aim"] then
                _G.Connections["riv_aim"]:Disconnect()
                _G.Connections["riv_aim"] = nil
            end
        end
    )
end

-- 11. PIGGY
local function Panel_Piggy(parent)
    local order = 0
    local function addLbl(t) order = order + 1; CreateFuncLabel(parent, t, order) end
    local function addTog(id, t, onF, offF)
        order = order + 1
        CreateToggleButton(parent, id, t, order, onF, offF)
    end

    addLbl("🐷 PIGGY")

    addTog("pig_speed", "Скорость 60",
        function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 60
            end
        end,
        function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 16
            end
        end
    )

    addTog("pig_noclip", "NoClip",
        function()
            local conn
            conn = RunService.Stepped:Connect(function()
                if not _G.Toggles["pig_noclip"] then
                    if conn then conn:Disconnect() end
                    return
                end
                local char = LocalPlayer.Character
                if char then
                    for _, p in ipairs(char:GetDescendants()) do
                        if p:IsA("BasePart") then p.CanCollide = false end
                    end
                end
            end)
            _G.Connections["pig_noclip"] = conn
        end,
        function()
            if _G.Connections["pig_noclip"] then
                _G.Connections["pig_noclip"]:Disconnect()
                _G.Connections["pig_noclip"] = nil
            end
        end
    )
end

-- 12. BEDWARS
local function Panel_BedWars(parent)
    local order = 0
    local function addLbl(t) order = order + 1; CreateFuncLabel(parent, t, order) end
    local function addTog(id, t, onF, offF)
        order = order + 1
        CreateToggleButton(parent, id, t, order, onF, offF)
    end

    addLbl("🛏 BEDWARS")

    addTog("bw_esp", "ESP игроков",
        function()
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    if not plr.Character:FindFirstChild("ESP_HL") then
                        local hl = Instance.new("Highlight")
                        hl.Name = "ESP_HL"
                        hl.FillColor = Color3.fromRGB(0, 255, 255)
                        hl.Parent = plr.Character
                    end
                end
            end
        end,
        function()
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr.Character then
                    local hl = plr.Character:FindFirstChild("ESP_HL")
                    if hl then hl:Destroy() end
                end
            end
        end
    )

    addTog("bw_fly", "Fly",
        function()
            local conn
            conn = RunService.Heartbeat:Connect(function()
                if not _G.Toggles["bw_fly"] then
                    if conn then conn:Disconnect() end
                    return
                end
                local char = LocalPlayer.Character
                if char then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then hrp.Velocity = Vector3.new(0, 40, 0) end
                end
            end)
            _G.Connections["bw_fly"] = conn
        end,
        function()
            if _G.Connections["bw_fly"] then
                _G.Connections["bw_fly"]:Disconnect()
                _G.Connections["bw_fly"] = nil
            end
        end
    )
end

-- 13. DRESS TO IMPRESS
local function Panel_DTI(parent)
    local order = 0
    local function addLbl(t) order = order + 1; CreateFuncLabel(parent, t, order) end
    local function addTog(id, t, onF, offF)
        order = order + 1
        CreateToggleButton(parent, id, t, order, onF, offF)
    end

    addLbl("👗 DRESS TO IMPRESS")

    addTog("dti_speed", "Скорость 50",
        function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 50
            end
        end,
        function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 16
            end
        end
    )
end

-- 14. EVADE
local function Panel_Evade(parent)
    local order = 0
    local function addLbl(t) order = order + 1; CreateFuncLabel(parent, t, order) end
    local function addTog(id, t, onF, offF)
        order = order + 1
        CreateToggleButton(parent, id, t, order, onF, offF)
    end

    addLbl("🏃 EVADE")

    addTog("ev_fly", "Fly",
        function()
            local conn
            conn = RunService.Heartbeat:Connect(function()
                if not _G.Toggles["ev_fly"] then
                    if conn then conn:Disconnect() end
                    return
                end
                local char = LocalPlayer.Character
                if char then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then hrp.Velocity = Vector3.new(0, 40, 0) end
                end
            end)
            _G.Connections["ev_fly"] = conn
        end,
        function()
            if _G.Connections["ev_fly"] then
                _G.Connections["ev_fly"]:Disconnect()
                _G.Connections["ev_fly"] = nil
            end
        end
    )

    addTog("ev_noclip", "NoClip",
        function()
            local conn
            conn = RunService.Stepped:Connect(function()
                if not _G.Toggles["ev_noclip"] then
                    if conn then conn:Disconnect() end
                    return
                end
                local char = LocalPlayer.Character
                if char then
                    for _, p in ipairs(char:GetDescendants()) do
                        if p:IsA("BasePart") then p.CanCollide = false end
                    end
                end
            end)
            _G.Connections["ev_noclip"] = conn
        end,
        function()
            if _G.Connections["ev_noclip"] then
                _G.Connections["ev_noclip"]:Disconnect()
                _G.Connections["ev_noclip"] = nil
            end
        end
    )
end

-- 15. PET SIMULATOR X
local function Panel_PSX(parent)
    local order = 0
    local function addLbl(t) order = order + 1; CreateFuncLabel(parent, t, order) end
    local function addTog(id, t, onF, offF)
        order = order + 1
        CreateToggleButton(parent, id, t, order, onF, offF)
    end

    addLbl("🐶 PET SIMULATOR X")

    addTog("psx_speed", "Скорость 70",
        function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 70
            end
        end,
        function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 16
            end
        end
    )

    addTog("psx_noclip", "NoClip",
        function()
            local conn
            conn = RunService.Stepped:Connect(function()
                if not _G.Toggles["psx_noclip"] then
                    if conn then conn:Disconnect() end
                    return
                end
                local char = LocalPlayer.Character
                if char then
                    for _, p in ipairs(char:GetDescendants()) do
                        if p:IsA("BasePart") then p.CanCollide = false end
                    end
                end
            end)
            _G.Connections["psx_noclip"] = conn
        end,
        function()
            if _G.Connections["psx_noclip"] then
                _G.Connections["psx_noclip"]:Disconnect()
                _G.Connections["psx_noclip"] = nil
            end
        end
    )
end-- ============================================================
-- ЧАСТЬ 4 из 4: игры 16-20 + сборка панели + стоп-кран
-- ============================================================

-- 16. JAILBREAK
local function Panel_Jailbreak(parent)
    local order = 0
    local function addLbl(t) order = order + 1; CreateFuncLabel(parent, t, order) end
    local function addTog(id, t, onF, offF)
        order = order + 1
        CreateToggleButton(parent, id, t, order, onF, offF)
    end

    addLbl("🚔 JAILBREAK")

    addTog("jb_fly", "Fly",
        function()
            local conn
            conn = RunService.Heartbeat:Connect(function()
                if not _G.Toggles["jb_fly"] then
                    if conn then conn:Disconnect() end
                    return
                end
                local char = LocalPlayer.Character
                if char then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then hrp.Velocity = Vector3.new(0, 50, 0) end
                end
            end)
            _G.Connections["jb_fly"] = conn
        end,
        function()
            if _G.Connections["jb_fly"] then
                _G.Connections["jb_fly"]:Disconnect()
                _G.Connections["jb_fly"] = nil
            end
        end
    )

    addTog("jb_noclip", "NoClip",
        function()
            local conn
            conn = RunService.Stepped:Connect(function()
                if not _G.Toggles["jb_noclip"] then
                    if conn then conn:Disconnect() end
                    return
                end
                local char = LocalPlayer.Character
                if char then
                    for _, p in ipairs(char:GetDescendants()) do
                        if p:IsA("BasePart") then p.CanCollide = false end
                    end
                end
            end)
            _G.Connections["jb_noclip"] = conn
        end,
        function()
            if _G.Connections["jb_noclip"] then
                _G.Connections["jb_noclip"]:Disconnect()
                _G.Connections["jb_noclip"] = nil
            end
        end
    )
end

-- 17. DOORS
local function Panel_Doors(parent)
    local order = 0
    local function addLbl(t) order = order + 1; CreateFuncLabel(parent, t, order) end
    local function addTog(id, t, onF, offF)
        order = order + 1
        CreateToggleButton(parent, id, t, order, onF, offF)
    end

    addLbl("🚪 DOORS")

    addTog("dr_speed", "Скорость 80",
        function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 80
            end
        end,
        function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 16
            end
        end
    )

    addTog("dr_noclip", "NoClip",
        function()
            local conn
            conn = RunService.Stepped:Connect(function()
                if not _G.Toggles["dr_noclip"] then
                    if conn then conn:Disconnect() end
                    return
                end
                local char = LocalPlayer.Character
                if char then
                    for _, p in ipairs(char:GetDescendants()) do
                        if p:IsA("BasePart") then p.CanCollide = false end
                    end
                end
            end)
            _G.Connections["dr_noclip"] = conn
        end,
        function()
            if _G.Connections["dr_noclip"] then
                _G.Connections["dr_noclip"]:Disconnect()
                _G.Connections["dr_noclip"] = nil
            end
        end
    )
end

-- 18. DANDY'S WORLD
local function Panel_Dandy(parent)
    local order = 0
    local function addLbl(t) order = order + 1; CreateFuncLabel(parent, t, order) end
    local function addTog(id, t, onF, offF)
        order = order + 1
        CreateToggleButton(parent, id, t, order, onF, offF)
    end

    addLbl("🎨 DANDY'S WORLD")

    addTog("dw_fly", "Fly",
        function()
            local conn
            conn = RunService.Heartbeat:Connect(function()
                if not _G.Toggles["dw_fly"] then
                    if conn then conn:Disconnect() end
                    return
                end
                local char = LocalPlayer.Character
                if char then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then hrp.Velocity = Vector3.new(0, 30, 0) end
                end
            end)
            _G.Connections["dw_fly"] = conn
        end,
        function()
            if _G.Connections["dw_fly"] then
                _G.Connections["dw_fly"]:Disconnect()
                _G.Connections["dw_fly"] = nil
            end
        end
    )

    addTog("dw_speed", "Скорость 60",
        function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 60
            end
        end,
        function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 16
            end
        end
    )
end

-- 19. BLADE BALL
local function Panel_BladeBall(parent)
    local order = 0
    local function addLbl(t) order = order + 1; CreateFuncLabel(parent, t, order) end
    local function addTog(id, t, onF, offF)
        order = order + 1
        CreateToggleButton(parent, id, t, order, onF, offF)
    end

    addLbl("⚔ BLADE BALL")

    addTog("bb_esp", "ESP игроков",
        function()
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    if not plr.Character:FindFirstChild("ESP_HL") then
                        local hl = Instance.new("Highlight")
                        hl.Name = "ESP_HL"
                        hl.FillColor = Color3.fromRGB(255, 255, 0)
                        hl.Parent = plr.Character
                    end
                end
            end
        end,
        function()
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr.Character then
                    local hl = plr.Character:FindFirstChild("ESP_HL")
                    if hl then hl:Destroy() end
                end
            end
        end
    )

    addTog("bb_speed", "Скорость 60",
        function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 60
            end
        end,
        function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 16
            end
        end
    )
end

-- 20. ARSENAL
local function Panel_Arsenal(parent)
    local order = 0
    local function addLbl(t) order = order + 1; CreateFuncLabel(parent, t, order) end
    local function addTog(id, t, onF, offF)
        order = order + 1
        CreateToggleButton(parent, id, t, order, onF, offF)
    end

    addLbl("🔫 ARSENAL")

    addTog("ar_esp", "ESP игроков",
        function()
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    if not plr.Character:FindFirstChild("ESP_HL") then
                        local hl = Instance.new("Highlight")
                        hl.Name = "ESP_HL"
                        hl.FillColor = Color3.fromRGB(255, 0, 255)
                        hl.Parent = plr.Character
                    end
                end
            end
        end,
        function()
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr.Character then
                    local hl = plr.Character:FindFirstChild("ESP_HL")
                    if hl then hl:Destroy() end
                end
            end
        end
    )

    addTog("ar_speed", "Скорость 50",
        function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 50
            end
        end,
        function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 16
            end
        end
    )
end

-- ============================================================
-- СОБИРАЕМ ПАНЕЛЬ
-- ============================================================
local screen, main, gameList, funcList = CreateMainPanel()

local Games = {
    {name = "🧠 Brainrot",    panel = Panel_Brainrot},
    {name = "🏠 Brookhaven",  panel = Panel_Brookhaven},
    {name = "🔪 MM2",         panel = Panel_MM2},
    {name = "🍇 Blox Fruits", panel = Panel_BloxFruits},
    {name = "🐾 Adopt Me",    panel = Panel_AdoptMe},
    {name = "🌱 Grow Garden", panel = Panel_GrowGarden},
    {name = "🌲 99 Nights",   panel = Panel_99Nights},
    {name = "🗼 TOH",         panel = Panel_TOH},
    {name = "💪 TSB",         panel = Panel_TSB},
    {name = "🔫 RIVALS",      panel = Panel_Rivals},
    {name = "🐷 Piggy",       panel = Panel_Piggy},
    {name = "🛏 BedWars",     panel = Panel_BedWars},
    {name = "👗 DTI",         panel = Panel_DTI},
    {name = "🏃 Evade",       panel = Panel_Evade},
    {name = "🐶 PSX",         panel = Panel_PSX},
    {name = "🚔 Jailbreak",   panel = Panel_Jailbreak},
    {name = "🚪 DOORS",       panel = Panel_Doors},
    {name = "🎨 Dandy",       panel = Panel_Dandy},
    {name = "⚔ Blade Ball",  panel = Panel_BladeBall},
    {name = "🔫 Arsenal",     panel = Panel_Arsenal}
}

local function ClearFuncList()
    for _, child in ipairs(funcList:GetChildren()) do
        if child:IsA("TextButton") or child:IsA("TextLabel") then
            child:Destroy()
        end
    end
end

local function ShowGamePanel(panelFunc)
    ClearFuncList()
    panelFunc(funcList)
end

for i, game in ipairs(Games) do
    CreateGameButton(gameList, game.name, i, function()
        ShowGamePanel(game.panel)
    end)
end

ShowGamePanel(Panel_Brainrot)

-- ============================================================
-- АНТИ-АФК
-- ============================================================
LocalPlayer.Idled:Connect(function()
    local vu = game:GetService("VirtualUser")
    vu:CaptureController()
    vu:ClickButton2(Vector2.new())
end)

-- ============================================================
-- СТОП-КРАН (Правый Ctrl)
-- ============================================================
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        _G.StopAll = true

        for id, conn in pairs(_G.Connections) do
            pcall(function() conn:Disconnect() end)
        end
        _G.Connections = {}

        for id, _ in pairs(_G.Toggles) do
            _G.Toggles[id] = false
        end

        local p = workspace:FindFirstChild("BrainrotPlatform")
        if p then p:Destroy() end

        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Character then
                local hl = plr.Character:FindFirstChild("ESP_HL")
                if hl then hl:Destroy() end
            end
        end

        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
            LocalPlayer.Character.Humanoid.JumpPower = 50
        end

        print("🛑 Стоп-кран: все функции выключены")
    end
end)

print("✅ Своя панель загружена! 20 игр готовы.")
print("🟢 = ВКЛ | ⚫ = ВЫКЛ")
print("Кликни по кнопке — вкл/выкл. Правый Ctrl — выключить всё.")
