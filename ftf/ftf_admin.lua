--// ftf_commands.lua
--// by unknown

local _4 = Color3.new(0, .4984, 0)

-- check

local _EMPTY_FUNC = function() end
local _ENV = (getgenv or get_genv or _EMPTY_FUNC)() or _ENV or shared or _G
local _NAME = 'ftf_commands.lua'
local _PLACE_ID = game.PlaceId

_ENV[_NAME] = not _ENV[_NAME]
if not _ENV[_NAME] or (_PLACE_ID ~= 893973440 and _PLACE_ID ~= 0) then _ENV[_NAME] = nil return end

-- source code

(function(anim_id, anim_speed, auto_bc, auto_cptr, auto_hit,
	auto_rn, auto_save, btools_received, fire_enabled, fly_enabled,
	inf_jmp_enabled, keybinds, min_height, min_jump, min_speed,
	no_errors_mode, xray_enabled, teleport_enabled, wpx, wpy)
	anim_speed = anim_speed or 1
	auto_bc = auto_bc == 1
	auto_cptr = auto_cptr == 1
	auto_hit = auto_hit == 1
	auto_rn = auto_rn == 1
	auto_save = auto_save == 1
	btools_received = btools_received == 1
	fire_enabled = fire_enabled == 1
	fly_enabled = fly_enabled == 1
	inf_jmp_enabled = inf_jmp_enabled == 1
	keybinds = keybinds or {}
	min_height = min_height or -2
	min_jump = min_jump or 0
	min_speed = min_speed or 0
	no_errors_mode = no_errors_mode == 1
	xray_enabled = xray_enabled == 1
	teleport_enabled = teleport_enabled == 1

	local queue_on_teleport = queue_on_teleport or queueonteleport or _EMPTY_FUNC
	local set_clipboard = set_clipboard or setclipboard or _EMPTY_FUNC
	local set_fps_cap = set_fps_cap or setfpscap or _EMPTY_FUNC

	local context_action_service = game:GetService('ContextActionService')
	local core_gui = game:GetService('CoreGui')
	local gui_service = game:GetService('GuiService')
	local lighting = game:GetService('Lighting')
	local plrs = game:GetService('Players')
	local replicated_storage = game:GetService('ReplicatedStorage')
	local starter_gui = game:GetService('StarterGui')
	local teleport_service = game:GetService('TeleportService')
	local uis = game:GetService('UserInputService')

	local action4 = Enum.AnimationPriority.Action4
	local automatic_size_y = Enum.AutomaticSize.Y
	local bin_type = Enum.BinType
	local cf_new = CFrame.new
	local color3_from_rgb = Color3.fromRGB
	local core_gui_type = Enum.CoreGuiType
	local coroutine_create = coroutine.create
	local coroutine_resume = coroutine.resume
	local coroutine_status = coroutine.status
	local coroutine_wrap = coroutine.wrap
	local current_camera = workspace.CurrentCamera
	local humanoid_state_type = Enum.HumanoidStateType
	local font = Enum.Font
	local font_from_enum = Font.fromEnum
	local instance_new = Instance.new
	local job_id = game.JobId
	local key_code = Enum.KeyCode
	local math_floor = math.floor
	local math_huge = math.huge
	local math_max = math.max
	local rng = Random.new()
	local string_find = string.find
	local string_format = string.format
	local string_gsub = string.gsub
	local string_lower = string.lower
	local string_match = string.match
	local string_split = string.split
	local string_sub = string.sub
	local string_upper = string.upper
	local table_clear = table.clear
	local table_concat = table.concat
	local table_find = table.find
	local table_remove = table.remove
	local table_sort = table.sort
	local task_defer = task.defer
	local task_wait = task.wait
	local udim2_from_offset = UDim2.fromOffset
	local udim2_from_scale = UDim2.fromScale
	local udim2_new = UDim2.new
	local vec2_new = Vector2.new
	local vec3_new = Vector3.new

	local anim_track
	local beast_color = color3_from_rgb(255, 128, 128)
	local bottom = vec2_new(0, 2147483647)
	local black = color3_from_rgb(0, 0, 0)
	local cab_icon_pos = udim2_from_scale(0.175, 0.175)
	local cab_icon_size = udim2_from_scale(0.65, 0.65)
	local center = vec2_new(0.5, 0.5)
	local context_action_button_size = udim2_from_offset(45, 45)
	local core_gui_type_backpack = core_gui_type.Backpack
	local core_gui_type_chat = core_gui_type.Chat
	local current_map = replicated_storage:WaitForChild('CurrentMap')
	local dead = humanoid_state_type.Dead
	local font_source_sans = font_from_enum(font.SourceSans)
	local font_source_sans_bold = font_from_enum(font.SourceSansBold)
	local font_source_sans_semi_bold = font_from_enum(font.SourceSansSemibold)
	local green_fire_color = color3_from_rgb(255, 22950, 255)
	local heartbeat = game:GetService('RunService').Heartbeat
	local inf_vec3 = vec3_new(math_huge, math_huge, math_huge)
	local jumping = humanoid_state_type.Jumping
	local line_size = udim2_from_scale(1, 0)
	local name_len = #_NAME + 1
	local one_udim2 = udim2_from_scale(1, 1)
	local process_color = color3_from_rgb(255, 255, 102)
	local remote_event = replicated_storage:WaitForChild('RemoteEvent')
	local remote_event_fire_server = remote_event.FireServer
	local red = color3_from_rgb(255, 0, 0)
	local survivor_color = color3_from_rgb(128, 128, 255)
	local alignment_left = Enum.TextXAlignment.Left
	local alignment_top = Enum.TextYAlignment.Top
	local white = color3_from_rgb(255, 255, 255)
	local white_fire_color = color3_from_rgb(22950, 22950, 22950)
	local xray_highlight_size = udim2_from_offset(128, 18)
	local you = plrs.LocalPlayer
	local your_mouse = you:GetMouse()
	local your_gui = you:WaitForChild('PlayerGui')
	local your_tpsm = you:WaitForChild('TempPlayerStatsModule')
	local zero_udim2 = udim2_from_scale(0, 0)
	local zero_vec3 = vec3_new(0, 0, 0)

	local your_action_event = your_tpsm:WaitForChild('ActionEvent')
	local your_action_input = your_tpsm:WaitForChild('ActionInput')
	local your_action_progress = your_tpsm:WaitForChild('ActionProgress')
	local your_disable_crawl = your_tpsm:WaitForChild('DisableCrawl')

	local anims = {
		FLY = 'rbxassetid://148840371',
		CRAWL = 'rbxassetid://961932719',
		TYPING = 'rbxassetid://894496111',
		CARRY = 'rbxassetid://894494919',
		SWING = 'rbxassetid://894494203',
		HOLD = 'rbxassetid://1416947241',
		WIPE = 'rbxassetid://939025537'
	}

	local documentation = {
		anim = '<list|name> plays built-in animation.',
		anim_speed = '<speed> adjusts playing script animation speed.',
		autobc = 'automated version of /bc.',
		autocptr = 'automated version of /cptr.',
		autohit = 'automated version of /hit.',
		autorn = 'automated version of /rn.',
		autosave = 'automated version of /save.',
		bc = 'detaches beast\'s rope from any tied up survivor.',
		btools = 'gives you deprecated building tools.',
		clear = 'clears console window contents.',
		clicktp = 'toggles click-to-teleport mode.',
		copysi = 'copies server information to clipboard.',
		cptr = '<usernames...> captures nearest survivor(s).',
		dats = 'destroys all fading tiles in the cave.',
		doors = '<max> <min> <open> opens or closes all doors in the map.',
		escape = 'flees the facility. (requires any opened exit)',
		fire = 'toggles green fire on your character.',
		fixgui = 'fixes certain UI bugs.',
		fly = 'toggles flying.',
		fps = '<fps> adjusts frames per second.',
		fulbrt = 'deletes all ambient effects.',
		headcol = 'toggles your head collision.',
		help = 'shows built-in and documentated commands.',
		hit = '<usernames...> hits nearest survivor(s)',
		infjmp = 'toggles jumping in the air.',
		kb = '<key> <command> binds command to a key.',
		kbp = '<key> <sx> <cx> <sy> <cy> sets key button position.',
		min_height = '<min> sets minimal limit to your hip height.',
		min_jump = '<min> sets minimal limit to your jump power.',
		min_speed = '<min> sets minimal limit to your walk speed.',
		nextbeast = 'outputs the next beast\'s username in console.',
		noerrors = 'toggles automated computer minigame mode.',
		reset = 'acts like \'Reset\' button.',
		rn = '<is_this> rejoins into the same or another server.',
		run = '<code> runs any Lua code using \'loadstring\'.',
		save = '<names...> rescues captured survivor(s).',
		set_height = '<new> sets your current hip height to a new one.',
		set_jump = '<new> sets your current jump power to a new one.',
		set_speed = '<new> sets your current walk speed to a new one.',
		spectate = '<username> sets your camera subject to another player.',
		tchat = 'toggles chat.',
		tcrawl = 'toggles crawling.',
		tp = '<username|x> <y> <z> teleports you to the target player or position.',
		ttouch = 'toggles your touch events.',
		tu = '<username> <x> <y> <z> ties up survivor. (use < or > for any)',
		ub = '<key> unbinds all commands from the specified key.',
		unload = 'unloads this console.',
		wpos = 'sets window\'s position from the right-bottom corner.',
		xray = 'toggles extrasensory perception.'
	}

	local animation = instance_new('Animation')
	animation.AnimationId = anim_id or ''
	animation.Archivable = false
	animation:SetAttribute('4', _4)

	local main_ui = instance_new('ScreenGui')
	main_ui.Archivable = false
	main_ui.AutoLocalize = false
	main_ui.ClipToDeviceSafeArea = false
	main_ui.DisplayOrder = 100
	main_ui.Name = 'MainFTFGui'
	main_ui.ResetOnSpawn = false
	main_ui.Parent = pcall(tostring, core_gui) and core_gui or your_gui

	local sca_ui = instance_new('ScreenGui')
	sca_ui.Archivable = false
	sca_ui.AutoLocalize = false
	sca_ui.ClipToDeviceSafeArea = false
	sca_ui.Name = 'ScriptContextActionGui'
	sca_ui.ResetOnSpawn = false
	sca_ui.Parent = your_gui

	local commands_frame = instance_new('Frame')
	commands_frame.Active = true
	commands_frame.AnchorPoint = vec2_new(1, 1)
	commands_frame.Archivable = false
	commands_frame.AutoLocalize = false
	commands_frame.BackgroundColor3 = color3_from_rgb(28, 28, 28)
	commands_frame.BackgroundTransparency = 0.125
	commands_frame.Draggable = true
	commands_frame.Name = 'CommandsFrame'
	commands_frame.Position = udim2_new(1, wpx or -16, 1, wpy or -16)
	commands_frame.Size = udim2_from_scale(0.25, 0.3)

	local ui_stroke = instance_new('UIStroke')
	ui_stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	ui_stroke.Archivable = false
	ui_stroke.Color = black
	ui_stroke.Thickness = 2
	ui_stroke.Parent = commands_frame

	local command_bar = instance_new('TextBox')
	command_bar.Archivable = false
	command_bar.AutoLocalize = false
	command_bar.BackgroundTransparency = 1
	command_bar.ClearTextOnFocus = false
	command_bar.FontFace = font_source_sans_semi_bold
	command_bar.Name = 'CommandBar'
	command_bar.PlaceholderText = 'Enter a command to run.'
	command_bar.Position = udim2_from_scale(0.01, 0.89)
	command_bar.Selectable = false
	command_bar.Size = udim2_from_scale(0.98, 0.105)
	command_bar.Text = ''
	command_bar.TextColor3 = white
	command_bar.TextScaled = true
	command_bar.TextStrokeColor3 = black
	command_bar.TextStrokeTransparency = 0.5
	command_bar.TextXAlignment = alignment_left
	command_bar.Parent = commands_frame

	local commands_scrolling_frame = instance_new('ScrollingFrame')
	commands_scrolling_frame.Active = true
	commands_scrolling_frame.Archivable = false
	commands_scrolling_frame.AutoLocalize = false
	commands_scrolling_frame.AutomaticCanvasSize = automatic_size_y
	commands_scrolling_frame.BackgroundTransparency = 1
	commands_scrolling_frame.BorderColor3 = black
	commands_scrolling_frame.BorderSizePixel = 1
	commands_scrolling_frame.BottomImage = 'rbxasset://textures/SurfacesDefault.png'
	commands_scrolling_frame.CanvasSize = zero_udim2
	commands_scrolling_frame.ElasticBehavior = Enum.ElasticBehavior.Never
	commands_scrolling_frame.MidImage = 'rbxasset://textures/SurfacesDefault.png'
	commands_scrolling_frame.Position = udim2_from_scale(0, 0.125)
	commands_scrolling_frame.ScrollBarImageColor3 = black
	commands_scrolling_frame.ScrollBarThickness = 8
	commands_scrolling_frame.ScrollingDirection = Enum.ScrollingDirection.Y
	commands_scrolling_frame.Selectable = false
	commands_scrolling_frame.Size = udim2_from_scale(1, 0.75)
	commands_scrolling_frame.TopImage = 'rbxasset://textures/SurfacesDefault.png'
	commands_scrolling_frame.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
	commands_scrolling_frame.Parent = commands_frame

	local ui_list_layout = instance_new('UIListLayout')
	ui_list_layout.Archivable = false
	ui_list_layout.SortOrder = Enum.SortOrder.LayoutOrder
	ui_list_layout.Parent = commands_scrolling_frame

	local ui_stroke = instance_new('UIStroke')
	ui_stroke.Archivable = false
	ui_stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	ui_stroke.Color = black
	ui_stroke.Thickness = 1
	ui_stroke.Parent = commands_scrolling_frame

	local commands_frame_title = instance_new('TextLabel')
	commands_frame_title.Archivable = false
	commands_frame_title.AutoLocalize = false
	commands_frame_title.BackgroundTransparency = 1
	commands_frame_title.FontFace = font_source_sans
	commands_frame_title.Size = udim2_from_scale(1, 0.125)
	commands_frame_title.Text = 'FTF commands window'
	commands_frame_title.TextColor3 = white
	commands_frame_title.TextScaled = true
	commands_frame_title.TextStrokeColor3 = black
	commands_frame_title.TextStrokeTransparency = 0.5
	commands_frame_title.Parent = commands_frame
	commands_frame.Parent = main_ui

	local function bool_int(e)
		return e and 1 or 0
	end

	local function get(a, b)
		return a[b]
	end

	local function compare_model_to_point(a, b)
		return b == '>' and function(x, y)
			return (a - x:GetPivot().Position).Magnitude > (a - y:GetPivot().Position).Magnitude
		end or function(x, y)
			return (a - x:GetPivot().Position).Magnitude < (a - y:GetPivot().Position).Magnitude
		end
	end

	local function create_button(action_name, func, text, image, ox, oy, sx, sy)
		if not action_name or not func then return end
		local name = 'ContextActionButton_' .. action_name
		if sca_ui:FindFirstChild(name) then return end
		local function input(input) func(action_name, input.UserInputState, input) end
		local btn = instance_new('ImageButton')
		btn.AnchorPoint = center
		btn.Archivable = false
		btn.AutoLocalize = false
		btn.BackgroundTransparency = 1
		btn.Image = btn.GuiState.Value == 2 and 'rbxassetid://97166756' or 'rbxassetid://97166444'
		btn.Name = name
		btn.Position = udim2_new(sx or (0.666 + rng:NextNumber() / 4), ox or 0, sy or (0.666 + rng:NextNumber() / 4), oy or 0)
		btn.Size = context_action_button_size

		local icon = instance_new('ImageLabel')
		icon.Archivable = false
		icon.AutoLocalize = false
		icon.BackgroundTransparency = 1
		icon.Image = image or ''
		icon.Name = 'ActionIcon'
		icon.Position = cab_icon_pos
		icon.Size = cab_icon_size
		icon.Parent = btn

		local title = instance_new('TextLabel')
		title.Archivable = false
		title.AutoLocalize = false
		title.BackgroundTransparency = 1
		title.FontFace = font_source_sans_bold
		title.Name = 'ActionTitle'
		title.Position = zero_udim2
		title.Size = one_udim2
		title.Text = text or ''
		title.TextColor3 = white
		title.TextSize = 18
		title.TextStrokeColor3 = black
		title.TextStrokeTransparency = 0
		title.TextWrapped = true
		title.Parent = btn

		btn.Changed:Connect(function() btn.Image = btn.GuiState.Value == 2 and 'rbxassetid://97166756' or 'rbxassetid://97166444' end)
		btn.Activated:Connect(input)
		btn.Parent = sca_ui

		return btn
	end

	local function find(iterable, matching_key, property, result, start, value)
		if not iterable or not matching_key or matching_key == '' then return value end
		matching_key = string_upper(tostring(matching_key or ''))

		if property then
			for _, val in next, iterable do
				if string_find(string_upper(tostring(val[property])), matching_key, start or 1, true) == result then return val end
			end
		else
			for key, val in next, iterable do
				if string_find(string_upper(tostring(key or '')), matching_key, start or 1, true) == result then return val end
			end
		end

		return value
	end

	local function find_key_precise(iterable, matching_key, value)
		if not iterable or not matching_key or matching_key == '' then return value end
		matching_key = string_upper(tostring(matching_key or ''))

		for key, val in next, iterable do
			if string_upper(tostring(key or '')) == matching_key then return val end
		end

		return value
	end

	local function get_len(t)
		local a = 0
		for _ in next, t do a += 1 end
		return a
	end

	local function get_plr(user_name)
		return find(plrs:GetPlayers(), user_name, 'Name', 1, 1, nil)
	end

	local function get_plrs(...)
		local names = {...}
		local len = 0
		local result = {}

		for idx = 1, #names do
			local plr = get_plr(names[idx])
			if not plr then continue end
			len += 1
			result[len] = plr
		end

		table_clear(names)

		return result
	end

	local function get_plr_name(plr)
		if not plr then return '' end
		if plr == you then return 'you' end
		local a, b = plr.DisplayName, plr.Name

		if a ~= b then
			return tostring(a) .. ' (@' .. tostring(b) .. ')'
		else
			return '@' .. b
		end
	end

	local function greater_than(a, b)
		return a > b
	end

	local function restore_ea(exit_area, org_cf)
		heartbeat:Wait()
		heartbeat:Wait()
		task_wait()
		exit_area.CFrame = org_cf
	end

	local function run_command(silent, func, ...)
		local succ, err = pcall(func, silent and true or false, ...)

		if not succ then
			warn('A recently called command has raised an error.', err)
		end
	end

	local function stringify(e)
		local t = type(e)
		local s = tostring(e)
		local us = string_upper(s)

		if t == 'boolean' then
			if us == 'TRUE' then
				return 'true'
			else
				return 'false'
			end
		elseif t == 'number' then
			if us == 'NAN' then
				return '0 / 0'
			elseif us == 'INF' then
				return 'math.huge'
			elseif us == '-INF' then
				return '-math.huge'
			else
				return s
			end
		elseif t == 'string' then
			return '\'' .. s .. '\''
		else
			return s
		end
	end

	local function table_str(t)
		local r = '{'

		for key, value in next, t do
			r ..= '[' .. stringify(key) .. '] = ' .. stringify(value)

			if next(t, key) then
				r ..= ', '
			end
		end

		return r .. '}'
	end

	local bin_types = {bin_type.Clone, bin_type.Grab, bin_type.Hammer}
	local commands = {}
	local connections = {}
	local notification_properties = {Button1 = 'OK', Icon = 'rbxassetid://13372803791', Text = 'Cheat activated.', Title = 'FTF admin'}
	local xray_highlights = {}

	local function char_handler()
		local your_char = you.Character

		while not your_char or not your_char.Parent do
			your_char = you.Character
			heartbeat:Wait()
		end

		local your_backpack = you:WaitForChild('Backpack')
		local your_h = your_char:WaitForChild('Humanoid')
		local your_hrp = your_char:WaitForChild('HumanoidRootPart')
		local your_torso = your_char:WaitForChild('Torso')

		if animation.AnimationId ~= '' then
			anim_track = your_h:WaitForChild('Animator'):LoadAnimation(animation)
			anim_track.Looped = true
			anim_track.Priority = action4
			anim_track:Play(0, 1, anim_speed)
			anim_track:AdjustSpeed(anim_speed)
		end

		if btools_received then
			for idx = 1, 3 do
				local val = bin_types[idx]
				local btool = instance_new('HopperBin')
				btool.Archivable = false
				btool.BinType = val
				btool.Name = val.Name
				btool.Parent = your_backpack
			end
		end

		if fire_enabled then
			for _ = 1, 3 do
				local y = instance_new('Fire')
				y.Archivable = false
				y.Color = green_fire_color
				y.Heat = 9
				y.Name = 'GreenFire'
				y.SecondaryColor = white_fire_color
				y.Size = 3
				y.Parent = your_hrp
			end
		end

		if fly_enabled then
			local body_gyro = your_torso:FindFirstChild('BodyGyroCheat') or instance_new('BodyGyro')
			body_gyro.Archivable = false
			body_gyro.MaxTorque = inf_vec3
			body_gyro.Name = 'BodyGyroCheat'
			body_gyro.P = 9e4
			body_gyro.Parent = your_torso

			local body_velocity = your_torso:FindFirstChild('BodyVelocityCheat') or instance_new('BodyVelocity')
			body_velocity.Archivable = false
			body_velocity.MaxForce = inf_vec3
			body_velocity.Name = 'BodyVelocityCheat'
			body_velocity.Parent = your_torso
		end

		local connection = connections['YourHumanoidChanged.']
		if connection then connection:Disconnect() end
		connections['YourHumanoidChanged.'] = your_h.Changed:Connect(function(property)
			if not your_h.Parent then return end

			if property == 'WalkSpeed' then
				your_h.WalkSpeed = math_max(your_h.WalkSpeed, min_speed or 0)
			elseif property == 'JumpPower' then
				your_h.JumpPower = math_max(your_h.JumpPower, min_jump or 0)
			elseif property == 'HipHeight' then
				your_h.HipHeight = math_max(your_h.HipHeight, min_height or 0)
			end
		end)
	end

	local function internal_xray(model)
		if not xray_enabled or model:FindFirstChild('XRayHighlight') then return end
		local plr = plrs:GetPlayerFromCharacter(model)

		if plr then
			local highlight = instance_new('Highlight')
			highlight.Adornee = model
			highlight.Archivable = false
			highlight.FillTransparency = 0.5
			highlight.Name = 'XRayHighlight'
			highlight.Parent = model

			local billboard_gui = instance_new('BillboardGui')
			billboard_gui.Adornee = model
			billboard_gui.AlwaysOnTop = true
			billboard_gui.Archivable = false
			billboard_gui.Name = 'XRayHighlight'
			billboard_gui.ResetOnSpawn = false
			billboard_gui.Size = xray_highlight_size

			local text_lbl = instance_new('TextLabel')
			text_lbl.Archivable = false
			text_lbl.BackgroundTransparency = 1
			text_lbl.FontFace = font_source_sans_semi_bold
			text_lbl.Size = one_udim2
			text_lbl.Text = get_plr_name(plr)
			text_lbl.TextColor3 = white
			text_lbl.TextScaled = true
			text_lbl.TextStrokeColor3 = black
			text_lbl.TextStrokeTransparency = 0
			text_lbl.Parent = billboard_gui
			billboard_gui.Parent = model

			local len = #xray_highlights
			xray_highlights[len + 1] = highlight
			xray_highlights[len + 2] = billboard_gui

			local plr_is_beast = plr:WaitForChild('TempPlayerStatsModule'):WaitForChild('IsBeast')
			highlight.FillColor = plr_is_beast.Value and color3_from_rgb(255, 128, 128) or color3_from_rgb(128, 128, 255)

			local id = 'TempPlayerStatsModuleIsBeastChanged.' .. get_plr_name(plr)
			local connection = connections[id]
			if connection then connection:Disconnect() end
			connections[id] = plr_is_beast.Changed:Connect(function(value)
				highlight.FillColor = value and beast_color or survivor_color
			end)
		elseif model.Name == 'ComputerTable' then
			local highlight = instance_new('Highlight')
			highlight.Adornee = model
			highlight.Archivable = false
			highlight.FillTransparency = 0.4
			highlight.Name = 'XRayHighlight'
			highlight.Parent = model

			local billboard_gui = instance_new('BillboardGui')
			billboard_gui.Adornee = model.PrimaryPart or model
			billboard_gui.AlwaysOnTop = true
			billboard_gui.Archivable = false
			billboard_gui.Name = 'XRayHighlight'
			billboard_gui.ResetOnSpawn = false
			billboard_gui.Size = xray_highlight_size

			local text_lbl = instance_new('TextLabel')
			text_lbl.Archivable = false
			text_lbl.BackgroundTransparency = 1
			text_lbl.FontFace = font_source_sans_semi_bold
			text_lbl.Size = one_udim2
			text_lbl.Text = 'Computer'
			text_lbl.TextColor3 = white
			text_lbl.TextScaled = true
			text_lbl.TextStrokeColor3 = black
			text_lbl.TextStrokeTransparency = 0
			text_lbl.Parent = billboard_gui
			billboard_gui.Parent = model

			local len = #xray_highlights
			xray_highlights[len + 1] = highlight
			xray_highlights[len + 2] = billboard_gui

			local as1 = model:WaitForChild('ComputerTrigger1'):WaitForChild('ActionSign')
			local as1_id = 'ComputerTrigger1ActionSignChanged.' .. rng:NextInteger(1000000000, 2147483647)
			local as1_connection = connections[as1_id]
			local as2 = model:WaitForChild('ComputerTrigger2'):WaitForChild('ActionSign')
			local as2_id = 'ComputerTrigger2ActionSignChanged.' .. rng:NextInteger(1000000000, 2147483647)
			local as2_connection = connections[as2_id]
			local as3 = model:WaitForChild('ComputerTrigger3'):WaitForChild('ActionSign')
			local as3_id = 'ComputerTrigger3ActionSignChanged.' .. rng:NextInteger(1000000000, 2147483647)
			local as3_connection = connections[as3_id]
			local screen = model:WaitForChild('Screen')
			local screen_id = 'ComputerScreenChanged.' .. rng:NextInteger(1000000000, 2147483647)
			local screen_connection = connections[screen_id]
			if as1_connection then as1_connection:Disconnect() end
			if as2_connection then as2_connection:Disconnect() end
			if as3_connection then as3_connection:Disconnect() end
			if screen_connection then screen_connection:Disconnect() end

			local function changed()
				if not as1.Parent or not as2.Parent or not as3.Parent or not screen.Parent then
					as1_connection:Disconnect()
					as2_connection:Disconnect()
					as3_connection:Disconnect()
					screen_connection:Disconnect()

					return
				end

				highlight.FillColor = (as1.Value ~= 20 or as2.Value ~= 20 or as3.Value ~= 20) and process_color or screen.Color:Lerp(white, 0.4)
			end

			changed()

			as1_connection = as1.Changed:Connect(changed)
			as2_connection = as2.Changed:Connect(changed)
			as3_connection = as3.Changed:Connect(changed)
			screen_connection = screen.Changed:Connect(changed)

			connections[as1_id] = as1_connection
			connections[as2_id] = as2_connection
			connections[as3_id] = as3_connection
			connections[screen_id] = screen_connection
		end
	end

	local function descendant_added(descendant)
		local map = current_map.Value
		if not descendant or descendant == map or not descendant:IsA('Model') or not xray_enabled then return end
		task_wait(0.4)

		local plr = plrs:GetPlayerFromCharacter(descendant)

		if descendant.Parent == map then
			task_defer(internal_xray, descendant)
		elseif descendant.Parent == workspace and plr and plr ~= you then
			descendant:WaitForChild('Humanoid')
			task_defer(internal_xray, descendant)
		end
	end

	local function keybind_function(action_name, state, _)
		for command, name in next, keybinds do
			if name == action_name then
				local words = string_split(command, ' ')
				local func = commands[words[1]]
				table_remove(words, 1)

				if func then
					coroutine_wrap(run_command)(true, func, unpack(words))
				end
			end
		end
	end

	local function keybind(command, key_code_enum)
		if not command or not key_code_enum then return end

		local found = false
		local key = key_code_enum.Name
		local keybind_name = _NAME .. key

		for _, name in next, keybinds do
			if name == keybind_name then
				found = true
				break
			end
		end

		if not found then
			context_action_service:BindAction(keybind_name, keybind_function, false, key_code_enum)
			create_button(keybind_name, keybind_function, key)
		end

		keybinds[command] = keybind_name
	end

	local function send_msg(silent, text, color)
		if silent then return end

		local children = commands_scrolling_frame:GetChildren()
		local len = #children

		if len > 101 then
			for idx = 1, 10 do
				local child = children[idx]
				if not child:IsA('TextLabel') then continue end
				child:Destroy()
				break
			end
		end

		local text_lbl = instance_new('TextLabel')
		text_lbl.Archivable = false
		text_lbl.AutomaticSize = automatic_size_y
		text_lbl.BackgroundTransparency = 1
		text_lbl.FontFace = font_source_sans_semi_bold
		text_lbl.Size = line_size
		text_lbl.Text = text or ''
		text_lbl.TextColor3 = color or black
		text_lbl.TextSize = 17
		text_lbl.TextStrokeTransparency = 0.5
		text_lbl.TextStrokeColor3 = black
		text_lbl.TextWrapped = true
		text_lbl.TextXAlignment = alignment_left
		text_lbl.TextYAlignment = alignment_top
		text_lbl.Parent = commands_scrolling_frame
		commands_scrolling_frame.CanvasPosition = bottom
	end

	connections['YourCharacterCharacterAdded.'] = you.CharacterAdded:Connect(char_handler)
	connections['WorkspaceDescendantAdded.'] = workspace.DescendantAdded:Connect(descendant_added)
	connections['RunServiceHeartbeat.'] = heartbeat:Connect(function()
		if not fly_enabled then return end
		local your_char = you.Character
		if not your_char then return end
		local h = your_char:FindFirstChildOfClass('Humanoid')
		if not h then return end
		local torso = your_char:FindFirstChild('Torso')
		if not torso then return end
		local body_gyro = torso:FindFirstChild('BodyGyroCheat')
		local body_velocity = torso:FindFirstChild('BodyVelocityCheat')
		if not body_gyro or not body_velocity then return end
		local cf = current_camera.CFrame
		local direction = zero_vec3
		local rot = cf.Rotation

		if h.MoveDirection.Magnitude > 0 then
			if uis.KeyboardEnabled and (uis:IsKeyDown(119) or uis:IsKeyDown(97) or uis:IsKeyDown(115) or uis:IsKeyDown(100)) then
				direction = rot * vec3_new(
					(uis:IsKeyDown(97) and -1 or 0) + (uis:IsKeyDown(100) and 1 or 0),
					0,
					(uis:IsKeyDown(119) and -1 or 0) + (uis:IsKeyDown(115) and 1 or 0)
				) * h.WalkSpeed * 2
			elseif uis.TouchEnabled then
				local element = your_gui:FindFirstChild('TouchGui')
				if element then
					local element = element:FindFirstChild('TouchControlFrame')
					if element then
						local element = element:FindFirstChild('DynamicThumbstickFrame')
						if element then
							local a = element:FindFirstChild('ThumbstickStart')
							local b = element:FindFirstChild('ThumbstickEnd')
							if a and b then
								local unit = (b.AbsolutePosition - a.AbsolutePosition).Unit
								local x = unit.X
								local y = unit.Y
								direction = rot * vec3_new(x == x and x or 0, 0, y == y and y or 0) * h.WalkSpeed * 2
							end
						end
					end
				end
			end
		end

		body_gyro.CFrame = rot
		body_velocity.Velocity = direction
		h.PlatformStand = true
	end)

	connections['UserInputServiceInputEnded.'] = uis.InputEnded:Connect(function(input, gpe)
		if gpe or gui_service.MenuIsOpen or input.UserInputType.Value ~= 0 or uis:GetFocusedTextBox() or
			not your_mouse.Target or not teleport_enabled then return end

		local your_char = you.Character
		if not your_char then return end
		local your_hrp = your_char:FindFirstChild('HumanoidRootPart')
		if not your_hrp then return end
		local hit = your_mouse.Hit.Position
		local new_cf = cf_new(hit.X, hit.Y + 4.5, hit.Z) * your_hrp.CFrame.Rotation
		local children = your_char:GetChildren()

		for idx = 1, #children do
			local child = children[idx]
			if not child:IsA('PVInstance') then return end
			child:PivotTo(new_cf)
		end
	end)

	connections['UserInputServiceJumpRequest.'] = uis.JumpRequest:Connect(function()
		if not inf_jmp_enabled then return end
		local h = (you.Character or game):FindFirstChildOfClass('Humanoid')
		if not h then return end
		h:ChangeState(jumping)
	end)

	connections['UserInputServiceTouchLongPress.'] = uis.TouchLongPress:Connect(function(_, state, gpe)
		if gpe or gui_service.MenuIsOpen or state.Value ~= 0 or uis:GetFocusedTextBox() or
			not your_mouse.Target or not teleport_enabled then
			return
		end

		local your_char = you.Character
		if not your_char then return end
		local your_hrp = your_char:FindFirstChild('HumanoidRootPart')
		if not your_hrp then return end
		local hit = your_mouse.Hit.Position
		local new_cf = cf_new(hit.X, hit.Y + 4.5, hit.Z) * your_hrp.CFrame.Rotation
		local children = your_char:GetChildren()

		for idx = 1, #children do
			local child = children[idx]
			if not child:IsA('PVInstance') then return end
			child:PivotTo(new_cf)
		end
	end)

	connections['YourCharacterOnTeleport.'] = you.OnTeleport:Once(function()
		local a = commands_frame.Position
		local b = 'https://pastebin.com/raw/vQCRaTku'
		local c = string_format(
			'\'%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s\'',
			stringify(anim_id),
			stringify(anim_speed),
			bool_int(auto_bc),
			bool_int(auto_cptr),
			bool_int(auto_hit),
			bool_int(auto_rn),
			bool_int(auto_save),
			bool_int(btools_received),
			bool_int(fire_enabled),
			bool_int(fly_enabled),
			bool_int(inf_jmp_enabled),
			table_str(keybinds),
			stringify(min_height),
			stringify(min_jump),
			stringify(min_speed),
			bool_int(no_errors_mode),
			bool_int(xray_enabled),
			bool_int(teleport_enabled),
			stringify(a.X.Offset),
			stringify(a.Y.Offset)
		)

		queue_on_teleport('loadstring(string.gsub(game:HttpGet(\'' .. b .. '\', true), \'ARGUMENTS_FROM_THE_TELEPORT_QUEUE\', ' .. c .. '))()')
	end)

	local function bc()
		local he = workspace:FindFirstChild('HammerEvent', true)
		if not he then return 'No beast was detected.', red end
		he:FireServer('HammerClick', true)
		return 'Detached the rope.', white
	end

	local function cptr(...)
		local your_char = you.Character
		if not your_char then return 'You don\'t have a character.', red end
		local he = your_char:FindFirstChild('HammerEvent', true)
		if not he then return 'You aren\'t the beast.', red end
		local map = current_map.Value

		if map then
			local actual_names, last_event, last_input, len, pods, pods_len = {}, your_action_event.Value, your_action_input.Value, 0, {}, 0
			local list = #{...} > 0 and get_plrs(...) or plrs:GetPlayers()
			local children = map:GetChildren()

			for idx = 1, #children do
				local child = children[idx]
				if string_find(string_upper(child.Name), 'FREEZEPOD', 1, true) ~= 1 then continue end
				local trigger = child:FindFirstChild('PodTrigger')
				if not trigger or trigger.CapturedTorso.Value then continue end
				pods_len += 1
				pods[pods_len] = trigger
			end

			table_sort(pods, compare_model_to_point(current_camera.CFrame.Position, '<'))

			for idx = 1, #list do
				local element = list[idx]
				if element == you then continue end
				local char = element.Character
				if not char then continue end
				local torso = char:FindFirstChild('Torso')
				if not torso then continue end
				local pos = torso.Position
				if (current_camera.CFrame.Position - pos).Magnitude > 10 then continue end
				local pod = pods[1]
				if not pod then break end
				local event = pod.Event
				table_remove(pods, 1)
				he:FireServer('HammerHit', torso)
				task_wait()
				he:FireServer('HammerTieUp', torso, pos)
				task_wait()
				your_action_event.Value, your_action_input.Value = event, true
				remote_event:FireServer('Input', 'Trigger', true, event)
				remote_event:FireServer('Input', 'Action', true)
				task_wait()
				len += 1
				actual_names[len] = get_plr_name(element)
				task_wait()
			end

			table_clear(list)
			table_clear(pods)

			if len > 0 then
				your_action_event.Value, your_action_input.Value = last_event, last_input
				remote_event:FireServer('Input', 'Trigger', last_event and true or false, last_event)
				remote_event:FireServer('Input', 'Action', last_input)

				return 'Captured: ' .. table_concat(actual_names, ', ') .. '.', white
			else
				return 'There were no survivors.', red
			end
		else
			return 'Doesn\'t work without map.', red
		end
	end

	local function hit(...)
		local he = workspace:FindFirstChild('HammerEvent', true)
		if not he then return 'No beast was detected.', red end
		local actual_names = {}
		local len = 0
		local list = #{...} > 0 and get_plrs(...) or plrs:GetPlayers()

		for idx = 1, #list do
			local element = list[idx]
			local char = element.Character
			if not char then continue end
			local children = char:GetChildren()
			local hit = false

			for idx = 1, #children do
				local child = children[idx]
				if not child:IsA('BasePart') then continue end
				he:FireServer('HammerHit', child)
				hit = true
			end

			if hit then
				len += 1
				actual_names[len] = get_plr_name(element)
			end
		end

		table_clear(list)

		if len > 0 then
			return 'Hit: ' .. table_concat(actual_names, ', ') .. '.', white
		else
			return 'No one was hit.', red
		end
	end

	local function save(...)
		local your_char = you.Character
		if not your_char then return 'You don\'t have a character.', red end
		if your_char:FindFirstChild('HammerEvent', true) then return 'You are the beast.', red end
		local map = current_map.Value

		if map then
			local actual_names, last_event, last_input, len = {}, your_action_event.Value, your_action_input.Value, 0
			local list = #{...} > 0 and get_plrs(...) or plrs:GetPlayers()
			local children = map:GetChildren()

			for idx = 1, #children do
				local child = children[idx]
				if string_find(string_upper(child.Name), 'FREEZEPOD', 1, true) ~= 1 then continue end
				local trigger = child:FindFirstChild('PodTrigger')
				if not trigger then continue end
				local captured_torso = trigger.CapturedTorso.Value
				local event = trigger.Event
				if not captured_torso or not event then continue end
				local plr = plrs:GetPlayerFromCharacter(captured_torso.Parent)
				if plr == you or not table_find(list, plr) then continue end
				your_action_event.Value, your_action_input.Value = event, true
				remote_event:FireServer('Input', 'Trigger', true, event)
				remote_event:FireServer('Input', 'Action', true)
				len += 1
				actual_names[len] = get_plr_name(plr)
				task_wait(0.025)
			end

			table_clear(list)

			if len > 0 then
				your_action_event.Value, your_action_input.Value = last_event, last_input
				remote_event:FireServer('Input', 'Trigger', last_event and true or false, last_event)
				remote_event:FireServer('Input', 'Action', last_input)

				return 'Rescued: ' .. table_concat(actual_names, ', ') .. '.', white
			else
				return 'There were no survivors.', red
			end
		else
			return 'Doesn\'t work without map.', red
		end
	end

	local cheat_functions = {
		anim = function(silent, name)
			local h = (you.Character or game):FindFirstChildOfClass('Humanoid')
			if not h then return end
			local animator = h:FindFirstChildOfClass('Animator')
			if not animator then return end

			if name and string_find('LIST', string_upper(name), 1, true) then
				local len = 0
				local list = {}

				for key, value in next, anims do
					len += 1
					list[len] = string_upper(string_sub(key, 1, 1)) .. string_lower(string_sub(key, 2, -1))
				end

				local str = table_concat(list, ', ')
				table_clear(list)

				return send_msg(silent, 'Current animations: ' .. str .. '.', white)
			end

			if anim_track then
				anim_track:Stop(0)
			end

			local new_anim_id = find(anims, name, nil, 1, 1, '')
			animation.AnimationId = new_anim_id

			if new_anim_id ~= '' then
				anim_track = animator:LoadAnimation(animation)
				anim_track.Looped = true
				anim_track.Priority = Enum.AnimationPriority.Action4
				anim_track:Play(0, 1, anim_speed)
				anim_track:AdjustSpeed(anim_speed)

				send_msg(silent, 'Playing animation from asset id \'' .. new_anim_id .. '\'.', white)
			else
				send_msg(silent, 'Stopped playing current animation.', white)
			end
		end,
		anim_speed = function(silent, speed)
			anim_speed = tonumber(speed) or 1

			if anim_track then
				anim_track:AdjustSpeed(anim_speed)
			end

			send_msg(silent, 'Set animation speed to ' .. anim_speed .. 'x.', white)
		end,
		autobc = function(silent)
			auto_bc = not auto_bc
			send_msg(silent, 'Automated /bc is ' .. (auto_bc and 'on' or 'off') .. '.', white)
		end,
		autocptr = function(silent)
			auto_cptr = not auto_cptr
			send_msg(silent, 'Automated /cptr is ' .. (auto_cptr and 'on' or 'off') .. '.', white)
		end,
		autohit = function(silent)
			auto_hit = not auto_hit
			send_msg(silent, 'Automated /hit is ' .. (auto_hit and 'on' or 'off') .. '.', white)
		end,
		autorn = function(silent)
			auto_rn = not auto_rn
			send_msg(silent, 'Automated /rn is ' .. (auto_rn and 'on' or 'off') .. '.', white)
		end,
		autosave = function(silent)
			auto_save = not auto_save
			send_msg(silent, 'Automated /save is ' .. (auto_save and 'on' or 'off') .. '.', white)
		end,
		bc = function(silent)
			send_msg(silent, bc())
		end,
		btools = function(silent)
			local your_backpack = you:WaitForChild('Backpack')
			btools_received = not btools_received

			if btools_received then
				for idx = 1, 3 do
					local val = bin_types[idx]
					local btool = instance_new('HopperBin')
					btool.Archivable = false
					btool.BinType = val
					btool.Name = val.Name
					btool.Parent = your_backpack
				end
			else
				for idx = 1, 3 do
					your_backpack:FindFirstChild(bin_types[idx].Name):Destroy()
				end
			end

			send_msg(silent, (btools_received and 'Gave' or 'Revoked') .. ' building tools.', white)
		end,
		clear = function(silent)
			local children = commands_scrolling_frame:GetChildren()

			for idx = 1, #children do
				local child = children[idx]
				if not child:IsA('TextLabel') then continue end
				child:Destroy()
			end

			table_clear(children)
		end,
		clicktp = function(silent)
			teleport_enabled = not teleport_enabled
			send_msg(silent, 'Click-to-teleport is ' .. (teleport_enabled and 'on' or 'off') .. '.', white)
		end,
		copysi = function(silent)
			set_clipboard('FTF server information: ' .. job_id .. '; ' .. _PLACE_ID .. '.')
			send_msg(silent, 'Copied server information to your clipboard.', white)
		end,
		cptr = function(silent, ...)
			send_msg(silent, cptr(...))
		end,
		dats = function(silent)
			local char = you.Character
			if not char then return send_msg(silent, 'No character detected.', red) end
			local children = workspace:WaitForChild('FadingTiles'):GetChildren()
			local pos = char:GetPivot().Position
			local len = #children

			for idx = 1, len do
				local child = children[idx]
				if not child:IsA('BasePart') then continue end
				child:SetAttribute('previous_pos', child:GetAttribute('previous_pos') or child.Position)
				child.CanCollide = false
				child.Position = pos
			end

			heartbeat:Wait()
			heartbeat:Wait()

			for idx = 1, len do
				local child = children[idx]
				if not child:IsA('BasePart') then continue end
				child.Position = child:GetAttribute('previous_pos')
				child.CanCollide = true
				child:SetAttribute('previous_pos', nil)
			end

			table_clear(children)
			send_msg(silent, 'Destroyed all tiles in the cave.', white)
		end,
		doors = function(silent, max, min, open)
			local map = current_map.Value

			if map then
				max = tonumber(max) or 8192
				min = tonumber(min) or 0

				if max < min then return send_msg(silent, 'Maximal distance is less than minimal.', red) end
				local last_event, last_input = your_action_event.Value, your_action_input.Value

				if not open then
					your_action_event.Value, your_action_input.Value = nil, nil

					task_defer(remote_event_fire_server, remote_event, 'Input', 'Trigger', false, last_event)
					task_defer(remote_event_fire_server, remote_event, 'Input', 'Action', false)
				end

				local children = map:GetChildren()
				local new_event

				for idx = 1, #children do
					local child = children[idx]
					if not string_find(string_upper(child.Name), 'DOOR', 1, true) then continue end
					local trigger = child:FindFirstChild('DoorTrigger')
					if not trigger then continue end
					local distance = (trigger.Position - current_camera.CFrame.Position).Magnitude
					if distance > max or distance < min then continue end
					local action_sign = trigger.ActionSign.Value
					local event = trigger.Event
					if not action_sign or not event then continue end
					if (open and action_sign > 10) or (not open and action_sign == 10) or action_sign == 0 then continue end
					your_action_event.Value, your_action_input.Value, new_event = event, true, event
					remote_event:FireServer('Input', 'Trigger', true, event)
					remote_event:FireServer('Input', 'Action', true)

					if not open then
						task_defer(remote_event_fire_server, remote_event, 'Input', 'Trigger', false, event)
						task_defer(remote_event_fire_server, remote_event, 'Input', 'Action', false)
					end
				end

				if open then
					your_action_progress.Value = 0
				end

				while _ENV[_NAME] and your_action_event.Value == new_event and your_action_progress.Value < 1 and open do
					heartbeat:Wait()
				end

				your_action_event.Value, your_action_input.Value = last_event, last_input
				task_defer(remote_event_fire_server, remote_event, 'Input', 'Trigger', last_event and true or false, last_event)
				task_defer(remote_event_fire_server, remote_event, 'Input', 'Action', last_input)
				send_msg(silent, 'All doors are ' .. (open and 'opened' or 'closed') .. '.', white)
			else
				send_msg(silent, 'Doesn\'t work without map.', red)
			end
		end,
		escape = function(silent)
			local map = current_map.Value

			if map then
				local children = map:GetChildren()

				for idx = 1, #children do
					local child = children[idx]
					if string_find(string_upper(child.Name), 'EXITDOOR', 1, true) ~= 1 then continue end
					local exit_area = child:FindFirstChild('ExitArea')
					if not exit_area or child:FindFirstChild('ExitDoorTrigger') then continue end
					local org_cf = exit_area:GetAttribute('OriginalCFrame')
					if not org_cf then
						local cf = exit_area.CFrame
						org_cf = cf
						exit_area:SetAttribute('OriginalCFrame', cf)
					end
					local your_char = you.Character
					if not your_char then continue end
					local your_cf = your_char:GetPivot()
					exit_area.CFrame = your_cf
					coroutine_wrap(restore_ea)(exit_area, org_cf)
					return send_msg(silent, 'Fleed the facility.', white)
				end

				send_msg(silent, 'No exits were open.', red)
			else
				send_msg(silent, 'Doesn\'t work without map.', red)
			end
		end,
		fire = function(silent)
			local your_hrp = (you.Character or game):FindFirstChild('HumanoidRootPart')
			if not your_hrp then return send_msg(silent, 'No humanoid root part detected.', red) end
			fire_enabled = not fire_enabled

			if fire_enabled then
				for _ = 1, 3 do
					local y = instance_new('Fire')
					y.Archivable = false
					y.Color = green_fire_color
					y.Heat = 9
					y.Name = 'GreenFire'
					y.SecondaryColor = white_fire_color
					y.Size = 3
					y.Parent = your_hrp
				end
			else
				for _ = 1, 3 do
					your_hrp:FindFirstChild('GreenFire'):Destroy()
				end
			end

			send_msg(silent, 'Fire is ' .. (fire_enabled and 'on' or 'off') .. '.', white)
		end,
		fixgui = function(silent)
			local black_out_screen_gui = your_gui:FindFirstChild('BlackOutScreenGui')
			local screen_gui = your_gui:FindFirstChild('ScreenGui')
			local fixed = false

			if black_out_screen_gui then
				local black_out_frame = black_out_screen_gui:FindFirstChild('BlackOutFrame')
				local whitelist_black_out_frame = black_out_screen_gui:FindFirstChild('WhitelistBlackOutFrame')

				if black_out_frame and black_out_frame.BackgroundTransparency ~= 1 then
					black_out_frame.BackgroundTransparency = 1
					fixed = true
				end

				if whitelist_black_out_frame and whitelist_black_out_frame.Visible then
					whitelist_black_out_frame.Visible = false
					fixed = true
				end
			end

			if screen_gui then
				local menus_tab_frame = screen_gui:FindFirstChild('MenusTabFrame')

				if menus_tab_frame and not menus_tab_frame.Visible then
					menus_tab_frame.Visible = true
					fixed = true
				end
			end

			send_msg(silent, fixed and 'Fixed GUI.' or 'There was no need to fix GUI.', fixed and white or red)
		end,
		fly = function(silent)
			local char = you.Character
			if not char then return end
			local h = char:FindFirstChildOfClass('Humanoid')
			if not h then return end
			local torso = char:FindFirstChild('Torso')
			if not torso then return end
			fly_enabled = not fly_enabled

			if fly_enabled then
				local body_gyro = torso:FindFirstChild('BodyGyroCheat') or instance_new('BodyGyro')
				body_gyro.Archivable = false
				body_gyro.MaxTorque = inf_vec3
				body_gyro.Name = 'BodyGyroCheat'
				body_gyro.P = 9e4
				body_gyro.Parent = torso

				local body_velocity = torso:FindFirstChild('BodyVelocityCheat') or instance_new('BodyVelocity')
				body_velocity.Archivable = false
				body_velocity.MaxForce = inf_vec3
				body_velocity.Name = 'BodyVelocityCheat'
				body_velocity.Parent = torso
			else
				local body_gyro = torso:FindFirstChild('BodyGyroCheat')
				if body_gyro then body_gyro:Destroy() end
				local body_velocity = torso:FindFirstChild('BodyVelocityCheat')
				if body_velocity then body_velocity:Destroy() end
				h.PlatformStand = false
			end

			send_msg(silent, 'Fly is ' .. (fly_enabled and 'on' or 'off') .. '.', white)
		end,
		fps = function(silent, fps)
			local new_fps = tonumber(fps) or 60
			set_fps_cap(new_fps)
			send_msg(silent, 'Set FPS to ' .. new_fps .. '.', white)
		end,
		fulbrt = function(silent)
			local children = lighting:GetChildren()

			for idx = 1, #children do
				local child = children[idx]

				if child:IsA('Atmosphere') then
					child.Density = 0
					child.Glare = 0
					child.Haze = 0
					child.Offset = 0
				end

				if child:IsA('PostEffect') then
					child.Enabled = false
				end

				if child:IsA('Sky') then
					child.CelestialBodiesShown = true
					child.MoonAngularSize = 11
					child.MoonTextureId = 'rbxasset://sky/moon.jpg'
					child.SkyboxBk = 'rbxasset://textures/sky/sky512_bk.tex'
					child.SkyboxDn = 'rbxasset://textures/sky/sky512_dn.tex'
					child.SkyboxFt = 'rbxasset://textures/sky/sky512_ft.tex'
					child.SkyboxLf = 'rbxasset://textures/sky/sky512_lf.tex'
					child.SkyboxRt = 'rbxasset://textures/sky/sky512_rt.tex'
					child.SkyboxUp = 'rbxasset://textures/sky/sky512_up.tex'
					child.StarCount = 3000
					child.SunAngularSize = 21
					child.SunTextureId = 'rbxasset://sky/sun.jpg'
				end
			end

			lighting.Ambient = white
			lighting.Brightness = 3
			lighting.ClockTime = 14.5
			lighting.ExposureCompensation = 0
			lighting.EnvironmentDiffuseScale = 1
			lighting.EnvironmentSpecularScale = 1
			lighting.OutdoorAmbient = white

			send_msg(silent, 'Deleted all lighting effects.', white)
		end,
		headcol = function(silent)
			local head = (you.Character or game):FindFirstChild('Head')
			if not head then return send_msg(silent, 'No head detected.', red) end
			local new_can_collide = not head.CanCollide
			head.CanCollide = new_can_collide
			send_msg(silent, 'Set head collision to ' .. (new_can_collide and 'true' or 'false') .. '.', white)
		end,
		hit = function(silent, ...)
			send_msg(silent, hit(...))
		end,
		infjmp = function(silent)
			inf_jmp_enabled = not inf_jmp_enabled
			send_msg(silent, 'Jumping in air is ' .. (inf_jmp_enabled and 'on' or 'off') .. '.', white)
		end,
		kb = function(silent, key, ...)
			if not key or key == '' then return send_msg(silent, 'Key is not provided.', red) end
			local succ, result = pcall(get, key_code, key)
			if not succ or not result then return send_msg(silent, key .. ' is not a valid key.', red) end
			local command = table_concat({...}, ' ')
			if command == '' then return send_msg(silent, 'Command is missing.', red) end
			if keybinds[command] then return send_msg(silent, 'Command already exists.', red) end
			if find_key_precise(keybinds, command, nil) then return send_msg(silent, 'Command already exists.', red) end
			if not commands[string_match(command, '%p?%w+')] then
				return send_msg(silent, 'Invalid command (if valid, then use prefix like \'/\' before command name).', red)
			end

			keybind(command, result)
			send_msg(silent, 'Bound ' .. command .. ' to ' .. key .. ' key.', white)
		end,
		kbp = function(silent, key, sx, cx, sy, cy)
			if not key or key == '' then return send_msg(silent, 'Key is not provided.', red) end
			local succ, result = pcall(get, key_code, key)
			if not succ or not result then return send_msg(silent, key .. ' is not a valid key.', red) end
			local found = false
			local keybind_name = _NAME .. key
			sx = tonumber(sx) or 0
			cx = tonumber(cx) or 0
			sy = tonumber(sy) or 0
			cy = tonumber(cy) or 0

			for _, name in next, keybinds do
				if name == keybind_name then
					found = true
					break
				end
			end

			if found then
				sca_ui['ContextActionButton_' .. keybind_name].Position = udim2_new(sx, cx, sy, cy)
			end

			send_msg(silent, found and ('Put bind to {' .. sx .. ', ' .. cx .. ', ' .. sy .. ', ' .. cy .. '}.') or
				('Commands to ' .. key .. ' key weren\'t bound.'), found and white or red)
		end,
		min_height = function(silent, min)
			local h = (you.Character or game):FindFirstChildOfClass('Humanoid')
			if not h then return send_msg(silent, 'No humanoid detected.', red) end
			min_height = tonumber(min) or 0
			h.HipHeight = math_max(h.HipHeight, min_height)
			send_msg(silent, 'Set your minimal hip height to ' .. min_height .. '.', white)
		end,
		min_jump = function(silent, min)
			local h = (you.Character or game):FindFirstChildOfClass('Humanoid')
			if not h then return send_msg(silent, 'No humanoid detected.', red) end
			min_jump = tonumber(min) or 0
			h.JumpPower = math_max(h.JumpPower, min_jump)
			send_msg(silent, 'Set your minimal jump power to ' .. min_jump .. '.', white)
		end,
		min_speed = function(silent, min)
			local h = (you.Character or game):FindFirstChildOfClass('Humanoid')
			if not h then return send_msg(silent, 'No humanoid detected.', red) end
			min_speed = tonumber(min) or 0
			h.WalkSpeed = math_max(h.WalkSpeed, min_speed)
			send_msg(silent, 'Set your minimal walk speed to ' .. min_speed .. '.', white)
		end,
		nextbeast = function(silent)
			local beast_chances = {}
			local chance_to_plr = {}
			local list = plrs:GetPlayers()
			local len = #list
			if len == 1 then return send_msg(silent, 'The next beast is you.', white) end

			for idx = 1, len do
				local element = list[idx]
				local chance = element:WaitForChild('SavedPlayerStatsModule'):WaitForChild('BeastChance').Value
				beast_chances[idx] = chance
				chance_to_plr[chance] = element
			end

			table_sort(beast_chances, greater_than)
			local plr = chance_to_plr[beast_chances[1]]
			table_clear(beast_chances)
			table_clear(chance_to_plr)
			send_msg(silent, 'The next beast is ' .. get_plr_name(plr) .. '.', white)
		end,
		noerrors = function(silent)
			no_errors_mode = not no_errors_mode
			send_msg(silent, 'Always win minigame mode is ' .. (no_errors_mode and 'on' or 'off') .. '.', white)
		end,
		reset = function(silent)
			local h = (you.Character or game):FindFirstChildOfClass('Humanoid')
			if not h then return send_msg(silent, 'No humanoid detected.', red) end

			for _ = 1, 4 do
				h:SetStateEnabled(dead, true)
				h.BreakJointsOnDeath = true
				h.RequiresNeck = true
				h:ChangeState(dead)
				h.Health = 0
				h.MaxHealth = 4
				task_wait()
			end

			send_msg(silent, 'Reset your character.', white)
		end,
		rn = function(silent, another)
			if another then
				teleport_service:Teleport(_PLACE_ID, you)
			else
				teleport_service:TeleportToPlaceInstance(_PLACE_ID, job_id, you)
			end

			you:Kick('Rejoining...')
		end,
		run = function(silent, ...)
			local succ, func = pcall(loadstring, table_concat({...}, ' '))

			if succ then
				coroutine_wrap(func)()
				send_msg(silent, 'Executed Lua code using \'loadstring\'.', white)
			else
				send_msg(silent, 'Loadstring error.', red)
			end
		end,
		save = function(silent, ...)
			send_msg(silent, save(...))
		end,
		set_height = function(silent, new)
			local h = (you.Character or game):FindFirstChildOfClass('Humanoid')
			if not h then return send_msg(silent, 'No humanoid detected.', red) end
			local hip_height = tonumber(new) or h.HipHeight
			h.HipHeight = hip_height
			send_msg(silent, 'Set your current jump power to ' .. hip_height .. '.', white)
		end,
		set_jump = function(silent, new)
			local h = (you.Character or game):FindFirstChildOfClass('Humanoid')
			if not h then return send_msg(silent, 'No humanoid detected.', red) end
			local jump_power = tonumber(new) or h.JumpPower
			h.JumpPower = jump_power
			send_msg(silent, 'Set your current jump power to ' .. jump_power .. '.', white)
		end,
		set_speed = function(silent, new)
			local h = (you.Character or game):FindFirstChildOfClass('Humanoid')
			if not h then return send_msg(silent, 'No humanoid detected.', red) end
			local walk_speed = tonumber(new) or h.WalkSpeed
			h.WalkSpeed = walk_speed
			send_msg(silent, 'Set your current walk speed to ' .. walk_speed .. '.', white)
		end,
		spectate = function(silent, username)
			local plr = get_plr(username) or you
			local char = plr.Character
			if not char then return send_msg(silent, 'Target doesn\'t have a character.', red) end
			current_camera.CameraSubject = char
			send_msg(silent, 'Set camera subject to ' .. get_plr_name(plr) .. '.', white)
		end,
		tchat = function(silent)
			local enabled = not starter_gui:GetCoreGuiEnabled(core_gui_type_chat)
			starter_gui:SetCoreGuiEnabled(core_gui_type_chat, enabled)
			return send_msg(silent, 'Chat is ' .. (enabled and 'on' or 'off') .. '.', white)
		end,
		tcrawl = function(silent)
			local new_disable_crawl = not your_disable_crawl.Value
			your_disable_crawl.Value = new_disable_crawl
			send_msg(silent, 'Crawling is ' .. (new_disable_crawl and 'disabled' or 'enabled') .. '.', white)
		end,
		tp = function(silent, x, y, z)
			local plr = get_plr(x)

			if plr then
				local char = plr.Character
				if not char then return send_msg(silent, 'No character detected.', red) end
				local your_char = you.Character
				if not your_char then return send_msg(silent, 'No character detected.', red) end
				your_char:PivotTo(char:GetPivot())
				send_msg(silent, 'Teleported you to ' .. get_plr_name(plr) .. '.', white)
			else
				local char = you.Character
				if not char then return send_msg(silent, 'No character detected.', red) end
				local destination = vec3_new(tonumber(x) or 0, tonumber(y) or 0, tonumber(z) or 0)
				char:PivotTo(cf_new(destination) * char:GetPivot().Rotation)
				send_msg(silent, 'Teleported you to [' .. destination.X .. ', ' .. destination.Y .. ', ' .. destination.Z .. '].', white)
			end
		end,
		ttouch = function(silent)
			local char = you.Character
			local torso = (char or game):FindFirstChild('Torso')
			if not torso then return send_msg(silent, 'You don\'t have a character.', red) end
			local new_can_touch = not torso.CanTouch
			local descendants = char:GetDescendants()

			for idx = 1, #descendants do
				local descendant = descendants[idx]
				if not descendant:IsA('BasePart') then continue end
				descendant.CanTouch = new_can_touch
			end

			send_msg(silent, 'Can touch is ' .. (new_can_touch and 'on' or 'off') .. '.', white)
		end,
		tu = function(silent, username, x, y, z)
			local he = workspace:FindFirstChild('HammerEvent', true)
			if not he then return send_msg(silent, 'No beast was detected.', red) end
			if username == '>' or username == '<' then
				local chars = {}
				local len = 0	
				local list = plrs:GetPlayers()

				for idx = 1, #list do
					local element = list[idx]
					if element == you or not element.TempPlayerStatsModule.Ragdoll.Value then continue end
					local char = element.Character
					if not char or not (char:FindFirstChild('Head') and char:FindFirstChild('Torso')) then continue end
					len += 1
					chars[len] = char
				end

				if len <= 0 then return send_msg(silent, 'No character was available.', red) end
				table_sort(chars, compare_model_to_point(current_camera.CFrame.Position, username))
				local char = chars[1]
				local body_part = char:FindFirstChild('Head') or char:FindFirstChild('Torso')
				local pos = body_part.Position
				table_clear(chars)
				he:FireServer('HammerTieUp', body_part, vec3_new(tonumber(x) or pos.X, tonumber(y) or pos.Y, tonumber(z) or pos.Z))
				send_msg(silent, 'Tied up ' .. get_plr_name(plrs:GetPlayerFromCharacter(char)) .. '.', white)
			else
				local plr = get_plr(username) or you
				local char = plr.Character
				if not char then return send_msg(silent, 'Target doesn\'t have a character.', red) end
				local body_part = char:FindFirstChild('Head') or char:FindFirstChild('Torso')
				if not body_part then return send_msg(silent, 'Target doesn\'t have a character.', red) end
				if char:FindFirstChild('HammerEvent', true) and plr == you then return send_msg(silent, 'You are the beast.', red) end
				local pos = body_part.Position
				he:FireServer('HammerTieUp', body_part, vec3_new(tonumber(x) or pos.X, tonumber(y) or pos.Y, tonumber(z) or pos.Z))
				send_msg(silent, 'Tied up ' .. get_plr_name(plr) .. '.', white)
			end
		end,
		ub = function(silent, key)
			if not key or key == '' then return send_msg(silent, 'Key is not provided.', red) end
			local succ, result = pcall(get, key_code, key)
			if not succ or not result then return send_msg(silent, key .. ' is not a valid key.', red) end
			local found = false
			local keybind_name = _NAME .. key

			for command, name in next, keybinds do
				if name == keybind_name then
					found = true
					keybinds[command] = nil
				end
			end

			if found then
				context_action_service:UnbindAction(keybind_name)
				sca_ui['ContextActionButton_' .. keybind_name]:Destroy()
			end

			send_msg(
				silent,
				found and ('Unbound everything from ' .. key .. ' key.') or ('No command was bound to ' .. key .. ' key.'),
				found and white or red
			)
		end,
		unload = function(silent)
			_ENV[_NAME] = nil
			send_msg(silent, 'Unloaded cheat.', white)
		end,
		wpos = function(silent, nx, ny)
			local nx = math_floor(tonumber(nx) or -16)
			local ny = math_floor(tonumber(ny) or -16)
			wpx = nx == nx and nx or -16
			wpy = ny == ny and ny or -16
			commands_frame.Position = udim2_new(1, wpx, 1, wpy)
			send_msg(silent, 'Put the window at X: ' .. wpx .. ', Y: ' .. wpy .. '.', white)
		end,
		xray = function(silent)
			xray_enabled = not xray_enabled

			if xray_enabled then
				local descendants = workspace:GetDescendants()

				for idx = 1, #descendants do
					coroutine_wrap(descendant_added)(descendants[idx])
				end
			else
				for idx = 1, #xray_highlights do
					xray_highlights[idx]:Destroy()
				end

				table_clear(xray_highlights)
			end

			send_msg(silent, 'XRay is ' .. (xray_enabled and 'on' or 'off') .. '.', white)
		end
	}

	local help_line = 'Exclusive cheat commands. (' .. get_len(documentation) .. '/' .. get_len(cheat_functions) + 1 .. ' documentated)'
	cheat_functions.help = function(silent)
		send_msg(silent, help_line, process_color)

		for name, _ in next, cheat_functions do
			send_msg(silent, '/' .. name .. ' : ' .. (documentation[name] or '???'), white)
		end

		send_msg(silent)
	end

	for name, func in next, cheat_functions do
		commands['!' .. name] = func
		commands[',' .. name] = func
		commands['-' .. name] = func
		commands['.' .. name] = func
		commands['/' .. name] = func
		commands[':' .. name] = func
		commands[';' .. name] = func
		commands['?' .. name] = func
	end

	command_bar.FocusLost:Connect(function(enter_pressed)
		if not enter_pressed then return end
		local command = command_bar.Text
		command_bar.Text = ''

		local words = string_split(command, ' ')
		local func = commands[words[1]]
		table_remove(words, 1)
		send_msg(nil, '> ' .. command, white)

		if func then
			coroutine_wrap(run_command)(false, func, unpack(words))
		else
			send_msg(nil, 'No such command: ' .. command, red)
		end
	end)

	for command, name in next, keybinds do
		keybind(command, string_sub(name, name_len, -1))
	end

	starter_gui:SetCore('TopbarEnabled', true)
	starter_gui:SetCoreGuiEnabled(core_gui_type_backpack, true)

	if wpx or wpy then
		starter_gui:SetCore('SendNotification', notification_properties)
	end

	char_handler()

	while _ENV[_NAME] do
		if auto_rn and not you:FindFirstChildOfClass('PlayerScripts') then
			local duration = 2
			teleport_service:TeleportToPlaceInstance(_PLACE_ID, job_id, you)
			while _ENV[_NAME] and duration > 0 do duration -= heartbeat:Wait() end
		else
			if auto_bc then bc() end
			if auto_cptr then cptr() end
			if auto_hit then hit() end
			if auto_save then save() end

			for _ = 1, 3 do
				if no_errors_mode then
					remote_event:FireServer('SetPlayerMinigameResult', true)
				end

				heartbeat:Wait()
			end
		end
	end

	notification_properties.Icon = 'rbxassetid://6264845452'
	notification_properties.Text = 'Cheat deactivated.'
	starter_gui:SetCore('SendNotification', notification_properties)
	starter_gui:SetCore('TopbarEnabled', false)
	starter_gui:SetCoreGuiEnabled(core_gui_type_backpack, false)
	animation:Destroy()
	main_ui:Destroy()
	sca_ui:Destroy()

	for _, connection in next, connections do
		connection:Disconnect()
	end

	for _, name in next, keybinds do
		context_action_service:UnbindAction(name)
	end

	for idx = 1, #xray_highlights do
		xray_highlights[idx]:Destroy()
	end

	local your_backpack = you:FindFirstChildOfClass('Backpack')
	local your_char = you.Character

	if anim_track then
		anim_track:Stop(0)
		anim_track:Destroy()
	end

	if your_backpack and btools_received then
		for idx = 1, 3 do
			your_backpack:FindFirstChild(bin_types[idx].Name):Destroy()
		end
	end

	if your_char then
		local your_h = your_char:FindFirstChildOfClass('Humanoid')

		if your_h then
			your_h.PlatformStand = false
		end

		local your_hrp = your_char:FindFirstChild('HumanoidRootPart')

		if your_hrp and fire_enabled then
			for _ = 1, 3 do
				your_hrp:FindFirstChild('GreenFire'):Destroy()
			end
		end

		local your_torso = your_char:FindFirstChild('Torso')

		if your_torso then
			local body_gyro = your_torso:FindFirstChild('BodyGyroCheat')
			if body_gyro then body_gyro:Destroy() end
			local body_velocity = your_torso:FindFirstChild('BodyVelocityCheat')
			if body_velocity then body_velocity:Destroy() end
		end
	end

	table_clear(anims)
	table_clear(bin_types)
	table_clear(cheat_functions)
	table_clear(commands)
	table_clear(connections)
	table_clear(documentation)
	table_clear(notification_properties)
	table_clear(keybinds)
	table_clear(xray_highlights)
end)(ARGUMENTS_FROM_THE_TELEPORT_QUEUE)
