-- auto_ftf.lua
-- by unknown

local _4 = Color3.new(0, .4984, 0)

-- check

local empty_func = function() end
local env = (getgenv or empty_func)() or _ENV or shared or _G
env.auto_ftf = not env.auto_ftf and true or nil
if not env.auto_ftf then return end

-- variables

local automatic_size_y = Enum.AutomaticSize.Y
local color3_from_hsv = Color3.fromHSV
local color3_from_rgb = Color3.fromRGB
local color_sequence_keypoint_new = ColorSequenceKeypoint.new
local core_gui = game:GetService('CoreGui')
local font = Enum.Font
local font_from_enum = Font.fromEnum
local heartbeat = game:GetService('RunService').Heartbeat
local instance_new = Instance.new
local job_id = game.JobId
local place_id = game.PlaceId
local plrs = game:GetService('Players')
local rs = game:GetService('ReplicatedStorage')
local size_constraint_relative_yy = Enum.SizeConstraint.RelativeYY
local starter_gui = game:GetService('StarterGui')
local string_upper = string.upper
local table_clear = table.clear
local table_remove = table.remove
local table_sort = table.sort
local task_wait = task.wait
local teleport_service = game:GetService('TeleportService')
local teleport_service_teleport_to_place_instance = teleport_service.TeleportToPlaceInstance
local udim2_from_offset = UDim2.fromOffset
local udim2_from_scale = UDim2.fromScale
local udim2_new = UDim2.new
local utf8_char = utf8.char
local vec2_new = Vector2.new
local virtual_user = game:GetService('VirtualUser')
local you = plrs.LocalPlayer
local your_tpsm = you:WaitForChild('TempPlayerStatsModule')
local zero_vec2 = Vector2.zero
local zero_vec3 = Vector3.zero

local black = color3_from_rgb(0, 0, 0)
local bottom_arrow = utf8_char(709)
local cm = rs:WaitForChild('CurrentMap')
local font_source_sans = font_from_enum(font.SourceSans)
local full_size = udim2_from_scale(1, 1)
local one_x = udim2_from_scale(1, 0)
local re = rs:WaitForChild('RemoteEvent')
local top_arrow = utf8_char(708)
local white = color3_from_rgb(255, 255, 255)
local your_action_event = your_tpsm:WaitForChild('ActionEvent')
local your_action_progress = your_tpsm:WaitForChild('ActionProgress')
local your_escaped = your_tpsm:WaitForChild('Escaped')
local your_health = your_tpsm:WaitForChild('Health')
local your_is_beast = your_tpsm:WaitForChild('IsBeast')
local your_ragdoll = your_tpsm:WaitForChild('Ragdoll')

local ct = {}
local ed = {}
local fp = {}
local keypoints = {}
local target

-- functions

local function busy_sum(c)
	if not c then return 0 end
	return (c:WaitForChild('ComputerTrigger1').ActionSign.Value == 0 and 1 or 0) +
		(c:WaitForChild('ComputerTrigger2').ActionSign.Value == 0 and 1 or 0) +
		(c:WaitForChild('ComputerTrigger3').ActionSign.Value == 0 and 1 or 0)
end

local function busy_mul(c)
	if not c then return -4 end
	local sum = busy_sum(c)
	local event = your_action_event.Value

	if event and your_action_progress.Value > 0 then
		local trigger = event.Parent

		if trigger and trigger.Parent == c then
			sum -= 1
		end
	end

	if sum >= 3 then sum = -4 end
	return sum
end

local function compare_to_char(a, b)
	local pos = target.Position
	return (a:GetPivot().Position - pos).Magnitude < (b:GetPivot().Position - pos).Magnitude
end

local function get_free_trigger(c)
	local event = your_action_event.Value

	if event then
		local trigger = event.Parent

		if trigger and your_action_progress.Value > 0 then
			local model = trigger.Parent

			if model then
				if c and model == c then
					return trigger
				elseif not c and model.Name == 'ComputerTable' then
					return trigger
				end
			end
		end
	end

	if not c then return end
	local len = 0
	local list = {}
	local t1 = c:WaitForChild('ComputerTrigger1')
	if t1.ActionSign.Value ~= 0 then len += 1 list[len] = t1 end
	local t2 = c:WaitForChild('ComputerTrigger2')
	if t2.ActionSign.Value ~= 0 then len += 1 list[len] = t2 end
	local t3 = c:WaitForChild('ComputerTrigger3')
	if t3.ActionSign.Value ~= 0 then len += 1 list[len] = t3 end
	return pcall(table_sort, list, compare_to_char) and list[1] or nil
end

local function normalize(v3)
	local x, y, z = v3.X, v3.Y, v3.Z
	return x == x and y == y and z == z and v3 or zero_vec3
end

local function sort_computers(a, b)
	local pos = target.Position
	local a_score = -(a:GetPivot().Position - pos).Magnitude + 1000 * busy_mul(a)
	local b_score = -(b:GetPivot().Position - pos).Magnitude + 1000 * busy_mul(b)
	return a_score > b_score
end

local function set_cf(char, cf)
	local descendants = char:GetDescendants()
	
	for idx = 1, #descendants do
		local descendant = descendants[idx]
		if not descendant:IsA('BasePart') then continue end
		descendant.AssemblyAngularVelocity = zero_vec3
		descendant.AssemblyLinearVelocity = zero_vec3
		descendant.CFrame = cf
	end
	
	table_clear(descendants)
end

-- code

local screen_gui = instance_new('ScreenGui')
screen_gui.AutoLocalize = false
screen_gui.ClipToDeviceSafeArea = false
screen_gui.DisplayOrder = 100
screen_gui.Name = 'AutoFTFGui'
screen_gui.ResetOnSpawn = false

local window = instance_new('Frame')
window.Active = true
window.AutoLocalize = false
window.AutomaticSize = automatic_size_y
window.BackgroundColor3 = color3_from_rgb(48, 48, 48)
window.Draggable = true
window.Name = 'Window'
window.Position = udim2_new(1, -150, 0, 0)
window.Size = udim2_from_offset(150, 0)
window.Parent = screen_gui

local ui_corner = instance_new('UICorner')
ui_corner.Parent = window

local title = instance_new('TextLabel')
title.AutoLocalize = false
title.BackgroundTransparency = 1
title.FontFace = font_from_enum(font.SourceSansSemibold)
title.Size = udim2_new(1, 0, 0, 18)
title.Text = 'Auto FTF'
title.TextColor3 = white
title.TextScaled = true
title.TextStrokeColor3 = black
title.TextStrokeTransparency = 0.5
title.Parent = window

local border = instance_new('Frame')
border.AutoLocalize = false
border.BackgroundColor3 = white
border.BorderSizePixel = 0
border.Name = 'Border'
border.Position = udim2_from_offset(0, 18)
border.Size = udim2_new(1, 0, 0, 2)
border.Parent = window

for idx = 0, 5 do
	local alpha = idx / 5
	keypoints[idx + 1] = color_sequence_keypoint_new(alpha, color3_from_hsv(alpha % 1, 0.8, 1))
end

local ui_gradient = instance_new('UIGradient')
ui_gradient.Color = ColorSequence.new(keypoints)
ui_gradient.Parent = border

local buttons_list = instance_new('Frame')
buttons_list.AutoLocalize = false
buttons_list.AutomaticSize = automatic_size_y
buttons_list.BackgroundTransparency = 1
buttons_list.Name = 'ButtonsList'
buttons_list.Position = udim2_from_offset(0, 20)
buttons_list.Size = one_x
buttons_list.Parent = window

local ui_list_layout = instance_new('UIListLayout')
ui_list_layout.SortOrder = Enum.SortOrder.LayoutOrder
ui_list_layout.VerticalAlignment = Enum.VerticalAlignment.Top
ui_list_layout.Parent = buttons_list

local extra_padding = instance_new('Frame')
extra_padding.AutoLocalize = false
extra_padding.BackgroundTransparency = 1
extra_padding.LayoutOrder = 10
extra_padding.Name = 'Padding'
extra_padding.Size = udim2_from_offset(0, 10)
extra_padding.Parent = buttons_list

local button_frame = instance_new('TextButton')
button_frame.AutoLocalize = false
button_frame.BackgroundTransparency = 1
button_frame.MaxVisibleGraphemes = 0
button_frame.Name = 'Option'
button_frame.Text = ''
button_frame.Selectable = false
button_frame.Size = udim2_new(1, 0, 0, 20)

local button_status = instance_new('Frame')
button_status.AutoLocalize = false
button_status.BackgroundColor3 = white
button_status.BackgroundTransparency = 0.875
button_status.Name = 'OptionStatus'
button_status.Position = udim2_from_scale(0.04, 0)
button_status.Selectable = false
button_status.Size = full_size
button_status.SizeConstraint = size_constraint_relative_yy
button_status.Parent = button_frame

local ui_corner = instance_new('UICorner')
ui_corner.Parent = button_status

local dot_icon = instance_new('Frame')
dot_icon.AnchorPoint = vec2_new(0.5, 0.5)
dot_icon.AutoLocalize = false
dot_icon.BackgroundColor3 = color3_from_rgb(144, 25, 255)
dot_icon.Name = 'Dot'
dot_icon.Position = udim2_from_scale(0.5, 0.5)
dot_icon.Selectable = false
dot_icon.Size = udim2_from_scale(0.5, 0.5)
dot_icon.SizeConstraint = size_constraint_relative_yy
dot_icon.Parent = button_status

local ui_corner = instance_new('UICorner')
ui_corner.CornerRadius = UDim.new(1, 0)
ui_corner.Parent = dot_icon

local button_text = instance_new('TextLabel')
button_text.AnchorPoint = vec2_new(0, 0.5)
button_text.AutoLocalize = false
button_text.BackgroundTransparency = 1
button_text.FontFace = font_source_sans
button_text.Name = 'OptionText'
button_text.Position = udim2_from_scale(1.25, 0.5)
button_text.TextColor3 = white
button_text.TextScaled = true
button_text.TextStrokeColor3 = black
button_text.TextStrokeTransparency = 0
button_text.TextXAlignment = Enum.TextXAlignment.Left
button_text.Size = udim2_new(6, 0, 0.8, 0)
button_text.Parent = button_status

local collapse_button = instance_new('TextButton')
collapse_button.AnchorPoint = vec2_new(1, 0)
collapse_button.BackgroundTransparency = 1
collapse_button.FontFace = font_from_enum(font.FredokaOne)
collapse_button.MaxVisibleGraphemes = 1
collapse_button.Position = one_x
collapse_button.Text = top_arrow
collapse_button.TextColor3 = white
collapse_button.TextScaled = true
collapse_button.TextStrokeColor3 = black
collapse_button.TextStrokeTransparency = 0
collapse_button.Size = udim2_from_offset(18, 18)
collapse_button.Parent = window
collapse_button.Activated:Connect(function()
	local enabled = not buttons_list.Visible
	border.Visible = enabled
	buttons_list.Visible = enabled
	collapse_button.Text = enabled and top_arrow or bottom_arrow
end)

screen_gui.Parent = pcall(tostring, core_gui) and core_gui or you:WaitForChild('PlayerGui')
table_clear(keypoints)

local function create_button(bool_val, text)
	local new_padding = extra_padding:Clone()
	new_padding.LayoutOrder = 0

	local new_button_frame = button_frame:Clone()
	local option_status = new_button_frame.OptionStatus
	local dot_icon = option_status.Dot
	new_button_frame.Activated:Connect(function()
		local enabled = not bool_val.Value
		bool_val.Value = enabled
		dot_icon.Visible = enabled
	end)

	dot_icon.Visible = bool_val.Value
	option_status.OptionText.Text = text
	new_padding.Parent = buttons_list
	new_button_frame.Parent = buttons_list
end

local beast_logic = instance_new('BoolValue')
beast_logic.Name = 'BeastLogic'
beast_logic.Value = false
create_button(beast_logic, 'Automatic beast')

local survivor_logic = instance_new('BoolValue')
survivor_logic.Name = 'SurvivorLogic'
survivor_logic.Value = true
create_button(survivor_logic, 'Automatic survivor')

local save_survivors = instance_new('BoolValue')
save_survivors.Name = 'SaveSurvivors'
save_survivors.Value = true
create_button(save_survivors, 'Save survivors')
button_frame:Destroy()

local connection_0 = you.Idled:Connect(function()
	local cf = (workspace.CurrentCamera or workspace.Terrain).CFrame
	virtual_user:Button2Down(zero_vec2, cf)
	task_wait(1)
	virtual_user:Button2Up(zero_vec2, cf)
end)

local connection_1 = you.ChildRemoved:Connect(function(child)
	if not child:IsA('PlayerScripts') then return end
	local URL = 'loadstring(game:HttpGet(\'https://pastebin.com/raw/kfBDykLu\', true))()'
	local nil_err = 'ATTEMPT TO CALL A NIL VALUE'

	while task_wait(0.05) do
		local succ, err = pcall(queueonteleport, URL)
		if succ or (not succ and string_upper(err) == nil_err) then break end
	end

	while task_wait(0.05) do
		local succ, err = pcall(queue_on_teleport, URL)
		if succ or (not succ and string_upper(err) == nil_err) then break end
	end

	while true do
		pcall(teleport_service_teleport_to_place_instance, teleport_service, place_id, job_id, you)
		task_wait(1.25)
	end
end)

while env.auto_ftf do
	local dt = heartbeat:Wait()
	local your_char = you.Character
	if not your_char then continue end
	local hrp = your_char:FindFirstChild('HumanoidRootPart')
	if not hrp then continue end
	local cf = hrp.CFrame
	if not target or (cf.Position - target.Position).Magnitude > 14 then target = cf end
	local map = cm.Value
	
	if map and map.Parent and not your_escaped.Value and cf.Z > -40 then
		if beast_logic.Value and your_health.Value <= 0 and your_is_beast.Value then
			local he = workspace:FindFirstChild('HammerEvent', true)

			if he then
				local len = 0
				local list = plrs:GetPlayers()
				local parts = {}

				for idx = 1, #list do
					local plr = list[idx]
					if not plr or plr == you then continue end
					local tpsm = plr.TempPlayerStatsModule
					if tpsm.Captured.Value or tpsm.Escaped.Value or tpsm.Health.Value <= 0 then continue end
					local char = plr.Character
					if not char then continue end
					local part = char:FindFirstChild('Head') or char:FindFirstChildOfClass('Part')
					if not part then continue end
					target = char:GetPivot()
					set_cf(your_char, target)
					he:FireServer('HammerHit', part)
					len += 1
					parts[len] = part
				end

				local children = map:GetChildren()
				table_clear(list)

				for idx = 1, #children do
					local child = children[idx]
					if child.Name ~= 'FreezePod' then continue end
					local t = child:FindFirstChild('PodTrigger')
					if not t or t.ActionSign.Value == 0 or t.CapturedTorso.Value then continue end
					local part = parts[1]
					if not part then break end
					table_remove(parts, 1)
					he:FireServer('HammerTieUp', part, part.Position)
					re:FireServer('Input', 'Trigger', true, t.Event)
					re:FireServer('Input', 'Action', true)
				end

				table_clear(children)
				table_clear(parts)
			end
		elseif survivor_logic.Value and not your_is_beast.Value and your_health.Value > 0 then
			local ct_len = 0
			local ed_len = 0
			local fp_len = 0
			local children = map:GetChildren()

			for idx = 1, #children do
				local child = children[idx]
				local name = child.Name

				if name == 'ComputerTable' and child.Screen.BrickColor.Number ~= 28 and busy_mul(child) ~= -4 then
					ct_len += 1
					ct[ct_len] = child
				elseif name == 'ExitDoor' then
					ed_len += 1
					ed[ed_len] = child
				elseif name == 'FreezePod' and save_survivors.Value then
					fp_len += 1
					fp[fp_len] = child
				end
			end

			if your_ragdoll.Value then
				local he = workspace:FindFirstChild('HammerEvent', true)

				if he then
					he:FireServer('HammerClick', true)
				end
			else
				for idx = 1, fp_len do
					local t = fp[idx]:FindFirstChild('PodTrigger')

					if t and t.CapturedTorso.Value then
						re:FireServer('Input', 'Trigger', true, t.Event)
						re:FireServer('Input', 'Action', true)
						break
					end
				end
			end

			local t = pcall(table_sort, ct, sort_computers) and get_free_trigger(ct[1]) or nil

			if t then
				local cf = t.CFrame
				local diff = cf.Position - target.Position
				local event = t.Event

				if your_action_event.Value == event and your_action_progress.Value > 0 then
					target = cf
					re:FireServer('Input', 'Trigger', true, event)
					re:FireServer('Input', 'Action', true)
					re:FireServer('SetPlayerMinigameResult', true)
				else
					re:FireServer('Input', 'Action', diff.Magnitude <= 1.5)
					target += normalize(diff.Unit * dt * 12)
				end
			elseif ed_len > 0 then
				for idx = 1, ed_len do
					local d = ed[idx]
					local edt = d:FindFirstChild('ExitDoorTrigger')

					if edt then
						re:FireServer('Input', 'Trigger', true, edt.Event)
						re:FireServer('Input', 'Action', true)
						target = edt:GetPivot()
						continue
					else
						target = d.ExitArea:GetPivot()
						break
					end
				end
			end

			set_cf(your_char, target)
		end
	else
		local cf = hrp.CFrame

		if cf.Y < -50 then
			local spawn_loc = workspace:FindFirstChild('LobbySpawnPad') or workspace:FindFirstChildOfClass('SpawnLocation')

			if spawn_loc then
				cf = spawn_loc.CFrame
				set_cf(your_char, cf)
			end
		end

		target = cf
	end

	table_clear(ct)
	table_clear(ed)
	table_clear(fp)
end

connection_0:Disconnect()
connection_1:Disconnect()
screen_gui:Destroy()
