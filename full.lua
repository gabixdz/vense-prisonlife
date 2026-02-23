-- Vense Prison Life Gun Script
-- LocalScript (place in StarterPlayerScripts or StarterGui)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player.PlayerGui

-- ============================================================
-- SETTINGS DEFAULTS
-- ============================================================
local settings = {
	godDamage   = false,  -- gun.Damage = 1000
	infiniteAmmo = false, -- gun.MaxAmmo / CurrentAmmo = -1
	noFireRate   = false, -- gun.FireRate = 0
	maxRange     = false, -- gun.Range = 1000
	noSpread     = false, -- gun.Spread = 0 (toggle: 0 vs 5)
	fastReload   = false, -- gun.ReloadTime = 0
}

-- ============================================================
-- GUI CONSTRUCTION
-- ============================================================

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VenseGunGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- ────────────────────────────────────────────
-- LOADING SCREEN
-- ────────────────────────────────────────────
local loadFrame = Instance.new("Frame")
loadFrame.Name = "LoadScreen"
loadFrame.Size = UDim2.new(1,0,1,0)
loadFrame.Position = UDim2.new(0,0,0,0)
loadFrame.BackgroundColor3 = Color3.fromRGB(5,5,10)
loadFrame.BorderSizePixel = 0
loadFrame.ZIndex = 100
loadFrame.Parent = screenGui

local loadLabel = Instance.new("TextLabel")
loadLabel.Size = UDim2.new(0.8,0,0,60)
loadLabel.AnchorPoint = Vector2.new(0.5,0.5)
loadLabel.Position = UDim2.new(0.5,0,0.5,0)
loadLabel.BackgroundTransparency = 1
loadLabel.Text = ""
loadLabel.Font = Enum.Font.Code
loadLabel.TextSize = 22
loadLabel.TextColor3 = Color3.fromRGB(0,255,128)
loadLabel.ZIndex = 101
loadLabel.Parent = loadFrame

local loadBar = Instance.new("Frame")
loadBar.Size = UDim2.new(0,0,0,3)
loadBar.Position = UDim2.new(0.1,0,0.6,0)
loadBar.BackgroundColor3 = Color3.fromRGB(0,255,128)
loadBar.BorderSizePixel = 0
loadBar.ZIndex = 101
loadBar.Parent = loadFrame

local loadCorner = Instance.new("UICorner")
loadCorner.CornerRadius = UDim.new(0,2)
loadCorner.Parent = loadBar

-- Typewriter animation
local fullText = "> loading vense gun script..."
task.spawn(function()
	for i = 1, #fullText do
		loadLabel.Text = string.sub(fullText, 1, i)
		task.wait(0.045)
	end
	-- Bar fill
	TweenService:Create(loadBar, TweenInfo.new(1.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
		Size = UDim2.new(0.8,0,0,3)
	}):Play()
	task.wait(1.4)
	-- Fade out load screen
	TweenService:Create(loadFrame, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {
		BackgroundTransparency = 1
	}):Play()
	TweenService:Create(loadLabel, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {
		TextTransparency = 1
	}):Play()
	TweenService:Create(loadBar, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {
		BackgroundTransparency = 1
	}):Play()
	task.wait(0.6)
	loadFrame:Destroy()
end)

-- ────────────────────────────────────────────
-- MAIN GUI FRAME (CSGO-style wide panel)
-- ────────────────────────────────────────────
local mainFrame = Instance.new("Frame")
mainFrame.Name = "Main"
mainFrame.Size = UDim2.new(0,400,0,360)
mainFrame.AnchorPoint = Vector2.new(0.5,0.5)
mainFrame.Position = UDim2.new(0.5,0,0.5,0)
mainFrame.BackgroundColor3 = Color3.fromRGB(12,12,18)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = false
mainFrame.Parent = screenGui

-- Outer glow border via UIStroke
local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(0,200,100)
mainStroke.Thickness = 1.5
mainStroke.Transparency = 0.3
mainStroke.Parent = mainFrame

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0,4)
mainCorner.Parent = mainFrame

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1,0,0,42)
titleBar.BackgroundColor3 = Color3.fromRGB(0,170,80)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0,4)
titleCorner.Parent = titleBar

-- Clip bottom corners of title bar
local titleFix = Instance.new("Frame")
titleFix.Size = UDim2.new(1,0,0,10)
titleFix.Position = UDim2.new(0,0,1,-10)
titleFix.BackgroundColor3 = Color3.fromRGB(0,170,80)
titleFix.BorderSizePixel = 0
titleFix.ZIndex = 0
titleFix.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1,-50,1,0)
titleLabel.Position = UDim2.new(0,14,0,0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "VENSE  //  PRISON LIFE GUN"
titleLabel.Font = Enum.Font.Code
titleLabel.TextSize = 14
titleLabel.TextColor3 = Color3.fromRGB(255,255,255)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Close button [X]
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,36,0,36)
closeBtn.Position = UDim2.new(1,-40,0,3)
closeBtn.BackgroundColor3 = Color3.fromRGB(200,30,30)
closeBtn.BorderSizePixel = 0
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.ZIndex = 2
closeBtn.Parent = titleBar

local closeBtnCorner = Instance.new("UICorner")
closeBtnCorner.CornerRadius = UDim.new(0,3)
closeBtnCorner.Parent = closeBtn

-- Subtitle / status bar
local subLabel = Instance.new("TextLabel")
subLabel.Size = UDim2.new(1,0,0,22)
subLabel.Position = UDim2.new(0,0,0,42)
subLabel.BackgroundColor3 = Color3.fromRGB(20,20,30)
subLabel.BorderSizePixel = 0
subLabel.Text = "  STATUS: IDLE  |  all toggles off"
subLabel.Font = Enum.Font.Code
subLabel.TextSize = 11
subLabel.TextColor3 = Color3.fromRGB(120,120,140)
subLabel.TextXAlignment = Enum.TextXAlignment.Left
subLabel.Parent = mainFrame

-- Scrolling list area
local listFrame = Instance.new("ScrollingFrame")
listFrame.Size = UDim2.new(1,-16,1,-80)
listFrame.Position = UDim2.new(0,8,0,70)
listFrame.BackgroundTransparency = 1
listFrame.BorderSizePixel = 0
listFrame.ScrollBarThickness = 3
listFrame.ScrollBarImageColor3 = Color3.fromRGB(0,200,100)
listFrame.CanvasSize = UDim2.new(0,0,0,0)
listFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
listFrame.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0,6)
listLayout.Parent = listFrame

-- ────────────────────────────────────────────
-- SMALL REOPEN BUTTON (bottom-right "V")
-- ────────────────────────────────────────────
local reopenBtn = Instance.new("TextButton")
reopenBtn.Size = UDim2.new(0,34,0,34)
reopenBtn.Position = UDim2.new(1,-44,0,60)
reopenBtn.AnchorPoint = Vector2.new(0,0)
reopenBtn.BackgroundColor3 = Color3.fromRGB(0,170,80)
reopenBtn.BorderSizePixel = 0
reopenBtn.Text = "V"
reopenBtn.Font = Enum.Font.GothamBold
reopenBtn.TextSize = 16
reopenBtn.TextColor3 = Color3.fromRGB(255,255,255)
reopenBtn.Visible = false
reopenBtn.Parent = screenGui

local reopenCorner = Instance.new("UICorner")
reopenCorner.CornerRadius = UDim.new(0,4)
reopenCorner.Parent = reopenBtn

-- ============================================================
-- HELPER: apply gun settings each frame we have a tool
-- ============================================================
local function applySettings()
	local char = player.Character
	if not char then return end
	local tool = char:FindFirstChildOfClass("Tool")
	if not tool then return end
	local ok, gun = pcall(function()
		return require(tool.GunStates)
	end)
	if not ok or not gun then return end

	if settings.godDamage    then gun.Damage         = 1000 end
	if settings.infiniteAmmo then gun.Max             = {Ammo = -1} ; gun.Current = {Ammo = -1} end
	if settings.noFireRate   then gun.FireRate        = 0   end
	if settings.maxRange     then gun.Range           = 1000 end
	if settings.noSpread     then gun.Spread          = 0   else gun.Spread = 5 end
	if settings.fastReload   then gun.ReloadTime      = 0   end
end

RunService.Heartbeat:Connect(applySettings)

-- ============================================================
-- TOGGLE BUTTON FACTORY
-- ============================================================
local function updateStatusBar()
	local on = {}
	if settings.godDamage    then table.insert(on,"DMG")  end
	if settings.infiniteAmmo then table.insert(on,"AMO")  end
	if settings.noFireRate   then table.insert(on,"RATE") end
	if settings.maxRange     then table.insert(on,"RNG")  end
	if settings.noSpread     then table.insert(on,"SPR")  end
	if settings.fastReload   then table.insert(on,"RLD")  end
	if #on > 0 then
		subLabel.Text = "  STATUS: ACTIVE  |  " .. table.concat(on," · ")
		subLabel.TextColor3 = Color3.fromRGB(0,220,110)
	else
		subLabel.Text = "  STATUS: IDLE  |  all toggles off"
		subLabel.TextColor3 = Color3.fromRGB(120,120,140)
	end
end

local function createToggle(labelText, description, settingKey)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1,0,0,54)
	row.BackgroundColor3 = Color3.fromRGB(18,18,26)
	row.BorderSizePixel = 0
	row.Parent = listFrame

	local rowCorner = Instance.new("UICorner")
	rowCorner.CornerRadius = UDim.new(0,4)
	rowCorner.Parent = row

	local accentBar = Instance.new("Frame")
	accentBar.Size = UDim2.new(0,3,1,0)
	accentBar.BackgroundColor3 = Color3.fromRGB(0,200,100)
	accentBar.BorderSizePixel = 0
	accentBar.BackgroundTransparency = 1
	accentBar.Parent = row

	local accentCorner = Instance.new("UICorner")
	accentCorner.CornerRadius = UDim.new(0,2)
	accentCorner.Parent = accentBar

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1,-80,0,22)
	lbl.Position = UDim2.new(0,14,0,8)
	lbl.BackgroundTransparency = 1
	lbl.Text = labelText
	lbl.Font = Enum.Font.GothamBold
	lbl.TextSize = 13
	lbl.TextColor3 = Color3.fromRGB(220,220,235)
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Parent = row

	local desc = Instance.new("TextLabel")
	desc.Size = UDim2.new(1,-80,0,16)
	desc.Position = UDim2.new(0,14,0,30)
	desc.BackgroundTransparency = 1
	desc.Text = description
	desc.Font = Enum.Font.Code
	desc.TextSize = 10
	desc.TextColor3 = Color3.fromRGB(80,80,100)
	desc.TextXAlignment = Enum.TextXAlignment.Left
	desc.Parent = row

	-- Toggle pill
	local pillBg = Instance.new("Frame")
	pillBg.Size = UDim2.new(0,50,0,24)
	pillBg.Position = UDim2.new(1,-66,0.5,0)
	pillBg.AnchorPoint = Vector2.new(0,0.5)
	pillBg.BackgroundColor3 = Color3.fromRGB(40,40,55)
	pillBg.BorderSizePixel = 0
	pillBg.Parent = row

	local pillCorner = Instance.new("UICorner")
	pillCorner.CornerRadius = UDim.new(1,0)
	pillCorner.Parent = pillBg

	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0,18,0,18)
	knob.Position = UDim2.new(0,3,0.5,0)
	knob.AnchorPoint = Vector2.new(0,0.5)
	knob.BackgroundColor3 = Color3.fromRGB(100,100,120)
	knob.BorderSizePixel = 0
	knob.ZIndex = 2
	knob.Parent = pillBg

	local knobCorner = Instance.new("UICorner")
	knobCorner.CornerRadius = UDim.new(1,0)
	knobCorner.Parent = knob

	-- Clickable overlay (entire row)
	local clickArea = Instance.new("TextButton")
	clickArea.Size = UDim2.new(1,0,1,0)
	clickArea.BackgroundTransparency = 1
	clickArea.Text = ""
	clickArea.ZIndex = 3
	clickArea.Parent = row

	local isOn = false

	local function setToggle(state, animate)
		isOn = state
		settings[settingKey] = state
		local targetKnobX = state and UDim2.new(0,29,0.5,0) or UDim2.new(0,3,0.5,0)
		local targetPillColor = state and Color3.fromRGB(0,190,95) or Color3.fromRGB(40,40,55)
		local targetKnobColor = state and Color3.fromRGB(255,255,255) or Color3.fromRGB(100,100,120)
		local targetAccentAlpha = state and 0 or 1

		if animate then
			TweenService:Create(knob, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Position = targetKnobX, BackgroundColor3 = targetKnobColor}):Play()
			TweenService:Create(pillBg, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = targetPillColor}):Play()
			TweenService:Create(accentBar, TweenInfo.new(0.2), {BackgroundTransparency = targetAccentAlpha}):Play()
			TweenService:Create(lbl, TweenInfo.new(0.2), {TextColor3 = state and Color3.fromRGB(0,230,115) or Color3.fromRGB(220,220,235)}):Play()
		else
			knob.Position = targetKnobX
			knob.BackgroundColor3 = targetKnobColor
			pillBg.BackgroundColor3 = targetPillColor
			accentBar.BackgroundTransparency = targetAccentAlpha
			lbl.TextColor3 = state and Color3.fromRGB(0,230,115) or Color3.fromRGB(220,220,235)
		end
		updateStatusBar()
	end

	clickArea.MouseButton1Click:Connect(function()
		setToggle(not isOn, true)
	end)
	clickArea.TouchTap:Connect(function()
		setToggle(not isOn, true)
	end)

	-- Hover effect
	clickArea.MouseEnter:Connect(function()
		TweenService:Create(row, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(24,24,36)}):Play()
	end)
	clickArea.MouseLeave:Connect(function()
		TweenService:Create(row, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(18,18,26)}):Play()
	end)

	return row
end

-- ============================================================
-- BUILD TOGGLE BUTTONS
-- ============================================================
createToggle("GOD DAMAGE",    "Sets gun.Damage to 1000",           "godDamage")
createToggle("INFINITE AMMO", "Sets Max & Current Ammo to -1",     "infiniteAmmo")
createToggle("NO FIRE DELAY", "Sets gun.FireRate to 0",            "noFireRate")
createToggle("MAX RANGE",     "Sets gun.Range to 1000 studs",      "maxRange")
createToggle("NO SPREAD",     "Sets gun.Spread to 0 (perfect aim)","noSpread")
createToggle("INSTANT RELOAD","Sets gun.ReloadTime to 0",          "fastReload")

-- ============================================================
-- SHOW MAIN GUI (after load screen)
-- ============================================================
local function showGui()
	mainFrame.Size = UDim2.new(0,400,0,10)
	mainFrame.BackgroundTransparency = 1
	mainFrame.Visible = true
	reopenBtn.Visible = false
	TweenService:Create(mainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Size = UDim2.new(0,400,0,360),
		BackgroundTransparency = 0,
	}):Play()
end

local function hideGui()
	TweenService:Create(mainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		Size = UDim2.new(0,400,0,10),
		BackgroundTransparency = 1,
	}):Play()
	task.wait(0.28)
	mainFrame.Visible = false
	reopenBtn.Visible = true
	-- Pulse effect on reopen button
	TweenService:Create(reopenBtn, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Size = UDim2.new(0,34,0,34)
	}):Play()
end

task.wait(2.8) -- let loading animation play
showGui()

closeBtn.MouseButton1Click:Connect(hideGui)
closeBtn.TouchTap:Connect(hideGui)
reopenBtn.MouseButton1Click:Connect(showGui)
reopenBtn.TouchTap:Connect(showGui)

-- Hover on reopen button
reopenBtn.MouseEnter:Connect(function()
	TweenService:Create(reopenBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(0,210,100)}):Play()
end)
reopenBtn.MouseLeave:Connect(function()
	TweenService:Create(reopenBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(0,170,80)}):Play()
end)
