-- mm24.lua
-- by @Vov4ik4124

local _4 = Color3.new(0, .4984, 0)

-- source code

local place_id = game.PlaceId
if place_id ~= 142823291 then return end
local empty_func = function(...) end
local env = (getgenv or empty_func)() or _ENV or shared or _G
local new_mm24 = not env.mm24 and true or nil
env.mm24 = new_mm24
if not new_mm24 then return end
local mm24_settings = env.mm24_settings
local first_time = mm24_settings == nil
if first_time then
	mm24_settings = {mouse = {}}
	env.mm24_settings = mm24_settings
end

local activated = false
local cam = workspace.CurrentCamera
local cf_new = CFrame.new
local clear = table.clear
local color3_from_rgb = Color3.fromRGB
local colors_black = color3_from_rgb(0, 0, 0)
local colors_white = color3_from_rgb(255, 255, 255)
local core_gui = game:GetService('CoreGui')
local coroutine_create = coroutine.create
local coroutine_resume = coroutine.resume
local data = {}
local find = string.find
local get_plr_data = game:GetService('ReplicatedStorage'):WaitForChild('Remotes'):WaitForChild('Extras'):WaitForChild('GetPlayerData')
local gs = game:GetService('GuiService')
local highlights = {}
local inst_new = Instance.new
local it = Enum.UserInputType
local keyboard = it.Keyboard
local key_code = Enum.KeyCode.Y
local lbls = {}
local light_inst = inst_new('PointLight')
local light_part = inst_new('Part')
local lighting = game:GetService('Lighting')
local lowest_quality = Enum.QualityLevel.Level01
local min = math.min
local mm24_highlight = inst_new('BoxHandleAdornment')
local offset = Vector3.new(0, 3.444, 0)
local offset_x = 30
local offset_y = 30
local other_mouse = mm24_settings.mouse
local plrs = game:GetService('Players')
local ray_new = Ray.new
local rendering = settings().Rendering
local rng = Random.new()
local sg = game:GetService('StarterGui')
local sg_sc = sg.SetCore
local sg_scp = {}
local smooth = Enum.SurfaceType.Smooth
local smooth_plastic = Enum.Material.SmoothPlastic
local starter_player = game:GetService('StarterPlayer')
local stroke = inst_new('UIStroke')
local task_wait = task.wait
local terrain = workspace.Terrain
local touch = it.Touch
local udim2_from_offset = UDim2.fromOffset
local udim2_from_scale = UDim2.fromScale
local ui = inst_new('ScreenGui')
local ui_btn = inst_new('TextButton')
local uis = game:GetService('UserInputService')
local upper = string.upper
local vec3_zero = Vector3.zero
local vim = game:GetService('VirtualInputManager')
local you = plrs.LocalPlayer
light_inst.Brightness = 1.444
light_inst.Color = _4
light_inst.Enabled = true
light_inst.Name = '4'
light_inst.Range = 48
light_inst.Shadows = false
light_inst.Parent = light_part

light_part.Anchored = true
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
light_part.Size = vec3_zero
light_part.TopSurface = smooth
light_part.Transparency = 1
light_part.Parent = workspace

mm24_highlight.AdornCullingMode = Enum.AdornCullingMode.Never
mm24_highlight.AlwaysOnTop = true
mm24_highlight.Color3 = _4
mm24_highlight.Name = 'Highlight'
mm24_highlight.Transparency = 0.6444
mm24_highlight.Visible = true
mm24_highlight.ZIndex = 4

stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.Color = colors_white
stroke.Enabled = true
stroke.LineJoinMode = Enum.LineJoinMode.Round
stroke.Name = 'Stroke'
stroke.Thickness = 4
stroke.Parent = ui_btn

ui.AutoLocalize = false
ui.ClipToDeviceSafeArea = false
ui.DisplayOrder = 4000
ui.IgnoreGuiInset = true
ui.Name = '4Gui'
ui.ResetOnSpawn = false
ui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ui.Parent = pcall(tostring, core_gui) and core_gui or you:WaitForChild('PlayerGui')

ui_btn.Active = false
ui_btn.AnchorPoint = Vector2.new(0.5, 0.5)
ui_btn.AutoButtonColor = false
ui_btn.AutoLocalize = false
ui_btn.BackgroundColor3 = colors_black
ui_btn.BackgroundTransparency = 1
ui_btn.BorderColor3 = _4
ui_btn.BorderMode = Enum.BorderMode.Outline
ui_btn.BorderSizePixel = 4
ui_btn.FontFace = Font.new('rbxasset://fonts/families/Ubuntu.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
ui_btn.Interactable = false
ui_btn.Name = 'Element'
ui_btn.Text = '4'
ui_btn.TextColor3 = colors_white
ui_btn.TextScaled = true
ui_btn.TextStrokeColor3 = colors_black
ui_btn.TextStrokeTransparency = 0
ui_btn.Visible = false
ui_btn.ZIndex = 4000

local funcs_len = 2
local funcs = {
	function(obj)
		return typeof(obj.Parent) == 'Instance' and obj.Name == 'GunDrop'
	end,
	function(obj)
		local parent = obj.Parent
		if typeof(parent) ~= 'Instance' or parent.Name == 'Handle' then return false end
		local effect = parent:FindFirstChildOfClass('ParticleEmitter')
		if effect == nil then return false end
		return effect.Texture == 'rbxassetid://16885815956'
	end
}

local function change_mouse_properties(...)
	clear(other_mouse)
	local args = {...}
	for idx = 1, #args, 2 do other_mouse[args[idx]] = args[idx + 1] end
	clear(args)
end

local function get_plr_pos(mode)
	local cam_pos = cam.CFrame.Position
	local dist = 444
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
		if h == nil or h.Health <= 0 or h:GetState().Value == 15 then continue end
		local hrp = h.RootPart
		if hrp == nil then continue end
		if mode == 'Murderer' then
			if bp:FindFirstChild('Knife') == nil and char:FindFirstChild('Knife') == nil then continue end
		elseif mode == 'Sheriff' then
			if bp:FindFirstChild('Gun') == nil and char:FindFirstChild('Gun') == nil then continue end
		end
		local new_dist = (cam_pos - hrp.Position).Magnitude
		if new_dist >= dist then continue end
		dist = new_dist
		result = hrp
	end

	clear(list)
	return result
end

local function is_special(obj)
	for idx = 1, funcs_len do if funcs[idx](obj) then return true end end
	return false
end

local function notify(btn, dur, img, text, title)
	sg_scp.Button1 = btn
	sg_scp.Duration = dur
	sg_scp.Icon = img
	sg_scp.Text = text
	sg_scp.Title = title
	pcall(sg_sc, sg, 'SendNotification', sg_scp)
	clear(sg_scp)
end

local function lighting_added(descendant)
	if not descendant:IsA('PostEffect') then return end
	descendant.Enabled = false
end

local function plrs_added(plr)
	if plr == you then return end
	local plr_lbl = lbls[plr]
	if plr_lbl ~= nil then return end
	local new_lbl = ui_btn:Clone()
	lbls[plr] = new_lbl
	new_lbl.Name = tostring(plr.UserId)
	new_lbl.Parent = ui
end

local function scripted_shoot()
	if activated then return end
	local your_char = you.Character
	if your_char == nil then return end
	local your_h = your_char:FindFirstChildOfClass('Humanoid')
	if your_h == nil or your_h.Health <= 0 or your_h:GetState().Value == 15 then return end
	local your_hrp = your_h.RootPart
	if your_hrp == nil then return end
	local your_tool = your_char:FindFirstChildOfClass('Tool')
	if your_tool == nil then return end
	local name = your_tool.Name
	local is_gun = name == 'Gun'
	local is_knife = name == 'Knife'
	if not is_gun and not is_knife then return end
	local other_part = (is_gun and get_plr_pos('Murderer')) or (is_knife and get_plr_pos('Sheriff')) or get_plr_pos('')
	if other_part == nil then return end
	local cam_pos = cam.CFrame.Position
	local pos = other_part.Position
	local rng_x = offset_x + rng:NextInteger(-1, 1)
	local rng_y = offset_y + rng:NextInteger(-1, 1)
	activated = true
	change_mouse_properties(
		'Hit', cf_new(pos), 'Origin', cf_new(cam_pos, pos), 'Target', other_part,
		'UnitRay', ray_new(cam_pos, (pos - cam_pos).Unit), 'X', rng_x, 'Y', rng_y
	)

	if uis:GetLastInputType() == touch then
		local id = rng:NextInteger(14, 2147483647)
		local point = cam:WorldToScreenPoint(pos)
		vim:SendTouchEvent(id, 0, point.X + rng_x, point.Y + rng_y)
		task_wait(0.014)
		local point = cam:WorldToScreenPoint(pos)
		vim:SendTouchEvent(id, 2, point.X + rng_x, point.Y + rng_y)
	else
		local point = cam:WorldToScreenPoint(pos)
		local x = point.X + rng_x
		local y = point.Y + rng_y
		vim:SendMouseButtonEvent(x, y, 0, true, nil, 0)
		vim:SendMouseButtonEvent(x, y, 1, true, nil, 0)
		task_wait(0.014)
		local point = cam:WorldToScreenPoint(pos)
		local x = point.X + rng_x
		local y = point.Y + rng_y
		vim:SendMouseButtonEvent(x, y, 0, false, nil, 0)
		vim:SendMouseButtonEvent(x, y, 1, false, nil, 0)
	end

	change_mouse_properties()
	activated = false
end

local function workspace_added(descendant)
	if descendant:IsA('BasePart') then
		descendant.BackSurface = smooth
		descendant.BottomSurface = smooth
		descendant.FrontSurface = smooth
		descendant.LeftSurface = smooth
		descendant.Material = smooth_plastic
		descendant.Reflectance = 0
		descendant.RightSurface = smooth
		descendant.TopSurface = smooth
		local special = is_special(descendant)
		if not special then
			task_wait(0.004)
			local char = descendant.Parent
			if char == nil then return end
			local plr = plrs:FindFirstChild(char.Name)
			if plr == nil or plr == you then return end
			local h = char:WaitForChild('Humanoid', 0.4)
			if h == nil or h.Health <= 0 or h:GetState().Value == 15 then return end
		end

		local highlight = highlights[descendant]
		if highlight ~= nil then return end
		local new_highlight = mm24_highlight:Clone()
		if special then new_highlight.Name, new_highlight.Transparency = 'SpecialHighlight', 0.24 end
		highlights[descendant] = new_highlight
		new_highlight.Parent = ui
	elseif descendant:IsA('Decal') then
		descendant.Transparency = 1
	elseif descendant:IsA('Beam') or descendant:IsA('Fire') or descendant:IsA('Highlight') or descendant:IsA('ParticleEmitter') or
		descendant:IsA('Smoke') or descendant:IsA('Sparkles') or descendant:IsA('Trail') then
		descendant.Enabled = false
	elseif descendant:IsA('Attachment') or descendant:IsA('Constraint') or descendant:IsA('Explosion') or
		descendant:IsA('FloorWire') or descendant:IsA('ForceField') then
		descendant.Visible = false
	end
end

-- logic

if first_time then
	local old_func = empty_func
	old_func = hookmetamethod(game, '__index', newcclosure(function(self, key)
		return self == you:GetMouse() and other_mouse[key] or old_func(self, key)
	end))
end

local connections = {
	cam.DescendantAdded:Connect(lighting_added),
	lighting.DescendantAdded:Connect(lighting_added),
	plrs.PlayerAdded:Connect(plrs_added),
	plrs.PlayerRemoving:Connect(function(plr)
		local plr_lbl = lbls[plr]
		if plr_lbl == nil then return end
		plr_lbl:Destroy()
		lbls[plr] = nil
	end),
	uis.InputBegan:Connect(function(input, gpe)
		if gpe or gs.MenuIsOpen or input.KeyCode ~= key_code or input.UserInputType ~= keyboard or uis:GetFocusedTextBox() ~= nil then return end
		scripted_shoot()
	end),
	workspace.DescendantAdded:Connect(workspace_added),
	workspace.DescendantRemoving:Connect(function(descendant)
		local highlight = highlights[descendant]
		if highlight == nil then return end
		highlight:Destroy()
		highlights[descendant] = nil
	end)
}

local list_1 = lighting:GetDescendants()
local list_2 = plrs:GetPlayers()
local list_3 = workspace:GetDescendants()
local new_jh = starter_player.CharacterJumpHeight * 1.144
local new_jp = starter_player.CharacterJumpPower * 1.144
local new_ws = starter_player.CharacterWalkSpeed * 1.144
for idx = 1, #list_1 do coroutine_resume(coroutine_create(lighting_added), list_1[idx]) end
for idx = 1, #list_2 do coroutine_resume(coroutine_create(plrs_added), list_2[idx]) end
for idx = 1, #list_3 do coroutine_resume(coroutine_create(workspace_added), list_3[idx]) end
clear(list_1)
clear(list_2)
clear(list_3)
coroutine_resume(coroutine_create(function()
	while env.mm24 do
		data = get_plr_data:InvokeServer() or data
		task_wait(1.4)
	end

	clear(data)
end))

local interact_btn = ui_btn:Clone()
local new_stroke = interact_btn:FindFirstChildOfClass('UIStroke') do if new_stroke then new_stroke.Color = colors_black end end
local lighting_settings = {FogColor = lighting.FogColor, FogEnd = lighting.FogEnd, FogStart = lighting.FogStart, GlobalShadows = lighting.GlobalShadows}
local rendering_quality_level = rendering.QualityLevel
local terrain_settings = {
	WaterReflectance = terrain.WaterReflectance, WaterTransparency = terrain.WaterTransparency,
	WaterWaveSize = terrain.WaterWaveSize, WaterWaveSpeed = terrain.WaterWaveSpeed
}

interact_btn.Active = true
interact_btn.BackgroundTransparency = 0.5
interact_btn.BorderSizePixel = 0
interact_btn.Interactable = true
interact_btn.MaxVisibleGraphemes = 1
interact_btn.Name = 'Interact'
interact_btn.Position = udim2_from_scale(0.75, 0.725)
interact_btn.Size = udim2_from_scale(0.14, 0.14)
interact_btn.SizeConstraint = Enum.SizeConstraint.RelativeYY
interact_btn.Text = '4'
interact_btn.TextColor3 = colors_white
interact_btn.TextStrokeColor3 = _4
interact_btn.Visible = false
interact_btn.Parent = ui
interact_btn.MouseButton1Down:Connect(scripted_shoot)
notify('OK', 4, 'rbxassetid://7440784829', 'Script activated', 'MM24')

while env.mm24 do
	task_wait()
	local cam_pos = cam.CFrame.Position
	light_part.Position = cam_pos
	for adornee, highlight in next, highlights do
		if typeof(adornee) ~= 'Instance' or not adornee:IsA('BasePart') then continue end
		local parent = adornee.Parent
		if parent == nil or highlight.Parent == nil then continue end
		highlight.Adornee = adornee
		highlight.Size = adornee.Size * (highlight.Name == 'SpecialHighlight' and 2 or 1)
		local plr = plrs:GetPlayerFromCharacter(parent)
		if plr == nil then continue end
		local lbl = ui:FindFirstChild(tostring(plr.UserId))
		if lbl == nil or not lbl:IsA('GuiObject') then continue end
		highlight.Color3 = lbl.BorderColor3
	end

	for plr, plr_lbl in next, lbls do
		plr_lbl.Visible = false
		if plr_lbl.Parent == nil then continue end
		local char = plr.Character
		if char == nil or char.Parent ~= workspace then continue end
		local h = char:FindFirstChildOfClass('Humanoid')
		if h == nil or h.Health <= 0 or h:GetState().Value == 15 then continue end
		local hrp = h.RootPart
		if hrp == nil then continue end
		local pos = (hrp.Position or vec3_zero) + offset
		local pos_2d = cam:WorldToViewportPoint(pos)
		local pos_dist = (cam_pos - pos).Magnitude
		if pos_2d.Z < 0 or pos_dist > 444 then continue end
		local lbl_stroke = plr_lbl:FindFirstChildOfClass('UIStroke')
		if lbl_stroke == nil or not lbl_stroke:IsA('UIStroke') then continue end
		local name = plr.Name
		local role = upper(tostring((data[name] or data).Role))
		lbl_stroke.Thickness = min(4, 100 / pos_dist)
		plr_lbl.Position = udim2_from_offset(pos_2d.X, pos_2d.Y)
		plr_lbl.Size = udim2_from_offset(3000 / pos_dist, 600 / pos_dist)
		plr_lbl.Text = name
		plr_lbl.Visible = true

		if plr:FindFirstChild('Knife', true) ~= nil or char:FindFirstChild('Knife') ~= nil or
			role == 'FREEZER' or role == 'INFECTED' or role == 'MURDERER' or role == 'ZOMBIE' then
			plr_lbl.BorderColor3 = _4
			plr_lbl.TextColor3 = _4
			lbl_stroke.Color = _4
		elseif plr:FindFirstChild('Gun', true) ~= nil or char:FindFirstChild('Gun') ~= nil or
			role == 'HERO' or role == 'RUNNER' or role == 'SHERIFF' or role == 'SURVIVOR' then
			plr_lbl.BorderColor3 = colors_black
			plr_lbl.TextColor3 = colors_white
			lbl_stroke.Color = colors_black
		else
			plr_lbl.BorderColor3 = colors_white
			plr_lbl.TextColor3 = colors_white
			lbl_stroke.Color = colors_white
		end
	end

	interact_btn.Visible = false
	lighting.FogColor, lighting.FogEnd, lighting.FogStart, lighting.GlobalShadows = colors_black, 9e9, 9e9, false
	rendering.QualityLevel = lowest_quality
	terrain.WaterReflectance, terrain.WaterTransparency, terrain.WaterWaveSiz, terrain.WaterWaveSpeed = 0, 0, 0, 0
	local your_char = you.Character
	if your_char == nil then continue end
	local your_h = your_char:FindFirstChildOfClass('Humanoid')
	if your_h == nil or your_h.Health <= 0 or your_h:GetState().Value == 15 then continue end
	local your_hrp = your_h.RootPart
	if your_hrp == nil then continue end
	local your_tn = (your_char:FindFirstChildOfClass('Tool') or game).Name
	interact_btn.Visible = (your_tn == 'Gun' or your_tn == 'Knife') and uis:GetLastInputType() == touch
	your_h.JumpHeight = new_jh
	your_h.WalkSpeed = new_jp
	your_h.WalkSpeed = new_ws
end

ui_btn:Destroy()
ui:Destroy()
stroke:Destroy()
rendering.QualityLevel = rendering_quality_level
notify('OK', 4, 'rbxassetid://7440784829', 'Script deactivated', 'MM24')
mm24_highlight:Destroy()
light_part:Destroy()
light_inst:Destroy()
interact_btn:Destroy()
for key, val in next, terrain_settings do terrain[key] = val end
for key, val in next, lighting_settings do lighting[key] = val end
for idx = 1, 7 do connections[idx]:Disconnect() end
for _, lbl in next, lbls do lbl:Destroy() end
for _, highlight in next, highlights do highlight:Destroy() end
clear(terrain_settings)
clear(other_mouse)
clear(lighting_settings)
clear(lbls)
clear(highlights)
clear(connections)
activated = false
