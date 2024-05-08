-- Services

local CoreGui = game:GetService('CoreGui')
local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local RunService = game:GetService('RunService')
local UserInputService = game:GetService('UserInputService')

-- Control executes

local CheatName = 'RF_GUI_v1.0.0'

if not _G[CheatName] then
	_G[CheatName] = true
else
	_G[CheatName] = nil

	return true
end

-- Variables

local LocalPlayer = Players.LocalPlayer
local Backpack = nil
local Character = nil
local Humanoid = nil

local DragingOtherObject = false

local BToolsActivated = false
local InvincibilityEnabled = false
local SpeedHackActivated = false
local TeleportingEnabled = false
local XRayEnabled = false

local DelaySendingRequest = 0.075
local LastHumanoidWalkSpeed = 0

local OverlapParam = OverlapParams.new()
OverlapParam.FilterDescendantsInstances = {Character}
OverlapParam.FilterType = Enum.RaycastFilterType.Exclude

-- Tables

local Connections = {}
local Hitboxes = {}
local Overlays = {}
local Tabs = {}
local Windows = {}

-- Functions

local function GetLocalPlayerGui()
	local Result = nil

	if LocalPlayer then
		Result = LocalPlayer:FindFirstChildWhichIsA('PlayerGui') or
			LocalPlayer:WaitForChild('PlayerGui')
	end

	return Result
end

local function GetGUI()
	local Result = nil

	local Success, _ = pcall(function()
		if CoreGui.ClassName then
			return true
		end
	end)

	Result = Success and CoreGui or GetLocalPlayerGui()

	return Result
end

local function GetHumanoid(Character)
	local Result = nil

	if Character then
		Result = Character:FindFirstChildWhichIsA('Humanoid') or
			Character:FindFirstChild('Humanoid')
	end

	return Result
end

local function GetIgnoreInstances()
	local IgnoreInstances = {Character}

	local function __init__(Object)
		if Object then
			for _, v in next, Object:GetChildren() do
				if v:IsA('BasePart') then
					if not v.CanCollide then
						table.insert(IgnoreInstances, v)
					end
				end

				__init__(v)
			end
		end
	end

	__init__(workspace)

	return IgnoreInstances
end

local function GetTorso(Character)
	local Result = nil

	if Character then
		Result = Character:FindFirstChild('Torso') or
			Character:FindFirstChild('UpperTorso') or
			Character:FindFirstChild('HumanoidRootPart')
	end

	return Result
end

local function Initialize()
	Character = nil
	Backpack = nil
	Humanoid = nil

	if not Character then
		if LocalPlayer then
			Character = LocalPlayer.Character
		end
	else
		if not Character.Parent then
			if LocalPlayer then
				Character = LocalPlayer.Character
			end
		end
	end

	if not Backpack then
		if LocalPlayer then
			Backpack = LocalPlayer:FindFirstChildWhichIsA('Backpack')
		end
	else
		if not Backpack.Parent then
			if LocalPlayer then
				Backpack = LocalPlayer:FindFirstChildWhichIsA('Backpack')
			end
		end
	end

	if not Humanoid then
		Humanoid = GetHumanoid(Character)
	else
		if not Humanoid.Parent then
			Humanoid = GetHumanoid(Character)
		end
	end

	return true
end

local function RandomCharacters(Length)
	local STR = ''

	for i = 1, Length do
		STR = STR .. string.char(math.random(65, 90))
	end

	return STR
end

-- Sorting functions

local function SortTabs(SelectedTab)
	if Tabs then
		if Tabs[1] then
			if Tabs[1].Name ~= SelectedTab.Name then
				local i = #Tabs
				local Object = nil

				for x, v in next, Tabs do
					if v.Name == SelectedTab.Name then
						Object = v

						table.remove(Tabs, x)
					end
				end

				table.insert(Tabs, 1, Object)

				for _, v in next, Tabs do
					if v then
						local x = i * 10

						v.ZIndex = x

						for _, v2 in next, v:GetChildren() do
							if v2 then
								if string.find(v2.Name, 'Background') then
									v2.ZIndex = x - 1
								elseif string.find(v2.Name, 'FrameTitle') then
									v2.ZIndex = x + 1
								elseif string.find(v2.Name, 'MinimizeButton') then
									v2.ZIndex = x + 1
								elseif string.find(v2.Name, 'Border') then
									v2.ZIndex = x + 2
								elseif string.find(v2.Name, 'ButtonsFrame') or
									string.find(v2.Name, 'TextFrame') then

									v2.ZIndex = x + 3

									for _, v3 in next, v2:GetChildren() do
										if v3 then
											v3.ZIndex = x + 4
										end
									end
								end
							end
						end
					end

					i = i - 1
				end
			end
		end
	end
end

local function SortWindows(SelectedWindow)
	if Windows then
		if Windows[1] then
			if Windows[1].Name ~= SelectedWindow.Name then
				local i = #Windows
				local Object = nil

				for x, v in next, Windows do
					if v.Name == SelectedWindow.Name then
						Object = v

						table.remove(Windows, x)
					end
				end

				table.insert(Windows, 1, Object)

				for _, v in next, Windows do
					if v then
						local x = i * 150

						v.ZIndex = x

						for _, v2 in next, v:GetDescendants() do
							if v2 then
								if v2:IsA('GuiObject') then
									v2.ZIndex = x
								end
							end
						end
					end

					i = i - 1
				end
			end
		end
	end
end

-- GUI functions

local function MakeRGBSpin(GuiObj, ColorOffset)
	if not GuiObj then return end
	if not GuiObj:IsA('GuiBase') then return end

	if GuiObj then
		local Index1 = ColorOffset
		local Index2 = ColorOffset + 0.1

		local UIGradient = Instance.new('UIGradient')
		UIGradient.Parent = GuiObj

		coroutine.wrap(function()
			while true do
				if not GuiObj then break end
				if not GuiObj.Parent then break end
				if not UIGradient then break end
				if not UIGradient.Parent then break end
				if not _G[CheatName] then break end

				if Index1 > 1 then
					Index1 = Index1 - 1
				else
					Index1 = Index1 + 0.005
				end

				if Index2 > 1 then
					Index2 = Index2 - 1
				else
					Index2 = Index2 + 0.005
				end

				if UIGradient then
					local Color1 = Color3.fromHSV(Index1, 0.888, 1)
					local Color2 = Color3.fromHSV(Index2, 0.888, 1)

					UIGradient.Color = ColorSequence.new(Color1, Color2)
				end

				task.wait()
			end
		end)()

		return true
	end

	return false
end

local function SetDraggable(ObjectToHold, ObjectToMove)
	if ObjectToHold and ObjectToMove then
		local Drag = false
		local LastVector = Vector2.new()

		local Connection1 = ObjectToHold.InputBegan:Connect(function(Input)
			if DragingOtherObject then return end

			if Input.UserInputType == Enum.UserInputType.MouseButton1 or
				Input.UserInputType == Enum.UserInputType.Touch then

				Drag = true
				DragingOtherObject = true

				LastVector = Vector2.new(Input.Position.X - ObjectToMove.AbsolutePosition.X,
					Input.Position.Y - ObjectToMove.AbsolutePosition.Y)
			end
		end)

		local Connection2 = UserInputService.InputChanged:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseMovement or
				Input.UserInputType == Enum.UserInputType.Touch then

				if Drag then
					if ObjectToMove then
						local uDim = UDim2.new(0, Input.Position.X - LastVector.X,
							0, Input.Position.Y - LastVector.Y)

						ObjectToMove.AnchorPoint = Vector2.new(0, 0)
						ObjectToMove.Position = uDim

						if table.find(Tabs, ObjectToMove) then
							SortTabs(ObjectToMove)
						end

						if table.find(Windows, ObjectToMove) then
							SortWindows(ObjectToMove)
						end
					end
				end
			end
		end)

		local Connection3 = UserInputService.InputEnded:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or
				Input.UserInputType == Enum.UserInputType.Touch then

				Drag = false
				DragingOtherObject = false
			end
		end)

		local Name = CheatName..', '..ObjectToHold.Name..', '..ObjectToMove.Name

		Connections[Name..'1'] = Connection1
		Connections[Name..'2'] = Connection2
		Connections[Name..'3'] = Connection3

		return true
	end

	return false
end

local function SetRoundness(uDim, GuiObj)
	if not GuiObj then return end
	if not GuiObj:IsA('GuiBase') then return end

	GuiObj.BorderColor3 = Color3.new(0, 0, 0)
	GuiObj.BorderSizePixel = 0

	local UICorner = Instance.new('UICorner')
	UICorner.Parent = GuiObj

	if uDim then
		UICorner.CornerRadius = uDim
	else
		UICorner.CornerRadius = UDim.new()
	end

	return UICorner
end

-- GUI

local MainGUI = GetGUI()
local StartOffset = 45

local RF_GUI = Instance.new('ScreenGui')
RF_GUI.AutoLocalize = false
RF_GUI.Name = RandomCharacters(24)
RF_GUI.ResetOnSpawn = false
RF_GUI.Parent = MainGUI

local MainFrame = Instance.new('Frame')
MainFrame.Active = true
MainFrame.BackgroundColor3 = Color3.new(0.196078, 0.196078, 0.196078)
MainFrame.BorderSizePixel = 0
MainFrame.Name = 'MainFrame'
MainFrame.Position = UDim2.new(0, StartOffset, 0, 40)
MainFrame.Size = UDim2.new(0, 150, 0, 27)
MainFrame.Parent = RF_GUI

SetDraggable(MainFrame, MainFrame)
SetRoundness(UDim.new(0, 7), MainFrame)

table.insert(Tabs, MainFrame)
StartOffset = StartOffset + 165

local MainFrameBackground = Instance.new('Frame')
MainFrameBackground.AnchorPoint = Vector2.new(0.5, 1)
MainFrameBackground.BackgroundColor3 = Color3.new(0.196078, 0.196078, 0.196078)
MainFrameBackground.BorderSizePixel = 0
MainFrameBackground.Name = 'MainFrameBackground'
MainFrameBackground.Position = UDim2.new(0.5, 0, 1, 0)
MainFrameBackground.Size = UDim2.new(1, 0, 0, 7)
MainFrameBackground.Parent = MainFrame

local MainFrameTitle = Instance.new('TextLabel')
MainFrameTitle.BackgroundColor3 = Color3.new(1, 1, 1)
MainFrameTitle.BackgroundTransparency = 1
MainFrameTitle.Font = Enum.Font.SourceSansLight
MainFrameTitle.Name = 'MainFrameTitle'
MainFrameTitle.Size = UDim2.new(1, 0, 1, 0)
MainFrameTitle.Text = 'Main'
MainFrameTitle.TextColor3 = Color3.new(1, 1, 1)
MainFrameTitle.TextScaled = true
MainFrameTitle.TextSize = 14
MainFrameTitle.TextWrapped = true
MainFrameTitle.Parent = MainFrame

local BorderMainFrame = Instance.new('Frame')
BorderMainFrame.BackgroundColor3 = Color3.new(1, 1, 1)
BorderMainFrame.BorderSizePixel = 0
BorderMainFrame.Name = 'BorderMainFrame'
BorderMainFrame.Position = UDim2.new(0, 0, 1, 0)
BorderMainFrame.Size = UDim2.new(1, 0, 0, 3)
BorderMainFrame.Parent = MainFrame

MakeRGBSpin(BorderMainFrame, 0)

local MainButtonsFrame = Instance.new('Frame')
MainButtonsFrame.BackgroundColor3 = Color3.new(0.196078, 0.196078, 0.196078)
MainButtonsFrame.BorderSizePixel = 0
MainButtonsFrame.ClipsDescendants = true
MainButtonsFrame.Name = 'MainButtonsFrame'
MainButtonsFrame.Position = UDim2.new(0, 0, 1, 3)
MainButtonsFrame.Size = UDim2.new(1, 0, 0, 140)
MainButtonsFrame.Parent = MainFrame

local MainFrame_MinimizeButton = Instance.new('TextButton')
MainFrame_MinimizeButton.AnchorPoint = Vector2.new(1, 0)
MainFrame_MinimizeButton.BackgroundTransparency = 1
MainFrame_MinimizeButton.Font = Enum.Font.SourceSansLight
MainFrame_MinimizeButton.Name = 'MainFrame_MinimizeButton'
MainFrame_MinimizeButton.Position = UDim2.new(1, 0, 0, 0)
MainFrame_MinimizeButton.Size = UDim2.new(1, 0, 1, 0)
MainFrame_MinimizeButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
MainFrame_MinimizeButton.Text = '-'
MainFrame_MinimizeButton.TextColor3 = Color3.new(1, 1, 1)
MainFrame_MinimizeButton.TextScaled = true
MainFrame_MinimizeButton.TextSize = 14
MainFrame_MinimizeButton.TextWrapped = true
MainFrame_MinimizeButton.Parent = MainFrame
MainFrame_MinimizeButton.Activated:Connect(function()
	local MaxSize = UDim2.new(1, 0, 0, 140)
	local MinSize = UDim2.new(1, 0, 0, 0)

	local Collapsed = MainButtonsFrame.Size.Y.Offset < 40

	if Collapsed then
		if MainButtonsFrame then
			MainButtonsFrame:TweenSize(MaxSize, 'InOut', 'Sine', 0.4, true, function()
				MainFrame_MinimizeButton.Text = '-'
			end)
		end
	else
		if MainButtonsFrame then
			MainButtonsFrame:TweenSize(MinSize, 'InOut', 'Sine', 0.4, true, function()
				MainFrame_MinimizeButton.Text = '+'
			end)
		end
	end
end)

local BToolsButton = Instance.new('TextButton')
BToolsButton.AutoButtonColor = false
BToolsButton.BackgroundColor3 = Color3.new(1, 1, 1)
BToolsButton.BackgroundTransparency = 1
BToolsButton.Font = Enum.Font.SourceSansLight
BToolsButton.Name = 'BToolsButton'
BToolsButton.Size = UDim2.new(1, 0, 0, 20)
BToolsButton.Text = 'BTools'
BToolsButton.TextColor3 = Color3.new(1, 1, 1)
BToolsButton.TextScaled = true
BToolsButton.TextSize = 16
BToolsButton.TextWrapped = true
BToolsButton.Parent = MainButtonsFrame
BToolsButton.Activated:Connect(function()
	Initialize()

	if not BToolsActivated then
		BToolsActivated = true
		BToolsButton.BackgroundTransparency = 0.888

		if Backpack then
			local Hammer = Instance.new('HopperBin')
			Hammer.BinType = Enum.BinType.Hammer
			Hammer.Name = 'Hammer'
			Hammer.Parent = Backpack

			local Grab = Instance.new('HopperBin')
			Grab.BinType = Enum.BinType.Grab
			Grab.Name = 'Grab'
			Grab.Parent = Backpack

			local Clone = Instance.new('HopperBin')
			Clone.BinType = Enum.BinType.Clone
			Clone.Name = 'Clone'
			Clone.Parent = Backpack
		end
	else
		BToolsActivated = false
		BToolsButton.BackgroundTransparency = 1

		for _, v in next, Backpack:GetChildren() do
			if v:IsA('HopperBin') then
				v:Destroy()
			end
		end
	end
end)

local SpeedHackBtn = Instance.new('TextButton')
SpeedHackBtn.AutoButtonColor = false
SpeedHackBtn.BackgroundColor3 = Color3.new(1, 1, 1)
SpeedHackBtn.BackgroundTransparency = 1
SpeedHackBtn.Font = Enum.Font.SourceSansLight
SpeedHackBtn.Name = 'SpeedHackBtn'
SpeedHackBtn.Position = UDim2.new(0, 0, 0, 20)
SpeedHackBtn.Size = UDim2.new(1, 0, 0, 20)
SpeedHackBtn.Text = 'Speed hack'
SpeedHackBtn.TextColor3 = Color3.new(1, 1, 1)
SpeedHackBtn.TextScaled = true
SpeedHackBtn.TextSize = 16
SpeedHackBtn.TextWrapped = true
SpeedHackBtn.Parent = MainButtonsFrame
SpeedHackBtn.Activated:Connect(function()
	Initialize()

	if not SpeedHackActivated then
		if Humanoid then
			SpeedHackActivated = true
			SpeedHackBtn.BackgroundTransparency = 0.888

			local Connection = Humanoid.Changed:Connect(function(Property)
				if Property == 'WalkSpeed' then
					if Humanoid.WalkSpeed ~= LastHumanoidWalkSpeed * 3 then
						LastHumanoidWalkSpeed = Humanoid.WalkSpeed
						Humanoid.WalkSpeed = LastHumanoidWalkSpeed * 3
					end
				end
			end)

			LastHumanoidWalkSpeed = Humanoid.WalkSpeed
			Humanoid.WalkSpeed = LastHumanoidWalkSpeed * 3

			Connections['HumanoidChangedExploit'] = Connection
		end
	else
		SpeedHackActivated = false
		SpeedHackBtn.BackgroundTransparency = 1

		local Connection = Connections['HumanoidChangedExploit']

		if Connection then
			Connection:Disconnect()
			Connections['HumanoidChangedExploit'] = nil
		end

		if Humanoid then
			Humanoid.WalkSpeed = LastHumanoidWalkSpeed
		end
	end
end)

local XRayObjects = Instance.new('TextButton')
XRayObjects.AutoButtonColor = false
XRayObjects.BackgroundColor3 = Color3.new(1, 1, 1)
XRayObjects.BackgroundTransparency = 1
XRayObjects.Font = Enum.Font.SourceSansLight
XRayObjects.Name = 'XRayObjects'
XRayObjects.Position = UDim2.new(0, 0, 0, 40)
XRayObjects.Size = UDim2.new(1, 0, 0, 20)
XRayObjects.Text = 'XRay Objects'
XRayObjects.TextColor3 = Color3.new(1, 1, 1)
XRayObjects.TextScaled = true
XRayObjects.TextSize = 16
XRayObjects.TextWrapped = true
XRayObjects.Parent = MainButtonsFrame
XRayObjects.Activated:Connect(function()
	if not XRayEnabled then
		XRayEnabled = true

		local Monsters = workspace:FindFirstChild('Monsters')

		if Monsters then
			for _, v in next, Monsters:GetChildren() do
				if v:IsA('Model') and v:FindFirstChildOfClass('Humanoid') then
					local ColorByName = (v.Name:lower():find('blue') and Color3.fromRGB(0, 127, 255)) or
						(v.Name:lower():find('green') and Color3.fromRGB(0, 255, 0)) or
						(v.Name:lower():find('orange') and Color3.fromRGB(255, 127, 0)) or
						(v.Name:lower():find('purple') and Color3.fromRGB(127, 0, 255)) or Color3.new(1, 1, 1)

					local Highlight = v:FindFirstChild('Highlightsploit') or Instance.new('Highlight')
					Highlight.Adornee = v
					Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
					Highlight.Enabled = true
					Highlight.FillColor = ColorByName
					Highlight.FillTransparency = 0.5
					Highlight.Name = 'Highlightsploit'
					Highlight.OutlineColor = Color3.new(1, 1, 1)
					Highlight.OutlineTransparency = 0.5
					Highlight.Parent = v

					Overlays[v] = Highlight
				end
			end
		end

		for _, v in next, workspace:GetChildren() do
			if v:IsA('Model') and (v.Name:lower():find('block') or v.Name:lower():find('food') or
				v.Name:lower():find('fuse') or v.Name:lower():find('battery')) and
				not Players:GetPlayerFromCharacter(v) and not v:FindFirstChildOfClass('Humanoid') then

				local Highlight = v:FindFirstChild('Highlightsploit') or Instance.new('Highlight')
				Highlight.Adornee = v
				Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				Highlight.Enabled = true
				Highlight.FillColor = Color3.new(1, 1, 1)
				Highlight.FillTransparency = 0.5
				Highlight.Name = 'Highlightsploit'
				Highlight.OutlineColor = Color3.new(1, 1, 1)
				Highlight.OutlineTransparency = 0.5
				Highlight.Parent = v

				Overlays[v] = Highlight
			end
		end

		if Monsters then
			Connections['MonstersChildAddedExploit0'] = Monsters.ChildAdded:Connect(function(v)
				if v:IsA('Model') and v:FindFirstChildOfClass('Humanoid') then
					local ColorByName = (v.Name:lower():find('blue') and Color3.fromRGB(0, 127, 255)) or
						(v.Name:lower():find('green') and Color3.fromRGB(0, 255, 0)) or
						(v.Name:lower():find('orange') and Color3.fromRGB(255, 127, 0)) or
						(v.Name:lower():find('purple') and Color3.fromRGB(127, 0, 255)) or Color3.new(1, 1, 1)

					local Highlight = v:FindFirstChild('Highlightsploit') or Instance.new('Highlight')
					Highlight.Adornee = v
					Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
					Highlight.Enabled = true
					Highlight.FillColor = ColorByName
					Highlight.FillTransparency = 0.5
					Highlight.Name = 'Highlightsploit'
					Highlight.OutlineColor = Color3.new(1, 1, 1)
					Highlight.OutlineTransparency = 0.5
					Highlight.Parent = v

					Overlays[v] = Highlight
				end
			end)
		end

		Connections['WorkspaceChildAddedExploit0'] = workspace.ChildAdded:Connect(function(v)
			if v:IsA('Model') and (v.Name:lower():find('block') or v.Name:lower():find('food') or
				v.Name:lower():find('fuse') or v.Name:lower():find('battery')) and
				not Players:GetPlayerFromCharacter(v) and not v:FindFirstChildOfClass('Humanoid') then

				local Highlight = v:FindFirstChild('Highlightsploit') or Instance.new('Highlight')
				Highlight.Adornee = v
				Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				Highlight.Enabled = true
				Highlight.FillColor = Color3.new(1, 1, 1)
				Highlight.FillTransparency = 0.5
				Highlight.Name = 'Highlightsploit'
				Highlight.OutlineColor = Color3.new(1, 1, 1)
				Highlight.OutlineTransparency = 0.5
				Highlight.Parent = v

				Overlays[v] = Highlight
			end
		end)
	else
		XRayEnabled = false

		if Connections['MonstersChildAddedExploit0'] then
			Connections['MonstersChildAddedExploit0']:Disconnect()
			Connections['MonstersChildAddedExploit0'] = nil
		end

		if Connections['WorkspaceChildAddedExploit0'] then
			Connections['WorkspaceChildAddedExploit0']:Disconnect()
			Connections['WorkspaceChildAddedExploit0'] = nil
		end

		for _, v in next, Overlays do
			v:Destroy()
		end

		table.clear(Overlays)
	end

	XRayObjects.BackgroundTransparency = XRayEnabled and 0.888 or 1
end)

local TeleportingEnabledBtn = Instance.new('TextButton')
TeleportingEnabledBtn.AutoButtonColor = false
TeleportingEnabledBtn.BackgroundColor3 = Color3.new(1, 1, 1)
TeleportingEnabledBtn.BackgroundTransparency = 1
TeleportingEnabledBtn.Font = Enum.Font.SourceSansLight
TeleportingEnabledBtn.Name = 'TeleportingEnabledBtn'
TeleportingEnabledBtn.Position = UDim2.new(0, 0, 0, 60)
TeleportingEnabledBtn.Size = UDim2.new(1, 0, 0, 20)
TeleportingEnabledBtn.Text = 'Click to teleport'
TeleportingEnabledBtn.TextColor3 = Color3.new(1, 1, 1)
TeleportingEnabledBtn.TextScaled = true
TeleportingEnabledBtn.TextSize = 16
TeleportingEnabledBtn.TextWrapped = true
TeleportingEnabledBtn.Parent = MainButtonsFrame
TeleportingEnabledBtn.Activated:Connect(function()
	TeleportingEnabled = not TeleportingEnabled

	TeleportingEnabledBtn.BackgroundTransparency = TeleportingEnabled and 0.888 or 1
	TeleportingEnabledBtn.Text = TeleportingEnabled and 'LControl + LMB' or 'Click to teleport'
end)

local GetAllItems = Instance.new('TextButton')
GetAllItems.AutoButtonColor = false
GetAllItems.BackgroundColor3 = Color3.new(1, 1, 1)
GetAllItems.BackgroundTransparency = 1
GetAllItems.Font = Enum.Font.SourceSansLight
GetAllItems.Name = 'GetAllItems'
GetAllItems.Position = UDim2.new(0, 0, 0, 80)
GetAllItems.Size = UDim2.new(1, 0, 0, 20)
GetAllItems.Text = 'Get all items'
GetAllItems.TextColor3 = Color3.new(1, 1, 1)
GetAllItems.TextScaled = true
GetAllItems.TextSize = 16
GetAllItems.TextWrapped = true
GetAllItems.Parent = MainButtonsFrame
GetAllItems.Activated:Connect(function()
	for _, v in next, workspace:GetChildren() do
		coroutine.resume(coroutine.create(function()
			if v:IsA('Model') and (v.Name:lower():find('block') or v.Name:lower():find('food') or
				v.Name:lower():find('fuse') or v.Name:lower():find('battery')) then

				local Original = v:GetPivot()
				v:PivotTo(Character:GetPivot())

				task.wait(1)
				v:PivotTo(Original)
			end
		end))
	end
end)

local TeleportToTheater = Instance.new('TextButton')
TeleportToTheater.AutoButtonColor = false
TeleportToTheater.BackgroundColor3 = Color3.new(1, 1, 1)
TeleportToTheater.BackgroundTransparency = 1
TeleportToTheater.Font = Enum.Font.SourceSansLight
TeleportToTheater.Name = 'TeleportToTheater'
TeleportToTheater.Position = UDim2.new(0, 0, 0, 100)
TeleportToTheater.Size = UDim2.new(1, 0, 0, 20)
TeleportToTheater.Text = 'Tp to theater'
TeleportToTheater.TextColor3 = Color3.new(1, 1, 1)
TeleportToTheater.TextScaled = true
TeleportToTheater.TextSize = 16
TeleportToTheater.TextWrapped = true
TeleportToTheater.Parent = MainButtonsFrame
TeleportToTheater.Activated:Connect(function()
	Character:PivotTo(CFrame.new(381, 45, 123), select(4, Character:GetPivot():GetComponents()))
end)

local TeleportToFinale = Instance.new('TextButton')
TeleportToFinale.AutoButtonColor = false
TeleportToFinale.BackgroundColor3 = Color3.new(1, 1, 1)
TeleportToFinale.BackgroundTransparency = 1
TeleportToFinale.Font = Enum.Font.SourceSansLight
TeleportToFinale.Name = 'TeleportToFinale'
TeleportToFinale.Position = UDim2.new(0, 0, 0, 120)
TeleportToFinale.Size = UDim2.new(1, 0, 0, 20)
TeleportToFinale.Text = 'Tp to finale'
TeleportToFinale.TextColor3 = Color3.new(1, 1, 1)
TeleportToFinale.TextScaled = true
TeleportToFinale.TextSize = 16
TeleportToFinale.TextWrapped = true
TeleportToFinale.Parent = MainButtonsFrame
TeleportToFinale.Activated:Connect(function()
	Character:PivotTo(CFrame.new(-352, 23, 620), select(4, Character:GetPivot():GetComponents()))
end)

local CreditsFrame = Instance.new('Frame')
CreditsFrame.BackgroundColor3 = Color3.new(0.196078, 0.196078, 0.196078)
CreditsFrame.BorderSizePixel = 0
CreditsFrame.Name = 'CreditsFrame'
CreditsFrame.Position = UDim2.new(0, StartOffset, 0, 40)
CreditsFrame.Size = UDim2.new(0, 150, 0, 27)
CreditsFrame.Parent = RF_GUI

SetDraggable(CreditsFrame, CreditsFrame)
SetRoundness(UDim.new(0, 7), CreditsFrame)

table.insert(Tabs, CreditsFrame)
StartOffset = StartOffset + 165

local CreditsFrameBackground = Instance.new('Frame')
CreditsFrameBackground.AnchorPoint = Vector2.new(0.5, 1)
CreditsFrameBackground.BackgroundColor3 = Color3.new(0.196078, 0.196078, 0.196078)
CreditsFrameBackground.BorderSizePixel = 0
CreditsFrameBackground.Name = 'CreditsFrameBackground'
CreditsFrameBackground.Position = UDim2.new(0.5, 0, 1, 0)
CreditsFrameBackground.Size = UDim2.new(1, 0, 0, 7)
CreditsFrameBackground.Parent = CreditsFrame

local CreditsFrameTitle = Instance.new('TextLabel')
CreditsFrameTitle.BackgroundColor3 = Color3.new(1, 1, 1)
CreditsFrameTitle.BackgroundTransparency = 1
CreditsFrameTitle.Font = Enum.Font.SourceSansLight
CreditsFrameTitle.Name = 'CreditsFrameTitle'
CreditsFrameTitle.Size = UDim2.new(1, 0, 1, 0)
CreditsFrameTitle.Text = 'Credits'
CreditsFrameTitle.TextColor3 = Color3.new(1, 1, 1)
CreditsFrameTitle.TextScaled = true
CreditsFrameTitle.TextSize = 14
CreditsFrameTitle.TextWrapped = true
CreditsFrameTitle.Parent = CreditsFrame

local BorderCreditsFrame = Instance.new('Frame')
BorderCreditsFrame.BackgroundColor3 = Color3.new(1, 1, 1)
BorderCreditsFrame.BorderSizePixel = 0
BorderCreditsFrame.Name = 'BorderCreditsFrame'
BorderCreditsFrame.Position = UDim2.new(0, 0, 1, 0)
BorderCreditsFrame.Size = UDim2.new(1, 0, 0, 3)
BorderCreditsFrame.Parent = CreditsFrame

MakeRGBSpin(BorderCreditsFrame, 0.1)

local CreditsTextFrame = Instance.new('Frame')
CreditsTextFrame.BackgroundColor3 = Color3.new(0.196078, 0.196078, 0.196078)
CreditsTextFrame.BorderSizePixel = 0
CreditsTextFrame.ClipsDescendants = true
CreditsTextFrame.Name = 'CreditsTextFrame'
CreditsTextFrame.Position = UDim2.new(0, 0, 1, 3)
CreditsTextFrame.Size = UDim2.new(1, 0, 0, 100)
CreditsTextFrame.Parent = CreditsFrame

local CreditsFrame_MinimizeButton = Instance.new('TextButton')
CreditsFrame_MinimizeButton.AnchorPoint = Vector2.new(1, 0)
CreditsFrame_MinimizeButton.BackgroundTransparency = 1
CreditsFrame_MinimizeButton.Font = Enum.Font.SourceSansLight
CreditsFrame_MinimizeButton.Name = 'CreditsFrame_MinimizeButton'
CreditsFrame_MinimizeButton.Position = UDim2.new(1, 0, 0, 0)
CreditsFrame_MinimizeButton.Size = UDim2.new(1, 0, 1, 0)
CreditsFrame_MinimizeButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
CreditsFrame_MinimizeButton.Text = '-'
CreditsFrame_MinimizeButton.TextColor3 = Color3.new(1, 1, 1)
CreditsFrame_MinimizeButton.TextScaled = true
CreditsFrame_MinimizeButton.TextSize = 14
CreditsFrame_MinimizeButton.TextWrapped = true
CreditsFrame_MinimizeButton.Parent = CreditsFrame
CreditsFrame_MinimizeButton.Activated:Connect(function()
	local MaxSize = UDim2.new(1, 0, 0, 100)
	local MinSize = UDim2.new(1, 0, 0, 0)

	local Collapsed = CreditsTextFrame.Size.Y.Offset < 40

	if Collapsed then
		if CreditsTextFrame then
			CreditsTextFrame:TweenSize(MaxSize, 'InOut', 'Sine', 0.4, true, function()
				CreditsFrame_MinimizeButton.Text = '-'
			end)
		end
	else
		if CreditsTextFrame then
			CreditsTextFrame:TweenSize(MinSize, 'InOut', 'Sine', 0.4, true, function()
				CreditsFrame_MinimizeButton.Text = '+'
			end)
		end
	end
end)

local CreditsText = Instance.new('TextLabel')
CreditsText.AnchorPoint = Vector2.new(0.5, 0.5)
CreditsText.BackgroundTransparency = 1
CreditsText.Font = Enum.Font.SourceSansLight
CreditsText.Name = 'CreditsText'
CreditsText.Position = UDim2.new(0.5, 0, 0.5, 0)
CreditsText.Size = UDim2.new(1, 0, 1, 0)
CreditsText.Text = 'Script created by Vov4ik4124.'
CreditsText.TextColor3 = Color3.new(1, 1, 1)
CreditsText.TextScaled = true
CreditsText.TextWrapped = true
CreditsText.TextYAlignment = Enum.TextYAlignment.Top
CreditsText.Parent = CreditsTextFrame

-- Event functions

local function OnCharacterAdded(newCharacter)
	Character = newCharacter or LocalPlayer.Character
end

local function OnInputBegan(Input, GameProcessedEvent)
	if GameProcessedEvent then return end
	if not TeleportingEnabled then return end

	if Input.UserInputType == Enum.UserInputType.MouseButton1 and
		UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then

		local Mouse = LocalPlayer:GetMouse() -- Get mouse

		if not Mouse then return end
		if not Character then return end

		-- Raycast

		local Hit = Mouse.Hit

		local RayParams = RaycastParams.new()
		RayParams.FilterDescendantsInstances = GetIgnoreInstances()
		RayParams.FilterType = Enum.RaycastFilterType.Exclude
		RayParams.IgnoreWater = true

		local RayResult = workspace:Raycast(
			Mouse.UnitRay.Origin,
			Mouse.UnitRay.Direction * 400,
			RayParams
		)

		if not RayResult then return end
		if not RayResult.Instance then return end

		local CollisionSphere = Instance.new('Part')
		CollisionSphere.Anchored = true
		CollisionSphere.CanCollide = false
		CollisionSphere.CFrame = CFrame.new(RayResult.Position + RayResult.Normal)
		CollisionSphere.Shape = Enum.PartType.Ball
		CollisionSphere.Size = Vector3.new(0.54, 0.54, 0.54)
		CollisionSphere.Transparency = 1
		CollisionSphere.Name = 'CollisionSphere'
		CollisionSphere.Parent = workspace

		-- Teleport player

		Character:PivotTo(
			CFrame.new(
				CollisionSphere.Position.X, CollisionSphere.Position.Y, CollisionSphere.Position.Z,
				select(4, Character:GetPivot():GetComponents())
			)
		)

		task.wait()

		-- Cleanup

		CollisionSphere:Destroy()
		CollisionSphere = nil
	end
end

-- Connections

UserInputService.InputBegan:Connect(OnInputBegan)
LocalPlayer.CharacterAdded:Connect(OnCharacterAdded)

if LocalPlayer.Character then
	OnCharacterAdded(LocalPlayer.Character)
end

-- Execute event

repeat
	task.wait(1)
until not _G[CheatName]

if RF_GUI then
	RF_GUI:Destroy()
	RF_GUI = nil
end

for _, v in next, Connections do
	if v then
		v:Disconnect()
		v = nil
	end
end

table.clear(Connections)

Connections = nil

return true
