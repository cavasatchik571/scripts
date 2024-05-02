local CoreGui = game:GetService('CoreGui')
local Lighting = game:GetService('Lighting')
local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local RunService = game:GetService('RunService')
local TweenService = game:GetService('TweenService')
local UserInputService = game:GetService('UserInputService')
local Workspace = game:GetService('Workspace')

local LocalPlayer = Players.LocalPlayer
local Work = true

local function ConvertToFixedSize(GuiObject)
	if GuiObject and typeof(GuiObject) == 'Instance' then
		if GuiObject:IsA('GuiObject') then
			local AbsSize = GuiObject.AbsoluteSize

			GuiObject.Size = UDim2.new(0, AbsSize.X, 0, AbsSize.Y)
		end
	end
end

local function GetHugeNumber()
	local SG = Instance.new('ScreenGui')
	SG.DisplayOrder = math.huge
	SG.AutoLocalize = false

	local HugeNumber = math.abs(SG.DisplayOrder + 1)
	SG:Destroy()

	return HugeNumber
end

local function GetPlayerGuiFromPlayer(Player)
	if Player and typeof(Player) == 'Instance' then
		return Player:FindFirstChildWhichIsA('PlayerGui')
	end
end

local function IsCoreGuiEnabled()
	return pcall(function()
		Instance.new('Humanoid', CoreGui):Destroy()
	end)
end

local function RandomCharacters(Length)
	local STR = ''

	for i = 1, Length do
		STR = STR .. string.char(math.random(65, 90))
	end

	return STR
end

-- Settings

local MenuItems = {}
local Connections = {}
local NeverFailCompzEnabled = false
local ComputerPrankEnabled = false
local FasterCharacter = false
local LastWalkSpeed = 16
local XRayEnabled = false
local NoFogEnabled = false
local FogData = {Lighting.FogEnd, Lighting.FogStart, Lighting.ExposureCompensation}
local FogInstances = {}
local FlyEnabled = false
local FFNoclipEnabled = false
local NoGuiResetEnabled = false
local GuiResetData = {}

-- Code

local FTFGui = Instance.new('ScreenGui')
FTFGui.Parent = IsCoreGuiEnabled() and CoreGui or GetPlayerGuiFromPlayer(LocalPlayer)
FTFGui.Name = 'FTFGui_'..RandomCharacters(9)
FTFGui.DisplayOrder = GetHugeNumber()
FTFGui.IgnoreGuiInset = true
FTFGui.ResetOnSpawn = false
FTFGui.AutoLocalize = false

local FTFXRayGui = Instance.new('ScreenGui')
FTFXRayGui.Parent = GetPlayerGuiFromPlayer(LocalPlayer)
FTFXRayGui.Name = 'FTFXRayGui_'..RandomCharacters(9)
FTFXRayGui.DisplayOrder = -GetHugeNumber() - 1
FTFXRayGui.IgnoreGuiInset = true
FTFXRayGui.ResetOnSpawn = false
FTFXRayGui.AutoLocalize = false

-- Gui

local CreditsFrame = Instance.new('TextButton')
CreditsFrame.Parent = FTFGui
CreditsFrame.Name = 'CreditsFrame'
CreditsFrame.Position = UDim2.new(0, 8, 1, -8)
CreditsFrame.AnchorPoint = Vector2.new(0, 1)
CreditsFrame.Size = UDim2.new(0.225, 0, 0.1, 0)
CreditsFrame.BackgroundTransparency = 1
CreditsFrame.BorderSizePixel = 0
CreditsFrame.AutoLocalize = false
CreditsFrame.Text = ''
ConvertToFixedSize(CreditsFrame)

local FleeIcon = Instance.new('ImageLabel')
FleeIcon.Parent = CreditsFrame
FleeIcon.Name = 'FleeIcon'
FleeIcon.Position = UDim2.new(0, 0, 0.5, 0)
FleeIcon.AnchorPoint = Vector2.new(0, 0.5)
FleeIcon.Size = UDim2.new(0.75, 0, 0.75, 0)
FleeIcon.BackgroundColor3 = Color3.new(1, 1, 1)
FleeIcon.BorderSizePixel = 0
FleeIcon.AutoLocalize = false
FleeIcon.SizeConstraint = Enum.SizeConstraint.RelativeYY
FleeIcon.Image = 'rbxassetid://1216966139'
ConvertToFixedSize(FleeIcon)

local Roundness = Instance.new('UICorner')
Roundness.Parent = FleeIcon
Roundness.Name = 'Roundness'
Roundness.CornerRadius = UDim.new(0, 8)

local CreditsText = Instance.new('TextLabel')
CreditsText.Parent = CreditsFrame
CreditsText.Name = 'CreditsText'
CreditsText.Position = UDim2.new(0, FleeIcon.AbsoluteSize.X + 8, 0, 4)
CreditsText.Size = UDim2.new(0, CreditsFrame.AbsoluteSize.X - FleeIcon.AbsoluteSize.X - 24, 0.8, 0)
CreditsText.BackgroundTransparency = 1
CreditsText.BorderSizePixel = 0
CreditsText.AutoLocalize = false
CreditsText.Font = Enum.Font.SourceSansBold
CreditsText.Text = 'Flee the Facility Gui\nby VovaEin4'
CreditsText.TextColor3 = Color3.new(1, 1, 1)
CreditsText.TextStrokeTransparency = 0
CreditsText.TextStrokeColor3 = Color3.new(0, 0, 0)
CreditsText.TextSize = 24
CreditsText.TextXAlignment = Enum.TextXAlignment.Left
ConvertToFixedSize(CreditsText)

local FTFMenu = Instance.new('Frame')
FTFMenu.Parent = FTFGui
FTFMenu.Name = 'FTFMenu'
FTFMenu.Position = UDim2.new(0.5, 0, 1, 0)
FTFMenu.AnchorPoint = Vector2.new(0.5, 0)
FTFMenu.Size = UDim2.new(1, -16, 0.125, 0)
FTFMenu.BackgroundTransparency = 0.5
FTFMenu.BackgroundColor3 = Color3.new(0, 0, 0)
FTFMenu.BorderSizePixel = 0
FTFMenu.AutoLocalize = false
ConvertToFixedSize(FTFMenu)

local Roundness = Instance.new('UICorner')
Roundness.Parent = FTFMenu
Roundness.Name = 'Roundness'
Roundness.CornerRadius = UDim.new(0.5, 0)

local UIListLayout = Instance.new('UIListLayout')
UIListLayout.Parent = FTFMenu
UIListLayout.FillDirection = Enum.FillDirection.Horizontal
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.Padding = UDim.new(0, 8)

local MovementButton = Instance.new('TextButton')
MovementButton.Parent = FTFMenu
MovementButton.Name = 'MovementButton'
MovementButton.Size = UDim2.new(0.125, 0, 0.8, 0)
MovementButton.BackgroundColor3 = Color3.fromHSV(Random.new():NextNumber(0, 1), 1, 1)
MovementButton.BackgroundTransparency = 0.15
MovementButton.BorderSizePixel = 0
MovementButton.AutoLocalize = false
MovementButton.AutoButtonColor = false
MovementButton.LayoutOrder = 1
MovementButton.Text = 'Movement'
MovementButton.TextScaled = true
MovementButton.TextColor3 = Color3.new(1, 1, 1)
MovementButton.TextStrokeTransparency = 0
MovementButton.TextStrokeColor3 = Color3.new(0, 0, 0)

local Roundness = Instance.new('UICorner')
Roundness.Parent = MovementButton
Roundness.Name = 'Roundness'
Roundness.CornerRadius = UDim.new(0.1, 0)

local TextSizeLimit = Instance.new('UITextSizeConstraint')
TextSizeLimit.Parent = MovementButton
TextSizeLimit.Name = 'TextSizeLimit'
TextSizeLimit.MaxTextSize = 22

local MovementCheatsButtonMenu = Instance.new('Frame')
MovementCheatsButtonMenu.Parent = MovementButton
MovementCheatsButtonMenu.Name = 'MovementCheatsButtonMenu'
MovementCheatsButtonMenu.Position = UDim2.new(0.5, 0, 0, -FTFMenu.AbsoluteSize.Y / 6)
MovementCheatsButtonMenu.AnchorPoint = Vector2.new(0.5, 1)
MovementCheatsButtonMenu.Size = UDim2.new(0, 0, 0, 0)
MovementCheatsButtonMenu.BackgroundColor3 = Color3.new(0, 0, 0)
MovementCheatsButtonMenu.BackgroundTransparency = 0.65
MovementCheatsButtonMenu.BorderSizePixel = 0
MovementCheatsButtonMenu.AutoLocalize = false

local Roundness = Instance.new('UICorner')
Roundness.Parent = MovementCheatsButtonMenu
Roundness.Name = 'Roundness'
Roundness.CornerRadius = UDim.new(0, 7)

local UIListLayout = Instance.new('UIListLayout')
UIListLayout.Parent = MovementCheatsButtonMenu
UIListLayout.FillDirection = Enum.FillDirection.Vertical
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.Padding = UDim.new(0, 3)

local UIPadding = Instance.new('UIPadding')
UIPadding.Parent = MovementCheatsButtonMenu
UIPadding.PaddingBottom = UDim.new(0, 3)

local MiscHeckzButton = Instance.new('TextButton')
MiscHeckzButton.Parent = FTFMenu
MiscHeckzButton.Name = 'MiscHeckzButton'
MiscHeckzButton.Size = UDim2.new(0.125, 0, 0.8, 0)
MiscHeckzButton.BackgroundColor3 = Color3.fromHSV(Random.new():NextNumber(0, 1), 1, 1)
MiscHeckzButton.BackgroundTransparency = 0.15
MiscHeckzButton.BorderSizePixel = 0
MiscHeckzButton.AutoLocalize = false
MiscHeckzButton.AutoButtonColor = false
MiscHeckzButton.LayoutOrder = 1
MiscHeckzButton.Text = 'Misc'
MiscHeckzButton.TextScaled = true
MiscHeckzButton.TextColor3 = Color3.new(1, 1, 1)
MiscHeckzButton.TextStrokeTransparency = 0
MiscHeckzButton.TextStrokeColor3 = Color3.new(0, 0, 0)

local Roundness = Instance.new('UICorner')
Roundness.Parent = MiscHeckzButton
Roundness.Name = 'Roundness'
Roundness.CornerRadius = UDim.new(0.1, 0)

local TextSizeLimit = Instance.new('UITextSizeConstraint')
TextSizeLimit.Parent = MiscHeckzButton
TextSizeLimit.Name = 'TextSizeLimit'
TextSizeLimit.MaxTextSize = 22

local MiscCheatsButtonMenu = Instance.new('Frame')
MiscCheatsButtonMenu.Parent = MiscHeckzButton
MiscCheatsButtonMenu.Name = 'MiscCheatsButtonMenu'
MiscCheatsButtonMenu.Position = UDim2.new(0.5, 0, 0, -FTFMenu.AbsoluteSize.Y / 6)
MiscCheatsButtonMenu.AnchorPoint = Vector2.new(0.5, 1)
MiscCheatsButtonMenu.Size = UDim2.new(0, 0, 0, 0)
MiscCheatsButtonMenu.BackgroundColor3 = Color3.new(0, 0, 0)
MiscCheatsButtonMenu.BackgroundTransparency = 0.65
MiscCheatsButtonMenu.BorderSizePixel = 0
MiscCheatsButtonMenu.AutoLocalize = false

local Roundness = Instance.new('UICorner')
Roundness.Parent = MiscCheatsButtonMenu
Roundness.Name = 'Roundness'
Roundness.CornerRadius = UDim.new(0, 7)

local UIListLayout = Instance.new('UIListLayout')
UIListLayout.Parent = MiscCheatsButtonMenu
UIListLayout.FillDirection = Enum.FillDirection.Vertical
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.Padding = UDim.new(0, 3)

local UIPadding = Instance.new('UIPadding')
UIPadding.Parent = MiscCheatsButtonMenu
UIPadding.PaddingBottom = UDim.new(0, 3)

local CloseMenuButton = Instance.new('TextButton')
CloseMenuButton.Parent = FTFMenu
CloseMenuButton.Name = 'CloseMenuButton'
CloseMenuButton.Size = UDim2.new(0.105, 0, 0.8, 0)
CloseMenuButton.BackgroundColor3 = Color3.new(1, 0, 0)
CloseMenuButton.BackgroundTransparency = 0.15
CloseMenuButton.BorderSizePixel = 0
CloseMenuButton.AutoLocalize = false
CloseMenuButton.AutoButtonColor = false
CloseMenuButton.LayoutOrder = 2
CloseMenuButton.Text = 'Close'
CloseMenuButton.TextScaled = true
CloseMenuButton.TextColor3 = Color3.new(1, 1, 1)
CloseMenuButton.TextStrokeTransparency = 0
CloseMenuButton.TextStrokeColor3 = Color3.new(0, 0, 0)

local Roundness = Instance.new('UICorner')
Roundness.Parent = CloseMenuButton
Roundness.Name = 'Roundness'
Roundness.CornerRadius = UDim.new(0.1, 0)

local TextSizeLimit = Instance.new('UITextSizeConstraint')
TextSizeLimit.Parent = CloseMenuButton
TextSizeLimit.Name = 'TextSizeLimit'
TextSizeLimit.MaxTextSize = 22

for x = 1, 3 do
	local CheatButtonMenuItem = Instance.new('TextButton')
	CheatButtonMenuItem.Parent = MovementCheatsButtonMenu
	CheatButtonMenuItem.Size = UDim2.new(0.925, 0, 0.125, 0)
	CheatButtonMenuItem.BackgroundColor3 = Color3.new(0.498039, 0.498039, 0.498039)
	CheatButtonMenuItem.BackgroundTransparency = 1
	CheatButtonMenuItem.BorderSizePixel = 0
	CheatButtonMenuItem.AutoLocalize = false
	CheatButtonMenuItem.AutoButtonColor = false
	CheatButtonMenuItem.TextScaled = true
	CheatButtonMenuItem.TextColor3 = Color3.new(1, 1, 1)
	CheatButtonMenuItem.TextStrokeTransparency = 0
	CheatButtonMenuItem.TextStrokeColor3 = Color3.new(0, 0, 0)
	CheatButtonMenuItem.LayoutOrder = x

	local Roundness = Instance.new('UICorner')
	Roundness.Parent = CheatButtonMenuItem
	Roundness.Name = 'Roundness'
	Roundness.CornerRadius = UDim.new(0, 7)

	local TextSizeLimit = Instance.new('UITextSizeConstraint')
	TextSizeLimit.Parent = CheatButtonMenuItem
	TextSizeLimit.Name = 'TextSizeLimit'
	TextSizeLimit.MaxTextSize = 13.75

	CheatButtonMenuItem.MouseEnter:Connect(function()
		TweenService:Create(
			TextSizeLimit,
			TweenInfo.new(
				0.2,
				Enum.EasingStyle.Sine,
				Enum.EasingDirection.InOut,
				0,
				false,
				0
			),
			{
				['MaxTextSize'] = 19.7
			}
		):Play()
	end)

	CheatButtonMenuItem.MouseLeave:Connect(function()
		TweenService:Create(
			TextSizeLimit,
			TweenInfo.new(
				0.2,
				Enum.EasingStyle.Sine,
				Enum.EasingDirection.InOut,
				0,
				false,
				0
			),
			{
				['MaxTextSize'] = 13.75
			}
		):Play()
	end)

	if x == 1 then
		CheatButtonMenuItem.Name = 'FasterCharacter'
		CheatButtonMenuItem.Text = 'Faster character'
		CheatButtonMenuItem.MouseButton1Up:Connect(function()
			if LocalPlayer and LocalPlayer.Character then
				if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA('Humanoid') then
					local h = LocalPlayer.Character:FindFirstChildWhichIsA('Humanoid')

					if not FasterCharacter then LastWalkSpeed = h.WalkSpeed end
					FasterCharacter = not FasterCharacter

					CheatButtonMenuItem.BackgroundTransparency = FasterCharacter and 0.5 or 1

					spawn(function()
						local IsDone = false
						delay(0.027, function()
							IsDone = true
						end)

						repeat
							if math.random(1, 2) == 1 then wait() end

							h.WalkSpeed = FasterCharacter and LastWalkSpeed * 3 or LastWalkSpeed
						until IsDone
					end)
				end
			end
		end)
	elseif x == 2 then
		CheatButtonMenuItem.Name = 'FlyItemMenu'
		CheatButtonMenuItem.Text = 'Fly ( Hold Space )'
		CheatButtonMenuItem.MouseButton1Up:Connect(function()
			FlyEnabled = not FlyEnabled

			CheatButtonMenuItem.BackgroundTransparency = FlyEnabled and 0.5 or 1
		end)
	elseif x == 3 then
		CheatButtonMenuItem.Name = 'FFNoclip'
		CheatButtonMenuItem.Text = 'FF Noclip'
		CheatButtonMenuItem.MouseButton1Up:Connect(function()
			FFNoclipEnabled = not FFNoclipEnabled

			CheatButtonMenuItem.BackgroundTransparency = FFNoclipEnabled and 0.5 or 1
			if not FFNoclipEnabled then
				if LocalPlayer and LocalPlayer.Character then
					if LocalPlayer.Character and
						LocalPlayer.Character:FindFirstChildWhichIsA('Humanoid') then

						local h = LocalPlayer.Character:FindFirstChildWhichIsA('Humanoid')

						h:ChangeState(Enum.HumanoidStateType.Jumping)
						h:ChangeState(Enum.HumanoidStateType.Ragdoll)
						h:ChangeState(Enum.HumanoidStateType.GettingUp)
					end
				end
			end
		end)
	end

	table.insert(MenuItems, CheatButtonMenuItem)
end

for x = 1, 6 do
	local CheatButtonMenuItem = Instance.new('TextButton')
	CheatButtonMenuItem.Parent = MiscCheatsButtonMenu
	CheatButtonMenuItem.Size = UDim2.new(0.925, 0, 0.125, 0)
	CheatButtonMenuItem.BackgroundColor3 = Color3.new(0.498039, 0.498039, 0.498039)
	CheatButtonMenuItem.BackgroundTransparency = 1
	CheatButtonMenuItem.BorderSizePixel = 0
	CheatButtonMenuItem.AutoLocalize = false
	CheatButtonMenuItem.AutoButtonColor = false
	CheatButtonMenuItem.TextScaled = true
	CheatButtonMenuItem.TextColor3 = Color3.new(1, 1, 1)
	CheatButtonMenuItem.TextStrokeTransparency = 0
	CheatButtonMenuItem.TextStrokeColor3 = Color3.new(0, 0, 0)
	CheatButtonMenuItem.LayoutOrder = x

	local Roundness = Instance.new('UICorner')
	Roundness.Parent = CheatButtonMenuItem
	Roundness.Name = 'Roundness'
	Roundness.CornerRadius = UDim.new(0, 7)

	local TextSizeLimit = Instance.new('UITextSizeConstraint')
	TextSizeLimit.Parent = CheatButtonMenuItem
	TextSizeLimit.Name = 'TextSizeLimit'
	TextSizeLimit.MaxTextSize = 13.75

	CheatButtonMenuItem.MouseEnter:Connect(function()
		TweenService:Create(
			TextSizeLimit,
			TweenInfo.new(
				0.2,
				Enum.EasingStyle.Sine,
				Enum.EasingDirection.InOut,
				0,
				false,
				0
			),
			{
				['MaxTextSize'] = 19.7
			}
		):Play()
	end)

	CheatButtonMenuItem.MouseLeave:Connect(function()
		TweenService:Create(
			TextSizeLimit,
			TweenInfo.new(
				0.2,
				Enum.EasingStyle.Sine,
				Enum.EasingDirection.InOut,
				0,
				false,
				0
			),
			{
				['MaxTextSize'] = 13.75
			}
		):Play()
	end)

	if x == 1 then
		CheatButtonMenuItem.Name = 'NeverFailCompz'
		CheatButtonMenuItem.Text = 'No hack fail'
		CheatButtonMenuItem.MouseButton1Up:Connect(function()
			NeverFailCompzEnabled = not NeverFailCompzEnabled

			CheatButtonMenuItem.BackgroundTransparency = NeverFailCompzEnabled and 0.5 or 1
		end)
	elseif x == 2 then
		CheatButtonMenuItem.Name = 'ComputerPrank'
		CheatButtonMenuItem.Text = 'Computer prank'
		CheatButtonMenuItem.MouseButton1Up:Connect(function()
			ComputerPrankEnabled = not ComputerPrankEnabled

			CheatButtonMenuItem.BackgroundTransparency = ComputerPrankEnabled and 0.5 or 1
		end)
	elseif x == 3 then
		CheatButtonMenuItem.Name = 'XRayItemMenu'
		CheatButtonMenuItem.Text = 'X-Ray'
		CheatButtonMenuItem.MouseButton1Up:Connect(function()
			XRayEnabled = not XRayEnabled

			CheatButtonMenuItem.BackgroundTransparency = XRayEnabled and 0.5 or 1
		end)
	elseif x == 4 then
		CheatButtonMenuItem.Name = 'NoFogMode'
		CheatButtonMenuItem.Text = 'No fog'
		CheatButtonMenuItem.MouseButton1Up:Connect(function()
			if Lighting then
				if not NoFogEnabled then
					FogData = {Lighting.FogEnd, Lighting.FogStart, Lighting.ExposureCompensation}

					for _, v in pairs(Lighting:GetChildren()) do
						if typeof(v) == 'Instance' then
							if v:IsA('Atmosphere') then
								table.insert(FogInstances, {v, v.Parent})

								v.Parent = nil
							end
						end
					end
				else
					for _, v in pairs(FogInstances) do
						if v[1] and v[2] then
							v[1].Parent = v[2]
						end
					end

					table.clear(FogInstances)
				end

				NoFogEnabled = not NoFogEnabled
				CheatButtonMenuItem.BackgroundTransparency = NoFogEnabled and 0.5 or 1

				spawn(function()
					local IsDone = false
					delay(0.027, function()
						IsDone = true
					end)

					repeat
						if math.random(1, 2) == 1 then wait() end

						Lighting.FogEnd = FogData[1]
						Lighting.FogStart = FogData[2]
						Lighting.ExposureCompensation = FogData[3]
					until IsDone
				end)
			end
		end)
	elseif x == 5 then
		CheatButtonMenuItem.Name = 'NoGuiResetItemMenu'
		CheatButtonMenuItem.Text = 'No gui reset'
		CheatButtonMenuItem.MouseButton1Up:Connect(function()
			NoGuiResetEnabled = not NoGuiResetEnabled

			CheatButtonMenuItem.BackgroundTransparency = NoGuiResetEnabled and 0.5 or 1

			if not NoGuiResetEnabled then
				if typeof(GuiResetData) == 'table' and #GuiResetData > 0 then
					for _, v in pairs(GuiResetData) do
						if typeof(v) == 'Instance' then
							if v:IsA('ScreenGui') or v:IsA('GuiMain') then
								v:Destroy()
							end
						end
					end

					table.clear(GuiResetData)
				end
			end
		end)
	elseif x == 6 then
		CheatButtonMenuItem.Name = 'ExitItemMenu'
		CheatButtonMenuItem.Text = 'Exit'
		CheatButtonMenuItem.MouseButton1Up:Connect(function()
			NeverFailCompzEnabled = false
			ComputerPrankEnabled = false
			FasterCharacter = false
			XRayEnabled = false
			NoFogEnabled = false
			FlyEnabled = false
			FFNoclipEnabled = false
			NoGuiResetEnabled = false

			for _, v in pairs(FTFXRayGui:GetChildren()) do
				if v and typeof(v) == 'Instance' then
					v:Destroy()
				end
			end

			if typeof(FogInstances) == 'table' and #FogInstances > 0 then
				for _, v in pairs(FogInstances) do
					if v[1] and v[2] then
						v[1].Parent = v[2]
					end
				end
			end

			table.clear(FogInstances)

			if typeof(Connections) == 'table' and #Connections > 0 then
				for _, v in pairs(Connections) do
					if typeof(v) == 'RBXScriptConnection' then
						v:Disconnect()
					end
				end
			end

			table.clear(Connections)

			if typeof(GuiResetData) == 'table' and #GuiResetData > 0 then
				for _, v in pairs(GuiResetData) do
					if typeof(v) == 'Instance' then
						if v:IsA('ScreenGui') or v:IsA('GuiMain') then
							v:Destroy()
						end
					end
				end
			end

			table.clear(GuiResetData)

			if LocalPlayer and LocalPlayer.Character then
				local Character = LocalPlayer.Character

				if Character and Character:FindFirstChildWhichIsA('Humanoid') then
					local h = Character:FindFirstChildWhichIsA('Humanoid')

					h.WalkSpeed = LastWalkSpeed
				end
			end

			Work = nil
			FTFXRayGui:Destroy()
			FTFGui:Destroy()
		end)
	end

	table.insert(MenuItems, CheatButtonMenuItem)
end

MovementButton.MouseButton1Up:Connect(function()
	MovementCheatsButtonMenu:TweenSize(
		MovementCheatsButtonMenu.Size.Y.Scale < 4 and UDim2.new(1.25, 0, 4.25, 0)
			or UDim2.new(0, 0, 0, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, 0.25, false)

	MiscCheatsButtonMenu:TweenSize(UDim2.new(0, 0, 0, 0),
		Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, 0.25, false)
end)

MiscHeckzButton.MouseButton1Up:Connect(function()
	MiscCheatsButtonMenu:TweenSize(
		MiscCheatsButtonMenu.Size.Y.Scale < 4 and UDim2.new(1.25, 0, 4.25, 0)
			or UDim2.new(0, 0, 0, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, 0.25, false)

	MovementCheatsButtonMenu:TweenSize(UDim2.new(0, 0, 0, 0),
		Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, 0.25, false)
end)

CloseMenuButton.MouseButton1Up:Connect(function()
	TweenService:Create(
		FTFMenu,
		TweenInfo.new(
			0.25,
			Enum.EasingStyle.Sine,
			Enum.EasingDirection.InOut,
			0,
			false,
			0
		),
		{
			['AnchorPoint'] = FTFMenu.AnchorPoint.Y < 1 and
				Vector2.new(0.5, 1) or Vector2.new(0.5, 0),

			['Position'] =  FTFMenu.AnchorPoint.Y < 1 and 
				UDim2.new(0.5, 0, 1, -8) or UDim2.new(0.5, 0, 1, 0)
		}
	):Play()

	TweenService:Create(
		CreditsFrame,
		TweenInfo.new(
			0.25,
			Enum.EasingStyle.Sine,
			Enum.EasingDirection.InOut,
			0,
			false,
			0
		),
		{
			['Position'] =  FTFMenu.AnchorPoint.Y < 1 and 
				UDim2.new(0, 8, 2, -8) or UDim2.new(0, 8, 1, -8)
		}
	):Play()

	MovementCheatsButtonMenu:TweenSize(UDim2.new(0, 0, 0, 0),
		Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, 0.25, false)

	MiscCheatsButtonMenu:TweenSize(UDim2.new(0, 0, 0, 0),
		Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, 0.25, false)
end)

CreditsFrame.MouseEnter:Connect(function()
	local LastSize1 = FleeIcon.Size
	local NewSize1 = UDim2.new()
	FleeIcon.Size = UDim2.new(1, 0, 1, 0)

	ConvertToFixedSize(FleeIcon)
	NewSize1 = FleeIcon.Size
	FleeIcon.Size = LastSize1

	local FleeIconTween = TweenService:Create(
		FleeIcon,
		TweenInfo.new(
			0.25,
			Enum.EasingStyle.Sine,
			Enum.EasingDirection.InOut,
			0,
			false,
			0
		),
		{
			['Size'] = NewSize1,
			['BackgroundColor3'] = Color3.new(1, 0, 0)
		}
	)

	local CreditsTextTween = TweenService:Create(
		CreditsText,
		TweenInfo.new(
			0.25,
			Enum.EasingStyle.Sine,
			Enum.EasingDirection.InOut,
			0,
			false,
			0
		),
		{
			['Position'] = UDim2.new(0, NewSize1.X.Offset + 8, 0, 4),
			['TextSize'] = 27.5
		}
	)

	FleeIconTween:Play()
	CreditsTextTween:Play()
end)

CreditsFrame.MouseLeave:Connect(function()
	local LastSize1 = FleeIcon.Size
	local NewSize1 = UDim2.new()
	FleeIcon.Size = UDim2.new(0.75, 0, 0.75, 0)

	ConvertToFixedSize(FleeIcon)
	NewSize1 = FleeIcon.Size
	FleeIcon.Size = LastSize1

	local FleeIconTween = TweenService:Create(
		FleeIcon,
		TweenInfo.new(
			0.25,
			Enum.EasingStyle.Sine,
			Enum.EasingDirection.InOut,
			0,
			false,
			0
		),
		{
			['Size'] = NewSize1,
			['BackgroundColor3'] = Color3.new(1, 1, 1)
		}
	)

	local CreditsTextTween = TweenService:Create(
		CreditsText,
		TweenInfo.new(
			0.25,
			Enum.EasingStyle.Sine,
			Enum.EasingDirection.InOut,
			0,
			false,
			0
		),
		{
			['Position'] = UDim2.new(0, NewSize1.X.Offset + 8, 0, 4),
			['TextSize'] = 24
		}
	)

	FleeIconTween:Play()
	CreditsTextTween:Play()
end)

CreditsFrame.MouseButton1Up:Connect(function()
	TweenService:Create(
		FTFMenu,
		TweenInfo.new(
			0.25,
			Enum.EasingStyle.Sine,
			Enum.EasingDirection.InOut,
			0,
			false,
			0
		),
		{
			['AnchorPoint'] = FTFMenu.AnchorPoint.Y < 1 and
				Vector2.new(0.5, 1) or Vector2.new(0.5, 0),

			['Position'] =  FTFMenu.AnchorPoint.Y < 1 and 
				UDim2.new(0.5, 0, 1, -8) or UDim2.new(0.5, 0, 1, 0)
		}
	):Play()

	TweenService:Create(
		CreditsFrame,
		TweenInfo.new(
			0.25,
			Enum.EasingStyle.Sine,
			Enum.EasingDirection.InOut,
			0,
			false,
			0
		),
		{
			['Position'] =  FTFMenu.AnchorPoint.Y < 1 and 
				UDim2.new(0, 8, 2, -8) or UDim2.new(0, 8, 1, -8)
		}
	):Play()
end)

local HueIndex = 0
local function AnimateButtons()
	for i, v in pairs(MenuItems) do
		if typeof(v) == 'Instance' then
			if v:IsA('TextButton') then
				if HueIndex < 1 then HueIndex += 0.0005 else HueIndex -= 1 end
				local Index = HueIndex + (i - 1) / 25

				if Index >= 1 then Index -= 1 end
				v.TextStrokeColor3 = Color3.fromHSV(Index, 1, 1)
			end
		end
	end
end

local function OnJumpRequest()
	if FlyEnabled then
		if LocalPlayer and LocalPlayer.Character then
			if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA('Humanoid') then
				local h = LocalPlayer.Character:FindFirstChildWhichIsA('Humanoid')

				h:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end
	end
end

local function Tick()
	if NeverFailCompzEnabled then
		if ReplicatedStorage and ReplicatedStorage:FindFirstChild('RemoteEvent') then
			local RemoteEvent = ReplicatedStorage:FindFirstChild('RemoteEvent')

			RemoteEvent:FireServer('SetPlayerMinigameResult', true)
		end
	end

	if ComputerPrankEnabled then
		if LocalPlayer and LocalPlayer:FindFirstChild('TempPlayerStatsModule') then
			local TPSM = LocalPlayer:FindFirstChild('TempPlayerStatsModule')

			if TPSM and TPSM:FindFirstChild('CurrentAnimation')
				and TPSM:FindFirstChild('ActionInput') then

				if TPSM:FindFirstChild('CurrentAnimation').Value == 'Typing' then
					TPSM:FindFirstChild('ActionInput').Value = true
				end
			end
		end
	end

	if FasterCharacter then
		if LocalPlayer and LocalPlayer.Character then
			if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA('Humanoid') then
				local h = LocalPlayer.Character:FindFirstChildWhichIsA('Humanoid')

				h.WalkSpeed = LastWalkSpeed * 3
			end
		end
	end

	if FFNoclipEnabled then
		if LocalPlayer and LocalPlayer.Character then
			if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA('Humanoid') then
				local h = LocalPlayer.Character:FindFirstChildWhichIsA('Humanoid')

				h:ChangeState(11)
			end
		end
	end

	if XRayEnabled then
		for _, v in pairs(Players:GetPlayers()) do
			if v and v.Character and v ~= LocalPlayer then
				local vChar = v.Character
				local vCharHRP = vChar:FindFirstChild('HumanoidRootPart')

				if vChar and vChar:FindFirstChild('HumanoidRootPart') then
					vCharHRP = vChar:FindFirstChild('HumanoidRootPart')
				end

				if vCharHRP and not FTFXRayGui:FindFirstChild(vChar.Name..'_XRAYITEM') then
					local XRayFrameItem = Instance.new('Frame')
					XRayFrameItem.Parent = FTFXRayGui
					XRayFrameItem.Name = vChar.Name..'_XRAYITEM'
					XRayFrameItem.AnchorPoint = Vector2.new(0.5, 0.5)
					XRayFrameItem.BackgroundTransparency = 1
					XRayFrameItem.BorderSizePixel = 0
					XRayFrameItem.AutoLocalize = false

					local UserThumbnail = Instance.new('ImageLabel')
					UserThumbnail.Parent = XRayFrameItem
					UserThumbnail.Name = 'UserThumbnail'
					UserThumbnail.Position = UDim2.new(0.5, 0, 0, 0)
					UserThumbnail.AnchorPoint = Vector2.new(0.5, 0)
					UserThumbnail.Size = UDim2.new(1, 0, 1, 0)
					UserThumbnail.BackgroundColor3 = Color3.new(0, 0, 0)
					UserThumbnail.BackgroundTransparency = 0
					UserThumbnail.BorderSizePixel = 0
					UserThumbnail.AutoLocalize = false
					UserThumbnail.SizeConstraint = Enum.SizeConstraint.RelativeYY

					local UserNameText = Instance.new('TextLabel')
					UserNameText.Parent = UserThumbnail
					UserNameText.Name = 'UserNameText'
					UserNameText.Position = UDim2.new(0.5, 0, 1.3, 0)
					UserNameText.AnchorPoint = Vector2.new(0.5, 1)
					UserNameText.Size = UDim2.new(1.05, 0, 0.3, 0)
					UserNameText.BackgroundTransparency = 1
					UserNameText.BorderSizePixel = 0
					UserNameText.AutoLocalize = false
					UserNameText.Font = Enum.Font.SourceSansBold
					UserNameText.Text = v.Name
					UserNameText.TextColor3 = Color3.new(1, 1, 1)
					UserNameText.TextStrokeTransparency = 0
					UserNameText.TextStrokeColor3 = Color3.new(0, 0, 0)
					UserNameText.TextScaled = true
					UserNameText.RichText = true

					local DistanceText = Instance.new('TextLabel')
					DistanceText.Parent = UserNameText
					DistanceText.Name = 'DistanceText'
					DistanceText.Position = UDim2.new(0.5, 0, 1, 0)
					DistanceText.AnchorPoint = Vector2.new(0.5, 0)
					DistanceText.Size = UDim2.new(1.05, 0, 1, 0)
					DistanceText.BackgroundTransparency = 1
					DistanceText.BorderSizePixel = 0
					DistanceText.AutoLocalize = false
					DistanceText.Font = Enum.Font.SourceSansBold
					DistanceText.Text = '0m'
					DistanceText.TextColor3 = Color3.new(1, 1, 1)
					DistanceText.TextStrokeTransparency = 0
					DistanceText.TextStrokeColor3 = Color3.new(0, 0, 0)
					DistanceText.TextScaled = true
					DistanceText.RichText = true

					if string.split(v.Name, '4') then
						local Code = ''
						local Strings = string.split(v.Name, '4')

						if Strings then
							for i, v2 in pairs(Strings) do
								if v2 and v2 ~= '' then
									if i ~= #Strings then
										Code = Code..v2..'<font color=\'#005400\'>4</font>'
									else
										Code = Code..v2
									end
								end
							end
						end

						UserNameText.Text = Code
					end

					spawn(function()
						pcall(function()
							UserThumbnail.Image = Players:GetUserThumbnailAsync(v.UserId,
								Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size420x420)
						end)

						if UserThumbnail.Image == '' then
							UserThumbnail.BackgroundColor3 = Color3.new(
								Random.new():NextNumber(0, 1),
								Random.new():NextNumber(0, 1),
								Random.new():NextNumber(0, 1))
						end
					end)
				end
			end
		end

		for _, v in pairs(FTFXRayGui:GetChildren()) do
			if v then
				local Index = string.find(v.Name, '_XRAYITEM')

				if Workspace:FindFirstChild(string.sub(v.Name, 0, Index - 1)) then
					local vChar = Workspace:FindFirstChild(string.sub(v.Name, 0, Index - 1))
					local vCharHRP = vChar:FindFirstChild('HumanoidRootPart')

					if vChar and vChar:FindFirstChild('HumanoidRootPart') then
						vCharHRP = vChar:FindFirstChild('HumanoidRootPart')
					else
						v:Destroy()
					end

					if vCharHRP then
						local Distance =
							(Workspace.CurrentCamera.CFrame.Position - vCharHRP.Position).Magnitude / 75

						local WorldDistance =
							(Workspace.CurrentCamera.CFrame.Position - vCharHRP.Position).Magnitude

						if Distance < 0 then Distance = 0 end

						local Position =
							Workspace.CurrentCamera:WorldToScreenPoint(vCharHRP.Position)

						local Size = Vector2.new(75 * Distance, 90 * Distance)
						if Size.X < 50 then Size = Vector2.new(50, Size.Y) end
						if Size.Y < 70 then Size = Vector2.new(Size.X, 70) end
						if Size.X < 50 and Size.Y < 70 then Size = Vector2.new(50, 70) end
						if Size.X > 75 then Size = Vector2.new(75, Size.Y) end
						if Size.Y > 90 then Size = Vector2.new(Size.X, 90) end
						if Size.X > 75 and Size.Y > 90 then Size = Vector2.new(75, 90) end

						v.Position = UDim2.new(0, Position.X, 0, Position.Y)
						v.Size = UDim2.new(0, Size.X, 0, Size.Y)
						v.Visible = Position.Z > 0

						if v:FindFirstChild('UserThumbnail') then
							local UserThumbnail = v:FindFirstChild('UserThumbnail')

							if UserThumbnail:FindFirstChild('UserNameText') then
								local UserNameText = UserThumbnail:FindFirstChild('UserNameText')
								UserNameText.RichText = true

								if UserNameText:FindFirstChild('DistanceText') then
									local DistanceText = UserNameText:FindFirstChild('DistanceText')

									DistanceText.Text = tostring(math.floor(
										WorldDistance + 0.5))..'m'
								end

								if Players:FindFirstChild(vChar.Name) then
									local Player = Players:GetPlayerFromCharacter(vChar)

									if Player and Player:FindFirstChild('TempPlayerStatsModule') then
										local TPSM = Player:FindFirstChild('TempPlayerStatsModule')

										if TPSM and TPSM:FindFirstChild('IsBeast') then
											local IsBeast = TPSM:FindFirstChild('IsBeast')

											if IsBeast then
												if IsBeast.Value then
													UserNameText.TextColor3 = Color3.new(1, 0, 0)
												else
													UserNameText.TextColor3 = Color3.new(1, 1, 1)
												end
											end
										end
									end
								end
							end
						end
					end
				else
					v:Destroy()
				end
			end
		end
	else
		for _, v in pairs(FTFXRayGui:GetChildren()) do
			if v and typeof(v) == 'Instance' then
				v:Destroy()
			end
		end
	end

	if NoFogEnabled then
		if Lighting then
			Lighting.FogEnd = 262144
			Lighting.FogStart = 262144
			Lighting.ExposureCompensation = 0
		end
	end
end

local function AddAllResetableGuis()
	wait(Players.RespawnTime > 1 and Players.RespawnTime - 0.75 or 0.25)

	if NoGuiResetEnabled then
		if GetPlayerGuiFromPlayer(LocalPlayer) then
			for i, v in pairs(GetPlayerGuiFromPlayer(LocalPlayer):GetChildren()) do
				local AvailableData = GuiResetData[i]
				local FindSameValue = false

				if AvailableData then
					if table.find(AvailableData, v) then
						FindSameValue = true
					end
				end

				if typeof(v) == 'Instance' and not FindSameValue then
					if v:IsA('ScreenGui') or v:IsA('GuiMain') then
						if v.ResetOnSpawn then
							local Gui = v

							if Gui.ResetOnSpawn then
								local defaultArchivable = true
								if not Gui.Archivable then
									defaultArchivable = false
									Gui.Archivable = true
								end

								table.insert(GuiResetData, Gui:Clone())
								Gui.Archivable = defaultArchivable
							end
						end
					end
				end
			end
		end
	end
end

local function OnCharacterAdded(Character)
	if typeof(GuiResetData) == 'table' and #GuiResetData > 0 then
		for i, v in pairs(GuiResetData) do
			if typeof(v) == 'Instance' then
				if v:IsA('ScreenGui') or v:IsA('GuiMain') then
					local Gui = v
					table.remove(GuiResetData, i)

					if GetPlayerGuiFromPlayer(LocalPlayer) then
						Gui.Parent = GetPlayerGuiFromPlayer(LocalPlayer)

						if game.PlaceId == 893973440 or game.PlaceId == 1738581510
							or game.PlaceId == 455327877 then

							for _, v2 in pairs(Gui:GetDescendants()) do
								if typeof(v2) == 'Instance' then
									if string.find(v2.Name, 'Menus') and v2:IsA('Frame') then
										v2.Visible = true
									end
								end
							end
						end
					end
				end
			end
		end
	end

	if LocalPlayer and LocalPlayer.Character or Character then
		local Character = LocalPlayer.Character or Character

		spawn(function()
			local FindHumanoid = false
			delay(5, function()
				FindHumanoid = -1
			end)

			repeat
				if Character:FindFirstChildWhichIsA('Humanoid') then
					FindHumanoid = Character:FindFirstChildWhichIsA('Humanoid')
				end

				wait()
			until FindHumanoid

			if typeof(FindHumanoid) == 'Instance' then
				if FindHumanoid:IsA('Humanoid') then
					local h = Character:FindFirstChildWhichIsA('Humanoid')

					Connections[5] = h.Died:Connect(AddAllResetableGuis)
				end
			end
		end)
	end
end

Connections[1] = RunService.Stepped:Connect(Tick)
Connections[2] = RunService.RenderStepped:Connect(AnimateButtons)
Connections[3] = UserInputService.JumpRequest:Connect(OnJumpRequest)
Connections[4] = LocalPlayer.CharacterAdded:Connect(OnCharacterAdded)

if LocalPlayer and LocalPlayer.Character then
	local Character = LocalPlayer.Character

	spawn(function()
		local FindHumanoid = false
		delay(5, function()
			FindHumanoid = -1
		end)

		repeat
			if Character:FindFirstChildWhichIsA('Humanoid') then
				FindHumanoid = Character:FindFirstChildWhichIsA('Humanoid')
			end

			wait()
		until FindHumanoid

		if typeof(FindHumanoid) == 'Instance' then
			if FindHumanoid:IsA('Humanoid') then
				local h = Character:FindFirstChildWhichIsA('Humanoid')

				Connections[5] = h.Died:Connect(AddAllResetableGuis)
			end
		end
	end)
end

while true do
	if not Work then break end
	if math.random(1, 2) == 1 then wait() end

	Tick()
end
