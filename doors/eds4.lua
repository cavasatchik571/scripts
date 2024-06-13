-- eds4.lua
-- by unknown

local _4 = Color3.new(0, .4984, 0)

-- source code

local empty_func = function(...) end
local env = (getgenv or empty_func)() or _ENV or shared or _G
local fpp = fireproximityprompt or fire_proximity_prompt or empty_func
local gncm = getnamecallmethod or empty_func
local hf = hookfunction or empty_func
local hmm = hookmetamethod or empty_func
local nc = newcclosure or empty_func
local place_id = game.PlaceId
if env.bha4 or (place_id ~= 6839171747 and place_id ~= 10549820578) then return end
env.bha4 = true

local auto_prompts = {}
local clone = game.Clone
local color3_from_rgb = Color3.fromRGB
local core_gui = game:GetService('CoreGui')
local coroutine_create = coroutine.create
local coroutine_resume = coroutine.resume
local current_rooms = workspace:WaitForChild('CurrentRooms')
local heartbeat = game:GetService('RunService').Heartbeat
local idl = {}
local ignore_symbol = newproxy(false)
local inst_new = Instance.new
local lbls = {}
local plrs = game:GetService('Players')
local points = {}
local properties = {}
local re = game:GetService('ReplicatedStorage')
local smooth = Enum.SurfaceType.Smooth
local smooth_plastic = Enum.Material.SmoothPlastic
local starter_gui = game:GetService('StarterGui')
local string_find = string.find
local table_clear = table.clear
local table_concat = table.concat
local task_wait = task.wait
local udim2_from_scale = UDim2.fromScale
local vec3_bha4 = Vector3.new(0.44, 1.44, 0.44)
local vec3_zero = Vector3.zero

local black = color3_from_rgb(0, 0, 0)
local frame = inst_new('Frame')
local full = udim2_from_scale(1, 1)
local latest_room = re:WaitForChild('GameData'):WaitForChild('LatestRoom')
local latest_room_changed = latest_room.Changed
local old_function_is = empty_func
local old_function_fs = empty_func
local old_namecall = empty_func
local starter_gui_set_core = starter_gui.SetCore
local ubuntu = Font.new('rbxasset://fonts/families/Ubuntu.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
local white = color3_from_rgb(255, 255, 255)
local you = plrs.LocalPlayer
local your_gui = pcall(tostring, core_gui) and core_gui or you:WaitForChild('PlayerGui')
local patterns: any = setmetatable({}, {__newindex = function(t, k, v) if k ~= nil then rawset(t, k, v) end end})
local raw_lbl4 = inst_new('TextLabel')
raw_lbl4.BackgroundColor3 = _4
raw_lbl4.BackgroundTransparency = 1
raw_lbl4.BorderColor3 = _4
raw_lbl4.BorderSizePixel = 0
raw_lbl4.FontFace = Font.fromEnum(Enum.Font.SourceSansSemibold)
raw_lbl4.Name = 'TextLabel4'
raw_lbl4.Size = full
raw_lbl4.Text = ''
raw_lbl4.TextColor3 = white
raw_lbl4.TextScaled = true
raw_lbl4.TextStrokeColor3 = _4
raw_lbl4.TextStrokeTransparency = 0
raw_lbl4.Visible = false
raw_lbl4:SetAttribute('4', _4)

local raw_bha4 = inst_new('BoxHandleAdornment')
raw_bha4.AdornCullingMode = Enum.AdornCullingMode.Never
raw_bha4.AlwaysOnTop = true
raw_bha4.Color3 = _4
raw_bha4.Name = 'bha4'
raw_bha4.Transparency = 0.744
raw_bha4.ZIndex = 4
raw_bha4:SetAttribute('4', _4)

local light_part = inst_new('Part')
light_part.Anchored = true
light_part.Archivable = false
light_part.BackSurface = smooth
light_part.BottomSurface = smooth
light_part.CanCollide = false
light_part.CanQuery = false
light_part.CanTouch = false
light_part.CastShadow = false
light_part.Color = _4
light_part.EnableFluidForces = false
light_part.FrontSurface = smooth
light_part.LeftSurface = smooth
light_part.Massless = true
light_part.Material = smooth_plastic
light_part.Name = '4'
light_part.RightSurface = smooth
light_part.Size = vec3_bha4
light_part.TopSurface = smooth
light_part.Transparency	= 1
light_part:SetAttribute('4', _4)

local light_inst = inst_new('PointLight')
light_inst.Archivable = false
light_inst.Brightness = 2.14
light_inst.Color = _4
light_inst.Enabled = true
light_inst.Name = '4'
light_inst.Range = 44
light_inst.Shadows = false
light_inst:SetAttribute('4', _4)
light_inst.Parent = light_part
light_part.Parent = workspace

local function child_added_rs(child)
	local name = child.Name
	if name ~= 'EntityInfo' and name ~= 'RemotesFolder' then return end
	patterns[child:WaitForChild('A90', 4)] = {false}
	patterns[child:WaitForChild('ClutchHeartbeat', 4)] = {ignore_symbol, true}
	patterns[child:WaitForChild('Dread', 4)] = ignore_symbol
	patterns[child:WaitForChild('MotorReplication', 4)] = {ignore_symbol, ignore_symbol, ignore_symbol, ignore_symbol}
	patterns[child:WaitForChild('Screech', 4)] = {true}
	patterns[child:WaitForChild('ShadeResult', 4)] = ignore_symbol
end

local function child_added_w(child)
	if child == nil or typeof(child) ~= 'Instance' or child.ClassName ~= 'Model' then return end
	task_wait(0.004)
	if not child:IsA('Model') or plrs:FindFirstChild(child.Name) then
		return
	end

	local lbl4 = clone(raw_lbl4)
	lbl4.Archivable = false
	lbl4.Text = child.Name
	lbls[child] = lbl4
	lbl4.Parent = frame
end

local function child_removed(child)
	local lbl4 = lbls[child]
	if lbl4 ~= nil and typeof(lbl4) == 'Instance' then lbl4:Destroy() end
	lbls[child] = nil
end

local function get_deg(pos)
	local children = workspace:GetChildren()

	for idx = 1, #children do
		local child = children[idx]
		if not child:IsA('Model') or (child:GetPivot().Position - pos).Magnitude > 240 then continue end
		local core = child:FindFirstChild('Core')
		if not core then continue end
		local light = core:FindFirstChildOfClass('PointLight')
		if not light or not light.Enabled then continue end
		local name = child.Name

		if name == 'BackdoorLookman' then
			table_clear(children)
			return -90
		elseif name == 'Eyes' then
			table_clear(children)
			return 90
		end
	end

	table_clear(children)
	return ignore_symbol
end

local function get_library_code()
	local bp = you.Backpack or game
	local char = you.Character or game
	local he = you.PlayerGui.PermUI:FindFirstChild('Hints')
	local paper = (bp:FindFirstChild('LibraryHintPaper') or bp:FindFirstChild('LibraryHintPaperHard') or
		char:FindFirstChild('LibraryHintPaper') or char:FindFirstChild('LibraryHintPaperHard'))

	if not he or not paper then return '' end
	local code = {}
	local hints = he:GetChildren()
	local map = {}
	local ui = paper.UI:GetChildren()
	for idx = 1, #hints do
		local icon = hints[idx]
		if icon.Name ~= 'Icon' then continue end
		map[icon.ImageRectOffset.X] = icon.TextLabel.Text
	end

	for idx = 1, #map do map[idx] = '?' end
	for idx = 1, #ui do
		local child = ui[idx]
		local id = tonumber(child.Name)
		if not id then continue end
		local number = map[child.ImageRectOffset.X]
		if not number then continue end
		code[id] = number
	end

	local result = table_concat(code)
	table_clear(code)
	table_clear(hints)
	table_clear(map)
	table_clear(ui)
	return result
end

local function get_pos(obj)
	if obj == nil or typeof(obj) ~= 'Instance' then return vec3_zero end
	return (obj:IsA('Attachment') and obj.WorldPosition) or (obj:IsA('PVInstance') and obj:GetPivot().Position) or vec3_zero
end

local function remote_call(func, self, ...)
	local pattern = patterns[self]
	if pattern == ignore_symbol then return end

	if pattern then
		local args = {...}

		for idx = 1, #args do
			local val = pattern[idx]
			if val == ignore_symbol then continue end
			args[idx] = val
		end

		return func(self, unpack(args))  
	else
		return func(self, ...)
	end
end

local function send_notification(...)
	local args = {...}
	for idx = 1, #args, 2 do properties[args[idx]] = args[idx + 1] end
	while not pcall(starter_gui_set_core, starter_gui, 'SendNotification', properties) do task_wait(0.5) end
	table_clear(properties)
end

local function solve_ebf(real) real.EBF:FireServer() end
local function solve_pl(real, prompt) real.PL:FireServer(typeof(prompt) == 'string' and #prompt == 5 and tonumber(prompt) and prompt or '00000') end
local function descendant_added_cr(descendant)
	if descendant == nil or typeof(descendant) ~= 'Instance' then return end
	task_wait(0.004)
	local class_name, name = descendant.ClassName, descendant.Name
	local is_door, is_tl = name == 'Door', name == 'TimerLever'

	if class_name == 'Model' and descendant:IsA('Model') and (is_door or is_tl or name == 'FigureRagdoll' or name == 'LeverForGate' or
		name == 'LiveBreakerPolePickup' or name == 'LiveHintBook' or string_find(name, 'KeyObtain', 1, true) ~= nil) then
		local display = is_door and descendant:WaitForChild('Door') or descendant
		if not display:IsA('PVInstance') then return end
		local bha4 = clone(raw_bha4)
		local function update()
			local size = vec3_bha4

			if display:IsA('BasePart') then
				size = display.Size
			elseif display:IsA('Model') then
				size = select(2, descendant:GetBoundingBox())
			end

			bha4.Size = size
		end

		bha4.Adornee = display
		bha4.Archivable = false
		update()
		local connection = descendant.ChildAdded:Connect(update)
		bha4.Parent = descendant

		if is_door then
			local number = (tonumber((descendant.Parent or game).Name) or 0) + 1
			while latest_room.Value < number do latest_room_changed:Wait() end
			bha4:Destroy()
			connection:Disconnect()
		elseif is_tl then
			local label = descendant:WaitForChild('TakeTimer'):WaitForChild('TextLabel')
			if not label:IsA('TextLabel') then return end
			local label_changed = label.Changed
			while label.Text ~= '00:00' do label_changed:Wait() end
			bha4:Destroy()
			connection:Disconnect()
		end
	elseif class_name == 'ProximityPrompt' and descendant:IsA('ProximityPrompt') and (name == 'LootPrompt' or name == 'ModulePrompt') then
		auto_prompts[descendant] = true
	end
end

local function descendant_added_w(descendant)
	if not descendant:IsA('BasePart') then return end
	if descendant.Parent == you.Character then
		local name = descendant.Name
		descendant.CanTouch = name == 'Collision' or
			string_find(name, 'Foot', 1, true) ~= nil or
			string_find(name, 'Leg', 1, true) ~= nil
	elseif descendant:IsDescendantOf(current_rooms) then
		local id = (descendant.Parent or game).Name .. '.' .. descendant.Name
		descendant.CanTouch = string_find(id, 'Door%a*%.Hidden') ~= nil or
			string_find(id, 'ElevatorCar%.CollisionFloor') ~= nil or
			string_find(id, 'KeyObtain%.Hitbox') ~= nil or
			string_find(id, 'TriggerEventCollision%.Collision') ~= nil
	else
		descendant.CanTouch = false
	end
end

local function descendant_added_you(descendant)
	if typeof(descendant) ~= 'Instance' or descendant.Name ~= 'MinigameBackout' or descendant:FindFirstChild('Interact') then return end
	local interact_btn = inst_new('TextButton')
	interact_btn.AutoButtonColor = false
	interact_btn.AutoLocalize = false
	interact_btn.BackgroundColor3 = black
	interact_btn.BackgroundTransparency = 0.5
	interact_btn.BorderColor3 = _4
	interact_btn.BorderMode = Enum.BorderMode.Outline
	interact_btn.BorderSizePixel = 0
	interact_btn.FontFace = ubuntu
	interact_btn.MaxVisibleGraphemes = 1
	interact_btn.Name = 'Interact'
	interact_btn.Position = udim2_from_scale(0, -1.05)
	interact_btn.Size = udim2_from_scale(0.64, 0.64)
	interact_btn.SizeConstraint = Enum.SizeConstraint.RelativeYY
	interact_btn.Text = '4'
	interact_btn.TextColor3 = white
	interact_btn.TextScaled = true
	interact_btn.TextStrokeColor3 = _4
	interact_btn.TextStrokeTransparency = 0
	interact_btn.Parent = descendant
	interact_btn.Activated:Connect(function()
		local real = re:FindFirstChild('RemotesFolder') or re:FindFirstChild('EntityInfo')
		if not real then return end
		local room = re.GameData.LatestRoom.Value
		if room == 50 then
			solve_pl(real, get_library_code())
		elseif room == 100 then
			solve_ebf(real)
		end
	end)
end

-- logic

local ui = inst_new('ScreenGui')
ui.Archivable = false
ui.ClipToDeviceSafeArea = false
ui.DisplayOrder = 4000
ui.IgnoreGuiInset = false
ui.Name = 'EasierDoorsUI'
ui.ResetOnSpawn = false
ui.Parent = your_gui

local list_layout = inst_new('UIListLayout')
list_layout.Archivable = false
list_layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
list_layout.SortOrder = Enum.SortOrder.LayoutOrder
list_layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
list_layout.Parent = frame

frame.AnchorPoint = Vector2.one
frame.Archivable = false
frame.BackgroundTransparency = 1
frame.Position = UDim2.new(1, -8, 1, -8)
frame.Size = udim2_from_scale(0.224, 0.104)
frame.Parent = ui
re.ChildAdded:Connect(child_added_rs)
local children = re:GetChildren()
for idx = 1, #children do coroutine_resume(coroutine_create(child_added_rs), children[idx]) end
table_clear(children)
workspace.ChildAdded:Connect(child_added_w)
workspace.ChildRemoved:Connect(child_removed)
local children = workspace:GetChildren()
for idx = 1, #children do coroutine_resume(coroutine_create(child_added_w), children[idx]) end
table_clear(children)
current_rooms.DescendantAdded:Connect(descendant_added_cr)
current_rooms.DescendantRemoving:Connect(function(descendant) auto_prompts[descendant] = nil end)
local descendants = current_rooms:GetDescendants()
for idx = 1, #descendants do coroutine_resume(coroutine_create(descendant_added_cr), descendants[idx]) end
table_clear(descendants)
you.DescendantAdded:Connect(descendant_added_you)
local descendants = you:GetDescendants()
for idx = 1, #descendants do coroutine_resume(coroutine_create(descendant_added_you), descendants[idx]) end
table_clear(descendants)
workspace.DescendantAdded:Connect(descendant_added_w)
local descendants = workspace:GetDescendants()
for idx = 1, #descendants do coroutine_resume(coroutine_create(descendant_added_w), descendants[idx]) end
table_clear(descendants)
old_function_fs = hf(inst_new('RemoteEvent').FireServer, nc(function(self, ...) return remote_call(old_function_fs, self, ...) end))
old_function_is = hf(inst_new('RemoteFunction').InvokeServer, nc(function(self, ...) return remote_call(old_function_is, self, ...) end))
old_namecall = hmm(game, '__namecall', nc(function(self, ...)
	local ncm = gncm()
	if ncm ~= 'FireServer' and ncm ~= 'InvokeServer' then return old_namecall(self, ...) end
	return remote_call(old_namecall, self, ...)
end))

send_notification('Button1', 'OK', 'Duration', 4, 'Icon', 'rbxassetid://7440784829', 'Text', 'The exploit has been activated', 'Title', '4')

while true do
	task_wait(0.144)
	local cam = workspace.CurrentCamera
	if cam == nil then continue end
	local cam_pos = cam.CFrame.Position
	for model, lbl4 in next, lbls do lbl4.Visible = (cam_pos - model:GetPivot().Position).Magnitude <= 4800 end
	light_part.Position = cam_pos
	for prompt, enabled in next, auto_prompts do
		if not enabled or prompt.HoldDuration > 0.04 then continue end
		local parent = prompt.Parent
		if parent == nil then continue end
		local point = get_pos(parent)
		if (cam_pos - point).Magnitude > prompt.MaxActivationDistance or not select(2, cam:WorldToViewportPoint(point)) then continue end
		idl[2], points[1] = ((parent:IsA('Attachment') and parent.Parent or parent).Parent or game).Parent, point
		local succ = true
		local list = cam:GetPartsObscuringTarget(points, idl)
		local len = #list
		for idx = 1, len do
			local element = list[idx]
			if element.Transparency > 0 or not element.CanCollide then continue end
			succ = false
			break
		end

		table_clear(list)
		if not succ then continue end
		fpp(prompt)
	end

	local deg = get_deg(cam_pos)
	for inst, pattern in next, patterns do
		if inst.Name ~= 'MotorReplication' then continue end
		pattern[1], pattern[2], pattern[3] = ignore_symbol, deg, ignore_symbol
	end
end
