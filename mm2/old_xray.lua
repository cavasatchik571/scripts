-- XRay players in Murder Mystery 2 game
-- by Vov4ik4124

_4=Color3:new(.4984)

-- Game compatibility check

local _ENV = (getgenv and getgenv()) or _ENV or shared or _G

if _ENV.CheatActiveXRay_MM2 or game.PlaceId ~= 142823291 then
	_ENV.CheatActiveXRay_MM2 = nil

	return
else
	_ENV.CheatActiveXRay_MM2 = true
end

-- Services

local CoreGui = game:GetService('CoreGui')
local Players = game:GetService('Players')
local RunService = game:GetService('RunService')
local StarterGui = game:GetService('StarterGui')

-- Variables

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild('PlayerGui')
local ParentGui = pcall(tostring, CoreGui) and CoreGui or PlayerGui
local ScreenGui = Instance.new('ScreenGui')
local HalfVector2 = Vector2.new(0.5, 0.5)
local LabelSizeX = 200
local LabelSizeY = 24
local BlackColor = Color3.new(0, 0, 0)
local WhiteColor = Color3.new(1, 1, 1)
local CurrentCamera = workspace.CurrentCamera
local Tick = 0

local Remotes = game:GetService('ReplicatedStorage'):WaitForChild('Remotes')
local Extras = Remotes:WaitForChild('Extras')
local GetPlayerData = Extras:WaitForChild('GetPlayerData')

-- Tables

local Connections = {}
local Data = {}
local FakeData = {Role = ''}
local Targets = {}

-- Functions

local function CreateLabel()
	local TextLabel = Instance.new('TextLabel')
	TextLabel.AnchorPoint = HalfVector2
	TextLabel.BackgroundTransparency = 1
	TextLabel.Text = '4'
	TextLabel.TextStrokeTransparency = 0
	TextLabel.TextScaled = true
	TextLabel.Visible = false
	TextLabel.ZIndex = 2147483647

	local UIStroke = Instance.new('UIStroke')
	UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	UIStroke.Color = WhiteColor
	UIStroke.LineJoinMode = Enum.LineJoinMode.Miter
	UIStroke.Thickness = 4
	UIStroke.Parent = TextLabel

	TextLabel.Parent = ScreenGui

	return TextLabel
end

local function SetTo(self, property, value)
	self[property] = value
end

-- Event functions

local function OnPlayerAdded(Player)
	if not (Player and Player ~= LocalPlayer and Player:IsA('Player')) then
		return
	end

	if not Targets[Player] then
		Targets[Player] = CreateLabel()
	end
end

local function OnPlayerRemoving(Player)
	if not (Player and Player:IsA('Player')) then
		return
	end

	local Label = Targets[Player]

	if Label then
		Label:Destroy()
		Targets[Player] = nil
	end
end

local function OnRenderStepped()
	local NewTick = tick()

	if NewTick - Tick < 1.4 then
		return
	end

	Tick = math.huge

	local NewData = GetPlayerData:InvokeServer()

	if not _ENV.CheatActiveXRay_MM2 then
		return
	end

	Tick = NewTick
	Data = NewData
end

-- Connections

Connections[1] = Players.PlayerAdded:Connect(OnPlayerAdded)
Connections[2] = Players.PlayerRemoving:Connect(OnPlayerRemoving)
Connections[3] = RunService.RenderStepped:Connect(OnRenderStepped)

-- Code

pcall(SetTo, ScreenGui, 'OnTopOfCoreBlur', true)
pcall(SetTo, ScreenGui, 'SafeAreaCompatibility', Enum.SafeAreaCompatibility.FullscreenExtension)
pcall(SetTo, ScreenGui, 'ScreenInsets', Enum.ScreenInsets.None)

ScreenGui.ClipToDeviceSafeArea = false
ScreenGui.DisplayOrder = 2147483647
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.Parent = ParentGui

local PlayerList = Players:GetPlayers()

for Index = 1, #PlayerList do
	OnPlayerAdded(PlayerList[Index])
end

local Properties = {Text = 'Player XRay has been activated.', Title = 'Murder Mystery 2', Button1 = 'OK'}
StarterGui:SetCore('SendNotification', Properties)

while _ENV.CheatActiveXRay_MM2 do
	for Player, Label in next, Targets do
		Label.Visible = false

		if not (Label and Label.Parent) then
			continue
		end

		local Character = Player.Character

		if not (Character and Character:IsDescendantOf(workspace)) then
			continue
		end

		local Position3D = Character:GetPivot().Position + Vector3.new(0, 2.44, 0)
		local Position2D = CurrentCamera:WorldToViewportPoint(Position3D)
		local Visible = Position2D.Z > 0 and (Position3D - CurrentCamera.CFrame.Position).Magnitude <= 444
		local PlayerDisplayName, PlayerName = Player.DisplayName, Player.Name
		local UIStroke = Label:FindFirstChildOfClass('UIStroke')
		local PlayerData = Data[PlayerName] or FakeData

		if Visible then
			Label.Position = UDim2.new(0, Position2D.X, 0, Position2D.Y)
			Label.Size = UDim2.new(0, LabelSizeX, 0, LabelSizeY)
			Label.Text = PlayerDisplayName == PlayerName and PlayerName or PlayerDisplayName .. ' (@' .. PlayerName .. ')'
			Label.Visible = true

			if Player:FindFirstChild('Knife', true) or Character:FindFirstChild('Knife') or PlayerData.Role == 'Murderer' then
				Label.TextColor3 = _4
				Label.TextStrokeColor3 = BlackColor
				UIStroke.Color = _4
			elseif Player:FindFirstChild('Gun', true) or Character:FindFirstChild('Gun')
				or PlayerData.Role == 'Sheriff' or PlayerData.Role == 'Hero' then

				Label.TextColor3 = WhiteColor
				Label.TextStrokeColor3 = BlackColor
				UIStroke.Color = BlackColor
			else
				Label.TextColor3 = WhiteColor
				Label.TextStrokeColor3 = BlackColor
				UIStroke.Color = WhiteColor
			end
		end
	end

	RunService.RenderStepped:Wait()
end

for Index = 1, #Connections do
	Connections[Index]:Disconnect()
end

for _, Label in next, Targets do
	Label:Destroy()
end

Properties.Text = 'Player XRay has been deactivated.'
StarterGui:SetCore('SendNotification', Properties)

table.clear(Connections)
table.clear(Data)
table.clear(FakeData)
table.clear(Properties)
table.clear(Targets)
