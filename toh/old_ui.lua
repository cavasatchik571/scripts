-- Tower of Hell script by Vov4ik4124

local V1 = game:FindFirstChild('ToH_CheatGUI', true)

if V1 then
	V1.Enabled = not V1.Enabled

	return
else
	V1 = Instance.new('ScreenGui')
end

-- Services

local CoreGui = game:GetService('CoreGui')
local Debris = game:GetService('Debris')
local GuiService = game:GetService('GuiService')
local Lighting = game:GetService('Lighting')
local Players = game:GetService('Players')
local StarterGui = game:GetService('StarterGui')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local RunService = game:GetService('RunService')
local TweenService = game:GetService('TweenService')
local UserInputService = game:GetService('UserInputService')

-- Variables

local function SetFrom(self: Instance, property: string, otherInstance: Instance): any
	self[property] = otherInstance[property]

	return otherInstance[property]
end

local function SetTo(self: Instance, property: string, value: any): any
	self[property] = value

	return value
end

local function WaitForChildWhichIsA(self: Instance, className: string, recursive: boolean?): Instance
	local Signal = self[recursive and 'DescendantAdded' or 'ChildAdded']

	while true do
		if self:FindFirstChildWhichIsA(className, recursive) then
			return self:FindFirstChildWhichIsA(className, recursive)
		end

		Signal:Wait()
	end
end

local LocalPlayer = Players.LocalPlayer
local PlayerScripts = LocalPlayer:FindFirstChildWhichIsA('PlayerScripts', true) or
	WaitForChildWhichIsA(LocalPlayer, 'PlayerScripts', false)

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:FindFirstChildWhichIsA('Humanoid') or WaitForChildWhichIsA(Character, 'Humanoid', false)
local HumanoidRootPart = Character:FindFirstChild('HumanoidRootPart') or Character:WaitForChild('HumanoidRootPart')
local Mouse = LocalPlayer:GetMouse()

local PlayerGui = LocalPlayer:FindFirstChildWhichIsA('BasePlayerGui') or
	WaitForChildWhichIsA(LocalPlayer, 'BasePlayerGui', true)

local Chat = PlayerGui:WaitForChild('Chat')
local Frame = Chat:WaitForChild('Frame')
local ChatBarParentFrame = Frame:WaitForChild('ChatBarParentFrame')
local Frame2 = ChatBarParentFrame:WaitForChild('Frame')
local BoxFrame = Frame2:WaitForChild('BoxFrame')
local Frame3 = BoxFrame:WaitForChild('Frame')
local TextLabel = Frame3:WaitForChild('TextLabel')
local ChatBar = Frame3:WaitForChild('ChatBar')
local ChatBarClone = ChatBar:Clone() do
	ChatBarClone.Name = 'ChatBarClone'
	ChatBarClone.TextStrokeColor3 = Color3.fromRGB(255, 255, 127)
	ChatBarClone.TextStrokeTransparency = 0.15
	ChatBarClone.Visible = false
	ChatBarClone.Parent = ChatBar.Parent

	ChatBar.Changed:Connect(function(Property)
		if Property == 'Text' or Property == 'Parent' or Property == 'Visible' or
			Property == 'TextStrokeColor3' or Property == 'SelectionStart' or Property == 'CursorPosition' or
			Property == 'TextStrokeTransparency' then

			return
		end

		pcall(SetFrom, ChatBarClone, Property, ChatBar)
	end)
end

local DurationBetweenTowers = 5
local FogEnd = nil
local Removing = false

local CtrlClickToBuild = Instance.new('BoolValue')
CtrlClickToBuild.Value = false

local GreenFireEnabled = Instance.new('BoolValue')
GreenFireEnabled.Value = false

local ImmuneToEffects = Instance.new('BoolValue')
ImmuneToEffects.Value = false

local InfiniteJumps = Instance.new('BoolValue')
InfiniteJumps.Value = false

local Invincible = Instance.new('BoolValue')
Invincible.Value = false

local Noclip = Instance.new('BoolValue')
Noclip.Value = false

local SilentErrors = Instance.new('BoolValue')
SilentErrors.Value = false

local BeatingTower = Instance.new('BoolValue')
BeatingTower.Value = false

local RemovedAntiCheat = Instance.new('BoolValue')
RemovedAntiCheat.Value = false

local SpeedModifier = Instance.new('NumberValue')
SpeedModifier.Value = 1.0

local JumpModifier = Instance.new('NumberValue')
JumpModifier.Value = 1.0

local TopLeft, BottomRight = GuiService:GetGuiInset()
local InfoTween = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0)
local _RaycastParams = RaycastParams.new() do
	_RaycastParams.FilterType = Enum.RaycastFilterType.Blacklist
	_RaycastParams.IgnoreWater = true
end

local Properties = {
	['BackgroundTransparency'] = 1,
	['Size'] = UDim2.new(5, 0, 5, 0)
}

local function Warn(...): ()
	if not SilentErrors.Value then
		warn(...)
	end
end

local DragingOtherObject = false

-- Tables

local Affected = {}
local AffectedCharacterParts = {}
local Faked = {}
local Killparts = {}

local ScriptNames = {
	'LocalScript',
	'LocalScript1',
	'LocalScript2',
	'LocalScript0',
	'Script',
	'Script0',
	'Script1',
	'Script2',
	'localScript',
	'localScript1',
	'localScript2',
	'localScript0',
	'script',
	'script0',
	'script1',
	'script2',
	'localscript',
	'localscript0',
	'localscript1',
	'localscript2'
}

-- Functions

local function CompleteTower()
	local tower = workspace:FindFirstChild('tower')

	local Finishes = tower and tower:FindFirstChild('finishes') or workspace:FindFirstChild('finishes', true)
	local Sections = tower and tower:FindFirstChild('sections') or workspace:FindFirstChild('sections', true)

	if not Finishes or not Sections then
		return Warn('No finishes and/or sections were found.')
	end

	if BeatingTower.Value then
		BeatingTower.Value = false

		for _, v in next, Character:GetDescendants() do
			if v:IsA('BasePart') then
				v.AssemblyAngularVelocity = Vector3.new()
				v.AssemblyLinearVelocity = Vector3.new()
				v.RotVelocity = Vector3.new()
				v.Velocity = Vector3.new()
			end
		end

		return
	end

	BeatingTower.Value = true

	coroutine.resume(coroutine.create(function()
		local a = {}
		local b = {}

		for _, v in next, workspace:GetDescendants() do
			if (v:FindFirstChild('kills') or v.Name:upper():find('KILL')) and v:IsA('BasePart') then
				a[v] = v.Parent

				v.Parent = nil
			end
		end

		task.wait()

		local SectionsList = Sections:GetChildren()
		local Positions = {}

		table.sort(SectionsList, function(A, B)
			if A.Name ~= 'start' and B.Name ~= 'start' then
				return A.start.CFrame.Y < B.start.CFrame.Y
			end

			return false
		end)

		for _, Child in next, SectionsList do
			if Child.Name ~= 'start' then
				local cFrame = Child.start.CFrame + Vector3.new(1, 2, 1)

				if not table.find(Positions, cFrame) then
					if Character:GetPivot().Y < cFrame.Y then
						table.insert(Positions, cFrame)
					end
				end
			end
		end

		table.clear(SectionsList)

		SectionsList = nil

		local LastPosition = HumanoidRootPart.CFrame

		LocalPlayer.CharacterAdded:Once(function()
			BeatingTower.Value = false
		end)

		for _, v in next, Positions do
			local Time = 0

			while Time <= DurationBetweenTowers do
				if not BeatingTower.Value then
					for i, v in next, a do
						i.Parent = v
					end

					for i, v in next, b do
						i.CFrame = v
					end

					table.clear(a)
					table.clear(b)

					a = nil
					b = nil

					return
				end

				local Tick = task.wait()

				HumanoidRootPart.CFrame = CFrame.new(
					LastPosition.X * (1 - Time / DurationBetweenTowers) + v.X * (Time / DurationBetweenTowers),
					LastPosition.Y * (1 - Time / DurationBetweenTowers) + v.Y * (Time / DurationBetweenTowers),
					LastPosition.Z * (1 - Time / DurationBetweenTowers) + v.Z * (Time / DurationBetweenTowers)
				)

				for _, v in next, Character:GetDescendants() do
					if v:IsA('BasePart') then
						v.AssemblyAngularVelocity = Vector3.new()
						v.AssemblyLinearVelocity = Vector3.new()
						v.RotVelocity = Vector3.new()
						v.Velocity = Vector3.new()
					end
				end

				Time += Tick
			end

			LastPosition = v
		end

		task.wait(0.5)

		for _, v in next, Finishes:GetChildren() do
			if v:IsA('BasePart') then
				b[v] = v.CFrame

				v.CFrame = Sections.finish.FinishGlow.CFrame * CFrame.new(-Sections.finish.FinishGlow.Size.X * 2, 0, 0)
			end
		end

		HumanoidRootPart.CFrame = Sections.finish.FinishGlow.CFrame *
			CFrame.new(-Sections.finish.FinishGlow.Size.X * 2, 0, 0)

		task.wait()
		BeatingTower.Value = false

		for i, v in next, a do
			i.Parent = v
		end

		for i, v in next, b do
			i.CFrame = v
		end

		table.clear(a)
		table.clear(b)

		a = nil
		b = nil
	end))
end

local function GetAllItems()
	if not ReplicatedStorage:FindFirstChild('Gear') then
		return Warn('No items were found.')
	end

	local Backpack = LocalPlayer:FindFirstChildWhichIsA('Backpack')

	if not Backpack then
		return Warn('No standard backpack was found.')
	end

	coroutine.resume(coroutine.create(function()
		V1.Frame.Frame.GetAllItems.CheckMark.TextColor3 = Color3.fromRGB(255, 255, 255)
		V1.Frame.Frame.GetAllItems.CheckMark.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)

		for _, v in next, ReplicatedStorage.Gear:GetDescendants() do
			if Backpack:FindFirstChild('NOTHING_'..v.Name) then
				Backpack:FindFirstChild('NOTHING_'..v.Name):Destroy()

				task.wait()
			else
				if v:IsA('BackpackItem') and not v:IsA('HopperBin') then
					local Cloned = v:Clone()

					task.wait()

					Cloned.CanBeDropped = true
					Cloned.Name = 'NOTHING_'..v.Name
					Cloned.Parent = Backpack
				end
			end
		end

		V1.Frame.Frame.GetAllItems.CheckMark.TextColor3 = Color3.fromRGB(64, 64, 64)
		V1.Frame.Frame.GetAllItems.CheckMark.TextStrokeColor3 = Color3.fromRGB(64, 64, 64)
	end))
end

local function GodMode(Value)
	Invincible.Value = Value

	if Invincible.Value then
		for _, v in next, workspace:GetDescendants() do
			if not v:IsA('BasePart') then
				continue
			end

			if (v:FindFirstChild('kills') or v.Name:upper():find('KILL')) and Killparts[v] == nil then
				Killparts[v] = v.CanTouch
			end
		end

		for _, v in next, Character:GetChildren() do
			if v.Name:upper():find('HITBOX') and v:IsA('BasePart') then
				Killparts[v] = v.CanTouch
			end

			if v.Name:upper():find('KILL') and v:IsA('BaseScript') then
				v.Disabled = true
				v.Enabled = false
			end
		end
	else
		for i, v in next, Killparts do
			i.CanTouch = v
		end

		for _, v in next, Character:GetChildren() do
			if v.Name:upper():find('KILL') and v:IsA('BaseScript') then
				v.Disabled = false
				v.Enabled = true
			end
		end

		table.clear(Killparts)
	end
end

local function GreenFire(Value)
	local Torso = Character:FindFirstChild('Torso') or Character:FindFirstChild('UpperTorso') or HumanoidRootPart

	if Torso then
		GreenFireEnabled.Value = Value

		if Torso:FindFirstChild('GreenFire') then
			while Torso:FindFirstChild('GreenFire') do
				Torso:FindFirstChild('GreenFire'):Destroy()
			end
		end

		if GreenFireEnabled.Value then
			for x = 1, 3 do
				local GreenFire = Instance.new('Fire')
				GreenFire.Archivable = true
				GreenFire.Color = Color3.new(1, 90, 1)
				GreenFire.Enabled = true
				GreenFire.Heat = 9
				GreenFire.Name = 'GreenFire'
				GreenFire.SecondaryColor = Color3.new(90, 90, 90)
				GreenFire.Size = 3
				GreenFire.TimeScale = 1
				GreenFire.Parent = Torso
			end
		end
	else
		Warn('No torso was found.')
	end
end

local function Highlight(GuiObject)
	local Location = UserInputService:GetMouseLocation()
	local Frame = Instance.new('Frame')
	Frame.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Frame.BorderSizePixel = 0

	Frame.Position = UDim2.new(
		0,
		Location.X - GuiObject.AbsolutePosition.X,
		0,
		Location.Y - GuiObject.AbsolutePosition.Y - TopLeft.Y
	)

	Frame.SizeConstraint = Enum.SizeConstraint.RelativeYY
	Frame.ZIndex = 5
	Frame.Parent = GuiObject

	local UICorner = Instance.new('UICorner')
	UICorner.CornerRadius = UDim.new(1, 0)
	UICorner.Parent = Frame

	local Tween = TweenService:Create(Frame, InfoTween, Properties)

	Tween:Play()
	Debris:AddItem(Frame, InfoTween.Time)
end

local function HumanoidSetup()
	local OriginalSpeed = Humanoid.WalkSpeed
	local OriginalJH = Humanoid.JumpHeight
	local OriginalJP = Humanoid.JumpPower

	local function OnChanged(Property)
		if Property == 'WalkSpeed' then
			if Humanoid.WalkSpeed / SpeedModifier.Value ~= OriginalSpeed then
				if Humanoid.WalkSpeed > 0 then
					OriginalSpeed = Humanoid.WalkSpeed
				end

				Humanoid.WalkSpeed = OriginalSpeed * SpeedModifier.Value
			end
		elseif Property == 'JumpHeight' then
			if math.round(Humanoid.JumpHeight / JumpModifier.Value) ~= math.round(OriginalJH) then
				if Humanoid.JumpHeight > 0 then
					OriginalJH = Humanoid.JumpHeight
				end

				Humanoid.JumpHeight = OriginalJH * JumpModifier.Value
			end
		elseif Property == 'JumpPower' then
			if Humanoid.JumpPower / JumpModifier.Value ~= OriginalJP then
				if Humanoid.JumpPower > 0 then
					OriginalSpeed = Humanoid.WalkSpeed
				end

				Humanoid.JumpPower = OriginalJP * JumpModifier.Value
			end
		end
	end

	SpeedModifier.Changed:Connect(function()
		Humanoid.WalkSpeed = OriginalSpeed * SpeedModifier.Value
	end)

	JumpModifier.Changed:Connect(function()
		Humanoid.JumpHeight = OriginalJH * JumpModifier.Value
		Humanoid.JumpPower = OriginalJP * JumpModifier.Value
	end)

	Humanoid.Changed:Connect(OnChanged)

	Humanoid.WalkSpeed = OriginalSpeed * SpeedModifier.Value
	Humanoid.JumpHeight = OriginalJH * JumpModifier.Value
	Humanoid.JumpPower = OriginalJP * JumpModifier.Value
end

local function ImmuneToEffectsActive(Value)
	ImmuneToEffects.Value = Value

	if ImmuneToEffects.Value then
		local Negative = Lighting:FindFirstChild('Negative') or Lighting:FindFirstChild('negative')

		if Negative then
			Faked[Negative] = Negative.Parent

			local FakeNegative = Instance.new('ColorCorrectionEffect')
			FakeNegative.Changed:Connect(function()
				FakeNegative.Brightness = 0
				FakeNegative.Contrast = 0
				FakeNegative.Enabled = false
				FakeNegative.Saturation = 0
				FakeNegative.TintColor = Color3.fromRGB(255, 255, 255)
			end)

			FakeNegative.Name = Negative.Name
			FakeNegative.Parent = Negative.Parent

			Negative.Parent = nil
		end

		local bunnyJump = Character:FindFirstChild('bunnyJumping') or
			Character:FindFirstChild('BunnyJumping') or
			Character:FindFirstChild('bunnyJump') or
			Character:FindFirstChild('BunnyJump')

		if bunnyJump then
			Faked[bunnyJump] = bunnyJump.Parent

			local Fake_bunnyJump = Instance.new('LocalScript')
			Fake_bunnyJump.Changed:Connect(function()
				Fake_bunnyJump.Disabled = true
				Fake_bunnyJump.Enabled = false
			end)

			Fake_bunnyJump.Name = bunnyJump.Name
			Fake_bunnyJump.Parent = bunnyJump.Parent

			bunnyJump.Parent = nil
		end

		for _, v in next, Character:GetChildren() do
			if v:IsA('BasePart') and v.Name ~= 'HumanoidRootPart' and not v.Name:upper():find('HITBOX') then
				if not AffectedCharacterParts[v] then
					AffectedCharacterParts[v] = v.Transparency

					v.Transparency = 0
				end
			elseif v:IsA('Accoutrement') then
				for _, v2 in next, v:GetDescendants() do
					if v2:IsA('BasePart') then
						if not AffectedCharacterParts[v2] then
							AffectedCharacterParts[v2] = v2.Transparency

							v2.Transparency = 0
						end
					end
				end
			end
		end

		for _, v in next, Character:GetDescendants() do
			if v:IsA('Explosion') then
				if not AffectedCharacterParts[v] then
					AffectedCharacterParts[v] = v.Visible

					v.Visible = true
				end
			elseif v:IsA('Beam') or v:IsA('ParticleEmitter') or v:IsA('Trail') or
				v:IsA('Fire') or v:IsA('Smoke') or v:IsA('Sparkles') or v:IsA('Highlight') or
				v:IsA('SurfaceGui') or v:IsA('BillboardGui') then

				if not AffectedCharacterParts[v] then
					AffectedCharacterParts[v] = v.Enabled

					v.Enabled = true
				end
			elseif v:IsA('Decal') or v:IsA('Texture') then
				if not AffectedCharacterParts[v] then
					AffectedCharacterParts[v] = v.Transparency

					v.Transparency = 0
				end
			end
		end

		FogEnd = Lighting.FogEnd
		Lighting.FogEnd = 9e9
	else
		for i, v in next, Faked do
			local Fake = v:FindFirstChild(i.Name)

			if Fake then
				Fake:Destroy()
			end

			pcall(SetTo, i, 'Parent', v)
		end

		table.clear(Faked)

		for i, v in next, AffectedCharacterParts do
			if i:IsA('Explosion') then
				i.Visible = v
			elseif i:IsA('Beam') or i:IsA('ParticleEmitter') or i:IsA('Trail') or
				i:IsA('Fire') or i:IsA('Smoke') or i:IsA('Sparkles') or i:IsA('Highlight') or
				i:IsA('SurfaceGui') or i:IsA('BillboardGui') then

				i.Enabled = v
			elseif i:IsA('Decal') or i:IsA('Texture') or i:IsA('BasePart') then
				i.Transparency = v
			end
		end

		table.clear(AffectedCharacterParts)

		Lighting.FogEnd = FogEnd
		FogEnd = nil
	end
end

local function NoclipSetup()
	if not Noclip.Value then
		return
	end

	local HRPClone = HumanoidRootPart.Parent:FindFirstChild('HRPHitbox')

	if HRPClone then
		HRPClone:Destroy()
	end

	HRPClone = HumanoidRootPart:Clone()
	HRPClone.CanCollide = false
	HRPClone.CanQuery = false
	HRPClone.CastShadow = false
	HRPClone.CFrame = HumanoidRootPart.CFrame
	HRPClone.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
	HRPClone.Massless = true
	HRPClone.Name = 'HRPHitbox'
	HRPClone.Size = Vector3.new(2, 3.6, 2)
	HRPClone.Transparency = 1
	HRPClone:ClearAllChildren()

	local Weld = Instance.new('Weld')
	Weld.C1 = CFrame.new(0, 0.5, 0)
	Weld.Part0 = HRPClone
	Weld.Part1 = HumanoidRootPart
	Weld.Parent = HRPClone

	HRPClone.Touched:Connect(function(OtherPart)
		if not Humanoid then
			return
		end

		if not Humanoid.Parent then
			return
		end

		if Humanoid.Health <= 0 or
			Humanoid:GetState() == Enum.HumanoidStateType.Climbing or
			Humanoid:GetState() == Enum.HumanoidStateType.Dead then

			return
		end

		if not Affected[OtherPart] then
			Affected[OtherPart] = {OtherPart.CanCollide, OtherPart.CanTouch}

			OtherPart.CanCollide = false
		end
	end)

	HRPClone.TouchEnded:Connect(function(OtherPart)
		if Affected[OtherPart] then
			OtherPart.CanCollide = Affected[OtherPart][1]
			OtherPart.CanTouch = Affected[OtherPart][2]

			table.clear(Affected[OtherPart])
			Affected[OtherPart] = nil
		end
	end)

	HRPClone.Parent = HumanoidRootPart.Parent
end

local function NoclipActive(Value)
	if not HumanoidRootPart then
		return Warn('No humanoid root part was found.')
	end

	if not HumanoidRootPart.Parent then
		return Warn('No humanoid root part was found.')
	end

	Noclip.Value = Value

	if Value then
		NoclipSetup()

		for _, v in next, workspace:GetDescendants() do
			if v.Name:upper():find('KILL') and v.Name:upper():find('WALL') and
				v:IsA('BasePart') then

				v.CanTouch = false
			end
		end
	else
		local HRPClone = HumanoidRootPart.Parent:FindFirstChild('HRPHitbox')

		if HRPClone then
			HRPClone:Destroy()
		end

		for i, v in next, Affected do
			if i then
				if i.Parent and v then
					i.CanCollide = v[1]
					i.CanTouch = v[2]

					table.clear(v)
				end
			end
		end

		table.clear(Affected)

		for _, v in next, workspace:GetDescendants() do
			if v.Name:upper():find('KILL') and v.Name:upper():find('WALL') and v:IsA('BasePart') then
				v.CanTouch = true
			end
		end
	end
end

local function RemoveAntiCheat()
	if Removing then
		return
	end

	if RemovedAntiCheat.Value then
		return Warn('Anti-cheat was already removed.')
	end

	Removing = true

	for x = 1, 5 do
		local Success0, _ = pcall(function()
			local Found = false

			for _, v in next, getreg() do
				if type(v) == 'function' then
					local info = getinfo(v)

					if info.name == 'kick' then
						if hookfunction(info.func, function(...)end) then
							Found = true
						end
					end
				end
			end
		end)

		if Success0 then
			print('Successfully hooked \'kick\' function(s).')
		else
			Warn('Failed to hook \'kick\' functions(s).')
		end

		local Success1, _ = pcall(function()
			local LocalScripts = {}
			local Success, Result = pcall(getnilinstances)

			if Success and Result then
				for _, v in next, Result do
					if v:IsA('LocalScript') then
						table.insert(LocalScripts, v)
					end
				end
			end

			for _, v in next, ScriptNames do
				table.insert(LocalScripts, PlayerScripts:FindFirstChild(v, true))
			end

			local AffectedScripts = {}
			local Found = false

			for _, v in next, LocalScripts do
				local Successes = {}
				local Success = true

				for _, Connection in next, getconnections(v.Changed) do
					local Result0, Result1 = pcall(Connection.Disable)

					table.insert(Successes, Result0 and Result1)
				end

				for _, v in next, Successes do
					if not v then
						Success = false

						break
					end
				end

				table.clear(Successes)

				AffectedScripts[v] = Success

				if Success then
					Found = true
				end
			end

			for i, v in next, AffectedScripts do
				if v then
					pcall(SetTo, i, 'Disabled', true)
					pcall(SetTo, i, 'Enabled', false)
					pcall(i.Destroy, i)

					AffectedScripts[i] = nil
				end
			end

			table.clear(LocalScripts)

			LocalScripts = nil
		end)

		if Success1 then
			print('Successfully removed anti-cheat scripts.')
		else
			Warn('No anti-cheat scripts were found.')
		end

		local Success2, _ = pcall(function()
			local Lag = ReplicatedStorage:FindFirstChild('lag') or ReplicatedStorage:FindFirstChild('Lag')
			local oldhmmi, oldhmmnc

			oldhmmi = hookmetamethod(game, '__index', function(self, method)
				if self == Lag and method:upper() == 'FIRESERVER' then
					return error('Expected \':\' not \'.\' calling member function FireServer', 2)
				end

				return oldhmmi(self, method)
			end)

			oldhmmnc = hookmetamethod(game, '__namecall', function(self, ...)
				if self == Lag and getnamecallmethod():upper() == 'FIRESERVER' then
					return
				end

				return oldhmmnc(self, ...)
			end)
		end)

		if Success2 then
			print('Successfully hooked \'Lag\' remote event.')
		else
			Warn('Failed to hook \'Lag\' remote event.')
		end

		local Success3, _ = pcall(GuiService.ClearError, GuiService)

		if Success3 then
			print('Successfully cleared errors.')
		else
			Warn('Failed to clear errors.')
		end

		if Success0 and Success1 and Success2 and Success3 then
			RemovedAntiCheat.Value = true

			return true
		else
			task.wait(3)
		end
	end

	Removing = false
	Warn('Failed to remove anti-cheat, please try again later.')
end

local function SetDraggable(ObjectToHold, ObjectToMove)
	if ObjectToHold and ObjectToMove then
		local Drag = false
		local LastVector = Vector2.new()

		local Connection0 = ObjectToHold.InputBegan:Connect(function(Input)
			if DragingOtherObject then return end

			if Input.UserInputType == Enum.UserInputType.MouseButton1 or
				Input.UserInputType == Enum.UserInputType.Touch then

				Drag = true
				DragingOtherObject = true

				LastVector = Vector2.new(Input.Position.X - ObjectToMove.AbsolutePosition.X,
					Input.Position.Y - ObjectToMove.AbsolutePosition.Y)
			end
		end)

		local Connection1 = UserInputService.InputChanged:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseMovement or
				Input.UserInputType == Enum.UserInputType.Touch then

				if Drag then
					if ObjectToMove then
						local uDim = UDim2.new(0, Input.Position.X - LastVector.X,
							0, Input.Position.Y - LastVector.Y + (V1.IgnoreGuiInset and TopLeft.Y or 0))

						ObjectToMove.AnchorPoint = Vector2.new(0, 0)
						ObjectToMove.Position = uDim
					end
				end
			end
		end)

		local Connection2 = UserInputService.InputEnded:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or
				Input.UserInputType == Enum.UserInputType.Touch then

				Drag = false
				DragingOtherObject = false
			end
		end)

		return true
	end

	return false
end

-- Tables with functions

local CheatFunctions = {
	['RemoveAntiCheat'] = RemoveAntiCheat,
	['InfiniteJumps'] = function()
		InfiniteJumps.Value = not InfiniteJumps.Value
	end,
	['CompleteTower'] = CompleteTower,
	['Invincibility'] = function()
		GodMode(not Invincible.Value)
	end,
	['Noclip'] = function()
		NoclipActive(not Noclip.Value)
	end,
	['GetAllItems'] = GetAllItems,
	['ToggleGreenFire'] = function()
		GreenFire(not GreenFireEnabled.Value)
	end,
	['CtrlClickToBuild'] = function()
		CtrlClickToBuild.Value = not CtrlClickToBuild.Value
	end,
	['SilentErrors'] = function()
		SilentErrors.Value = not SilentErrors.Value
	end,
	['ImmuneToEffects'] = function()
		ImmuneToEffectsActive(not ImmuneToEffects.Value)
	end,
}

local Preset = {
	['no_anti_cheat'] = {
		CheatFunctions.RemoveAntiCheat,
		'Removing anti cheat...'
	},
	['inf_jumps'] = {
		CheatFunctions.InfiniteJumps,
		'Toggling infinite jumps...'
	},
	['beat_tower'] = {
		CheatFunctions.CompleteTower,
		'Beating tower of hell...'
	},
	['complete_tower'] = {
		CheatFunctions.CompleteTower,
		'Beating tower of hell...'
	},
	['invincible'] = {
		CheatFunctions.Invincibility,
		'Toggling invincibility...'
	},
	['noclip'] = {
		CheatFunctions.Noclip,
		'Toggling noclip...'
	},
	['items'] = {
		CheatFunctions.GetAllItems,
		'Receiving all items...'
	},
	['all_items'] = {
		CheatFunctions.GetAllItems,
		'Receiving all items...'
	},
	['get_all_items'] = {
		CheatFunctions.GetAllItems,
		'Receiving all items...'
	},
	['gears'] = {
		CheatFunctions.GetAllItems,
		'Receiving all items...'
	},
	['all_gears'] = {
		CheatFunctions.GetAllItems,
		'Receiving all items...'
	},
	['get_all_gears'] = {
		CheatFunctions.GetAllItems,
		'Receiving all items...'
	},
	['green_fire'] = {
		CheatFunctions.ToggleGreenFire,
		'Toggling green fire...'
	},
	['green_flame'] = {
		CheatFunctions.ToggleGreenFire,
		'Toggling green fire...'
	},
	['ctrl_click_build'] = {
		CheatFunctions.CtrlClickToBuild,
		'Toggling ctrl + click to build...'
	},
	['ctrl_click_to_build'] = {
		CheatFunctions.CtrlClickToBuild,
		'Toggling ctrl + click to build...'
	},
	['cc_to_build'] = {
		CheatFunctions.CtrlClickToBuild,
		'Toggling ctrl + click to build...'
	},
	['cc_build'] = {
		CheatFunctions.CtrlClickToBuild,
		'Toggling ctrl + click to build...'
	},
	['immune_to_effects'] = {
		CheatFunctions.ImmuneToEffects,
		'Toggling immune to negative effects...'
	},
	['immune_to_negative_effects'] = {
		CheatFunctions.ImmuneToEffects,
		'Toggling immune to negative effects...'
	},
	['immune_to_ne'] = {
		CheatFunctions.ImmuneToEffects,
		'Toggling immune to negative effects...'
	},

	-- Silent errors

	['no_errors'] = {
		CheatFunctions.SilentErrors,
		'Toggling silent errors...'
	},
	['no_error_messages'] = {
		CheatFunctions.SilentErrors,
		'Toggling silent errors...'
	},
	['no_warns'] = {
		CheatFunctions.SilentErrors,
		'Toggling silent errors...'
	},
	['no_warnings'] = {
		CheatFunctions.SilentErrors,
		'Toggling silent errors...'
	},
	['toggle_errors'] = {
		CheatFunctions.SilentErrors,
		'Toggling silent errors...'
	},
	['toggle_error_messages'] = {
		CheatFunctions.SilentErrors,
		'Toggling silent errors...'
	},
	['toggle_warns'] = {
		CheatFunctions.SilentErrors,
		'Toggling silent errors...'
	},
	['toggle_warnings'] = {
		CheatFunctions.SilentErrors,
		'Toggling silent errors...'
	}
}

local Commands = {} do
	for i, v in next, Preset do
		for _, v2 in next, {'/', '?', ';'} do
			Commands[v2..i] = v
		end
	end
end

local Trackbars = {
	['Speed modifier'] = SpeedModifier,
	['Jump modifier'] = JumpModifier,
}

-- Event functions

local function OnChanged_OrgChatBar(Property)
	if ChatBarClone.Visible then
		return
	end

	if Property == 'Text' and ChatBar:IsFocused() and ChatBar.Visible then
		if Commands[ChatBar.Text] then
			ChatBarClone.Text = ChatBar.Text
			ChatBarClone.Visible = true
			ChatBarClone:CaptureFocus()

			ChatBarClone.CursorPosition = ChatBar.CursorPosition
			ChatBarClone.SelectionStart = ChatBar.SelectionStart

			ChatBar:ReleaseFocus()
			ChatBar.CursorPosition = 1
			ChatBar.SelectionStart = -1
			ChatBar.Text = ''
			ChatBar.Visible = false
		end
	end
end

local function OnChanged_ChatBarClone(Property)
	if ChatBar.Visible then
		return
	end

	if Property == 'Text' and ChatBarClone:IsFocused() and ChatBarClone.Visible then
		if not Commands[ChatBarClone.Text] then
			ChatBar.Text = ChatBarClone.Text
			ChatBar.Visible = true
			ChatBar:CaptureFocus()

			ChatBar.CursorPosition = ChatBarClone.CursorPosition
			ChatBar.SelectionStart = ChatBarClone.SelectionStart

			ChatBarClone:ReleaseFocus()
			ChatBarClone.CursorPosition = 1
			ChatBarClone.SelectionStart = -1
			ChatBarClone.Text = ''
			ChatBarClone.Visible = false
		end
	end
end

local function OnChanged_Lighting(Property)
	if Property == 'FogEnd' then
		if ImmuneToEffects.Value then
			FogEnd = Lighting.FogEnd

			Lighting.FogEnd = 9e9
		end
	end
end

local function OnFocusLost(EnterPressed)
	if EnterPressed and ChatBarClone.Visible then
		Commands[ChatBarClone.Text][1]()

		StarterGui:SetCore(
			'ChatMakeSystemMessage',
			{
				['Text'] = Commands[ChatBarClone.Text][2],
				['Color'] = Color3.fromRGB(255, 255, 127)
			}
		)

		ChatBar.CursorPosition = 1
		ChatBar.SelectionStart = -1
		ChatBar.Text = ''
		ChatBar.Visible = true
		ChatBar:ReleaseFocus()

		ChatBarClone.CursorPosition = 1
		ChatBarClone.SelectionStart = -1
		ChatBarClone.Text = ''
		ChatBarClone.Visible = false
		ChatBarClone:ReleaseFocus()

		TextLabel.Visible = true
	end
end

local function OnDescendantAdded_AntiCheat(Descendant)
	if RemovedAntiCheat.Value then
		if Descendant:IsA('LocalScript') then
			if table.find(ScriptNames, Descendant.Name) then
				pcall(SetTo, Descendant, 'Disabled', true)
				pcall(SetTo, Descendant, 'Enabled', false)
				pcall(Descendant.Destroy, Descendant)

				task.defer(SetTo, Descendant, 'Disabled', true)
				task.defer(SetTo, Descendant, 'Enabled', false)
				task.defer(Descendant.Destroy, Descendant)

				task.wait()

				pcall(SetTo, Descendant, 'Disabled', true)
				pcall(SetTo, Descendant, 'Enabled', false)
				pcall(Descendant.Destroy, Descendant)
			end
		end
	end
end

local function OnCharacterAdded(NewCharacter)
	Character = NewCharacter or LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

	Humanoid = Character:FindFirstChildWhichIsA('Humanoid') or WaitForChildWhichIsA(Character, 'Humanoid', false)
	HumanoidRootPart = Character:FindFirstChild('HumanoidRootPart') or Character:WaitForChild('HumanoidRootPart')
	Character.DescendantAdded:Connect(OnDescendantAdded_AntiCheat)

	HumanoidSetup()

	if Noclip.Value then
		NoclipSetup()
	end

	if Invincible.Value then
		task.defer(function()
			for _, v in next, Character:GetChildren() do
				if v.Name:upper():find('HITBOX') and v:IsA('BasePart') then
					Killparts[v] = v.CanTouch
				end

				if v.Name:upper():find('KILL') and v:IsA('BaseScript') then
					v.Disabled = true
					v.Enabled = false
				end
			end
		end)
	end

	if ImmuneToEffects.Value then
		task.wait(0.1)

		local bunnyJump = Character:FindFirstChild('bunnyJumping') or
			Character:FindFirstChild('BunnyJumping') or
			Character:FindFirstChild('bunnyJump') or
			Character:FindFirstChild('BunnyJump')

		for i, _ in next, AffectedCharacterParts do
			if i.Name == bunnyJump.Name then
				AffectedCharacterParts[i] = nil
			end
		end

		Faked[bunnyJump] = bunnyJump.Parent

		local Fake_bunnyJump = Instance.new('LocalScript')
		Fake_bunnyJump.Changed:Connect(function()
			Fake_bunnyJump.Disabled = true
			Fake_bunnyJump.Enabled = false
		end)

		Fake_bunnyJump.Name = bunnyJump.Name
		Fake_bunnyJump.Parent = bunnyJump.Parent

		table.clear(AffectedCharacterParts)

		for _, v in next, Character:GetChildren() do
			if v:IsA('BasePart') and v.Name ~= 'HumanoidRootPart' and not v.Name:upper():find('HITBOX') then
				if not AffectedCharacterParts[v] then
					AffectedCharacterParts[v] = v.Transparency

					v.Transparency = 0
				end
			elseif v:IsA('Accoutrement') then
				for _, v2 in next, v:GetDescendants() do
					if v2:IsA('BasePart') then
						if not AffectedCharacterParts[v2] then
							AffectedCharacterParts[v2] = v2.Transparency

							v2.Transparency = 0
						end
					end
				end
			end
		end

		for _, v in next, Character:GetDescendants() do
			if v:IsA('Explosion') then
				if not AffectedCharacterParts[v] then
					AffectedCharacterParts[v] = v.Visible

					v.Visible = true
				end
			elseif v:IsA('Beam') or v:IsA('ParticleEmitter') or v:IsA('Trail') or
				v:IsA('Fire') or v:IsA('Smoke') or v:IsA('Sparkles') or v:IsA('Highlight') or
				v:IsA('SurfaceGui') or v:IsA('BillboardGui') then

				if not AffectedCharacterParts[v] then
					AffectedCharacterParts[v] = v.Enabled

					v.Enabled = true
				end
			elseif v:IsA('Decal') or v:IsA('Texture') then
				if not AffectedCharacterParts[v] then
					AffectedCharacterParts[v] = v.Transparency

					v.Transparency = 0
				end
			end
		end
	end

	if GreenFireEnabled.Value then
		local Torso = Character:FindFirstChild('Torso') or Character:FindFirstChild('UpperTorso') or HumanoidRootPart

		for x = 1, 3 do
			local GreenFire = Instance.new('Fire')
			GreenFire.Archivable = true
			GreenFire.Color = Color3.new(1, 90, 1)
			GreenFire.Enabled = true
			GreenFire.Heat = 9
			GreenFire.Name = 'GreenFire'
			GreenFire.SecondaryColor = Color3.new(90, 90, 90)
			GreenFire.Size = 3
			GreenFire.TimeScale = 1
			GreenFire.Parent = Torso
		end
	end
end

local function OnDescendantAdded(Descendant)
	task.defer(function()
		if Descendant:IsA('BasePart') then
			if Invincible.Value then
				if (Descendant:FindFirstChild('kills') or Descendant.Name:upper():find('KILL')) and
					Killparts[Descendant] == nil then

					Killparts[Descendant] = Descendant.CanTouch
				end
			end

			if Noclip.Value then
				if Descendant.Name:upper():find('KILL') and Descendant.Name:upper():find('WALL') and
					Descendant:IsA('BasePart') then

					Descendant.CanTouch = false
				end
			end
		end
	end)
end

local function OnDescendantRemoving(Descendant)
	Killparts[Descendant] = nil
end

local function OnHeartbeat()
	for i, v in next, Killparts do
		if Invincible.Value then
			i.CanTouch = false
		else
			if v ~= nil then
				i.CanTouch = v[1]
			else
				i.CanTouch = true
			end
		end
	end
end

local function OnJumpRequest()
	if not InfiniteJumps.Value then
		return
	end

	if Humanoid then
		if Humanoid.Parent then
			if Humanoid:GetStateEnabled(Enum.HumanoidStateType.Jumping) and Humanoid.Health > 0 then
				if Humanoid.UseJumpPower then
					if Humanoid.JumpPower <= 0 then
						return
					end
				else
					if Humanoid.JumpHeight <= 0 then
						return
					end
				end

				if Humanoid:GetState() ~= Enum.HumanoidStateType.Landed and
					Humanoid:GetState() ~= Enum.HumanoidStateType.Running and
					Humanoid:GetState() ~= Enum.HumanoidStateType.RunningNoPhysics and
					Humanoid:GetState() ~= Enum.HumanoidStateType.Swimming and
					Humanoid:GetState() ~= Enum.HumanoidStateType.Climbing and
					Humanoid:GetState() ~= Enum.HumanoidStateType.Seated and
					Humanoid:GetState() ~= Enum.HumanoidStateType.Dead and
					Humanoid:GetState() ~= Enum.HumanoidStateType.Ragdoll then

					Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
				end
			end
		end
	end
end

local function OnInputBegan(Input, GameProcessedEvent)
	if not Input then
		return
	end

	if CtrlClickToBuild.Value and (UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or
		UserInputService:IsKeyDown(Enum.KeyCode.RightControl)) and
		Input.UserInputType == Enum.UserInputType.MouseButton1 and not GameProcessedEvent then

		if not Mouse then
			Mouse = LocalPlayer:GetMouse()
		end

		if Mouse then
			local List = {}

			for _, v in next, workspace:GetDescendants() do
				if not v:IsA('BasePart') then
					continue
				end

				if v.Transparency >= 0.3 or v.Material == Enum.Material.ForceField or not v.CanCollide then
					table.insert(List, v)
				end
			end

			_RaycastParams.FilterDescendantsInstances = List

			local RayResult = workspace:Raycast(
				Mouse.UnitRay.Origin,
				Mouse.UnitRay.Direction * 200,
				_RaycastParams
			)

			if RayResult then
				local Part = Instance.new('Part')
				Part.Anchored = true
				Part.Material = Enum.Material.Glass
				Part.Position = RayResult.Position
				Part.Size = Vector3.new(4, 1, 4)
				Part.Transparency = 0.2

				local ClickDetector = Instance.new('ClickDetector')
				ClickDetector.MaxActivationDistance = 15
				ClickDetector.MouseClick:Connect(function(Player)
					if Player ~= LocalPlayer or (UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or
						UserInputService:IsKeyDown(Enum.KeyCode.RightControl)) then

						return
					end

					Part:Destroy()
				end)

				ClickDetector.Parent = Part
				Part.Parent = workspace
			end
		end
	end

	if InfiniteJumps.Value then
		if Input.UserInputType == Enum.UserInputType.Keyboard then
			if not UserInputService:GetFocusedTextBox() and not GameProcessedEvent then
				UserInputService.JumpRequest:Once(OnJumpRequest)
			end
		elseif Input.UserInputType == Enum.UserInputType.Touch then
			if not UserInputService:GetFocusedTextBox() and GameProcessedEvent then
				UserInputService.JumpRequest:Once(OnJumpRequest)
			end
		end
	end
end

-- Connections

LocalPlayer.CharacterAdded:Connect(OnCharacterAdded)
UserInputService.InputBegan:Connect(OnInputBegan)

RunService.Heartbeat:Connect(OnHeartbeat)
Lighting.Changed:Connect(OnChanged_Lighting)

ChatBar.Changed:Connect(OnChanged_OrgChatBar)
ChatBarClone.Changed:Connect(OnChanged_ChatBarClone)
ChatBarClone.FocusLost:Connect(OnFocusLost)

workspace.DescendantAdded:Connect(OnDescendantAdded)
workspace.DescendantRemoving:Connect(OnDescendantRemoving)

Character.DescendantAdded:Connect(OnDescendantAdded_AntiCheat)
PlayerScripts.DescendantAdded:Connect(OnDescendantAdded_AntiCheat)

-- Code

-- Script generated by Vov4ik4124's GUI to script Plugin.

V1.AutoLocalize = false
V1.Name = 'ToH_CheatGUI'
V1.ResetOnSpawn = false

local V2 = Instance.new('Frame')
V2.Active = true
V2.AnchorPoint = Vector2.new(0.5, 0.5)
V2.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
V2.Position = UDim2.new(0.5, 0, 0.5, 0)
V2.Selectable = true
V2.Size = UDim2.new(0.84, 0, 0.69, 0)
V2.SizeConstraint = Enum.SizeConstraint.RelativeYY

local V3 = Instance.new('TextLabel')
V3.AnchorPoint = Vector2.new(0.5, 0)
V3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
V3.BackgroundTransparency = 1
V3.Font = Enum.Font.SourceSansBold
V3.Position = UDim2.new(0.5, 0, 0.01, 0)
V3.Size = UDim2.new(1, 0, 0.066, 0)
V3.Text = 'Tower of Hell'
V3.TextColor3 = Color3.fromRGB(255, 255, 255)
V3.TextScaled = true
V3.TextStrokeTransparency = 0
V3.TextWrapped = true

local V4 = Instance.new('UICorner')
V4.CornerRadius = UDim.new(0.02, 0)

local V5 = Instance.new('Frame')
V5.AnchorPoint = Vector2.new(0.5, 0.5)
V5.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
V5.BackgroundTransparency = 1
V5.Position = UDim2.new(0.5, 0, 0.5, 0)
V5.Size = UDim2.new(0.967, 0, 0.85, 0)

local V6 = Instance.new('UIGridLayout')
V6.CellPadding = UDim2.new(0.025, 0, 0.025, 0)
V6.CellSize = UDim2.new(0.475, 0, 0.133, 0)
V6.FillDirectionMaxCells = 2
V6.HorizontalAlignment = Enum.HorizontalAlignment.Center
V6.SortOrder = Enum.SortOrder.LayoutOrder
V6.VerticalAlignment = Enum.VerticalAlignment.Center

local V7 = Instance.new('TextButton')
V7.AutoButtonColor = false
V7.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
V7.ClipsDescendants = true
V7.Font = Enum.Font.SourceSans
V7.Name = '_PrefabButton'
V7.Size = UDim2.new(0, 200, 0, 50)
V7.Text = ''
V7.TextColor3 = Color3.fromRGB(0, 0, 0)
V7.Visible = false

local V8 = Instance.new('UICorner')
V8.CornerRadius = UDim.new(0.133, 0)

local V9 = Instance.new('TextLabel')
V9.AnchorPoint = Vector2.new(0, 0.5)
V9.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
V9.BackgroundTransparency = 1
V9.Font = Enum.Font.GothamBlack
V9.Name = 'CheckMark'
V9.Position = UDim2.new(0.033, 0, 0.5, 0)
V9.Size = UDim2.new(0.7, 0, 0.7, 0)
V9.SizeConstraint = Enum.SizeConstraint.RelativeYY
V9.Text = utf8.char(10003)
V9.TextColor3 = Color3.fromRGB(64, 64, 64)
V9.TextScaled = true
V9.TextStrokeColor3 = Color3.fromRGB(64, 64, 64)
V9.TextStrokeTransparency = 0
V9.TextWrapped = true

local V10 = Instance.new('TextLabel')
V10.AnchorPoint = Vector2.new(1, 0.5)
V10.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
V10.BackgroundTransparency = 1
V10.Font = Enum.Font.Gotham
V10.Position = UDim2.new(0.933, 0, 0.5, 0)
V10.Size = UDim2.new(0.7, 0, 0.133, 0)
V10.SizeConstraint = Enum.SizeConstraint.RelativeXX
V10.Text = 'Prefab'
V10.TextColor3 = Color3.fromRGB(255, 255, 255)
V10.TextScaled = true
V10.TextStrokeColor3 = Color3.fromRGB(100, 100, 100)
V10.TextStrokeTransparency = 0
V10.TextWrapped = true
V10.TextXAlignment = Enum.TextXAlignment.Left

local V11 = Instance.new('UIGradient')
V11.Color = ColorSequence.new(Color3.fromRGB(87, 255, 101), Color3.fromRGB(83, 255, 169))
V11.Rotation = 90

local V12 = Instance.new('UIGradient')
V12.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(150, 150, 150))
V12.Rotation = 72

local V13 = Instance.new('TextLabel')
V13.AnchorPoint = Vector2.new(0.5, 1)
V13.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
V13.BackgroundTransparency = 1
V13.Font = Enum.Font.SourceSansSemibold
V13.Position = UDim2.new(0.5, 0, 0.99, 0)
V13.Size = UDim2.new(1, 0, 0.05, 0)
V13.Text = 'Cheat by Vov4ik4124'
V13.TextColor3 = Color3.fromRGB(255, 255, 255)
V13.TextScaled = true
V13.TextStrokeTransparency = 0
V13.TextWrapped = true

local V14 = Instance.new('TextButton')
V14.AnchorPoint = Vector2.new(1, 0)
V14.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
V14.BackgroundTransparency = 1
V14.Font = Enum.Font.SourceSansSemibold
V14.MaxVisibleGraphemes = 1
V14.Position = UDim2.new(1, 0, 0, 0)
V14.Size = UDim2.new(0.05, 0, 0.05, 0)
V14.SizeConstraint = Enum.SizeConstraint.RelativeYY
V14.Text = 'X'
V14.TextColor3 = Color3.fromRGB(255, 255, 255)
V14.TextScaled = true
V14.TextStrokeTransparency = 0
V14.TextWrapped = true
V14.Activated:Connect(function()
	V1.Enabled = false
end)

local V15 = Instance.new('Frame')
V15.AnchorPoint = Vector2.new(0.5, 0)
V15.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
V15.BackgroundTransparency = 1
V15.Position = UDim2.new(0.5, 0, 0.1, 0)
V15.Size = UDim2.new(0.95, 0, 0.7, 0)
V15.Visible = false

local V16 = Instance.new('UIGridLayout')
V16.CellPadding = UDim2.new(0, 0, 0.05, 0)
V16.CellSize = UDim2.new(1, 0, 0.25, 0)
V16.FillDirectionMaxCells = 1
V16.HorizontalAlignment = Enum.HorizontalAlignment.Center
V16.SortOrder = Enum.SortOrder.LayoutOrder
V16.VerticalAlignment = Enum.VerticalAlignment.Top

V2.Parent = V1
V3.Parent = V2
V4.Parent = V2
V5.Parent = V2
V6.Parent = V5
V7.Parent = V5
V8.Parent = V7
V9.Parent = V7
V10.Parent = V7
V11.Parent = V7
V12.Parent = V2
V13.Parent = V2
V14.Parent = V2
V15.Parent = V2
V16.Parent = V15

local V17 = V7:Clone()
V17.CheckMark:Destroy()
V17.LayoutOrder = 11
V17.Name = 'SwitchTab'
V17.TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
V17.TextLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
V17.TextLabel.Size = UDim2.new(0.7, 0, 0.133, 0)
V17.TextLabel.Text = 'Change settings'
V17.TextLabel.TextXAlignment = Enum.TextXAlignment.Center
V17.Visible = true
V17.Parent = V5

local V18 = V17:Clone()
V18.Visible = false
V18.Parent = V2

V17.Activated:Connect(function()
	Highlight(V18)

	V18.Visible = true

	V5.Visible = false
	V15.Visible = true
end)

V18.Changed:Connect(function()
	V18.AnchorPoint = Vector2.new(0, 0)
	V18.Position = UDim2.new(
		0,
		math.ceil(V17.AbsolutePosition.X - V18.Parent.AbsolutePosition.X) - 1,
		0,
		math.ceil(V17.AbsolutePosition.Y - V18.Parent.AbsolutePosition.Y) - 1
	)

	V18.Size = UDim2.new(
		0,
		math.ceil(V17.AbsoluteSize.X) - 1,
		0,
		math.ceil(V17.AbsoluteSize.Y)
	)
end)

V18.Activated:Connect(function()
	Highlight(V17)

	V18.Visible = false

	V5.Visible = true
	V15.Visible = false
end)

local V19 = Instance.new('TextButton')
V19.AutoButtonColor = false
V19.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
V19.MaxVisibleGraphemes = 0
V19.Name = '_PrefabFrame'
V19.Text = ''
V19.TextTransparency = 1
V19.Visible = false

local V20 = Instance.new('UICorner')
V20.CornerRadius = UDim.new(0.1, 0)

local V21 = Instance.new('UIGradient')
V21.Color = ColorSequence.new(Color3.fromRGB(87, 255, 101), Color3.fromRGB(83, 255, 169))
V21.Rotation = 90

local V22 = Instance.new('TextLabel')
V22.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
V22.BackgroundTransparency = 1
V22.Font = Enum.Font.Gotham
V22.Position = UDim2.new(0.01, 0, 0.05, 0)
V22.Size = UDim2.new(0.5, 0, 0.05, 0)
V22.SizeConstraint = Enum.SizeConstraint.RelativeXX
V22.Text = 'Prefab'
V22.TextColor3 = Color3.fromRGB(255, 255, 255)
V22.TextScaled = true
V22.TextStrokeColor3 = Color3.fromRGB(100, 100, 100)
V22.TextStrokeTransparency = 0
V22.TextWrapped = true
V22.TextXAlignment = Enum.TextXAlignment.Left

local V23 = Instance.new('Frame')
V23.AnchorPoint = Vector2.new(0.5, 1)
V23.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
V23.BackgroundTransparency = 0.5
V23.BorderColor3 = Color3.fromRGB(0, 0, 0)
V23.BorderSizePixel = 0
V23.Position = UDim2.new(0.5, 0, 0.9, 0)
V23.Size = UDim2.new(0.97, 0, 0.133, 0)

local V24 = Instance.new('Frame')
V24.AnchorPoint = Vector2.new(0.5, 0.5)
V24.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
V24.Position = UDim2.new(0.5, 0, 0.5, 0)
V24.Size = UDim2.new(0.988, 0, 0.5, 0)

local V25 = Instance.new('UICorner')
V25.CornerRadius = UDim.new(1, 0)

local V26 = Instance.new('Frame')
V26.AnchorPoint = Vector2.new(0.5, 0.5)
V26.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
V26.BackgroundTransparency = 0.5
V26.BorderColor3 = Color3.fromRGB(27, 42, 53)
V26.Name = 'Dragger'
V26.Position = UDim2.new(0.5, 0, 0.5, 0)
V26.Size = UDim2.new(2, 0, 2, 0)
V26.SizeConstraint = Enum.SizeConstraint.RelativeYY

local V27 = Instance.new('UICorner')
V27.CornerRadius = UDim.new(1, 0)

local V28 = Instance.new('Frame')
V28.AnchorPoint = Vector2.new(0.5, 0.5)
V28.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
V28.Position = UDim2.new(0.5, 0, 0.5, 0)
V28.Size = UDim2.new(0.75, 0, 0.75, 0)
V28.SizeConstraint = Enum.SizeConstraint.RelativeYY

local V29 = Instance.new('UICorner')
V29.CornerRadius = UDim.new(1, 0)

local V30 = Instance.new('TextLabel')
V30.AnchorPoint = Vector2.new(0.5, 1)
V30.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
V30.BackgroundTransparency = 1
V30.Font = Enum.Font.SourceSansBold
V30.Position = UDim2.new(0.5, 0, -0.5, 0)
V30.Size = UDim2.new(0.1, 0, 2, 0)
V30.Text = '1.0x'
V30.TextColor3 = Color3.fromRGB(255, 255, 255)
V30.TextScaled = true
V30.TextStrokeTransparency = 0.69
V30.TextWrapped = true

local V31 = Instance.new('TextLabel')
V31.AnchorPoint = Vector2.new(0.5, 1)
V31.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
V31.BackgroundTransparency = 1
V31.Font = Enum.Font.SourceSansBold
V31.Position = UDim2.new(0.25, 0, -0.5, 0)
V31.Size = UDim2.new(0.1, 0, 2, 0)
V31.Text = '0.5x'
V31.TextColor3 = Color3.fromRGB(255, 255, 255)
V31.TextScaled = true
V31.TextStrokeTransparency = 0.69
V31.TextWrapped = true

local V32 = Instance.new('TextLabel')
V32.AnchorPoint = Vector2.new(0.5, 1)
V32.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
V32.BackgroundTransparency = 1
V32.Font = Enum.Font.SourceSansBold
V32.Position = UDim2.new(0.75, 0, -0.5, 0)
V32.Size = UDim2.new(0.1, 0, 2, 0)
V32.Text = '1.5x'
V32.TextColor3 = Color3.fromRGB(255, 255, 255)
V32.TextScaled = true
V32.TextStrokeTransparency = 0.69
V32.TextWrapped = true

local V33 = Instance.new('UICorner')
V33.CornerRadius = UDim.new(1, 0)

V20.Parent = V19
V21.Parent = V19
V22.Parent = V19
V23.Parent = V19
V24.Parent = V23
V25.Parent = V24
V26.Parent = V23
V27.Parent = V26
V28.Parent = V26
V29.Parent = V28
V30.Parent = V23
V31.Parent = V23
V32.Parent = V23
V33.Parent = V23
V19.Parent = V15

V1.Parent = pcall(SetTo, V1, 'Parent', CoreGui) and CoreGui or PlayerGui

HumanoidSetup()
SetDraggable(V2, V2)

local function MakeTrackbar(Trackbar, NumberValue, SmallestChange)
	local Holding = false

	local Connection0 = Trackbar.MouseButton1Down:Connect(function()
		if not Holding then
			Holding = true
		end
	end)

	local Connection1 = UserInputService.InputChanged:Connect(function(Input)
		if Holding then
			if Input.UserInputType == Enum.UserInputType.MouseMovement or
				Input.UserInputType == Enum.UserInputType.Touch then

				local Location = UserInputService:GetMouseLocation()
				local Value = math.clamp(
					(Location.X - Trackbar.Frame.AbsolutePosition.X) / Trackbar.Frame.AbsoluteSize.X,
					0.0,
					1.0
				)

				if SmallestChange then
					if SmallestChange > 0 then
						Value = math.round(Value / SmallestChange --[[2 ^ -6]] ) * SmallestChange --[[2 ^ -6]]
					end
				end

				if NumberValue then
					NumberValue.Value = Value * 2
				end

				Trackbar.Frame.Dragger.Position = UDim2.new(
					Value,
					0,
					0.5,
					0
				)
			end
		end
	end)

	local Connection2 = UserInputService.InputEnded:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or
			Input.UserInputType == Enum.UserInputType.Touch then

			Holding = false
		end
	end)

	return Connection0, Connection1, Connection2
end

for i, v in next, CheatFunctions do
	local ClonedPrefab = V7:Clone()
	ClonedPrefab.Name = i
	ClonedPrefab.Visible = true

	ClonedPrefab.Activated:Connect(function()
		Highlight(ClonedPrefab)

		v()
	end)

	if i == 'RemoveAntiCheat' then
		ClonedPrefab.LayoutOrder = 1
		ClonedPrefab.TextLabel.Text = 'Remove anti-cheat'

		RemovedAntiCheat.Changed:Connect(function()
			ClonedPrefab.CheckMark.TextColor3 = RemovedAntiCheat.Value and Color3.fromRGB(255, 255, 255) or
				Color3.fromRGB(64, 64, 64)

			ClonedPrefab.CheckMark.TextStrokeColor3 = RemovedAntiCheat.Value and Color3.fromRGB(255, 255, 255) or
				Color3.fromRGB(64, 64, 64)
		end)

		ClonedPrefab.CheckMark.TextColor3 = RemovedAntiCheat.Value and Color3.fromRGB(255, 255, 255) or
			Color3.fromRGB(64, 64, 64)

		ClonedPrefab.CheckMark.TextStrokeColor3 = RemovedAntiCheat.Value and Color3.fromRGB(255, 255, 255) or
			Color3.fromRGB(64, 64, 64)
	elseif i == 'InfiniteJumps' then
		ClonedPrefab.LayoutOrder = 2
		ClonedPrefab.TextLabel.Text = 'Infinite jumps'

		InfiniteJumps.Changed:Connect(function()
			ClonedPrefab.CheckMark.TextColor3 = InfiniteJumps.Value and Color3.fromRGB(255, 255, 255) or
				Color3.fromRGB(64, 64, 64)

			ClonedPrefab.CheckMark.TextStrokeColor3 = InfiniteJumps.Value and Color3.fromRGB(255, 255, 255) or
				Color3.fromRGB(64, 64, 64)
		end)

		ClonedPrefab.CheckMark.TextColor3 = InfiniteJumps.Value and Color3.fromRGB(255, 255, 255) or
			Color3.fromRGB(64, 64, 64)

		ClonedPrefab.CheckMark.TextStrokeColor3 = InfiniteJumps.Value and Color3.fromRGB(255, 255, 255) or
			Color3.fromRGB(64, 64, 64)
	elseif i == 'CompleteTower' then
		ClonedPrefab.LayoutOrder = 3
		ClonedPrefab.TextLabel.Text = 'Beat tower'

		BeatingTower.Changed:Connect(function()
			ClonedPrefab.CheckMark.TextColor3 = BeatingTower.Value and Color3.fromRGB(255, 255, 255) or
				Color3.fromRGB(64, 64, 64)

			ClonedPrefab.CheckMark.TextStrokeColor3 = BeatingTower.Value and Color3.fromRGB(255, 255, 255) or
				Color3.fromRGB(64, 64, 64)
		end)

		ClonedPrefab.CheckMark.TextColor3 = BeatingTower.Value and Color3.fromRGB(255, 255, 255) or
			Color3.fromRGB(64, 64, 64)

		ClonedPrefab.CheckMark.TextStrokeColor3 = BeatingTower.Value and Color3.fromRGB(255, 255, 255) or
			Color3.fromRGB(64, 64, 64)
	elseif i == 'Invincibility' then
		ClonedPrefab.LayoutOrder = 4
		ClonedPrefab.TextLabel.Text = 'Invincibility'

		Invincible.Changed:Connect(function()
			ClonedPrefab.CheckMark.TextColor3 = Invincible.Value and Color3.fromRGB(255, 255, 255) or
				Color3.fromRGB(64, 64, 64)

			ClonedPrefab.CheckMark.TextStrokeColor3 = Invincible.Value and Color3.fromRGB(255, 255, 255) or
				Color3.fromRGB(64, 64, 64)
		end)

		ClonedPrefab.CheckMark.TextColor3 = Invincible.Value and Color3.fromRGB(255, 255, 255) or
			Color3.fromRGB(64, 64, 64)

		ClonedPrefab.CheckMark.TextStrokeColor3 = Invincible.Value and Color3.fromRGB(255, 255, 255) or
			Color3.fromRGB(64, 64, 64)
	elseif i == 'Noclip' then
		ClonedPrefab.LayoutOrder = 5
		ClonedPrefab.TextLabel.Text = 'Noclip'

		Noclip.Changed:Connect(function()
			ClonedPrefab.CheckMark.TextColor3 = Noclip.Value and Color3.fromRGB(255, 255, 255) or
				Color3.fromRGB(64, 64, 64)

			ClonedPrefab.CheckMark.TextStrokeColor3 = Noclip.Value and Color3.fromRGB(255, 255, 255) or
				Color3.fromRGB(64, 64, 64)
		end)

		ClonedPrefab.CheckMark.TextColor3 = Noclip.Value and Color3.fromRGB(255, 255, 255) or
			Color3.fromRGB(64, 64, 64)

		ClonedPrefab.CheckMark.TextStrokeColor3 = Noclip.Value and Color3.fromRGB(255, 255, 255) or
			Color3.fromRGB(64, 64, 64)
	elseif i == 'GetAllItems' then
		ClonedPrefab.LayoutOrder = 6
		ClonedPrefab.TextLabel.Text = 'Get all gears'
	elseif i == 'ToggleGreenFire' then
		ClonedPrefab.LayoutOrder = 7
		ClonedPrefab.TextLabel.Text = 'Green fire'

		GreenFireEnabled.Changed:Connect(function()
			ClonedPrefab.CheckMark.TextColor3 = GreenFireEnabled.Value and Color3.fromRGB(255, 255, 255) or
				Color3.fromRGB(64, 64, 64)

			ClonedPrefab.CheckMark.TextStrokeColor3 = GreenFireEnabled.Value and Color3.fromRGB(255, 255, 255) or
				Color3.fromRGB(64, 64, 64)
		end)

		ClonedPrefab.CheckMark.TextColor3 = GreenFireEnabled.Value and Color3.fromRGB(255, 255, 255) or
			Color3.fromRGB(64, 64, 64)

		ClonedPrefab.CheckMark.TextStrokeColor3 = GreenFireEnabled.Value and Color3.fromRGB(255, 255, 255) or
			Color3.fromRGB(64, 64, 64)
	elseif i == 'CtrlClickToBuild' then
		ClonedPrefab.LayoutOrder = 8
		ClonedPrefab.TextLabel.Text = 'Ctrl+Click build'

		CtrlClickToBuild.Changed:Connect(function()
			ClonedPrefab.CheckMark.TextColor3 = CtrlClickToBuild.Value and Color3.fromRGB(255, 255, 255) or
				Color3.fromRGB(64, 64, 64)

			ClonedPrefab.CheckMark.TextStrokeColor3 = CtrlClickToBuild.Value and Color3.fromRGB(255, 255, 255) or
				Color3.fromRGB(64, 64, 64)
		end)

		ClonedPrefab.CheckMark.TextColor3 = CtrlClickToBuild.Value and Color3.fromRGB(255, 255, 255) or
			Color3.fromRGB(64, 64, 64)

		ClonedPrefab.CheckMark.TextStrokeColor3 = CtrlClickToBuild.Value and Color3.fromRGB(255, 255, 255) or
			Color3.fromRGB(64, 64, 64)
	elseif i == 'ImmuneToEffects' then
		ClonedPrefab.LayoutOrder = 9
		ClonedPrefab.TextLabel.Text = 'Immune to effects'

		ImmuneToEffects.Changed:Connect(function()
			ClonedPrefab.CheckMark.TextColor3 = ImmuneToEffects.Value and Color3.fromRGB(255, 255, 255) or
				Color3.fromRGB(64, 64, 64)

			ClonedPrefab.CheckMark.TextStrokeColor3 = ImmuneToEffects.Value and Color3.fromRGB(255, 255, 255) or
				Color3.fromRGB(64, 64, 64)
		end)

		ClonedPrefab.CheckMark.TextColor3 = ImmuneToEffects.Value and Color3.fromRGB(255, 255, 255) or
			Color3.fromRGB(64, 64, 64)

		ClonedPrefab.CheckMark.TextStrokeColor3 = ImmuneToEffects.Value and Color3.fromRGB(255, 255, 255) or
			Color3.fromRGB(64, 64, 64)
	elseif i == 'SilentErrors' then
		ClonedPrefab.LayoutOrder = 10
		ClonedPrefab.TextLabel.Text = 'Silent errors'

		SilentErrors.Changed:Connect(function()
			ClonedPrefab.CheckMark.TextColor3 = SilentErrors.Value and Color3.fromRGB(255, 255, 255) or
				Color3.fromRGB(64, 64, 64)

			ClonedPrefab.CheckMark.TextStrokeColor3 = SilentErrors.Value and Color3.fromRGB(255, 255, 255) or
				Color3.fromRGB(64, 64, 64)
		end)

		ClonedPrefab.CheckMark.TextColor3 = SilentErrors.Value and Color3.fromRGB(255, 255, 255) or
			Color3.fromRGB(64, 64, 64)

		ClonedPrefab.CheckMark.TextStrokeColor3 = SilentErrors.Value and Color3.fromRGB(255, 255, 255) or
			Color3.fromRGB(64, 64, 64)
	end

	ClonedPrefab.Parent = V7.Parent
end

for i, v in next, Trackbars do
	local Cloned = V19:Clone()
	Cloned.Name = i:match('%w+')
	Cloned.Visible = true
	Cloned.TextLabel.Text = i
	Cloned.Parent = V15

	MakeTrackbar(Cloned, v, 2 ^ -6)

	if i:upper():find('SPEED') then
		Cloned.LayoutOrder = 1
	elseif i:upper():find('JUMP') then
		Cloned.LayoutOrder = 2
	end
end
