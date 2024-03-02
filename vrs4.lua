-- vrs4.lua
-- by @Vov4ik4124

local _4 = Color3.new(0, 0.4984, 0)

-- source code

local env = (getgenv and getgenv()) or _ENV or shared or _G
if not env then return end
local enabled = env.vrs4
local instance_new = Instance.new
local properties = {Button1 = 'OK', Text = enabled and 'The script has been already activated.' or 'Activated the script.', Title = 'The Rooms'}
local starter_gui = game:GetService('StarterGui')
local table_clear = table.clear
starter_gui:SetCore('SendNotification', properties)
table_clear(properties)
if enabled then return end
env.vrs4 = true

local btn_size = UDim2.fromScale(1, 2)
local cas = game:GetService('ContextActionService')
local ccf = instance_new('ColorCorrectionEffect')
local chat = game:GetService('Chat')
local color3_new = Color3.new
local connections_0 = {}
local connections_1 = {}
local debris = game:GetService('Debris')
local get = function(a, b) return a[b] end
local green = Enum.ChatColor.Green
local grey = color3_new(0.5, 0.5, 0.5)
local instance_new = Instance.new
local lighting = game:GetService('Lighting')
local math_max = math.max
local never = Enum.AdornCullingMode.Never
local plrs = game:GetService('Players')
local render_stepped = game:GetService('RunService').RenderStepped
local size = Vector3.new(0.4, 0.4, 0.4)
local smooth_plastic = Enum.Material.SmoothPlastic
local string_find = string.find
local string_gsub = string.gsub
local string_upper = string.upper
local task_defer = task.defer
local terrain = workspace.Terrain
local white = color3_new(1, 1, 1)
local wrapper = function(a, b) return function(c) return a(b, c) end end
local you = plrs.LocalPlayer
local your_gui = you:WaitForChild('PlayerGui')
local vim = game:GetService('VirtualInputManager')
local vim_ske = vim.SendKeyEvent
local vim_smbe = vim.SendMouseButtonEvent
local vim_smme = vim.SendMouseMoveEvent
local vim_smwe = vim.SendMouseWheelEvent

local mouse_click = ({
	is_window_active = function() return true end,
	key_press = function(x) return pcall(vim_ske, vim, true, x or 0, true, nil) and true or false end,
	key_release = function(x) return pcall(vim_ske, vim, false, x or 0, false, nil) and true or false end,
	mouse_click = function(x, y, z) return pcall(vim_smbe, vim, x or 0, y or 0, z or 0, true, nil, 0) and
		task_defer(pcall, vim_smbe, vim, x or 0, y or 0, z or 0, false, nil, 0) and true or false end,
	mouse_move = function(x, y) return pcall(vim_smme, vim, x or 0, y or 0, nil) and true or false end,
	mouse_press = function(x, y, z) return pcall(vim_smbe, vim, x or 0, y or 0, z or 0, true, nil, 0) and true or false end,
	mouse_release = function(x, y, z) return pcall(vim_smbe, vim, x or 0, y or 0, z or 0, false, nil, 0) and true or false end,
	mouse_wheel = function(x, y, z) return pcall(vim_smwe, vim, x or 0, y or 0, z and true or false, nil) and true or false end,
	type_key = function(x) return pcall(vim_ske, vim, true, x or 0, true, nil) and
		task_defer(pcall, vim_ske, vim, false, x or 0, false, nil) and true or false end
}).mouse_click

local properties = {
	Ambient = white,
	Brightness = 4,
	Density = 0,
	Enabled = false,
	EnvironmentDiffuseScale = 0,
	EnvironmentSpecularScale = 0,
	ExposureCompensation = 0,
	FogEnd = 400000,
	FogStart = 400000,
	GlobalShadows = false,
	OutdoorAmbient = white
}

local function action(name, state, _)
	if string_find(string_upper(name), 'RMB', 1, true) and state.Value == 2 then mouse_click(0, 0, 1) end
end

local function bool_passive_val(inst)
	local val = inst:FindFirstChild('Hunt') or inst:FindFirstChild('hunt') or inst:FindFirstChildOfClass('BoolValue')
	if val and val:IsA('BoolValue') then return val.Value end
	return true
end

local function btn_func()
	local char = you.Character
	if not char then return end
	local h = char:FindFirstChildOfClass('Humanoid')
	if not h then return end
	h.WalkSpeed = h.WalkSpeed == 12 and 20 or 12
end

local function create_highlight(pvi, ps)
	local highlight = instance_new('BoxHandleAdornment')
	highlight.AdornCullingMode = never
	highlight.Adornee = pvi
	highlight.AlwaysOnTop = true
	highlight.Archivable = false
	highlight.Color3 = _4
	highlight.Name = 'Highlight4'
	highlight.Size = ps
	highlight.Transparency = 0.1444
	highlight.ZIndex = 4
	highlight:SetAttribute('4', _4)
	highlight.Parent = pvi
end

local function is_unsafe()
	local children = workspace:GetChildren()
	local char = you.Character
	local y = (char and char:GetPivot().Y or 0) - 60

	for idx = 1, #children do
		local child = children[idx]
		local name = child.Name
		local upper_name = string_upper(name)
		local match = string_find(name, '%a%d+') or string_find(upper_name, 'MONSTER%d*') or
			string_find(name, '%a%-%d+') or string_find(upper_name, 'MONSTER%-%d*')

		if child:IsA('BasePart') and child.ClassName ~= 'Terrain' and match and child.Position.Y >= y and
			child:GetAttribute('done') ~= false and child:GetAttribute('Done') ~= false and bool_passive_val(child) then
			table_clear(children)
			return true
		end
	end

	table_clear(children)
	return false
end

local function li_reset(inst)
	if inst:GetAttribute('4') == _4 then return end

	for str, _ in next, properties do
		local attr = '4' .. str
		local old_val = inst:GetAttribute(attr)
		if not old_val then continue end
		inst[str] = old_val
		inst:SetAttribute(attr, nil)
	end
end

local function li_set(inst, str)
	if inst:GetAttribute('4') == _4 or (str and not properties[str]) then return end
	local connection = connections_0[inst]
	if connection then connection:Disconnect() end

	for str, val in next, properties do
		local exists, old_val = pcall(get, inst, str)
		if not exists or old_val == val then continue end
		inst[str] = val
		inst:SetAttribute('4' .. str, old_val)
	end

	assert(typeof(inst) == 'Instance')
	connections_0[inst] = inst.Changed:Connect(wrapper(li_set, inst))
end

local function r_disable()
	local list = {lighting, workspace.Terrain, workspace.CurrentCamera}
	ccf.Parent = nil

	for _, connection in next, connections_0 do connection:Disconnect() end
	table_clear(connections_0)
	for _, connection in next, connections_1 do connection:Disconnect() end
	table_clear(connections_1)

	for idx = 1, #list do
		local element = list[idx]
		li_reset(element)
		local children = element:GetChildren()
		for idx = 1, #children do li_reset(children[idx]) end
		table_clear(children)
	end

	table_clear(list)
end

local function r_enable()
	local list = {lighting, workspace.Terrain, workspace.CurrentCamera}

	for idx = 1, #list do
		local element = list[idx]
		local connection = connections_1[element]
		if connection then connection:Disconnect() end
		connections_1[element] = element.ChildAdded:Connect(li_set)
		li_set(element, '')
		local children = element:GetChildren()
		for idx = 1, #children do li_set(children[idx], '') end
		table_clear(children)
	end

	ccf.Parent = lighting
	table_clear(list)
end

local function sprint_button()
	local bar = (your_gui:WaitForChild('stamina', 1) or game):WaitForChild('back', 1)
	if not bar or bar:FindFirstChildOfClass('TextButton') then return end
	local btn = instance_new('TextButton')
	btn.Archivable = false
	btn.Size = btn_size
	btn.Transparency = 1
	btn:SetAttribute('4', _4)
	btn.Parent = bar
	btn.Activated:Connect(btn_func)
end

-- logic

cas:BindAction('4console', function() starter_gui:SetCore('DevConsoleVisible', true) end, true)
cas:BindAction('4rmb', action, true)
cas:SetTitle('4console', 'F9')
cas:SetTitle('4rmb', 'RC')
ccf.Archivable = false
ccf.Name = '4'
ccf.TintColor = _4
ccf:SetAttribute('4', _4)
coroutine.resume(coroutine.create(sprint_button))
do (workspace:FindFirstChild('monster') or terrain).CanTouch = false end
do (workspace:FindFirstChild('monster2') or terrain).CanTouch = false end
you.CameraMode, you.CameraMaxZoomDistance, you.CameraMinZoomDistance, you.CameraMinZoomDistance = 0, 12, 8, 0.5
you.CharacterAdded:Connect(sprint_button)
plrs.ChildRemoved:Connect(function(child)
	local char = workspace:FindFirstChild(child.Name)
	if not char then return end
	char:SetAttribute('4', _4)
	create_highlight(char, select(2, char:GetBoundingBox()))
end)

workspace.ChildAdded:Connect(function(child)
	if child.Name ~= 'battery' then return end
	create_highlight(child, size)
end)

workspace.ChildRemoved:Connect(function(child)
	if typeof(child) ~= 'Instance' or you.Character == child then return end
	local h = child:FindFirstChildOfClass('Humanoid')
	if not h or (h:GetState().Value == 15 and child:GetAttribute('4') ~= _4) then return end
	local hint = workspace:FindFirstChildOfClass('Hint')
	if hint then hint:Destroy() end
	local msg = instance_new('Hint')
	msg.Archivable = false
	msg.Text = child.Name .. ' has left the game.'
	msg:SetAttribute('4', _4)
	msg.Parent = workspace
	debris:AddItem(msg, 4)
end)

if game:GetService('TextChatService').ChatVersion == Enum.ChatVersion.LegacyChatService then
	local frame = ((your_gui:WaitForChild('Chat', 4) or game):WaitForChild('Frame', 4) or game):WaitForChild('ChatChannelParentFrame', 4)
	if not frame then return end
	local scroller = frame:FindFirstChild('Scroller', true)
	if not scroller then return end
	scroller.ChildAdded:Connect(function(child)
		local lbl = child:WaitForChild('TextLabel')
		while string_find(lbl.Text, '_', 1, true) and lbl.Changed:Wait() ~= 'Text' do end
		local prefix_lbl = lbl:FindFirstChildOfClass('TextButton')
		local prefix_text = typeof(prefix_lbl) == 'Instance' and prefix_lbl:IsA('TextButton') and prefix_lbl.Text or ''
		local msg = string_gsub(lbl.Text, '^%s*', '')
		local plr = workspace:FindFirstChild(string_gsub(prefix_text, '[%[%]%s:]*', ''))
		if plr and plr:GetAttribute('4') == _4 then chat:Chat(plr:WaitForChild('Head'), msg, green) end
		print(prefix_text .. ' ' .. msg)
	end)
end

while true do
	render_stepped:Wait()
	lighting.Brightness, lighting.ClockTime, lighting.OutdoorAmbient = 5, 14, grey
	local is_active = connections_1[lighting]

	if is_unsafe() then
		if not is_active then r_enable() end
	else
		if is_active then r_disable() end
	end

	local char = you.Character
	if not char then continue end
	local h = char:FindFirstChild('Humanoid')
	if not h or h:GetState().Value == 15 then continue end
	local children = workspace:GetChildren()
	local pos = char:GetPivot().Position
	local len = #children

	for idx = len, math_max(1, len - 25), -1 do
		local door = children[idx]:FindFirstChild('door')
		if not door then continue end
		local cd = door:FindFirstChildOfClass('ClickDetector')
		if not cd or cd:GetAttribute('4') == _4 or (door.Position - pos).Magnitude > (cd.MaxActivationDistance + 4) then continue end
		cd:SetAttribute('4', _4)
		fireclickdetector(cd)
	end

	table_clear(children)
end
