-- Services

local CoreGui = game:GetService('CoreGui')
local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local RunService = game:GetService('RunService')
local StarterGui = game:GetService('StarterGui')
local UserInputService = game:GetService('UserInputService')
local Workspace = game:GetService('Workspace') or workspace

-- Control executes

local CheatName = 'FTF_GUI_v1.0.0'

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
local LocalTorso = nil
local RemoteEvent = nil
local TempStats = nil

local DragingOtherObject = false

local AlwaysHackPCMode = false
local AutoInteract = false
local AutoKillSurvivors = false
local BToolsActivated = false
local DontDisableCrawl = false
local FlyCheatActive = false
local MoveInRagdoll = false
local NeverFailComputersActive = false
local SpeedHackActivated = false
local XRayEnabled = false

local TargetPCEvent = nil

local DelaySendingRequest = 0.075
local LastHumanoidWalkSpeed = 0
local LastDisableCrawlValue = false

-- Tables

local Connections = {}
local Tabs = {}
local Windows = {}

-- Functions

function GetGUI()
	local Result = nil

	local Success, _ = pcall(function()
		if CoreGui.ClassName then
			return true
		end
	end)

	Result = Success and CoreGui or GetLocalPlayerGui()

	return Result
end

function GetHumanoid(Character)
	local Result = nil

	if Character then
		Result = Character:FindFirstChildWhichIsA('Humanoid') or
			Character:FindFirstChild('Humanoid')
	end

	return Result
end

function GetLocalPlayerGui()
	local Result = nil

	if LocalPlayer then
		Result = LocalPlayer:FindFirstChildWhichIsA('PlayerGui') or
			LocalPlayer:WaitForChild('PlayerGui')
	end

	return Result
end

function GetTorso(Character)
	local Result = nil

	if Character then
		Result = Character:FindFirstChild('Torso') or
			Character:FindFirstChild('UpperTorso') or
			Character:FindFirstChild('HumanoidRootPart')
	end

	return Result
end

function Initialize()
	Character = nil
	Backpack = nil
	Humanoid = nil
	PlayerGui = nil

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

	if not PlayerGui then
		PlayerGui = GetLocalPlayerGui()
	else
		if not PlayerGui.Parent then
			PlayerGui = GetLocalPlayerGui()
		end
	end

	if not RemoteEvent then
		RemoteEvent = ReplicatedStorage:FindFirstChild('RemoteEvent', true)
	else
		if not RemoteEvent.Parent then
			RemoteEvent = ReplicatedStorage:FindFirstChild('RemoteEvent', true)
		end
	end

	if not TempStats then
		if LocalPlayer then
			TempStats = LocalPlayer:FindFirstChild('TempPlayerStatsModule')
		end
	else
		if not TempStats.Parent then
			if LocalPlayer then
				TempStats = LocalPlayer:FindFirstChild('TempPlayerStatsModule')
			end
		end
	end

	if not LocalTorso then
		if Character then
			LocalTorso = GetTorso(Character)
		end
	else
		if not LocalTorso.Parent then
			if Character then
				LocalTorso = GetTorso(Character)
			end
		end
	end

	return true
end

function RandomCharacters(Length)
	local STR = ''

	for i = 1, Length do
		STR = STR .. string.char(math.random(65, 90))
	end

	return STR
end

-- GUI functions

function MakeRGBSpin(GuiObj, ColorOffset)
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

function SetDraggable(ObjectToHold, ObjectToMove)
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

function SetRoundness(uDim, GuiObj)
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

-- Sorting functions

function SortTabs(SelectedTab)
	if Tabs then
		if Tabs[1] then
			if Tabs[1].Name ~= SelectedTab.Name then
				local i = #Tabs
				local Object = nil

				for x, v in pairs(Tabs) do
					if v.Name == SelectedTab.Name then
						Object = v

						table.remove(Tabs, x)
					end
				end

				table.insert(Tabs, 1, Object)

				for _, v in pairs(Tabs) do
					if v then
						local x = i * 10

						v.ZIndex = x

						for _, v2 in pairs(v:GetChildren()) do
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

									for _, v3 in pairs(v2:GetChildren()) do
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

function SortWindows(SelectedWindow)
	if Windows then
		if Windows[1] then
			if Windows[1].Name ~= SelectedWindow.Name then
				local i = #Windows
				local Object = nil

				for x, v in pairs(Windows) do
					if v.Name == SelectedWindow.Name then
						Object = v

						table.remove(Windows, x)
					end
				end

				table.insert(Windows, 1, Object)

				for _, v in pairs(Windows) do
					if v then
						local x = i * 150

						v.ZIndex = x

						for _, v2 in pairs(v:GetDescendants()) do
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

-- Exploit functions

function CreateHighlight(Object)
	if Object then
		if Object:IsA('Player') then
			local Character = Object.Character

			Object.CharacterAdded:Connect(function(newCharacter)
				Character = newCharacter or Object.Character
				task.wait(0.1)

				if Character then
					local Text = Character.Name..'₄'

					if not Character:FindFirstChild(Text) then
						local Highlight = Instance.new('Highlight')
						Highlight.Parent = Character
						Highlight.Name = Text
						Highlight.Adornee = Character
						Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
						Highlight.FillColor = Color3.new(1, 1, 1)
						Highlight.FillTransparency = 0.95
						Highlight.OutlineColor = Color3.new(1, 1, 1)
						Highlight.OutlineTransparency = 0.4
					end
				end
			end)

			Object = Character
		end

		if Object then
			if Object:IsA('Model') then
				local Text = Object.Name..'₄'

				if not Object:FindFirstChild(Text) then
					local Highlight = Instance.new('Highlight')
					Highlight.Parent = Object
					Highlight.Name = Text
					Highlight.Adornee = Object
					Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
					Highlight.FillColor = Color3.new(1, 1, 1)
					Highlight.FillTransparency = 0.95
					Highlight.OutlineColor = Color3.new(1, 1, 1)
					Highlight.OutlineTransparency = 0.4
				end

				local CorrectName = string.find(Object.Name, 'ComputerTable') and
					not string.find(Object.Name, 'Prefab')

				if CorrectName then
					coroutine.wrap(function()
						local Highlight = Object:WaitForChild(Text)
						local Screen = Object:WaitForChild('Screen')

						Screen.Changed:Connect(function(Property)
							if Property == 'Color' then
								if Highlight then
									local clr = Screen.Color

									Highlight.FillColor = clr
									Highlight.OutlineColor = clr
								end
							end
						end)

						Highlight.FillColor = Screen.Color
						Highlight.OutlineColor = Screen.Color
					end)()
				end

				return true
			end

			return false
		end

		return false
	end

	return false
end

function DeleteHighlight(Object)
	if Object then
		if Object:IsA('Player') then
			Object = Object.Character
		end

		if Object then
			if Object:IsA('Model') then
				local Text = Object.Name..'₄'

				for _, v in pairs(Object:GetChildren()) do
					if v:IsA('Highlight') and v.Name == Text then
						v:Destroy()
					end
				end

				return true
			end
		end
	end

	return false
end

-- GUI

local MainGUI = GetGUI()
local StartOffset = 45

local FTF_GUI = Instance.new('ScreenGui')
FTF_GUI.AutoLocalize = false
FTF_GUI.Name = RandomCharacters(24)
FTF_GUI.ResetOnSpawn = false
FTF_GUI.Parent = MainGUI

local MainFrame = Instance.new('Frame')
MainFrame.Active = true
MainFrame.BackgroundColor3 = Color3.new(0.196078, 0.196078, 0.196078)
MainFrame.BorderSizePixel = 0
MainFrame.Name = 'MainFrame'
MainFrame.Position = UDim2.new(0, StartOffset, 0, 40)
MainFrame.Size = UDim2.new(0, 150, 0, 27)
MainFrame.Parent = FTF_GUI

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
MainButtonsFrame.Size = UDim2.new(1, 0, 0, 260)
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
	local MaxSize = UDim2.new(1, 0, 0, 260)
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

		if StarterGui then
			StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)
			StarterGui:SetCore('TopbarEnabled', true)
		end

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

		if StarterGui then
			StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
			StarterGui:SetCore('TopbarEnabled', false)
		end

		if Backpack then
			Backpack:ClearAllChildren()
		end
	end
end)

local SuicideBtn = Instance.new('TextButton')
SuicideBtn.BackgroundTransparency = 1
SuicideBtn.Font = Enum.Font.SourceSansLight
SuicideBtn.Name = 'SuicideBtn'
SuicideBtn.Position = UDim2.new(0, 0, 0, 20)
SuicideBtn.Size = UDim2.new(1, 0, 0, 20)
SuicideBtn.Text = 'Suicide'
SuicideBtn.TextColor3 = Color3.new(1, 1, 1)
SuicideBtn.TextScaled = true
SuicideBtn.TextSize = 16
SuicideBtn.TextWrapped = true
SuicideBtn.Parent = MainButtonsFrame
SuicideBtn.Activated:Connect(function()
	Initialize()

	if Character and Humanoid then
		for _, v in pairs(Character:GetDescendants()) do
			if v:IsA('Constraint') then
				v:Destroy()
			elseif v:IsA('BasePart') then
				v.Anchored = false

				if v.Transparency < 1 then
					v.CanCollide = true
				end
			end
		end

		Character:BreakJoints()

		Humanoid.BreakJointsOnDeath = true
		Humanoid.RequiresNeck = true
		Humanoid.Health = 0
		Humanoid.MaxHealth = 0
		Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
	end
end)

local AutoInteractBtn = Instance.new('TextButton')
AutoInteractBtn.AutoButtonColor = false
AutoInteractBtn.BackgroundColor3 = Color3.new(1, 1, 1)
AutoInteractBtn.BackgroundTransparency = 1
AutoInteractBtn.Font = Enum.Font.SourceSansLight
AutoInteractBtn.Name = 'AutoInteractBtn'
AutoInteractBtn.Position = UDim2.new(0, 0, 0, 40)
AutoInteractBtn.Size = UDim2.new(1, 0, 0, 20)
AutoInteractBtn.Text = 'Auto interact'
AutoInteractBtn.TextColor3 = Color3.new(1, 1, 1)
AutoInteractBtn.TextScaled = true
AutoInteractBtn.TextSize = 16
AutoInteractBtn.TextWrapped = true
AutoInteractBtn.Parent = MainButtonsFrame
AutoInteractBtn.Activated:Connect(function()
	Initialize()

	if not AutoInteract then
		if TempStats then
			AutoInteract = true
			AutoInteractBtn.BackgroundTransparency = 0.888

			local ActionEvent = TempStats.ActionEvent
			local ActionInput = TempStats.ActionInput

			local LastEvent = nil

			local function OnChangedAEvent(Value)
				Value = Value or ActionEvent.Value

				if Value then
					if Value.Parent then
						if RemoteEvent then
							if LastEvent then
								RemoteEvent:FireServer('Input', 'Trigger', false, LastEvent)
								RemoteEvent:FireServer('Input', 'Action', false)
							end

							LastEvent = Value

							RemoteEvent:FireServer('Input', 'Trigger', true, Value)
							RemoteEvent:FireServer('Input', 'Action', true)
						end
					end
				end
			end

			local function OnChangedAInput(Value)
				Value = Value or ActionInput.Value

				if not Value then
					local Event = ActionEvent.Value

					if Event then
						if Event.Parent then
							if RemoteEvent then
								if LastEvent then
									RemoteEvent:FireServer('Input', 'Trigger', false, LastEvent)
									RemoteEvent:FireServer('Input', 'Action', false)
								end

								LastEvent = Value

								RemoteEvent:FireServer('Input', 'Trigger', true, Value)
								RemoteEvent:FireServer('Input', 'Action', true)
							end
						end
					end
				end
			end

			local Connection1 = ActionEvent.Changed:Connect(OnChangedAEvent)
			Connections['ChangedAEventExploit'] = Connection1

			local Connection2 = ActionInput.Changed:Connect(OnChangedAInput)
			Connections['ChangedAInputExploit'] = Connection2

			task.wait(DelaySendingRequest)
			OnChangedAInput(false)
		end
	else
		local Connection1 = Connections['ChangedAEventExploit']

		if Connection1 then
			Connection1:Disconnect()
			Connections['ChangedAEventExploit'] = nil
		end

		local Connection2 = Connections['ChangedAInputExploit']

		if Connection2 then
			Connection2:Disconnect()
			Connections['ChangedAInputExploit'] = nil
		end

		AutoInteract = false
		AutoInteractBtn.BackgroundTransparency = 1
	end
end)

local NeverFailComputersBtn = Instance.new('TextButton')
NeverFailComputersBtn.AutoButtonColor = false
NeverFailComputersBtn.BackgroundColor3 = Color3.new(1, 1, 1)
NeverFailComputersBtn.BackgroundTransparency = 1
NeverFailComputersBtn.Font = Enum.Font.SourceSansLight
NeverFailComputersBtn.Name = 'NeverFailComputersBtn'
NeverFailComputersBtn.Position = UDim2.new(0, 0, 0, 60)
NeverFailComputersBtn.Size = UDim2.new(1, 0, 0, 20)
NeverFailComputersBtn.Text = 'No PC errors'
NeverFailComputersBtn.TextColor3 = Color3.new(1, 1, 1)
NeverFailComputersBtn.TextScaled = true
NeverFailComputersBtn.TextSize = 16
NeverFailComputersBtn.TextWrapped = true
NeverFailComputersBtn.Parent = MainButtonsFrame
NeverFailComputersBtn.Activated:Connect(function()
	Initialize()

	if not NeverFailComputersActive then
		if TempStats then
			local ActionEvent = TempStats.ActionEvent

			NeverFailComputersActive = true
			NeverFailComputersBtn.BackgroundTransparency = 0.888

			coroutine.wrap(function()
				while true do
					if not NeverFailComputersActive then break end
					if not _G[CheatName] then break end

					local Event = ActionEvent.Value

					if Event then
						local Parent = Event.Parent

						if Parent then
							if string.find(Parent.Name, 'ComputerTrigger') then
								if RemoteEvent then
									RemoteEvent:FireServer('SetPlayerMinigameResult', true)
									RemoteEvent:FireServer('SetPlayerMinigameResult', true)
								end
							end
						end
					end

					task.wait(DelaySendingRequest / 2)
				end
			end)()
		end
	else
		NeverFailComputersActive = false
		NeverFailComputersBtn.BackgroundTransparency = 1
	end
end)

local AlwaysHackComputerBtn = Instance.new('TextButton')
AlwaysHackComputerBtn.AutoButtonColor = false
AlwaysHackComputerBtn.BackgroundColor3 = Color3.new(1, 1, 1)
AlwaysHackComputerBtn.BackgroundTransparency = 1
AlwaysHackComputerBtn.Font = Enum.Font.SourceSansLight
AlwaysHackComputerBtn.Name = 'AlwaysHackComputerBtn'
AlwaysHackComputerBtn.Position = UDim2.new(0, 0, 0, 80)
AlwaysHackComputerBtn.Size = UDim2.new(1, 0, 0, 20)
AlwaysHackComputerBtn.Text = 'Always hack PC'
AlwaysHackComputerBtn.TextColor3 = Color3.new(1, 1, 1)
AlwaysHackComputerBtn.TextScaled = true
AlwaysHackComputerBtn.TextSize = 16
AlwaysHackComputerBtn.TextWrapped = true
AlwaysHackComputerBtn.Parent = MainButtonsFrame
AlwaysHackComputerBtn.Activated:Connect(function()
	Initialize()

	if not AlwaysHackPCMode then
		if TempStats then
			AlwaysHackPCMode = true
			AlwaysHackComputerBtn.BackgroundTransparency = 0.888

			local ActionEvent = TempStats.ActionEvent
			local IsBeast = TempStats.IsBeast

			coroutine.wrap(function()
				while true do
					if not AlwaysHackPCMode then break end
					if not _G[CheatName] then break end

					local Condition = false
					local Event = nil

					repeat
						if not _G[CheatName] then break end

						if IsBeast then
							if IsBeast.Value then
								Event = nil
								task.wait(DelaySendingRequest)

								continue
							end
						end

						if not Event then
							Event = ActionEvent.Value
						end

						if Event then
							local Parent = Event.Parent

							if Parent then
								local Computer = Parent.Parent

								if Computer then
									local Screen = Computer:FindFirstChild('Screen')

									if Screen then
										if Screen.BrickColor.Name == 'Dark green' then
											Event = nil
											task.wait(DelaySendingRequest)

											continue
										end
									end
								end

								if string.find(Parent.Name, 'ComputerTrigger') then
									Condition = true
								else
									Event = nil
									task.wait(DelaySendingRequest)

									continue
								end
							else
								Event = nil
								task.wait(DelaySendingRequest)

								continue
							end
						end

						task.wait(DelaySendingRequest)
					until Condition

					if Event then
						if RemoteEvent then
							RemoteEvent:FireServer('Input', 'Trigger', true, Event)
							RemoteEvent:FireServer('Input', 'Action', true)
						end
					end

					while true do
						if not AlwaysHackPCMode then break end
						if not _G[CheatName] then break end

						local NewEvent = ActionEvent.Value

						if NewEvent then
							Event = NewEvent
						end

						if Event then
							local Parent = Event.Parent

							if Parent then
								local Computer = Parent.Parent

								if Computer then
									local Screen = Computer:FindFirstChild('Screen')

									if Screen then
										if Screen.BrickColor.Name ~= 'Bright blue' then
											break
										end
									end
								end

								if string.find(Parent.Name, 'ComputerTrigger') then
									Condition = true
								else
									Condition = false
								end
							end

							if Condition then
								if RemoteEvent then
									RemoteEvent:FireServer('Input', 'Trigger', true, Event)
									RemoteEvent:FireServer('Input', 'Action', true)
								end
							end
						end

						task.wait(DelaySendingRequest)
					end

					task.wait(DelaySendingRequest)
				end
			end)()
		end
	else
		AlwaysHackPCMode = false
		AlwaysHackComputerBtn.BackgroundTransparency = 1
	end
end)

local SpeedHackBtn = Instance.new('TextButton')
SpeedHackBtn.AutoButtonColor = false
SpeedHackBtn.BackgroundColor3 = Color3.new(1, 1, 1)
SpeedHackBtn.BackgroundTransparency = 1
SpeedHackBtn.Font = Enum.Font.SourceSansLight
SpeedHackBtn.Name = 'SpeedHackBtn'
SpeedHackBtn.Position = UDim2.new(0, 0, 0, 100)
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
					local NewSpeed = Humanoid.WalkSpeed

					if NewSpeed ~= 60 then
						LastHumanoidWalkSpeed = NewSpeed
					end
				end

				Humanoid.WalkSpeed = 60
			end)

			LastHumanoidWalkSpeed = Humanoid.WalkSpeed
			Humanoid.WalkSpeed = 60

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

local InfiniteJumpHack = Instance.new('TextButton')
InfiniteJumpHack.AutoButtonColor = false
InfiniteJumpHack.BackgroundColor3 = Color3.new(1, 1, 1)
InfiniteJumpHack.BackgroundTransparency = 1
InfiniteJumpHack.Font = Enum.Font.SourceSansLight
InfiniteJumpHack.Name = 'InfiniteJumpHack'
InfiniteJumpHack.Position = UDim2.new(0, 0, 0, 120)
InfiniteJumpHack.Size = UDim2.new(1, 0, 0, 20)
InfiniteJumpHack.Text = 'Fly hack'
InfiniteJumpHack.TextColor3 = Color3.new(1, 1, 1)
InfiniteJumpHack.TextScaled = true
InfiniteJumpHack.TextSize = 16
InfiniteJumpHack.TextWrapped = true
InfiniteJumpHack.Parent = MainButtonsFrame
InfiniteJumpHack.Activated:Connect(function()
	Initialize()

	if not FlyCheatActive then
		if UserInputService then
			FlyCheatActive = true
			InfiniteJumpHack.BackgroundTransparency = 0.888

			local Connection = UserInputService.JumpRequest:Connect(function()
				if Humanoid then
					Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
				end
			end)

			Connections['UISJumpRequestExploit'] = Connection
		end
	else
		FlyCheatActive = false
		InfiniteJumpHack.BackgroundTransparency = 1

		local Connection = Connections['UISJumpRequestExploit']

		if Connection then
			Connection:Disconnect()
			Connections['UISJumpRequestExploit'] = nil
		end
	end
end)

local XRayPlayerPCsBtn = Instance.new('TextButton')
XRayPlayerPCsBtn.AutoButtonColor = false
XRayPlayerPCsBtn.BackgroundColor3 = Color3.new(1, 1, 1)
XRayPlayerPCsBtn.BackgroundTransparency = 1
XRayPlayerPCsBtn.Font = Enum.Font.SourceSansLight
XRayPlayerPCsBtn.Name = 'XRayPlayerPCsBtn'
XRayPlayerPCsBtn.Position = UDim2.new(0, 0, 0, 140)
XRayPlayerPCsBtn.Size = UDim2.new(1, 0, 0, 20)
XRayPlayerPCsBtn.Text = 'XRay Objects'
XRayPlayerPCsBtn.TextColor3 = Color3.new(1, 1, 1)
XRayPlayerPCsBtn.TextScaled = true
XRayPlayerPCsBtn.TextSize = 16
XRayPlayerPCsBtn.TextWrapped = true
XRayPlayerPCsBtn.Parent = MainButtonsFrame
XRayPlayerPCsBtn.Activated:Connect(function()
	Initialize()

	if not XRayEnabled then
		XRayEnabled = true
		XRayPlayerPCsBtn.BackgroundTransparency = 0.888

		local Connection = Workspace.DescendantAdded:Connect(function(Descendant)
			if XRayEnabled then
				local CorrectName = string.find(Descendant.Name, 'ComputerTable') and
					not string.find(Descendant.Name, 'Prefab')

				if CorrectName then
					task.wait()

					CreateHighlight(Descendant)
				end
			end
		end)

		Connections['WDescendantAddedExploit'] = Connection

		local Connection = Players.PlayerAdded:Connect(function(newPlayer)
			if XRayEnabled and newPlayer ~= LocalPlayer then
				task.wait()

				CreateHighlight(newPlayer)
			end
		end)

		Connections['WDescendantAddedExploit'] = Connection

		for _, v in pairs(Players:GetPlayers()) do
			if v ~= LocalPlayer then
				CreateHighlight(v)
			end
		end

		for _, v in pairs(Workspace:GetDescendants()) do
			if v then
				local CorrectName = string.find(v.Name, 'ComputerTable') and
					not string.find(v.Name, 'Prefab')

				if CorrectName then
					task.wait()

					CreateHighlight(v)
				end
			end
		end
	else
		XRayEnabled = false
		XRayPlayerPCsBtn.BackgroundTransparency = 1

		local Connection = Connections['WDescendantAddedExploit']

		if Connection then
			Connection:Disconnect()
			Connections['WDescendantAddedExploit'] = nil
		end

		for _, v in pairs(Players:GetPlayers()) do
			DeleteHighlight(v)
		end

		for _, v in pairs(Workspace:GetDescendants()) do
			if v then
				local CorrectName = string.find(v.Name, 'ComputerTable') and
					not string.find(v.Name, 'Prefab')

				if CorrectName then
					task.wait()

					DeleteHighlight(v)
				end
			end
		end
	end
end)

local FixGUIBtn = Instance.new('TextButton')
FixGUIBtn.BackgroundTransparency = 1
FixGUIBtn.Font = Enum.Font.SourceSansLight
FixGUIBtn.Name = 'FixGUIBtn'
FixGUIBtn.Position = UDim2.new(0, 0, 0, 160)
FixGUIBtn.Size = UDim2.new(1, 0, 0, 20)
FixGUIBtn.Text = 'Fix GUI'
FixGUIBtn.TextColor3 = Color3.new(1, 1, 1)
FixGUIBtn.TextScaled = true
FixGUIBtn.TextSize = 16
FixGUIBtn.TextWrapped = true
FixGUIBtn.Parent = MainButtonsFrame
FixGUIBtn.Activated:Connect(function()
	Initialize()

	if PlayerGui then
		local ScreenGui = PlayerGui:FindFirstChild('ScreenGui')

		if ScreenGui then
			local MenusTabFrame = ScreenGui:FindFirstChild('MenusTabFrame')

			if MenusTabFrame then
				MenusTabFrame.Visible = true
			end
		end
	end
end)

local SaveSurvivorsBtn = Instance.new('TextButton')
SaveSurvivorsBtn.BackgroundTransparency = 1
SaveSurvivorsBtn.Font = Enum.Font.SourceSansLight
SaveSurvivorsBtn.Name = 'SaveSurvivorsBtn'
SaveSurvivorsBtn.Position = UDim2.new(0, 0, 0, 180)
SaveSurvivorsBtn.Size = UDim2.new(1, 0, 0, 20)
SaveSurvivorsBtn.Text = 'Save Survivors'
SaveSurvivorsBtn.TextColor3 = Color3.new(1, 1, 1)
SaveSurvivorsBtn.TextScaled = true
SaveSurvivorsBtn.TextSize = 16
SaveSurvivorsBtn.TextWrapped = true
SaveSurvivorsBtn.Parent = MainButtonsFrame
SaveSurvivorsBtn.Activated:Connect(function()
	Initialize()

	local CurrentMap = ReplicatedStorage:FindFirstChild('CurrentMap')

	if CurrentMap and TempStats then
		local Map = CurrentMap.Value

		local ActionEvent = TempStats.ActionEvent
		local ActionInput = TempStats.ActionInput

		if Map and ActionEvent and ActionInput then
			local LastEvent = ActionEvent.Value
			local LastInput = ActionInput.Value
			
			for _, v in pairs(Map:GetChildren()) do
				if v.Name == 'FreezePod' then
					local PodTrigger = v:FindFirstChild('PodTrigger')

					if PodTrigger then
						local CapturedTorso = PodTrigger:FindFirstChild('CapturedTorso')
						local Event = PodTrigger:FindFirstChild('Event')

						if CapturedTorso and Event then
							if CapturedTorso.Value then
								if RemoteEvent then
									RemoteEvent:FireServer('Input', 'Trigger', true, Event)
									RemoteEvent:FireServer('Input', 'Action', true)
								end
							end
						end
					end
				end
			end
			
			task.wait(DelaySendingRequest)

			ActionEvent.Value = LastEvent
			LastInput.Value = LastEvent
			
			RemoteEvent:FireServer('Input', 'Trigger', true, LastEvent)
		end
	end
end)

local AutoKillBtn = Instance.new('TextButton')
AutoKillBtn.AutoButtonColor = false
AutoKillBtn.BackgroundColor3 = Color3.new(1, 1, 1)
AutoKillBtn.BackgroundTransparency = 1
AutoKillBtn.Font = Enum.Font.SourceSansLight
AutoKillBtn.Name = 'AutoKillBtn'
AutoKillBtn.Position = UDim2.new(0, 0, 0, 200)
AutoKillBtn.Size = UDim2.new(1, 0, 0, 20)
AutoKillBtn.Text = 'Auto kill'
AutoKillBtn.TextColor3 = Color3.new(1, 1, 1)
AutoKillBtn.TextScaled = true
AutoKillBtn.TextSize = 16
AutoKillBtn.TextWrapped = true
AutoKillBtn.Parent = MainButtonsFrame
AutoKillBtn.Activated:Connect(function()
	Initialize()

	if not AutoKillSurvivors then
		AutoKillSurvivors = true
		AutoKillBtn.BackgroundTransparency = 0.888

		coroutine.wrap(function()
			local Survivors = {}
			local Pods = {}

			local CurrentMap = nil
			local Hammer = nil
			local HammerEvent = nil

			while true do
				if not _G[CheatName] then break end
				if not AutoKillSurvivors then break end

				Initialize()

				if TempStats then
					local IsBeast = TempStats.IsBeast

					if IsBeast.Value then
						if #Pods > 0 then
							table.clear(Pods)
						end

						if #Survivors > 0 then
							table.clear(Survivors)
						end

						if Hammer then
							Hammer = nil
						end

						if HammerEvent then
							HammerEvent = nil
						end

						local ReplicatedStorageMap = ReplicatedStorage:FindFirstChild('CurrentMap')

						if ReplicatedStorageMap then
							CurrentMap = ReplicatedStorageMap
						end

						for _, v in pairs(Players:GetPlayers()) do
							if v and v ~= LocalPlayer then
								local TempStats = v:FindFirstChild('TempPlayerStatsModule')

								if TempStats then
									local Captured = TempStats.Captured
									local Health = TempStats.Health
									local IsBeast = TempStats.IsBeast

									local AliveSurvivor = Health.Value > 0 and
										not IsBeast.Value and
										not Captured.Value

									if AliveSurvivor then
										table.insert(Survivors, v)
									end
								end
							end
						end

						if CurrentMap then
							local Map = CurrentMap.Value

							if Map then
								for _, v in pairs(Map:GetChildren()) do
									if v.Name == 'FreezePod' then
										local PodTrigger = v:FindFirstChild('PodTrigger')

										if PodTrigger then
											local CapturedTorso =
												PodTrigger:FindFirstChild('CapturedTorso')

											if CapturedTorso then
												if not CapturedTorso.Value then
													table.insert(Pods, v)
												end
											end
										end
									end
								end
							end
						end

						local NewHammer = Character:FindFirstChild('Hammer')

						if NewHammer then
							Hammer = NewHammer
						end

						if Hammer then
							local NewHammerEvent = Hammer:FindFirstChild('HammerEvent')

							if NewHammerEvent then
								HammerEvent = NewHammerEvent
							end
						end

						for i, v in pairs(Survivors) do
							if v then
								local Torso = GetTorso(v.Character)

								if LocalTorso and Torso then
									if (LocalTorso.Position - Torso.Position).Magnitude <= 10 then
										if HammerEvent then
											HammerEvent:FireServer('HammerClick', true)

											task.wait(DelaySendingRequest / 2)

											HammerEvent:FireServer('HammerHit', Torso)

											task.wait(DelaySendingRequest / 2)

											HammerEvent:FireServer('HammerTieUp', Torso, Torso.Position)
										end

										table.sort(Pods, function(Pod1, Pod2)
											local PodTrigger1 = Pod1:FindFirstChild('PodTrigger')
											local PodTrigger2 = Pod2:FindFirstChild('PodTrigger')

											local DistanceA = (LocalTorso.Position - PodTrigger1.Position).Magnitude
											local DistanceB = (LocalTorso.Position - PodTrigger2.Position).Magnitude

											return DistanceA < DistanceB
										end)

										local ClosestPod = Pods[1]

										if ClosestPod then
											local PodTrigger = ClosestPod:FindFirstChild('PodTrigger')

											if PodTrigger then
												local Event = PodTrigger:FindFirstChild('Event')

												if Event and RemoteEvent then
													task.wait(DelaySendingRequest / 2)

													RemoteEvent:FireServer('Input', 'Trigger', true, Event)
													RemoteEvent:FireServer('Input', 'Action', true)
												end
											end
										end
									end
								end
							end
						end

						task.wait(0.025)
					else
						task.wait(1)
					end
				else
					task.wait(0.5)

					Initialize()
				end
			end

			table.clear(Pods)
			table.clear(Survivors)
		end)()
	else
		AutoKillSurvivors = false
		AutoKillBtn.BackgroundTransparency = 1
	end
end)

local BodyVelocityCheat = Instance.new('BodyVelocity')
BodyVelocityCheat.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
BodyVelocityCheat.Name = 'BodyVelocityCheat'

local MoveInRagdollModeBtn = Instance.new('TextButton')
MoveInRagdollModeBtn.AutoButtonColor = false
MoveInRagdollModeBtn.BackgroundColor3 = Color3.new(1, 1, 1)
MoveInRagdollModeBtn.BackgroundTransparency = 1
MoveInRagdollModeBtn.Font = Enum.Font.SourceSansLight
MoveInRagdollModeBtn.Name = 'MoveInRagdollModeBtn'
MoveInRagdollModeBtn.Position = UDim2.new(0, 0, 0, 220)
MoveInRagdollModeBtn.Size = UDim2.new(1, 0, 0, 20)
MoveInRagdollModeBtn.Text = 'Move while ragdoll'
MoveInRagdollModeBtn.TextColor3 = Color3.new(1, 1, 1)
MoveInRagdollModeBtn.TextScaled = true
MoveInRagdollModeBtn.TextSize = 16
MoveInRagdollModeBtn.TextWrapped = true
MoveInRagdollModeBtn.Parent = MainButtonsFrame
MoveInRagdollModeBtn.Activated:Connect(function()
	Initialize()

	if not BodyVelocityCheat then
		BodyVelocityCheat = Instance.new('BodyVelocity')
		BodyVelocityCheat.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		BodyVelocityCheat.Name = 'BodyVelocityCheat'
	else
		if not BodyVelocityCheat.Parent then
			local Success, _ = pcall(function()
				BodyVelocityCheat:Destroy()
				BodyVelocityCheat = nil
			end)

			BodyVelocityCheat = Instance.new('BodyVelocity')
			BodyVelocityCheat.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
			BodyVelocityCheat.Name = 'BodyVelocityCheat'
		end
	end

	if not MoveInRagdoll then
		if Humanoid and BodyVelocityCheat then
			MoveInRagdoll = true
			MoveInRagdollModeBtn.BackgroundTransparency = 0.888

			local Connection1 = Humanoid.Changed:Connect(function(Property)
				if Humanoid and BodyVelocityCheat then
					local Speed = Humanoid.WalkSpeed

					local X = Humanoid.MoveDirection.X * Speed
					local Y = BodyVelocityCheat.Velocity.Y
					local Z = Humanoid.MoveDirection.Z * Speed

					BodyVelocityCheat.Velocity = Vector3.new(X, Y, Z)
				end
			end)

			Connections['HumanoidChanged2Exploit'] = Connection1

			local Connection2 = Humanoid.StateChanged:Connect(function(_ ,New)
				if New == Enum.HumanoidStateType.Landed or
					New == Enum.HumanoidStateType.Climbing or
					New == Enum.HumanoidStateType.PlatformStanding or
					New == Enum.HumanoidStateType.Swimming or
					New == Enum.HumanoidStateType.Seated then

					if not BodyVelocityCheat then
						Initialize()
					end

					if BodyVelocityCheat then
						local LastVelocity = BodyVelocityCheat.Velocity

						BodyVelocityCheat.Velocity = Vector3.new(LastVelocity.X, 0, LastVelocity.Z)
					end
				end
			end)

			Connections['HumanoidStateChangedExploit'] = Connection2

			local Connection3 = UserInputService.InputBegan:Connect(function(Input)
				if Input.KeyCode == Enum.KeyCode.Space then
					if not BodyVelocityCheat then
						Initialize()
					end

					if BodyVelocityCheat then
						local HeightUnit = 6.944444444444444
						local LastVelocity = BodyVelocityCheat.Velocity

						local JumpHeight = FlyCheatActive and
							Humanoid.JumpHeight * HeightUnit or
							Humanoid.JumpHeight

						local Y = Humanoid.UseJumpPower and
							Humanoid.JumpPower or
							JumpHeight

						BodyVelocityCheat.Velocity = Vector3.new(LastVelocity.X, Y, LastVelocity.Z)
					end
				end
			end)

			Connections['UISInputBeganExploit'] = Connection3

			local Connection4 = UserInputService.InputEnded:Connect(function(Input)
				if Input.KeyCode == Enum.KeyCode.Space then
					if not BodyVelocityCheat then
						Initialize()
					end

					if BodyVelocityCheat then
						local HeightUnit = 6.944444444444444
						local LastVelocity = BodyVelocityCheat.Velocity

						local JumpHeight = FlyCheatActive and
							Humanoid.JumpHeight * HeightUnit or
							Humanoid.JumpHeight

						local Y = Humanoid.UseJumpPower and
							Humanoid.JumpPower or
							JumpHeight

						BodyVelocityCheat.Velocity = Vector3.new(LastVelocity.X, -Y, LastVelocity.Z)
					end
				end
			end)

			Connections['UISInputEndedExploit'] = Connection4

			coroutine.wrap(function()
				while true do
					if not _G[CheatName] then break end
					if not MoveInRagdoll then break end

					if not TempStats or not LocalTorso then
						Initialize()
					end

					if TempStats then
						local Ragdoll = TempStats.Ragdoll

						if Ragdoll then
							BodyVelocityCheat.Parent = (Ragdoll.Value) and LocalTorso or nil
						end
					end

					task.wait(0.05)
				end

				BodyVelocityCheat.Parent = nil
			end)()
		end
	else
		MoveInRagdoll = false
		MoveInRagdollModeBtn.BackgroundTransparency = 1

		local Connection1 = Connections['HumanoidChanged2Exploit']

		if Connection1 then
			Connection1:Disconnect()
			Connections['HumanoidChanged2Exploit'] = nil
		end

		local Connection2 = Connections['HumanoidStateChangedExploit']

		if Connection2 then
			Connection2:Disconnect()
			Connections['HumanoidStateChangedExploit'] = nil
		end

		local Connection3 = Connections['UISInputBeganExploit']

		if Connection3 then
			Connection3:Disconnect()
			Connections['UISInputBeganExploit'] = nil
		end

		local Connection4 = Connections['UISInputEndedExploit']

		if Connection4 then
			Connection4:Disconnect()
			Connections['UISInputEndedExploit'] = nil
		end

		if BodyVelocityCheat.Parent then
			BodyVelocityCheat.Parent = nil
		end
	end
end)

local DontDisableCrawlBtn = Instance.new('TextButton')
DontDisableCrawlBtn.AutoButtonColor = false
DontDisableCrawlBtn.BackgroundColor3 = Color3.new(1, 1, 1)
DontDisableCrawlBtn.BackgroundTransparency = 1
DontDisableCrawlBtn.Font = Enum.Font.SourceSansLight
DontDisableCrawlBtn.Name = 'DontDisableCrawlBtn'
DontDisableCrawlBtn.Position = UDim2.new(0, 0, 0, 240)
DontDisableCrawlBtn.Size = UDim2.new(1, 0, 0, 20)
DontDisableCrawlBtn.Text = 'Don\'t disable crawl'
DontDisableCrawlBtn.TextColor3 = Color3.new(1, 1, 1)
DontDisableCrawlBtn.TextScaled = true
DontDisableCrawlBtn.TextSize = 16
DontDisableCrawlBtn.TextWrapped = true
DontDisableCrawlBtn.Parent = MainButtonsFrame
DontDisableCrawlBtn.Activated:Connect(function()
	Initialize()

	if not DontDisableCrawl then
		local TempStats = LocalPlayer:FindFirstChild('TempPlayerStatsModule')

		if TempStats then
			local DisableCrawl = TempStats:FindFirstChild('DisableCrawl')

			if DisableCrawl then
				DontDisableCrawl = true
				DontDisableCrawlBtn.BackgroundTransparency = 0.888

				local Connection = DisableCrawl.Changed:Connect(function(Value)
					if Value then
						DisableCrawl.Value = false
					end

					LastDisableCrawlValue = Value
				end)

				Connections['ChangedDCrawlExploit'] = Connection
				DisableCrawl.Value = false
			end
		end
	else
		DontDisableCrawl = false
		DontDisableCrawlBtn.BackgroundTransparency = 1

		local Connection = Connections['ChangedDCrawlExploit']

		if Connection then
			Connection:Disconnect()
			Connections['ChangedDCrawlExploit'] = nil
		end

		local TempStats = LocalPlayer:FindFirstChild('TempPlayerStatsModule')

		if TempStats then
			local DisableCrawl = TempStats:FindFirstChild('DisableCrawl')

			if DisableCrawl then
				DisableCrawl.Value = LastDisableCrawlValue
			end
		end
	end
end)

local CreditsFrame = Instance.new('Frame')
CreditsFrame.BackgroundColor3 = Color3.new(0.196078, 0.196078, 0.196078)
CreditsFrame.BorderSizePixel = 0
CreditsFrame.Name = 'CreditsFrame'
CreditsFrame.Position = UDim2.new(0, StartOffset, 0, 40)
CreditsFrame.Size = UDim2.new(0, 150, 0, 27)
CreditsFrame.Parent = FTF_GUI

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

function OnCharacterAdded(newCharacter)
	Character = newCharacter or LocalPlayer.Character
end

-- Connections

LocalPlayer.CharacterAdded:Connect(OnCharacterAdded)

-- Execute event

repeat
	task.wait(0.25)
until not _G[CheatName]

if FTF_GUI then
	FTF_GUI:Destroy()
	FTF_GUI = nil
end

for _, v in pairs(Connections) do
	if v then
		v:Disconnect()
		v = nil
	end
end

table.clear(Connections)

return true
