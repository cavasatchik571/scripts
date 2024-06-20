--!nolint
--!nonstrict

local _4 = Color3.new(0, .4984, 0)

-- by @Vov4ik4124

if game.PlaceId ~= 142823291 then return end
local gncm = getnamecallmethod or get_namecall_method
local hf = hookfunction or hook_function
local hmm = hookmetamethod or hook_meta_method
local nc = newcclosure
local plrs = game:GetService('Players')
local you = plrs.LocalPlayer
if not gncm or not hf or not hmm or not nc then return you:Kick('MM24 doesn\'t support your executor') end
local env = (getgenv or function() end)() or shared or _G
if env.mm24 then return end
env.mm24 = true
local cam = workspace.CurrentCamera
local cf_new = CFrame.new
local clear = table.clear
local color3_from_rgb = Color3.fromRGB
local colors_black = color3_from_rgb(0, 0, 0)
local colors_white = color3_from_rgb(255, 255, 255)
local core_gui = game:GetService('CoreGui')
local coroutine_create = coroutine.create
local coroutine_resume = coroutine.resume
local coroutine_yield = coroutine.yield
local data = {}
local dead = Enum.HumanoidStateType.Dead
local get_plr_data = game:GetService('ReplicatedStorage'):WaitForChild('Remotes'):WaitForChild('Extras'):WaitForChild('GetPlayerData')
local gui_service = game:GetService('GuiService')
local highlights = {}
local inst_new = Instance.new
local lighting = game:GetService('Lighting')
local name_tags = {}
local other_mouse = {}
local ray_new = Ray.new
local rng = Random.new()
local sleep = task.wait
local smooth = Enum.SurfaceType.Smooth
local smooth_plastic = Enum.Material.SmoothPlastic
local starter_player = game:GetService('StarterPlayer')
local touch = Enum.UserInputType.Touch
local ubuntu_font = Font.new('rbxasset://fonts/families/Ubuntu.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
local udim2_fs = UDim2.fromScale
local uis = game:GetService('UserInputService')
local upper = string.upper
local vec2_new = Vector2.new
local vec3_new = Vector3.new
local vim = game:GetService('VirtualInputManager')

local highlight_prefab = inst_new('BoxHandleAdornment')
highlight_prefab.AdornCullingMode = Enum.AdornCullingMode.Never
highlight_prefab.AlwaysOnTop = true
highlight_prefab.Color3 = _4
highlight_prefab.Name = 'Highlight'
highlight_prefab.Transparency = 0.644
highlight_prefab.ZIndex = 4

local name_tag = inst_new('BillboardGui')
name_tag.Active = false
name_tag.AlwaysOnTop = true
name_tag.AutoLocalize = false
name_tag.ClipsDescendants = false
name_tag.ExtentsOffsetWorldSpace = vec3_new(0, 1, 0)
name_tag.LightInfluence = 0
name_tag.MaxDistance = 1440
name_tag.Name = 'NameTag'
name_tag.ResetOnSpawn = false
name_tag.Size = udim2_fs(6, 1.44)
name_tag.StudsOffsetWorldSpace = vec3_new(0, 1.44, 0)

local name_tag_lbl = inst_new('TextLabel')
name_tag_lbl.Active = false
name_tag_lbl.BackgroundColor3 = colors_white
name_tag_lbl.BackgroundTransparency = 1
name_tag_lbl.BorderColor3 = colors_white
name_tag_lbl.FontFace = ubuntu_font
name_tag_lbl.Interactable = false
name_tag_lbl.MaxVisibleGraphemes = 24
name_tag_lbl.Name = 'Label'
name_tag_lbl.Text = ''
name_tag_lbl.TextColor3 = colors_white
name_tag_lbl.TextScaled = true
name_tag_lbl.TextStrokeColor3 = colors_black
name_tag_lbl.TextStrokeTransparency = 0
name_tag_lbl.ZIndex = 4000
name_tag_lbl.Parent = name_tag

local ui = inst_new('ScreenGui')
ui.AutoLocalize = false
ui.ClipToDeviceSafeArea = false
ui.DisplayOrder = 4000
ui.IgnoreGuiInset = true
ui.Name = '4Gui'
ui.ResetOnSpawn = false

local ui_btn = inst_new('TextButton')
ui_btn.Active = true
ui_btn.AnchorPoint = vec2_new(0.5, 0.5)
ui_btn.AutoButtonColor = false
ui_btn.BackgroundColor3 = colors_black
ui_btn.BackgroundTransparency = 0.5
ui_btn.BorderColor3 = _4
ui_btn.BorderMode = Enum.BorderMode.Outline
ui_btn.BorderSizePixel = 4
ui_btn.FontFace = ubuntu_font
ui_btn.MaxVisibleGraphemes = 1
ui_btn.Name = 'Interact'
ui_btn.Position = udim2_fs(0.75, 0.725)
ui_btn.Size = udim2_fs(0.144, 0.144)
ui_btn.SizeConstraint = Enum.SizeConstraint.RelativeYY
ui_btn.Text = '4'
ui_btn.TextColor3 = colors_white
ui_btn.TextScaled = true
ui_btn.TextStrokeColor3 = _4
ui_btn.TextStrokeTransparency = 0
ui_btn.ZIndex = 4000

do
	local line = inst_new('Frame')
	line.Active = false
	line.AnchorPoint = vec2_new(0, 0)
	line.BackgroundColor3 = colors_white
	line.BorderColor3 = colors_black
	line.BorderSizePixel = 0
	line.Interactable = false
	line.Name = 'Line'
	line.Position = udim2_fs(0, 0)

	local new_line_1 = line:Clone()
	new_line_1.AnchorPoint = vec2_new(0, 1)
	new_line_1.Size = udim2_fs(1, 0.04)
	new_line_1.Parent = name_tag_lbl

	local new_line_2 = line:Clone()
	new_line_2.Position = udim2_fs(0, 1)
	new_line_2.Size = udim2_fs(1, 0.04)
	new_line_2.Parent = name_tag_lbl

	local new_line_3 = line:Clone()
	new_line_3.AnchorPoint = vec2_new(1, 0)
	new_line_3.Size = udim2_fs(0.04, 1)
	new_line_3.Parent = name_tag_lbl

	local new_line_4 = line:Clone()
	new_line_4.Position = udim2_fs(1, 0)
	new_line_4.Size = udim2_fs(0.04, 1)
	new_line_4.Parent = name_tag_lbl
	name_tag_lbl.Changed:Connect(function(prop)
		if prop ~= 'BorderColor3' then return end
		local color = name_tag_lbl.BorderColor3
		new_line_1.BorderColor3, new_line_2.BorderColor3, new_line_3.BorderColor3, new_line_4.BorderColor3 = color, color, color, color
	end)

	local ui_stroke = inst_new('UIStroke')
	ui_stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	ui_stroke.Color = colors_black
	ui_stroke.Enabled = true
	ui_stroke.LineJoinMode = Enum.LineJoinMode.Round
	ui_stroke.Name = 'Stroke'
	ui_stroke.Thickness = 4
	ui_stroke.Parent = ui_btn
end

ui.Parent = pcall(tostring, core_gui) and core_gui or you:WaitForChild('PlayerGui')

-- omg4 ...

local function child_added_lighting(e) if e:IsA('PostEffect') then e.Enabled = false end end
local function set(a: any, b: any, c: any) a[b] = c end
local special_func_checks: {any} = {
	function(e) return e.Parent and e.Name == 'GunDrop' end,
	function(e) return e.Parent and e.Name == 'ThrowingKnife' end,
	function(e) return e.Parent and e.Name == 'Trap' end,
	function(e)
		local parent = e.Parent
		if not parent or parent.Name == 'Handle' then return false end
		local effect = parent:FindFirstChildOfClass('ParticleEmitter')
		return effect and effect.Texture == 'rbxassetid://16885815956' or false
	end
}

local function change_mouse_properties(...)
	clear(other_mouse)
	local args = {...}
	for idx = 1, #args, 2 do other_mouse[args[idx]] = args[idx + 1] end
	clear(args)
end

local function check_special(e)
	for idx = 1, #special_func_checks do if special_func_checks[idx](e) then return true end end
	return false
end

local function descendant_added_w(e)
	if e:IsA('BasePart') then
		e.BackSurface, e.BottomSurface, e.FrontSurface, e.LeftSurface, e.RightSurface, e.TopSurface = smooth, smooth, smooth, smooth, smooth, smooth
		e.Material, e.Reflectance = smooth_plastic, 0
		local special = check_special(e)
		if not special then
			sleep(0.004)
			local char = e.Parent
			if char == nil then return end
			local plr = plrs:FindFirstChild(char.Name)
			if plr == nil or plr == you then return end
			local h = char:WaitForChild('Humanoid', 0.4)
			if h == nil or h.Health <= 0 or h:GetState() == dead then return end
		end

		local highlight = highlights[e]
		if highlight then return end
		local new_highlight = highlight_prefab:Clone()
		if special then new_highlight.Name, new_highlight.Transparency = 'SpecialHighlight', 0.24 end
		highlights[e] = new_highlight
		new_highlight.Parent = ui
	elseif e:IsA('Decal') then
		e.Transparency = 1
	elseif e:IsA('Beam') or e:IsA('Fire') or e:IsA('Highlight') or e:IsA('Light') or
		e:IsA('ParticleEmitter') or e:IsA('Smoke') or e:IsA('Sparkles') or e:IsA('Trail') then
		e.Enabled = false
	elseif e:IsA('Attachment') or e:IsA('Constraint') or e:IsA('Explosion') or e:IsA('FloorWire') or e:IsA('ForceField') then
		e.Visible = false
	end
end

local function get_plr_pos(mode)
	local cam_pos = cam.CFrame.Position
	local dist = 400
	local list = plrs:GetPlayers()
	local result

	for idx = 1, #list do
		local element = list[idx]
		if element == nil or element == you then continue end
		local bp = element:FindFirstChildOfClass('Backpack')
		if bp == nil then continue end
		local char = element.Character
		if char == nil then continue end
		local h = char:FindFirstChildOfClass('Humanoid')
		if h == nil or h.Health <= 0 or h:GetState() == dead then continue end
		local hrp = h.RootPart
		if hrp == nil then continue end
		if mode == 'Murderer' then
			if bp:FindFirstChild('Knife') == nil and char:FindFirstChild('Knife') == nil then continue end
		elseif mode == 'Sheriff' then
			if bp:FindFirstChild('Gun') == nil and char:FindFirstChild('Gun') == nil then continue end
		end
		local new_dist = (cam_pos - hrp.Position).Magnitude
		if new_dist >= dist then continue end
		dist, result = new_dist, hrp
	end

	clear(list)
	return result
end

local function multi_call_internal()
	while true do
		local args = {coroutine_yield()}
		local func = args[1]
		if not func then return end
		func(unpack(args, 2))
		clear(args)
	end
end

local function plr_added(plr)
	if plr == you then return end
	local name_tag = name_tags[plr]
	if name_tag then return end
	name_tag = name_tag_lbl:Clone()
	name_tag.Label.Text = plr.Name
	name_tags[plr] = name_tag
	name_tag.Parent = ui
end

lighting.ChildAdded:Connect(child_added_lighting)
local list = lighting:GetChildren()
for i = 1, #list do child_added_lighting(list[i]) end
clear(list)
local thread = coroutine_create(multi_call_internal)
workspace.DescendantAdded:Connect(descendant_added_w)
workspace.DescendantRemoving:Connect(function(e)
	local highlight = highlights[e]
	if highlight == nil then return end
	highlights[e] = nil
	highlight:Destroy()
end)
local list = workspace:GetDescendants()
for i = 1, #list do coroutine_resume(thread, descendant_added_w, list[i]) end
clear(list)
coroutine_resume(thread)
plrs.PlayerAdded:Connect(plr_added)
plrs.PlayerRemoving:Connect(function(plr)
	if plr == you then return end
	local name_tag = name_tags[plr]
	if not name_tag then return end
	name_tags[plr] = nil
	name_tag:Destroy()
end)
local list = plrs:GetPlayers()
for i = 1, #list do plr_added(list[i]) end
clear(list)

local did_exist, rendering_stuff = pcall(settings)
local lowest_quality = Enum.QualityLevel.Level01
local terrain = workspace.Terrain
if did_exist then
	local rendering = rendering_stuff.Rendering
	pcall(set, rendering, 'EagerBulkExecution', false)
	pcall(set, rendering, 'EditQualityLevel', lowest_quality)
	pcall(set, rendering, 'EnableFRM', false)
	pcall(set, rendering, 'FrameRateManager', Enum.FramerateManagerMode.Off)
	pcall(set, rendering, 'QualityLevel', lowest_quality)
end

lighting.FogColor, lighting.FogEnd, lighting.FogStart, lighting.GlobalShadows = colors_black, 9e9, 9e9, false
terrain.WaterReflectance, terrain.WaterTransparency, terrain.WaterWaveSize, terrain.WaterWaveSpeed = 0, 0, 0, 0

local function target(part)
	local cam_pos = cam.CFrame.Position
	local pos = part.Position
	local screen_point = cam:WorldToScreenPoint(pos)
	local x = screen_point.X + 30 + rng:NextInteger(-1, 1)
	local y = screen_point.Y + 30 + rng:NextInteger(-1, 1)
	ui_btn.Interactable = true
	change_mouse_properties(
		'Hit', cf_new(pos), 'Origin', cf_new(cam_pos, pos), 'Target', part,
		'UnitRay', ray_new(cam_pos, (pos - cam_pos).Unit), 'X', x, 'Y', y
	)
	return x, y
end

local old_func
old_func = hmm(game, '__index', nc(function(self, key) return self == you:GetMouse() and other_mouse[key] or old_func(self, key) end))
ui_btn.Activated:Connect(function()
	if not ui_btn.Interactable then return end
	local your_char = you.Character
	if not your_char then return end
	local your_h = your_char:FindFirstChildOfClass('Humanoid')
	if not your_h or your_h.Health <= 0 or your_h:GetState() == dead then return end
	local your_hrp = your_h.RootPart
	if not your_hrp then return end
	local your_tool = your_char:FindFirstChildOfClass('Tool')
	if not your_tool then return end
	local name = your_tool.Name
	local is_gun = name == 'Gun'
	local is_knife = name == 'Knife'
	if not is_gun and not is_knife then return end
	local other_part = (is_gun and get_plr_pos('Murderer')) or (is_knife and get_plr_pos('Sheriff')) or get_plr_pos('')
	if not other_part then return end
	local left_top_corner = gui_service:GetGuiInset()
	local safe_zone_offsets = gui_service:GetSafeZoneOffsets()
	local cx, cy = safe_zone_offsets.left, safe_zone_offsets.top
	clear(safe_zone_offsets)
	cx += left_top_corner.X
	cy += left_top_corner.Y

	if uis:GetLastInputType() == touch then
		local x, y = target(other_part)
		vim:SendTouchEvent(14, 0, x + cx, y + cy)
		sleep(0.004)
		local x, y = target(other_part)
		vim:SendTouchEvent(14, 2, x + cx, y + cy)
	else
		local x, y = target(other_part)
		x += cx
		y += cy
		vim:SendMouseButtonEvent(x, y, 0, true, nil, 0)
		vim:SendMouseButtonEvent(x, y, 1, true, nil, 0)
		sleep(0.004)
		local x, y = target(other_part)
		x += cx
		y += cy
		vim:SendMouseButtonEvent(x, y, 0, false, nil, 0)
		vim:SendMouseButtonEvent(x, y, 1, false, nil, 0)
	end

	change_mouse_properties()
	ui_btn.Interactable = false
end)

local sg = game:GetService('StarterGui')
local sg_sc = sg.SetCore
local sg_scp = {Button1 = 'OK', Duration = 4, Icon = 'rbxassetid://7440784829', Text = 'Script activated', Title = 'MM24'}
while true do if pcall(sg_sc, sg, 'SendNotification', sg_scp) then break else sleep(0.04) end end
clear(sg_scp)

local new_jh = starter_player.CharacterJumpHeight * 1.144
local new_jp = starter_player.CharacterJumpPower * 1.144
local new_ws = starter_player.CharacterWalkSpeed * 1.144
coroutine_resume(coroutine_create(function()
	while true do
		data = get_plr_data:InvokeServer() or data
		for plr, name_tag in next, name_tags do
			if not name_tag then continue end
			local bp = plr:FindFirstChildOfClass('Backpack')
			if not bp then continue end
			local char = plr.Character
			if not char then continue end
			local lbl = name_tag.Label
			local role = upper((data[plr.Name] or data).Role or '')
			if bp:FindFirstChild('Knife') or char:FindFirstChild('Knife') or
				role == 'FREEZER' or role == 'INFECTED' or role == 'MURDERER' or role == 'ZOMBIE' then
				lbl.BorderColor3 = _4
				lbl.TextColor3 = _4
			elseif bp:FindFirstChild('Gun') or char:FindFirstChild('Gun') or
				role == 'HERO' or role == 'RUNNER' or role == 'SHERIFF' or role == 'SURVIVOR' then
				lbl.BorderColor3 = colors_black
				lbl.TextColor3 = colors_white
			else
				lbl.BorderColor3 = colors_white
				lbl.TextColor3 = colors_white
			end
		end

		sleep(1.44)
	end
end))

while true do
	sleep(0.04)
	local char = you.Character
	if not char then continue end
	local h = char:FindFirstChildOfClass('Humanoid')
	if not h or h.Health <= 0 or h:GetState() == dead then continue end
	if h.UseJumpPower then if h.JumpPower ~= 0 then h.JumpPower = new_jp end else if h.JumpHeight ~= 0 then h.JumpHeight = new_jh end end
	if h.WalkSpeed == 0 then continue end
	h.WalkSpeed = new_ws
	ui_btn.Parent = (char:FindFirstChild('Gun') or char:FindFirstChild('Knife')) and ui or nil
end
