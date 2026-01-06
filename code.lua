-- [[ 
--    DNLL by:SIX 
-- ]]

local function GenName()
    local s = ""
    for i = 1, 15 do s = s .. string.char(math.random(97, 122)) end
    return s
end

local UI_ID = GenName()
local CoreGui = game:GetService("CoreGui")
if CoreGui:FindFirstChild(UI_ID) then CoreGui[UI_ID]:Destroy() end

--// CONFIGURAÇÕES GLOBAIS
_G.Aimbot = false
_G.FovRadius = 100
_G.FovVisible = false
_G.SmoothInt = 2 
_G.WallCheck = true 
_G.MaxAimDistance = 500
_G.Speed = 16
_G.Fly = false
_G.FlySpeed = 50
_G.Noclip = false
_G.InfJump = false

--// VARIÁVEIS ESP
_G.ESP_Master = false
_G.ESP_Box = false
_G.ESP_Name = false
_G.ESP_HP = false
_G.ESP_Dist = false

local LP = game:GetService("Players").LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

--// FOV DRAWING
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.Color = Color3.fromRGB(0, 255, 150)
FOVCircle.Filled = false
FOVCircle.Transparency = 1

--// INTERFACE
local MainGui = Instance.new("ScreenGui", CoreGui)
MainGui.Name = UI_ID
local MainFrame = Instance.new("Frame", MainGui)
MainFrame.Size = UDim2.new(0, 280, 0, 360)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame)

-- TÍTULO DO MENU
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "DNLL hub by:SIX"
Title.TextColor3 = Color3.fromRGB(0, 255, 150)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold

local Content = Instance.new("Frame", MainFrame)
Content.Size = UDim2.new(1, -80, 1, -40)
Content.Position = UDim2.new(0, 75, 0, 35)
Content.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", Content)

local TabBar = Instance.new("Frame", MainFrame)
TabBar.Size = UDim2.new(0, 65, 1, -40)
TabBar.Position = UDim2.new(0, 5, 0, 35)
TabBar.BackgroundTransparency = 1
Instance.new("UIListLayout", TabBar).Padding = UDim.new(0, 5)

local Pages = {}
local function NewPage(name)
    local P = Instance.new("ScrollingFrame", Content)
    P.Size = UDim2.new(1, -10, 1, -10)
    P.Position = UDim2.new(0, 5, 0, 5)
    P.BackgroundTransparency = 1; P.Visible = false; P.ScrollBarThickness = 0
    Instance.new("UIListLayout", P).Padding = UDim.new(0, 5)
    local B = Instance.new("TextButton", TabBar)
    B.Size = UDim2.new(1, 0, 0, 30); B.Text = name; B.BackgroundColor3 = Color3.fromRGB(30, 30, 30); B.TextColor3 = Color3.fromRGB(255, 255, 255); B.TextSize = 10
    Instance.new("UICorner", B)
    B.MouseButton1Click:Connect(function()
        for _, v in pairs(Pages) do v.Visible = false end
        P.Visible = true
    end)
    Pages[name] = P; return P
end

local PAim = NewPage("AIM")
local PEsp = NewPage("ESP")
local PMisc = NewPage("MISC")
PAim.Visible = true

local function NewToggle(p, n, c)
    local b = Instance.new("TextButton", p)
    b.Size = UDim2.new(1, 0, 0, 25); b.Text = n; b.BackgroundColor3 = Color3.fromRGB(40, 40, 40); b.TextColor3 = Color3.fromRGB(180, 180, 180); b.TextSize = 11
    Instance.new("UICorner", b)
    local a = false
    b.MouseButton1Click:Connect(function()
        a = not a; b.BackgroundColor3 = a and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(40, 40, 40)
        c(a)
    end)
end

-- INPUT MINIMALISTA (TÍTULO DENTRO DA BOX)
local function NewInput(p, t, c)
    local i = Instance.new("TextBox", p)
    i.Size = UDim2.new(1, 0, 0, 28); i.PlaceholderText = t; i.Text = ""; i.BackgroundColor3 = Color3.fromRGB(35, 35, 35); i.TextColor3 = Color3.fromRGB(255, 255, 255); i.TextSize = 11; i.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    Instance.new("UICorner", i)
    i.FocusLost:Connect(function() c(i.Text) end)
end

-- // BOTÕES
NewToggle(PAim, "Aimbot", function(v) _G.Aimbot = v end)
NewToggle(PAim, "Wall Check", function(v) _G.WallCheck = v end)
NewToggle(PAim, "Ver FOV", function(v) _G.FovVisible = v end)
NewInput(PAim, "Distancia Aimbot", function(t) _G.MaxAimDistance = tonumber(t) or 500 end)
NewInput(PAim, "Tamanho FOV", function(t) _G.FovRadius = tonumber(t) or 100 end)
NewInput(PAim, "Suavidade (1-10)", function(t) _G.SmoothInt = tonumber(t) or 2 end)

NewToggle(PEsp, "ESP MASTER", function(v) _G.ESP_Master = v end)
NewToggle(PEsp, "Box", function(v) _G.ESP_Box = v end)
NewToggle(PEsp, "Nome", function(v) _G.ESP_Name = v end)
NewToggle(PEsp, "HP", function(v) _G.ESP_HP = v end)
NewToggle(PEsp, "Distancia", function(v) _G.ESP_Dist = v end)

NewToggle(PMisc, "Noclip", function(v) _G.Noclip = v end)
NewToggle(PMisc, "Fly", function(v) _G.Fly = v end)
NewToggle(PMisc, "Inf Jump", function(v) _G.InfJump = v end)
NewInput(PMisc, "Velocidade", function(t) _G.Speed = tonumber(t) or 16 end)
NewInput(PMisc, "Fly Speed", function(t) _G.FlySpeed = tonumber(t) or 50 end)

local OpenBtn = Instance.new("TextButton", MainGui)
OpenBtn.Size = UDim2.new(0, 45, 0, 45); OpenBtn.Position = UDim2.new(0, 10, 0.5, 0); OpenBtn.Text = "MENU"; OpenBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255); OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255); OpenBtn.Draggable = true; OpenBtn.Active = true
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
OpenBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

----------------------------------------------------
-- LÓGICA DE MOVIMENTO (FIXED)
----------------------------------------------------
RunService.Stepped:Connect(function()
    if LP.Character then
        for _, v in pairs(LP.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                if _G.Noclip then v.CanCollide = false else if v.Name ~= "HumanoidRootPart" then v.CanCollide = true end end
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") and LP.Character:FindFirstChild("Humanoid") then
        local hrp, hum = LP.Character.HumanoidRootPart, LP.Character.Humanoid
        hum.WalkSpeed = _G.Speed
        if _G.Fly then
            local bv = hrp:FindFirstChild("FlyV") or Instance.new("BodyVelocity", hrp)
            bv.Name = "FlyV"; bv.MaxForce = Vector3.new(9e9, 9e9, 9e9); bv.Velocity = Camera.CFrame.LookVector * _G.FlySpeed
            if hum:GetState() ~= Enum.HumanoidStateType.Physics then hum:ChangeState(Enum.HumanoidStateType.Physics) end
        else
            if hrp:FindFirstChild("FlyV") then hrp.FlyV:Destroy() end
            if hum:GetState() == Enum.HumanoidStateType.Physics then hum:ChangeState(Enum.HumanoidStateType.GettingUp) end
        end
    end
end)

----------------------------------------------------
-- LÓGICA ESP (FIXED POSITION)
----------------------------------------------------
local function AddESP(plr)
    local Box, Name, Dist, HP = Drawing.new("Square"), Drawing.new("Text"), Drawing.new("Text"), Drawing.new("Text")

    RunService.RenderStepped:Connect(function()
        if _G.ESP_Master and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Parent then
            local char = plr.Character
            local hrp = char.HumanoidRootPart
            local pos, on = Camera:WorldToViewportPoint(hrp.Position)
            
            if on then
                local headPos = Camera:WorldToViewportPoint(char.Head.Position)
                local sizeY = math.abs(headPos.Y - pos.Y) * 2.2
                local sizeX = sizeY * 0.6
                
                Box.Visible = _G.ESP_Box; Box.Size = Vector2.new(sizeX, sizeY); Box.Position = Vector2.new(pos.X - sizeX/2, pos.Y - sizeY/2); Box.Color = Color3.fromRGB(255, 255, 255)
                
                Name.Visible = _G.ESP_Name; Name.Text = plr.Name; Name.Position = Vector2.new(pos.X, pos.Y - sizeY/2 - 15); Name.Center = true; Name.Outline = true; Name.Size = 14
                
                Dist.Visible = _G.ESP_Dist; local d = (LP.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                Dist.Text = math.floor(d).."m"; Dist.Position = Vector2.new(pos.X, pos.Y + sizeY/2 + 5); Dist.Center = true; Dist.Outline = true; Dist.Size = 14

                if char:FindFirstChild("Humanoid") then
                    HP.Visible = _G.ESP_HP; HP.Text = "HP: "..math.floor(char.Humanoid.Health)
                    HP.Color = Color3.fromHSV(char.Humanoid.Health/100 * 0.3, 1, 1)
                    HP.Position = Vector2.new(pos.X, pos.Y + sizeY/2 + 20); HP.Center = true; HP.Outline = true; HP.Size = 14
                else HP.Visible = false end
            else Box.Visible = false; Name.Visible = false; Dist.Visible = false; HP.Visible = false end
        else
            Box.Visible = false; Name.Visible = false; Dist.Visible = false; HP.Visible = false
            if not plr.Parent then Box:Remove(); Name:Remove(); Dist:Remove(); HP:Remove() end
        end
    end)
end

for _, p in pairs(game.Players:GetPlayers()) do if p ~= LP then AddESP(p) end end
game.Players.PlayerAdded:Connect(function(p) if p ~= LP then AddESP(p) end end)

----------------------------------------------------
-- AIMBOT & FOV
----------------------------------------------------
RunService.RenderStepped:Connect(function()
    FOVCircle.Visible = _G.FovVisible; FOVCircle.Radius = _G.FovRadius; FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    if _G.Aimbot then
        local target = nil; local shortest = _G.FovRadius
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= LP and p.Character and p.Character:FindFirstChild("Head") and p.Character.Humanoid.Health > 0 then
                local head = p.Character.Head
                local distFromMe = (LP.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                if distFromMe > _G.MaxAimDistance then continue end
                local pos, on = Camera:WorldToViewportPoint(head.Position)
                if on then
                    if _G.WallCheck then
                        local cast = Camera:GetPartsObscuringTarget({head.Position}, {LP.Character, p.Character})
                        if #cast > 0 then continue end
                    end
                    local mag = (Vector2.new(pos.X, pos.Y) - FOVCircle.Position).Magnitude
                    if mag < shortest then shortest = mag; target = head end
                end
            end
        end
        if target then Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Position), _G.SmoothInt/100) end
    end
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.InfJump and LP.Character then LP.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end
end)
