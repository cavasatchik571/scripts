local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Debris = game:GetService("Debris")
local LocalPlayer = Players.LocalPlayer

local V1 = Instance.new("ScreenGui")
V1.IgnoreGuiInset = true
V1.ResetOnSpawn = false
V1.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
V1.Parent = pcall(tostring, CoreGui) and CoreGui or LocalPlayer:WaitForChild("PlayerGui")

local V2 = Instance.new("Frame")
V2.AnchorPoint = Vector2.new(0.5, 0.5)
V2.BackgroundColor3 = Color3.fromRGB(49, 49, 49)
V2.BackgroundTransparency = 1
V2.BorderSizePixel = 0
V2.Name = "Window"
V2.Position = UDim2.new(0.5, 0, 0.5, 0)
V2.Size = UDim2.new(0.497896373272, 0, 0.617041885853, 0)
V2.ZIndex = 20
V2.Parent = V1

local V3 = Instance.new("Frame")
V3.AnchorPoint = Vector2.new(0.5, 1)
V3.BackgroundColor3 = Color3.fromRGB(49, 49, 49)
V3.BorderSizePixel = 0
V3.Name = "Body"
V3.Position = UDim2.new(0.5, 0, 1, 0)
V3.Size = UDim2.new(1, 0, 0.899999976158, 0)
V3.ZIndex = 21
V3.Parent = V2

local V4 = Instance.new("UICorner")
V4.CornerRadius = UDim.new(0, 10)
V4.Parent = V3

local V5 = Instance.new("Frame")
V5.AnchorPoint = Vector2.new(1, 0)
V5.BackgroundColor3 = Color3.fromRGB(49, 49, 49)
V5.BorderColor3 = Color3.fromRGB(49, 49, 49)
V5.BorderSizePixel = 0
V5.Position = UDim2.new(1, 0, 0, 0)
V5.Size = UDim2.new(0, 10, 0, 10)
V5.ZIndex = 21
V5.Parent = V3

local V6 = Instance.new("Frame")
V6.BackgroundColor3 = Color3.fromRGB(49, 49, 49)
V6.BorderColor3 = Color3.fromRGB(49, 49, 49)
V6.BorderSizePixel = 0
V6.Size = UDim2.new(0, 10, 0, 10)
V6.ZIndex = 21
V6.Parent = V3

local V7 = Instance.new("Frame")
V7.AnchorPoint = Vector2.new(0.5, 1)
V7.BackgroundColor3 = Color3.fromRGB(57, 57, 57)
V7.BorderColor3 = Color3.fromRGB(57, 57, 57)
V7.BorderSizePixel = 0
V7.Name = "Content"
V7.Position = UDim2.new(0.5, 0, 0.949999988079, 0)
V7.Size = UDim2.new(0.949999988079, 0, 0.824999988079, 0)
V7.ZIndex = 22
V7.Parent = V3

local V8 = Instance.new("UICorner")
V8.CornerRadius = UDim.new(0, 10)
V8.Parent = V7

local V9 = Instance.new("Frame")
V9.BackgroundColor3 = Color3.fromRGB(57, 57, 57)
V9.BorderColor3 = Color3.fromRGB(57, 57, 57)
V9.BorderSizePixel = 0
V9.Size = UDim2.new(0, 10, 0, 10)
V9.ZIndex = 22
V9.Parent = V7

local V10 = Instance.new("Frame")
V10.AnchorPoint = Vector2.new(1, 0)
V10.BackgroundColor3 = Color3.fromRGB(57, 57, 57)
V10.BorderColor3 = Color3.fromRGB(57, 57, 57)
V10.BorderSizePixel = 0
V10.Position = UDim2.new(1, 0, 0, 0)
V10.Size = UDim2.new(0, 10, 0, 10)
V10.ZIndex = 22
V10.Parent = V7

local V11 = Instance.new("Frame")
V11.AnchorPoint = Vector2.new(0.5, 1)
V11.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
V11.BackgroundTransparency = 1
V11.BorderColor3 = Color3.fromRGB(0, 0, 0)
V11.BorderSizePixel = 0
V11.Name = "Tabs"
V11.Position = UDim2.new(0.5, 0, 0, 0)
V11.Size = UDim2.new(1, 0, 0.10000000149, 0)
V11.ZIndex = 22
V11.Parent = V7

local V12 = Instance.new("TextButton")
V12.BackgroundColor3 = Color3.fromRGB(57, 57, 57)
V12.BorderColor3 = Color3.fromRGB(57, 57, 57)
V12.BorderSizePixel = 0
V12.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
V12.Name = "_PrefabTab"
V12.Size = UDim2.new(0.20000000298, 0, 1, 0)
V12.Text = "Prefab"
V12.TextColor3 = Color3.fromRGB(255, 255, 255)
V12.TextScaled = true
V12.TextSize = 14
V12.TextStrokeTransparency = 0
V12.Visible = false
V12.ZIndex = 23
V12.Parent = V11

local V13 = Instance.new("UIListLayout")
V13.FillDirection = Enum.FillDirection.Horizontal
V13.SortOrder = Enum.SortOrder.LayoutOrder
V13.VerticalAlignment = Enum.VerticalAlignment.Bottom
V13.Parent = V11

local V14 = Instance.new("Frame")
V14.AnchorPoint = Vector2.new(0.5, 0.5)
V14.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
V14.BackgroundTransparency = 1
V14.BorderColor3 = Color3.fromRGB(0, 0, 0)
V14.BorderSizePixel = 0
V14.Name = "InnerContent"
V14.Position = UDim2.new(0.5, 0, 0.5, 0)
V14.Size = UDim2.new(1, 0, 1, 0)
V14.ZIndex = 23
V14.Parent = V7

local V15 = Instance.new("TextLabel")
V15.AnchorPoint = Vector2.new(0.5, 0.5)
V15.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
V15.BackgroundTransparency = 1
V15.BorderColor3 = Color3.fromRGB(0, 0, 0)
V15.BorderSizePixel = 0
V15.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
V15.Position = UDim2.new(0.5, 0, 0.5, 0)
V15.Size = UDim2.new(1, 0, 1, 0)
V15.Text = "Please select a tab"
V15.TextColor3 = Color3.fromRGB(255, 255, 255)
V15.TextSize = 52
V15.TextStrokeTransparency = 0
V15.ZIndex = 23
V15.Parent = V14

local V16 = Instance.new("ScrollingFrame")
V16.Active = true
V16.AnchorPoint = Vector2.new(0.5, 0.5)
V16.AutomaticCanvasSize = Enum.AutomaticSize.Y
V16.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
V16.BackgroundTransparency = 1
V16.BorderColor3 = Color3.fromRGB(0, 0, 0)
V16.BorderSizePixel = 2
V16.CanvasSize = UDim2.new(0, 0, 0, 0)
V16.ElasticBehavior = Enum.ElasticBehavior.Never
V16.Name = "GroupContent"
V16.Position = UDim2.new(0.5, 0, 0.5, 0)
V16.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
V16.Size = UDim2.new(1, 0, 1, 0)
V16.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
V16.Visible = true
V16.ZIndex = 24
V16.Parent = V14

local V17 = Instance.new("TextButton")
V17.BackgroundColor3 = Color3.fromRGB(57, 57, 57)
V17.BorderColor3 = Color3.fromRGB(57, 57, 57)
V17.BorderSizePixel = 0
V17.FontFace = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
V17.Name = "_PrefabItem"
V17.Size = UDim2.new(1, 0, 0, 40)
V17.TextColor3 = Color3.fromRGB(255, 255, 255)
V17.TextSize = 37
V17.TextStrokeTransparency = 0
V17.TextWrap = true
V17.TextWrapped = true
V17.Visible = false
V17.ZIndex = 25
V17.Parent = V16

local V18 = Instance.new("Frame")
V18.AnchorPoint = Vector2.new(0.5, 1)
V18.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
V18.BorderColor3 = Color3.fromRGB(255, 255, 255)
V18.BorderSizePixel = 0
V18.Position = UDim2.new(0.5, 0, 1, 0)
V18.Size = UDim2.new(1, 0, 0, 2)
V18.ZIndex = 25
V18.Parent = V17

local V19 = Instance.new("UIListLayout")
V19.HorizontalAlignment = Enum.HorizontalAlignment.Center
V19.SortOrder = Enum.SortOrder.LayoutOrder
V19.Parent = V16

local V20 = Instance.new("Frame")
V20.Active = true
V20.AnchorPoint = Vector2.new(0.5, 0)
V20.BackgroundColor3 = Color3.fromRGB(62, 62, 62)
V20.BorderColor3 = Color3.fromRGB(62, 62, 62)
V20.BorderSizePixel = 0
V20.Name = "Topbar"
V20.Position = UDim2.new(0.5, 0, 0, 0)
V20.Selectable = true
V20.Size = UDim2.new(1, 0, 0.10000000149, 0)
V20.ZIndex = 21
V20.Parent = V2

local V21 = Instance.new("UICorner")
V21.CornerRadius = UDim.new(0, 10)
V21.Parent = V20

local V22 = Instance.new("Frame")
V22.AnchorPoint = Vector2.new(1, 1)
V22.BackgroundColor3 = Color3.fromRGB(62, 62, 62)
V22.BorderColor3 = Color3.fromRGB(62, 62, 62)
V22.BorderSizePixel = 0
V22.Position = UDim2.new(1, 0, 1, 0)
V22.Size = UDim2.new(0, 10, 0, 10)
V22.ZIndex = 21
V22.Parent = V20

local V23 = Instance.new("Frame")
V23.AnchorPoint = Vector2.new(0, 1)
V23.BackgroundColor3 = Color3.fromRGB(62, 62, 62)
V23.BorderColor3 = Color3.fromRGB(62, 62, 62)
V23.BorderSizePixel = 0
V23.Position = UDim2.new(0, 0, 1, 0)
V23.Size = UDim2.new(0, 10, 0, 10)
V23.ZIndex = 21
V23.Parent = V20

local V24 = Instance.new("TextLabel")
V24.AnchorPoint = Vector2.new(0.5, 1)
V24.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
V24.BackgroundTransparency = 1
V24.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
V24.Position = UDim2.new(0.5, 0, 1, 0)
V24.Size = UDim2.new(1, 0, 1, 0)
V24.Text = "\"Rooms\" mod menu"
V24.TextColor3 = Color3.fromRGB(255, 255, 255)
V24.TextScaled = true
V24.TextSize = 14
V24.TextStrokeTransparency = 0
V24.ZIndex = 21
V24.Parent = V20

local function AttachGradient(Object, Idx)
	if not Object then
		return
	end

	local H0, H1 = Idx % 1, (Idx + 0.1) % 1
	local V1 = Instance.new("UIGradient")
	V1.Color = ColorSequence.new(Color3.fromHSV(H0, 0.75, 1), Color3.fromHSV(H1, 0.75, 1))
	V1.Parent = Object

	local function Init(Object)
		while true do
			if not (Object and Object.Parent) then
				return
			end

			local dt = RunService.Heartbeat:Wait()

			if not (Object and Object.Parent) then
				return
			end

			dt /= 4
			H0 += dt
			H0 %= 1
			H1 += dt
			H1 %= 1
			V1.Color = ColorSequence.new(Color3.fromHSV(H0, 0.75, 1), Color3.fromHSV(H1, 0.75, 1))
		end
	end

	local Thread = coroutine.create(Init)
	coroutine.resume(Thread, Object)

	return Thread
end

local function findrr()
	local children = workspace:GetChildren()
	local recent = {}
	for i, v in next, children do
		recent[#children - i + 1] = v
	end
	table.clear(children)
	for _, v in next, recent do
		if (v:IsA("Model") and not Players:GetPlayerFromCharacter(v) and Lighting:FindFirstChild(v.Name, true)) or
			(v.Name:upper():find("START") == 1 and v:IsA("Folder")) then

			--[[for _, v2 in next, v:GetDescendants() do
				if v2:IsA("ClickDetector") and v2.Parent.Name == "door" then
					return v2
				end
			end]]

			table.clear(recent)
			return v
		end
	end
end

local function findcd()
	for _, v in next, findrr():GetDescendants() do
		if v:IsA("ClickDetector") and v.Parent.Name:upper():find("DOOR") == 1 then
			return v
		end
	end
end

local function findlocker()
	local children = workspace:GetChildren()
	local recent = {}
	for i, v in next, children do
		recent[#children - i + 1] = v
	end
	table.clear(children)
	for _, v in next, recent do
		if (v:IsA("Model") and not Players:GetPlayerFromCharacter(v) and Lighting:FindFirstChild(v.Name, true)) or
			(v.Name:upper():find("START") == 1 and v:IsA("Folder")) then
			for _, v2 in next, v:GetDescendants() do
				if v2:IsA("Model") and v2.Name:upper():find("LOCKER") and not v2.Seat.Disabled and not v2.Seat.Occupant then
					table.clear(recent)
					return v2
				end
			end
		end
	end
end

local alert=false

local function changed(value)
	if alert then
		local msg=Instance.new("Message")
		msg.Parent=workspace
		msg.Text = value and "Monster spawned" or "Monster despawned"
		Debris:AddItem(msg,1)
	end
end

local Groups = {
	["Main"] = {
		["Open door"] = function()
			fireclickdetector(findcd(),0)
		end,
		["Run fast"] = function()
			LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed *= 6
		end,
		["Teleport to locker"] = function()
			local l = findlocker()
			if l then
				LocalPlayer.Character:PivotTo(l:GetPivot())
			end
		end,
		["Fullbright"] = function()
			Lighting.Changed:Connect(function()
				Lighting.OutdoorAmbient=Color3.new(1,1,1)
				Lighting.Brightness=2
			end)
			Lighting.OutdoorAmbient=Color3.new(1,1,1)
			Lighting.Brightness=2
		end,
		["Alert monsters"] = function()
			alert=not alert

			local msg=Instance.new("Message")
			msg.Parent=workspace
			msg.Text = alert and "Alerts enabled" or "Alerts disabled"
			Debris:AddItem(msg,1)
		end,
	}
}

workspace:WaitForChild("monster"):WaitForChild("hunt").Changed:Connect(changed)
workspace:WaitForChild("monster2"):WaitForChild("hunt").Changed:Connect(changed)

local function CreateTabButton(Text, Idx)
	local TabButton = V12:Clone()
	TabButton.LayoutOrder = Idx
	TabButton.Text = Text
	TabButton.Visible = true
	TabButton.Parent = V12.Parent
	TabButton.Activated:Connect(function()
		for _, v in next, V16:GetChildren() do
			if v ~= V17 and v ~= V19 then
				v:Destroy()
			end
		end

		V15.Visible = false

		local Group = Groups[Text]
		local Idx1 = 0

		if Group then
			for i, v in next, Group do
				local Button = V17:Clone()
				Button.LayoutOrder = Idx1
				Button.Text = i
				Button.Visible = true
				Button.Parent = V17.Parent
				Button.Activated:Connect(v)

				AttachGradient(Button.Frame, Idx1 / 20)
				Idx1 += 1
			end
		end
	end)
end

local Idx0 = 0

for i, _ in next, Groups do
	CreateTabButton(i, Idx0)
	Idx0 += 1
end

local isDragging = false
local startPosition = nil

local function updateWindowPosition(input)
	local delta = input.Position - startPosition
	V2.Position = UDim2.new(0, V2.AbsolutePosition.X + delta.X, 0, V2.AbsolutePosition.Y + delta.Y + 36)
	V2.AnchorPoint = Vector2.new(0, 0)
	startPosition = input.Position
end

local function onDragStart(input)
	startPosition = input.Position
	isDragging = true
end

local function onDragEnd()
	isDragging = false
end

V20.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		onDragStart(input)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		updateWindowPosition(input)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if isDragging and input.UserInputType == Enum.UserInputType.MouseButton1 then
		onDragEnd()
	end
end)
