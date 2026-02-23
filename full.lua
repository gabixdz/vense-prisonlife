-- Vense Prison Life Gun Script
-- Place as LocalScript in StarterPlayerScripts

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player.PlayerGui

-- ============================================================
-- TOGGLE STATES
-- ============================================================
local toggles = {
	godDamage    = false,
	infiniteAmmo = false,
	noFireRate   = false,
	maxRange     = false,
	noSpread     = false,
	fastReload   = false,
}

-- ============================================================
-- GUN LOOP — runs every frame, applies settings if gun equipped
-- ============================================================
RunService.Heartbeat:Connect(function()
	local char = player.Character
	if not char then return end

	local tool = char:FindFirstChildOfClass("Tool")
	if not tool then return end

	-- Try to find GunStates ModuleScript
	local gunStatesModule = tool:FindFirstChild("GunStates")
	if not gunStatesModule then return end

	local ok, gun = pcall(require, gunStatesModule)
	if not ok or type(gun) ~= "table" then return end

	if toggles.godDamage then
		gun.Damage = 1000
	end

	if toggles.infiniteAmmo then
		-- Handle both flat and nested table structures
		if type(gun.Max) == "table" then
			gun.Max.Ammo = math.huge
		else
			gun.MaxAmmo = math.huge
		end
		if type(gun.Current) == "table" then
			gun.Current.Ammo = math.huge
		else
			gun.CurrentAmmo = math.huge
		end
		-- Also try direct keys common in Prison Life guns
		gun.StoredAmmo   = math.huge
		gun.AmmoInClip   = math.huge
	end

	if toggles.noFireRate then
		gun.FireRate   = 0
		gun.Delay      = 0
		gun.FireDelay  = 0
	end

	if toggles.maxRange then
		gun.Range      = 9999
		gun.MaxRange   = 9999
	end

	if toggles.noSpread then
		gun.Spread     = 0
		gun.MinSpread  = 0
		gun.MaxSpread  = 0
	end

	if toggles.fastReload then
		gun.ReloadTime = 0
		gun.Reload     = 0
	end
end)

-- ============================================================
-- GUI
-- ============================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VenseGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- ─── LOADING SCREEN ─────────────────────────────────────────
local loadFrame = Instance.new("Frame")
loadFrame.Size = UDim2.new(1,0,1,0)
loadFrame.BackgroundColor3 = Color3.fromRGB(5,5,10)
loadFrame.BorderSizePixel = 0
loadFrame.ZIndex = 100
loadFrame.Parent = screenGui

local loadLabel = Instance.new("TextLabel")
loadLabel.Size = UDim2.new(0.8,0,0,50)
loadLabel.AnchorPoint = Vector2.new(0.5,0.5)
loadLabel.Position = UDim2.new(0.5,0,0.5,0)
loadLabel.BackgroundTransparency = 1
loadLabel.Text = ""
loadLabel.Font = Enum.Font.Code
loadLabel.TextSize = 20
loadLabel.TextColor3 = Color3.fromRGB(0,255,128)
loadLabel.ZIndex = 101
loadLabel.Parent = loadFrame

local loadBarBg = Instance.new("Frame")
loadBarBg.Size = UDim2.new(0.8,0,0,4)
loadBarBg.Position = UDim2.new(0.1,0,0.6,0)
loadBarBg.BackgroundColor3 = Color3.fromRGB(25,25,35)
loadBarBg.BorderSizePixel = 0
loadBarBg.ZIndex = 101
loadBarBg.Parent = loadFrame
Instance.new("UICorner", loadBarBg).CornerRadius = UDim.new(1,0)

local loadBarFill = Instance.new("Frame")
loadBarFill.Size = UDim2.new(0,0,1,0)
loadBarFill.BackgroundColor3 = Color3.fromRGB(0,255,128)
loadBarFill.BorderSizePixel = 0
loadBarFill.ZIndex = 102
loadBarFill.Parent = loadBarBg
Instance.new("UICorner", loadBarFill).CornerRadius = UDim.new(1,0)

-- Typewriter then reveal
task.spawn(function()
	local fullText = "> loading vense gun script..."
	for i = 1, #fullText do
		loadLabel.Text = string.sub(fullText, 1, i)
		task.wait(0.04)
	end
	TweenService:Create(loadBarFill, TweenInfo.new(1, Enum.EasingStyle.Quart), {Size = UDim2.new(1,0,1,0)}):Play()
	task.wait(1.2)
	TweenService:Create(loadFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
	TweenService:Create(loadLabel, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
	task.wait(0.55)
	loadFrame:Destroy()
end)

-- ─── MAIN FRAME ─────────────────────────────────────────────
local mainFrame = Instance.new("Frame")
mainFrame.Name = "Main"
mainFrame.Size = UDim2.new(0,420,0,0)
mainFrame.AnchorPoint = Vector2.new(0.5,0.5)
mainFrame.Position = UDim2.new(0.5,0,0.5,0)
mainFrame.BackgroundColor3 = Color3.fromRGB(10,10,16)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = false
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0,5)

local stroke = Instance.new("UIStroke", mainFrame)
stroke.Color = Color3.fromRGB(0,210,100)
stroke.Thickness = 1.5
stroke.Transparency = 0.4

-- Title bar
local titleBar = Instance.new("Frame", mainFrame)
titleBar.Size = UDim2.new(1,0,0,44)
titleBar.BackgroundColor3 = Color3.fromRGB(0,160,75)
titleBar.BorderSizePixel = 0
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0,5)

-- Fix bottom corners of title bar
local titleFix = Instance.new("Frame", titleBar)
titleFix.Size = UDim2.new(1,0,0.5,0)
titleFix.Position = UDim2.new(0,0,0.5,0)
titleFix.BackgroundColor3 = Color3.fromRGB(0,160,75)
titleFix.BorderSizePixel = 0

local titleLbl = Instance.new("TextLabel", titleBar)
titleLbl.Size = UDim2.new(1,-50,1,0)
titleLbl.Position = UDim2.new(0,14,0,0)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "VENSE  //  PRISON LIFE"
titleLbl.Font = Enum.Font.GothamBold
titleLbl.TextSize = 13
titleLbl.TextColor3 = Color3.fromRGB(255,255,255)
titleLbl.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Size = UDim2.new(0,32,0,32)
closeBtn.Position = UDim2.new(1,-38,0.5,0)
closeBtn.AnchorPoint = Vector2.new(0,0.5)
closeBtn.BackgroundColor3 = Color3.fromRGB(200,30,30)
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 13
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.ZIndex = 5
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,4)

-- Status bar
local statusBar = Instance.new("Frame", mainFrame)
statusBar.Size = UDim2.new(1,0,0,24)
statusBar.Position = UDim2.new(0,0,0,44)
statusBar.BackgroundColor3 = Color3.fromRGB(15,15,22)
statusBar.BorderSizePixel = 0

local statusLbl = Instance.new("TextLabel", statusBar)
statusLbl.Size = UDim2.new(1,-10,1,0)
statusLbl.Position = UDim2.new(0,10,0,0)
statusLbl.BackgroundTransparency = 1
statusLbl.Text = "● IDLE — no toggles active"
statusLbl.Font = Enum.Font.Code
statusLbl.TextSize = 11
statusLbl.TextColor3 = Color3.fromRGB(100,100,120)
statusLbl.TextXAlignment = Enum.TextXAlignment.Left

-- List
local listFrame = Instance.new("ScrollingFrame", mainFrame)
listFrame.Size = UDim2.new(1,-16,0,0) -- height set dynamically
listFrame.Position = UDim2.new(0,8,0,74)
listFrame.BackgroundTransparency = 1
listFrame.BorderSizePixel = 0
listFrame.ScrollBarThickness = 3
listFrame.ScrollBarImageColor3 = Color3.fromRGB(0,200,100)
listFrame.CanvasSize = UDim2.new(0,0,0,0)
listFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

local listLayout = Instance.new("UIListLayout", listFrame)
listLayout.Padding = UDim.new(0,6)

-- ─── REOPEN BUTTON ──────────────────────────────────────────
local reopenBtn = Instance.new("TextButton", screenGui)
reopenBtn.Size = UDim2.new(0,36,0,36)
reopenBtn.Position = UDim2.new(1,-46,0,60)
reopenBtn.BackgroundColor3 = Color3.fromRGB(0,160,75)
reopenBtn.Text = "V"
reopenBtn.Font = Enum.Font.GothamBold
reopenBtn.TextSize = 16
reopenBtn.TextColor3 = Color3.fromRGB(255,255,255)
reopenBtn.Visible = false
Instance.new("UICorner", reopenBtn).CornerRadius = UDim.new(0,5)

-- ─── STATUS UPDATE ──────────────────────────────────────────
local function updateStatus()
	local active = {}
	if toggles.godDamage    then table.insert(active, "GOD DMG")      end
	if toggles.infiniteAmmo then table.insert(active, "INF AMMO")     end
	if toggles.noFireRate   then table.insert(active, "NO FIRE DELAY") end
	if toggles.maxRange     then table.insert(active, "MAX RANGE")    end
	if toggles.noSpread     then table.insert(active, "NO SPREAD")    end
	if toggles.fastReload   then table.insert(active, "FAST RELOAD")  end

	if #active > 0 then
		statusLbl.Text = "● ACTIVE — " .. table.concat(active, " · ")
		statusLbl.TextColor3 = Color3.fromRGB(0,230,110)
	else
		statusLbl.Text = "● IDLE — no toggles active"
		statusLbl.TextColor3 = Color3.fromRGB(100,100,120)
	end
end

-- ─── TOGGLE FACTORY ─────────────────────────────────────────
local ROWS = 6
local ROW_H = 58
local PADDING = 6

local function makeToggle(title, desc, key)
	local row = Instance.new("Frame", listFrame)
	row.Size = UDim2.new(1,0,0,ROW_H)
	row.BackgroundColor3 = Color3.fromRGB(16,16,24)
	row.BorderSizePixel = 0
	Instance.new("UICorner", row).CornerRadius = UDim.new(0,4)

	-- Left accent line (shows when ON)
	local accent = Instance.new("Frame", row)
	accent.Size = UDim2.new(0,3,1,-12)
	accent.Position = UDim2.new(0,0,0.5,0)
	accent.AnchorPoint = Vector2.new(0,0.5)
	accent.BackgroundColor3 = Color3.fromRGB(0,230,110)
	accent.BackgroundTransparency = 1
	accent.BorderSizePixel = 0
	Instance.new("UICorner", accent).CornerRadius = UDim.new(1,0)

	local lbl = Instance.new("TextLabel", row)
	lbl.Size = UDim2.new(1,-80,0,22)
	lbl.Position = UDim2.new(0,14,0,8)
	lbl.BackgroundTransparency = 1
	lbl.Text = title
	lbl.Font = Enum.Font.GothamBold
	lbl.TextSize = 13
	lbl.TextColor3 = Color3.fromRGB(200,200,215)
	lbl.TextXAlignment = Enum.TextXAlignment.Left

	local descLbl = Instance.new("TextLabel", row)
	descLbl.Size = UDim2.new(1,-80,0,16)
	descLbl.Position = UDim2.new(0,14,0,32)
	descLbl.BackgroundTransparency = 1
	descLbl.Text = desc
	descLbl.Font = Enum.Font.Code
	descLbl.TextSize = 10
	descLbl.TextColor3 = Color3.fromRGB(70,70,90)
	descLbl.TextXAlignment = Enum.TextXAlignment.Left

	-- Pill background
	local pill = Instance.new("Frame", row)
	pill.Size = UDim2.new(0,52,0,26)
	pill.Position = UDim2.new(1,-64,0.5,0)
	pill.AnchorPoint = Vector2.new(0,0.5)
	pill.BackgroundColor3 = Color3.fromRGB(35,35,50)
	pill.BorderSizePixel = 0
	Instance.new("UICorner", pill).CornerRadius = UDim.new(1,0)

	-- Pill knob
	local knob = Instance.new("Frame", pill)
	knob.Size = UDim2.new(0,20,0,20)
	knob.Position = UDim2.new(0,3,0.5,0)
	knob.AnchorPoint = Vector2.new(0,0.5)
	knob.BackgroundColor3 = Color3.fromRGB(90,90,110)
	knob.BorderSizePixel = 0
	knob.ZIndex = 2
	Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)

	-- State indicator text inside knob
	local stateTag = Instance.new("TextLabel", row)
	stateTag.Size = UDim2.new(0,52,0,14)
	stateTag.Position = UDim2.new(1,-64,1,-14)
	stateTag.BackgroundTransparency = 1
	stateTag.Text = "OFF"
	stateTag.Font = Enum.Font.Code
	stateTag.TextSize = 9
	stateTag.TextColor3 = Color3.fromRGB(60,60,80)
	stateTag.TextXAlignment = Enum.TextXAlignment.Center
	stateTag.ZIndex = 2

	-- Click overlay
	local btn = Instance.new("TextButton", row)
	btn.Size = UDim2.new(1,0,1,0)
	btn.BackgroundTransparency = 1
	btn.Text = ""
	btn.ZIndex = 3

	local isOn = false

	local function set(state)
		isOn = state
		toggles[key] = state

		-- Visual: pill
		TweenService:Create(pill, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {
			BackgroundColor3 = state and Color3.fromRGB(0,185,90) or Color3.fromRGB(35,35,50)
		}):Play()
		-- Visual: knob slide
		TweenService:Create(knob, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {
			Position = state and UDim2.new(0,29,0.5,0) or UDim2.new(0,3,0.5,0),
			BackgroundColor3 = state and Color3.fromRGB(255,255,255) or Color3.fromRGB(90,90,110)
		}):Play()
		-- Visual: accent bar
		TweenService:Create(accent, TweenInfo.new(0.18), {
			BackgroundTransparency = state and 0 or 1
		}):Play()
		-- Visual: title color
		TweenService:Create(lbl, TweenInfo.new(0.18), {
			TextColor3 = state and Color3.fromRGB(0,230,110) or Color3.fromRGB(200,200,215)
		}):Play()
		-- Visual: row bg
		TweenService:Create(row, TweenInfo.new(0.18), {
			BackgroundColor3 = state and Color3.fromRGB(0,25,12) or Color3.fromRGB(16,16,24)
		}):Play()
		-- State tag
		stateTag.Text = state and "ON" or "OFF"
		stateTag.TextColor3 = state and Color3.fromRGB(0,200,100) or Color3.fromRGB(60,60,80)

		updateStatus()
	end

	btn.MouseButton1Click:Connect(function() set(not isOn) end)
	btn.TouchTap:Connect(function() set(not isOn) end)

	btn.MouseEnter:Connect(function()
		if not isOn then
			TweenService:Create(row, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(22,22,32)}):Play()
		end
	end)
	btn.MouseLeave:Connect(function()
		if not isOn then
			TweenService:Create(row, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(16,16,24)}):Play()
		end
	end)
end

makeToggle("GOD DAMAGE",     "gun.Damage = 1000",                    "godDamage")
makeToggle("INFINITE AMMO",  "Max & Current Ammo = ∞",               "infiniteAmmo")
makeToggle("NO FIRE DELAY",  "gun.FireRate / FireDelay = 0",         "noFireRate")
makeToggle("MAX RANGE",      "gun.Range = 9999 studs",               "maxRange")
makeToggle("NO SPREAD",      "gun.Spread / MinSpread / MaxSpread = 0","noSpread")
makeToggle("INSTANT RELOAD", "gun.ReloadTime = 0",                   "fastReload")

-- ─── OPEN / CLOSE ANIMATION ─────────────────────────────────
local FULL_HEIGHT = 74 + (ROW_H + PADDING) * ROWS + 14

local function openGui()
	mainFrame.Visible = true
	mainFrame.Size = UDim2.new(0,420,0,44) -- start at title bar height
	reopenBtn.Visible = false
	listFrame.Size = UDim2.new(1,-16,0,FULL_HEIGHT - 74)
	TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Size = UDim2.new(0,420,0,FULL_HEIGHT)
	}):Play()
end

local function closeGui()
	TweenService:Create(mainFrame, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		Size = UDim2.new(0,420,0,0)
	}):Play()
	task.wait(0.25)
	mainFrame.Visible = false
	reopenBtn.Visible = true
end

closeBtn.MouseButton1Click:Connect(closeGui)
closeBtn.TouchTap:Connect(closeGui)
reopenBtn.MouseButton1Click:Connect(openGui)
reopenBtn.TouchTap:Connect(openGui)

reopenBtn.MouseEnter:Connect(function()
	TweenService:Create(reopenBtn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(0,200,100)}):Play()
end)
reopenBtn.MouseLeave:Connect(function()
	TweenService:Create(reopenBtn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(0,160,75)}):Play()
end)

-- Open after load screen
task.wait(2.5)
openGui()

