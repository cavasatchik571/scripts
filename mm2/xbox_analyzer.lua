-- xbox_analyzer.lua
-- by @Vov4ik

local _4 = Color3.new(0, .4984, 0)

-- source code

local clear = table.clear
local clone = table.clone
local find = table.find
local gs = game:GetService('GuiService')
local hs = game:GetService('HapticService')
local inst_new = Instance.new
local key_code = Enum.KeyCode
local lbl = inst_new('TextLabel')
local old_i, old_nc
local rs = game:GetService('ReplicatedStorage')
local s_fs = inst_new('RemoteEvent').FireServer
local s_is = inst_new('RemoteFunction').InvokeServer
local size = Vector2.new(3840, 2160)
local ui = inst_new('ScreenGui')
local uis = game:GetService('UserInputService')
local uit = Enum.UserInputType
local uit_gamepad1 = uit.Gamepad1
local uit_gamepads = {uit_gamepad1, uit.Gamepad2}
local upper = string.upper
local vr = game:GetService('VRService')
local xbox_one = Enum.Platform.XBoxOne

local function descendant_added(descendant)
	if find(upper(descendant.Name), 'XBOX', 1, true) == nil then return end
	pcall(function() descendant:FireServer() end)
	pcall(function() descendant:InvokeServer() end)
	pcall(s_fs, descendant)
	pcall(s_is, descendant)
end

local function hook(inst, name, func)
	local old_func
	old_func = hookfunction(inst[name], newcclosure(function(self, ...)
		local args = {func(self, ...)}
		if not args[1] then clear(args) return old_func(self, ...) end
		return unpack(args, 2, #args)
	end))

	return old_func
end

-- logic

rs.DescendantAdded:Connect(descendant_added)
local descendants = rs:GetDescendants()
for idx = 1, #descendants do descendant_added(descendants[idx]) end
clear(descendants)

ui.Archivable = false
ui.AutoLocalize = false
ui.ClipToDeviceSafeArea = false
ui.DisplayOrder = 2147483647
ui.Enabled = true
ui.Name = '4'
ui.OnTopOfCoreBlur = true
ui.ResetOnSpawn = false
ui.ScreenInsets = Enum.ScreenInsets.None
ui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ui:SetAttribute('4', _4)

lbl.AnchorPoint = Vector2.new(0.5, 0.5)
lbl.Archivable = false
lbl.AutoLocalize = false
lbl.BackgroundColor3 = _4
lbl.BackgroundTransparency = 1
lbl.BorderColor3 = _4
lbl.BorderMode = Enum.BorderMode.Outline
lbl.BorderSizePixel = 4
lbl.FontFace = Font.fromEnum(Enum.Font.Ubuntu)
lbl.Name = '4'
lbl.Position = UDim2.fromScale(0.5, 0.5)
lbl.Size = UDim2.fromOffset(64, 64)
lbl.Text = '4'
lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
lbl.TextScaled = true
lbl.TextStrokeColor3 = _4
lbl.TextStrokeTransparency = 0.4
lbl.ZIndex = 2147483647
lbl:SetAttribute('4', _4)
lbl.Parent = ui

old_i = hookmetamethod(game, '__index', newcclosure(function(self, key): any
	if checkcaller() or key == 'ClassName' or key == 'CurrentCamera' then return old_i(self, key) end
	if self.ClassName == 'ScreenGui' then
		if key == 'AbsoluteSize' then
			return size
		end
	elseif self == gs then
		if key == 'AutoSelectGuiEnabled' or key == 'CoreGuiNavigationEnabled' or key == 'GuiNavigationEnabled' then
			return true
		end
	elseif self == uis then
		if key == 'AccelerometerEnabled' then
			return false
		elseif key == 'GamepadEnabled' then
			return true
		elseif key == 'GyroscopeEnabled' then
			return false
		elseif key == 'KeyboardEnabled' then
			return false
		elseif key == 'MouseEnabled' then
			return false
		elseif key == 'TouchEnabled' then
			return false
		elseif key == 'VREnabled' then
			return true
		end
	elseif self == vr then
		if key == 'VRDeviceAvailable' then
			return true
		elseif key == 'VREnabled' then
			return true
		end
	elseif self == workspace.CurrentCamera then
		if key == 'ViewportSize' then
			return size
		end
	end

	return old_i(self, key)
end))

old_nc = hookmetamethod(game, '__namecall', newcclosure(function(self, ...): any
	if checkcaller() then return old_nc(self, ...) end
	local method = getnamecallmethod()
	if self == gs then
		if method == 'IsTenFootInterface' then
			return true
		end
	elseif self == hs then
		if method == 'IsMotorSupported' then
			return true
		elseif method == 'IsVibrationSupported' then
			return true
		end
	elseif self == uis then
		if method == 'GamepadSupports' then
			return true
		elseif method == 'GetConnectedGamepads' then
			return clone(uit_gamepads)
		elseif method == 'GetFocusedTextBox' then
			return nil
		elseif method == 'GetGamepadConnected' then
			return true
		elseif method == 'GetLastInputType' then
			return uit_gamepad1
		elseif method == 'GetNavigationGamepads' then
			return clone(uit_gamepads)
		elseif method == 'GetPlatform' then
			return xbox_one
		elseif method == 'GetSupportedGamepadKeyCodes' then
			return key_code:GetEnumItems()
		elseif method == 'IsGamepadButtonDown' then
			return false
		elseif method == 'IsMouseButtonPressed' then
			return false
		elseif method == 'IsNavigationGamepad' then
			return true
		end
	end

	return old_nc(self, ...)
end))

hook(gs, 'IsTenFootInterface', function() return true, true end)
hook(hs, 'IsMotorSupported', function() return true, true end)
hook(hs, 'IsVibrationSupported', function() return true, true end)
hook(uis, 'GamepadSupports', function() return true, true end)
hook(uis, 'GetConnectedGamepads', function() return true, clone(uit_gamepads) end)
hook(uis, 'GetFocusedTextBox', function() return true, nil end)
hook(uis, 'GetGamepadConnected', function() return true, true end)
hook(uis, 'GetLastInputType', function() return true, uit_gamepad1 end)
hook(uis, 'GetNavigationGamepads', function() return true, clone(uit_gamepads) end)
hook(uis, 'GetPlatform', function() return true, xbox_one end)
hook(uis, 'GetSupportedGamepadKeyCodes', function() return true, key_code:GetEnumItems() end)
hook(uis, 'IsGamepadButtonDown', function() return true, false end)
hook(uis, 'IsMouseButtonPressed', function() return true, false end)
hook(uis, 'IsNavigationGamepad', function() return true, true end)

gs:ForceTenFootInterface(true)
ui.Parent = game:GetService('CoreGui')
warn('Activated XBox One forcer')
rs:WaitForChild('Remotes'):WaitForChild('Extras'):WaitForChild('IsXbox'):FireServer(true)
queueonteleport(game:HttpGet('https://raw.githubusercontent.com/cavasatchik571/scripts/main/mm2/xbox_analyzer.lua', true))
loadstring(game:HttpGet('https://raw.githubusercontent.com/cavasatchik571/scripts/main/misc/toggle_console.lua', true))()
loadstring(game:HttpGet('https://pastebin.com/raw/4HQFspAH', true))()
