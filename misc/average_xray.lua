-- XRay players in any Roblox game
-- by @Vov4ik4124

local _4 = Color3.new(0, .4984, 0)

-- Game compatibility check

local _ENV = (getgenv and getgenv()) or _ENV or shared or _G

if _ENV.XPS4 then
	_ENV.XPS4 = nil

	return
else
	_ENV.XPS4 = true
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
local WhiteColor = Color3.new(1, 1, 1)
local CurrentCamera = workspace.CurrentCamera

-- Tables

local Connections = {}
local Targets = {}

-- Functions

local function CreateLabel()
	local TextLabel = Instance.new('TextLabel')
	TextLabel.AnchorPoint = HalfVector2
	TextLabel.BackgroundTransparency = 1
	TextLabel.Size = UDim2.new()
	TextLabel.Text = '4'
	TextLabel.TextColor3 = WhiteColor
	TextLabel.TextScaled = true
	TextLabel.TextStrokeColor3 = _4
	TextLabel.TextStrokeTransparency = 0
	TextLabel.TextTransparency = 0
	TextLabel.Visible = false
	TextLabel.ZIndex = 2147483647

	local UIStroke = Instance.new('UIStroke')
	UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	UIStroke.Color = _4
	UIStroke.Enabled = true
	UIStroke.LineJoinMode = Enum.LineJoinMode.Round
	UIStroke.Thickness = 4
	UIStroke.Transparency = 0
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
	for Player, Label in next, Targets do
		if not (Label and Label.Parent) then
			continue
		end

		local Character = Player.Character

		if not (Character and Character.Parent == workspace) then
			continue
		end

		local Position3D = Character:GetPivot().Position + Vector3.new(0, 2.44, 0)
		local Distance = (Position3D - CurrentCamera.CFrame.Position).Magnitude
		local Position2D = CurrentCamera:WorldToViewportPoint(Position3D)
		local Visible = Position2D.Z > 0
		local PlayerDisplayName = Player.DisplayName
		local PlayerName = Player.Name
		Label.Text = PlayerDisplayName == PlayerName and PlayerName or (PlayerDisplayName .. ' (@' .. PlayerName .. ')')
		Label.Visible = Visible

		if Visible then
			Label.Position = UDim2.new(0, Position2D.X, 0, Position2D.Y)
			Label.Size = UDim2.new(0, LabelSizeX, 0, LabelSizeY)
		end
	end
end

-- Connections

Connections[#Connections + 1] = Players.PlayerAdded:Connect(OnPlayerAdded)
Connections[#Connections + 1] = Players.PlayerRemoving:Connect(OnPlayerRemoving)
Connections[#Connections + 1] = RunService.RenderStepped:Connect(OnRenderStepped)

-- Code

pcall(SetTo, ScreenGui, 'OnTopOfCoreBlur', true)

ScreenGui.AutoLocalize = false
ScreenGui.ClipToDeviceSafeArea = false
ScreenGui.DisplayOrder = 2147483647
ScreenGui.IgnoreGuiInset = true
ScreenGui.Name = 'XPS4'
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.Parent = ParentGui

local PlayerList = Players:GetPlayers()

for Index = 1, #PlayerList do
	OnPlayerAdded(PlayerList[Index])
end

local Properties = {Text = 'Player XRay has been activated.', Title = 'Roblox', Button1 = 'OK'}
StarterGui:SetCore('SendNotification', Properties)

while _ENV.XPS4 do
	RunService.RenderStepped:Wait()
end

for Index = 1, #Connections do
	Connections[Index]:Disconnect()
end

for _, Label in next, Targets do
	Label:Destroy()
end

table.clear(Connections)
table.clear(Targets)

Properties.Text = 'Player XRay has been deactivated.'
StarterGui:SetCore('SendNotification', Properties)
