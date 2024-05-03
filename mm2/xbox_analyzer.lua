-- xbox_analyzer.lua
-- by Vov4ik4124

local _4 = Color3.new(0, .4984, 0)

-- source code

local clone = table.clone
local gs = game:GetService('GuiService')
local inst_new = Instance.new
local key_code = Enum.KeyCode
local old_i, old_nc
local uis = game:GetService('UserInputService')
local uit = Enum.UserInputType
local uit_gamepads = {uit.Gamepad1, uit.Gamepad2}

-- logic

local ui = inst_new('ScreenGui')
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

local lbl = inst_new('TextLabel')
lbl.AnchorPoint = Vector2.new(0.5, 0.5)
lbl.Archivable = false
lbl.AutoLocalize = false
lbl.BackgroundColor3 = _4
lbl.BackgroundTransparency = 1
lbl.BorderColor3 = _4
lbl.BorderMode = Enum.BorderMode.Outline
lbl.BorderSizePixel = 4
lbl.FontFace = Font.fromEnum(Enum.Font.Ubuntu)
lbl.Interactable = false
lbl.Name = '4'
lbl.Position = UDim2.fromScale(0.5, 0.5)
lbl.Size = UDim2.fromOffset(64, 64)
lbl.Text = '4'
lbl.TextColor3 = Color3.from(255, 255, 255)
lbl.TextScaled = true
lbl.TextStrokeColor3 = _4
lbl.TextStrokeTransparency = 0.4
lbl.ZIndex = 2147483647
lbl:SetAttribute('4', _4)
lbl.Parent = ui

hookfunction(gs.IsTenFootInterface, newcclosure(function(...) return true end))

old_i = hookmetamethod(game, '__index', newcclosure(function(self, key)
	if self == gs then
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
		end
	end

	return old_i(self, key)
end))

old_nc = hookmetamethod(game, '__namecall', newcclosure(function(self, ...)
	local method = getnamecallmethod()

	if self == gs then
		if method == 'IsTenFootInterface' then
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
		elseif method == 'GetNavigationGamepads' then
			return clone(uit_gamepads)
		elseif method == 'GetSupportedGamepadKeyCodes' then
			return key_code:GetEnumItems()
		elseif method == 'IsGamepadButtonDown' then
			return false
		elseif method == 'IsNavigationGamepad' then
			return true
		end
	end

	return old_nc(self, ...)
end))

gs:ForceTenFootInterface(true)
ui.Parent = game:GetService('CoreGui')
warn('Activated XBox forcer')
