--!nolint
--!nonstrict

local _4 = Color3.new(0, .4984, 0)

-- by @Vov4ik4124

if game.PlaceId ~= 142823291 then return end
local env = (getgenv or function() end)() or _ENV or shared or _G
local fti = firetouchinterest or fire_touch_interest
local gncm = getnamecallmethod or get_namecall_method
local hmm = hookmetamethod or hook_metamethod
local hf = hookfunction or hook_function
local ncc = newcclosure or new_cclosure
local plrs = game:GetService('Players')
local you = plrs.LocalPlayer
if not env or not fti or not gncm or not hf or not hmm or not ncc then return you:Kick('Your client does not support MM24 script') end
if env.mm24 then return end
env.mm24 = true
local danger_speed = 304
local danger_y_zone = -400
local gun_line_lifetime = 0.64
local hex_color_innocent = '#FFF'
local hex_color_murderer = '#F00'
local hex_color_sheriff = '#00F'
local highlight_refresh_rate = 0.144
local highlight_transparency = 0.75
local ih_size_increase = 1.5
local ih_transparency = 0.24
local jump_boost = 1.2
local line_thickness = 0.24
local long_range_dist = 400
local melee_hitbox_extender = 6
local name_tag_height_offset = 2
local name_tag_refresh_rate = 1
local name_tag_thickness = 4
local speed_boost = 1.314

local cam = workspace.CurrentCamera
local cf_new = CFrame.new
local color3_from_hex = Color3.fromHex
local colors_black = color3_from_hex('000')
local colors_innocent = color3_from_hex(hex_color_innocent)
local colors_murderer = color3_from_hex(hex_color_murderer)
local colors_sheriff = color3_from_hex(hex_color_sheriff)
local colors_white = color3_from_hex('FFF')
local core_gui = game:GetService('CoreGui')
local coroutine_create = coroutine.create
local coroutine_resume = coroutine.resume
local clear = table.clear
local data = {}
local dead = Enum.HumanoidStateType.Dead
local debris = game:GetService('Debris')
local defer = task.defer
local enum_kc = Enum.KeyCode
local enum_rfi = Enum.RaycastFilterType
local enum_uit = Enum.UserInputType
local find = string.find
local get_plr_data = game:GetService('ReplicatedStorage'):WaitForChild('Remotes'):WaitForChild('Extras'):WaitForChild('GetPlayerData')
local gs = game:GetService('GuiService')
local highlights = {}
local inst_new = Instance.new
local keyboard = enum_uit.Keyboard
local lighting = game:GetService('Lighting')
local max = math.max
local min = math.min
local mouse = you:GetMouse()
local name_tags = {}
local ps = game:GetService('RunService').PreSimulation
local rcp_new = RaycastParams.new
local remove = table.remove
local rng = Random.new()
local sleep = task.wait
local smooth = Enum.SurfaceType.Smooth
local smooth_plastic = Enum.Material.SmoothPlastic
local sort = table.sort
local starter_player = game:GetService('StarterPlayer')
local terrain = workspace.Terrain
local touch = enum_uit.Touch
local ubuntu_font = Font.new('rbxasset://fonts/families/Ubuntu.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
local udim2_fs = UDim2.fromScale
local uis = game:GetService('UserInputService')
local upper = string.upper
local vec2_new = Vector2.new
local vec3_new = Vector3.new
local zero = Vector3.zero

local highlight_prefab = inst_new('BoxHandleAdornment')
highlight_prefab.AdornCullingMode = Enum.AdornCullingMode.Automatic
highlight_prefab.AlwaysOnTop = true
highlight_prefab.Color3 = _4
highlight_prefab.Name = 'Highlight'
highlight_prefab.Transparency = highlight_transparency
highlight_prefab.ZIndex = 4

local name_tag = inst_new('BillboardGui')
name_tag.Active = false
name_tag.AlwaysOnTop = true
name_tag.AutoLocalize = false
name_tag.ClipsDescendants = false
name_tag.Enabled = false
name_tag.ExtentsOffsetWorldSpace = vec3_new(0, 1, 0)
name_tag.LightInfluence = 0
name_tag.MaxDistance = 740
name_tag.Name = 'NameTag'
name_tag.ResetOnSpawn = false
name_tag.Size = udim2_fs(6, 1.44)
name_tag.StudsOffsetWorldSpace = vec3_new(0, name_tag_height_offset, 0)

local name_tag_lbl = inst_new('TextLabel')
name_tag_lbl.Active = false
name_tag_lbl.BackgroundColor3 = colors_white
name_tag_lbl.BackgroundTransparency = 1
name_tag_lbl.BorderColor3 = colors_black
name_tag_lbl.BorderSizePixel = 4
name_tag_lbl.FontFace = ubuntu_font
name_tag_lbl.Interactable = false
name_tag_lbl.MaxVisibleGraphemes = 24
name_tag_lbl.Name = 'Label'
name_tag_lbl.Size = udim2_fs(1, 1)
name_tag_lbl.Text = ''
name_tag_lbl.TextColor3 = colors_white
name_tag_lbl.TextScaled = true
name_tag_lbl.TextStrokeColor3 = colors_black
name_tag_lbl.TextStrokeTransparency = 0
name_tag_lbl.ZIndex = 40000
name_tag_lbl.Parent = name_tag

local stroke = inst_new('UIStroke')
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.Color = colors_black
stroke.Enabled = true
stroke.LineJoinMode = Enum.LineJoinMode.Round
stroke.Name = 'Stroke'
stroke.Thickness = 4
stroke.Parent = name_tag_lbl

local ui = inst_new('ScreenGui')
ui.AutoLocalize = false
ui.ClipToDeviceSafeArea = false
ui.DisplayOrder = 40000
ui.Name = '4Gui'
ui.ResetOnSpawn = false
ui.ScreenInsets = Enum.ScreenInsets.None

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
ui_btn.Position = udim2_fs(0.714, 0.744)
ui_btn.Size = udim2_fs(0.194, 0.194)
ui_btn.SizeConstraint = Enum.SizeConstraint.RelativeYY
ui_btn.Text = '4'
ui_btn.TextColor3 = colors_white
ui_btn.TextScaled = true
ui_btn.TextStrokeColor3 = colors_black
ui_btn.TextStrokeTransparency = 0
ui_btn.ZIndex = 40000
stroke:Clone().Parent = ui_btn
ui.Parent = pcall(tostring, core_gui) and core_gui or you:WaitForChild('PlayerGui')

---4

local auto_snap_enabled = false
local apos = ui.AbsolutePosition
local cx, cy = -apos.X, -apos.Y
local func_hooks_enabled = true
local old_fs, old_i, old_is, old_nc
local rcp_exclude = rcp_new() do rcp_exclude.FilterType, rcp_exclude.IgnoreWater, rcp_exclude.RespectCanCollide = enum_rfi.Exclude, true, false end
local rcp_include = rcp_new() do rcp_include.FilterType, rcp_include.IgnoreWater, rcp_include.RespectCanCollide = enum_rfi.Include, true, false end
local ss_offset = vec3_new(0, -0.04, 0)
local set = function(a, b, c) a[b] = c end

local function adjust_line(highlight, p0, p1)
	highlight.CFrame, highlight.Size = cf_new((p0 + p1) / 2, p0), vec3_new(line_thickness, line_thickness, (p0 - p1).Magnitude)
end

local special_func_checks = {
	function(e)
		if not e.Parent or e.Name ~= 'GunDrop' then return end
		return colors_sheriff, ih_transparency
	end,
	function(e)
		local parent = e.Parent
		if not parent or parent.Name ~= 'ThrowingKnife' then return end
		local line = highlight_prefab:Clone()
		local p0 = parent:WaitForChild('BladePosition').Position
		local unit = long_range_dist * parent:WaitForChild('Vector3Value').Value
		local connection
		connection = ps:Connect(function()
			if not connection.Connected then return end
			if not line or not line.Parent then return connection:Disconnect() end
			local list = {parent}
			rcp_exclude.FilterDescendantsInstances = list
			local result = workspace:Raycast(p0, unit, rcp_exclude)
			clear(list)
			adjust_line(line, p0, if result then result.Position else p0 + unit)
		end)
		line.Adornee, line.Color3, line.Parent = terrain, colors_murderer, parent
		debris:AddItem(parent, 10)
		return colors_murderer, ih_transparency
	end,
	function(e)
		local parent = e.Parent
		if not parent or parent.Name ~= 'Trap' or not parent:FindFirstChild('Trigger') then return end
		return colors_murderer, ih_transparency
	end,
	function(e)
		local parent = e.Parent
		if not parent or parent.Name == 'Handle' then return end
		local effect = parent:FindFirstChildOfClass('ParticleEmitter')
		if not effect or effect.Texture ~= 'rbxassetid://16885815956' then return end
		return _4, ih_transparency
	end
}

local function check_special(e)
	for i = 1, #special_func_checks do
		local color, transparency = special_func_checks[i](e)
		if color then return color, transparency end
	end
end

local function child_added_lighting(e)
	if not e:IsA('PostEffect') then return end
	e.Enabled = false
end

local function descendant_added_w(e)
	local name = e.Name
	if name == 'GunDisplay' or name == 'KnifeDisplay' then defer(e.Destroy, e) return end
	if e:IsA('Attachment') or e:IsA('Constraint') or e:IsA('Explosion') or e:IsA('FloorWire') or e:IsA('ForceField') then
		e.Visible = false
	elseif e:IsA('BasePart') then
		e.BackSurface, e.BottomSurface, e.FrontSurface, e.LeftSurface, e.RightSurface, e.TopSurface = smooth, smooth, smooth, smooth, smooth, smooth
		e.CastShadow, e.Material, e.Reflectance = false, smooth_plastic, 0
		local highlight = highlights[e]
		if highlight then return end
		local color, transparency = check_special(e)
		if not color then return end
		local new_highlight = highlight_prefab:Clone()
		new_highlight.Color3, new_highlight.Name, new_highlight.Transparency = color, 'SpecialHighlight', transparency
		highlights[e] = new_highlight
		new_highlight.Parent = ui
	elseif e:IsA('Beam') then
		e.Enabled = false
		local a0, a1 = e.Attachment0, e.Attachment1
		if not a0 or not a1 then return end
		local line = highlight_prefab:Clone()
		adjust_line(line, a0.WorldPosition, a1.WorldPosition)
		line.Adornee, line.Color3, line.Parent = terrain, colors_sheriff, ui
		debris:AddItem(line, gun_line_lifetime)
	elseif e:IsA('Decal') then
		e.Transparency = 1
	elseif e:IsA('Fire') or e:IsA('Highlight') or e:IsA('Light') or e:IsA('ParticleEmitter') or
		e:IsA('PostEffect') or e:IsA('Smoke') or e:IsA('Sparkles') or e:IsA('Trail') then
		e.Enabled = false
	elseif e:IsA('Humanoid') then
		local char = e.Parent
		local plr = plrs:GetPlayerFromCharacter(char)
		if not plr or plr == you then return end
		local function child_added(child)
			if highlights[child] then return end
			local new_highlight = highlight_prefab:Clone()
			highlights[child] = new_highlight
			new_highlight.Parent = ui
		end

		char.ChildAdded:Connect(child_added)
		local children = char:GetChildren()
		for i = 1, #children do child_added(children[i]) end
		clear(children)
	end
end

local function plr_added(plr)
	if plr == you then return end
	local plr_tag = name_tags[plr]
	if plr_tag then return end
	plr_tag = name_tag:Clone()
	local lbl = plr_tag.Label
	local stroke = lbl.Stroke
	lbl.Text = plr.Name
	lbl.Changed:Connect(function(prop) if prop == 'AbsoluteSize' then stroke.Thickness = min(name_tag_thickness, lbl.AbsoluteSize.Y * 0.1) end end)
	name_tags[plr] = plr_tag
	plr_tag.Parent = ui
end

lighting.ChildAdded:Connect(child_added_lighting)
local list = lighting:GetChildren()
for i = 1, #list do child_added_lighting(list[i]) end
clear(list)
workspace.DescendantAdded:Connect(descendant_added_w)
workspace.DescendantRemoving:Connect(function(e)
	local highlight = highlights[e]
	if not highlight then return end
	highlights[e] = nil
	highlight:Destroy()
end)

local list = workspace:GetDescendants()
for i = 1, #list do coroutine_resume(coroutine_create(descendant_added_w), list[i]) end
clear(list)
plrs.PlayerAdded:Connect(plr_added)
plrs.PlayerRemoving:Connect(function(plr)
	if plr == you then return end
	local plr_tag = name_tags[plr]
	if not plr_tag then return end
	name_tags[plr] = nil
	plr_tag:Destroy()
end)

local list = plrs:GetPlayers()
for i = 1, #list do plr_added(list[i]) end
clear(list)
local did_exist, rendering_stuff = pcall(settings)
local lowest_quality = Enum.QualityLevel.Level01
lighting.FogColor, lighting.FogEnd, lighting.FogStart, lighting.GlobalShadows = colors_black, 10000000, 10000000, false
terrain.WaterReflectance, terrain.WaterTransparency, terrain.WaterWaveSize, terrain.WaterWaveSpeed = 0, 0, 0, 0
if did_exist then
	local rendering = rendering_stuff.Rendering
	pcall(set, rendering, 'EagerBulkExecution', false)
	pcall(set, rendering, 'EditQualityLevel', lowest_quality)
	pcall(set, rendering, 'EnableFRM', false)
	pcall(set, rendering, 'FrameRateManager', Enum.FramerateManagerMode.Off)
	pcall(set, rendering, 'QualityLevel', lowest_quality)
end

local function closest_reachable_spot(char, origin)
	local center, children, len, points = char.Humanoid.RootPart.Position + ss_offset, char:GetChildren(), 0, {}
	for i = 1, #children do
		local child = children[i]
		if not child:IsA('BasePart') then continue end
		local rr = workspace:Raycast(origin, (child.Position - origin).Unit * (long_range_dist + 4), rcp_include)
		if not rr or not char:IsAncestorOf(rr.Instance) then continue end
		len += 1
		points[len] = rr.Position
	end

	clear(children)
	if len > 0 then
		sort(points, function(a, b) return (a - center).Magnitude < (b - center).Magnitude end)
		return points[1]
	end
end

local function is_alive(plr)
	if not plr or not plr:FindFirstChild('Backpack') then return false end
	local char = plr.Character
	if not char then return false end
	local h = char:FindFirstChild('Humanoid')
	if not h or h.Health <= 0 or h:GetState() == dead or not h.RootPart then return false end
	return true
end

local function get_alive_plrs()
	local list = plrs:GetPlayers()
	for i = #list, 1, -1 do local plr = list[i] if plr == you or not is_alive(plr) then remove(list, i) end end
	return list
end

local function get_path(inst)
	if not inst then return end
	local pn = get_path(inst.Parent)
	return (if pn then pn .. '.' else '') .. inst.Name
end

local function get_weapon(plr)
	if not is_alive(you) then return end
	local bp = plr.Backpack
	local tool = bp:FindFirstChild('Gun')
	if tool and tool:FindFirstChild('Handle') then return tool end
	tool = bp:FindFirstChild('Knife')
	if tool and tool:FindFirstChild('Handle') then return tool end
	local char = plr.Character
	tool = char:FindFirstChild('Gun')
	if tool and tool:FindFirstChild('Handle') then return tool end
	tool = char:FindFirstChild('Knife')
	if tool and tool:FindFirstChild('Handle') then return tool end
end

local function nearest_threat(origin, dist, has, reachable)
	local list, result, result_pos = get_alive_plrs(), nil, nil
	local c_list, c_len, len = {workspace.Normal}, 1, #list
	for i = 1, len do
		c_len += 1
		c_list[c_len] = list[i].Character
	end
	rcp_include.FilterDescendantsInstances = c_list
	for i = 1, len do
		local element = list[i]
		local char = element.Character
		if has and not (element.Backpack:FindFirstChild(has) or char:FindFirstChild(has)) then continue end
		local pos = if reachable then closest_reachable_spot(char, origin) else char.Humanoid.RootPart.Position
		if not pos then continue end
		local new_dist = (origin - pos).Magnitude
		if new_dist > dist then continue end
		dist, result, result_pos = new_dist, char, pos
	end
	clear(c_list)
	clear(list)
	return result_pos, result
end

local function get_threat_pos(weapon)
	if not weapon then return end
	local name, origin, pos = weapon.Name, weapon.Handle.Position, nil
	if name == 'Gun' then
		return nearest_threat(origin, long_range_dist, 'Knife', true)
	elseif name == 'Knife' then
		return nearest_threat(origin, long_range_dist, 'Gun', true) or nearest_threat(origin, long_range_dist, nil, true)
	end
end

local function scripted_shoot()
	auto_snap_enabled = not auto_snap_enabled
	ui_btn.TextStrokeColor3 = auto_snap_enabled and _4 or colors_black
end

old_i = hmm(game, '__index', ncc(function(self, key)
	if not auto_snap_enabled or self ~= mouse or (key ~= 'X' and key ~= 'Y') then return old_i(self, key) end
	local pos = get_threat_pos(get_weapon(you))
	if not pos then return old_i(self, key) end
	local screen_point = cam:WorldToScreenPoint(pos)
	if key == 'X' then
		return screen_point.X + cx
	elseif key == 'Y' then
		return screen_point.Y + cy
	end
	return old_i(self, key)
end))

local function func_management(self, ncm, func, ...)
	if not func_hooks_enabled then return func(self, ...) end
	func_hooks_enabled = false
	local class = self.ClassName
	if class == 'RemoteFunction' and ncm == 'InvokeServer' then
		local path = get_path(self)
		if auto_snap_enabled and find(path, 'Gun.KnifeLocal.CreateBeam.RemoteFunction', 1, true) then
			local args = {...}
			local arg_2 = args[2]
			if args[1] == 1 and typeof(arg_2) == 'Vector3' and args[3] == 'AH2' then
				args[2] = get_threat_pos(get_weapon(you)) or arg_2
				local results = {pcall(self[ncm], self, unpack(args))}
				if results[1] then remove(results, 1) return unpack(results) end
			end
		end
	end
	func_hooks_enabled = true
	return func(self, ...)
end

old_fs = hf(inst_new('RemoteEvent').FireServer, ncc(function(self, ...) return func_management(self, 'FireServer', old_fs, ...) end))
old_is = hf(inst_new('RemoteFunction').InvokeServer, ncc(function(self, ...) return func_management(self, 'InvokeServer', old_is, ...) end))
old_nc = hmm(game, '__namecall', ncc(function(self, ...) return func_management(self, gncm(), old_nc, ...) end))
ui_btn.Activated:Connect(scripted_shoot)
uis.InputBegan:Connect(function(input, gpe)
	if gpe or gs.MenuIsOpen or input.UserInputType ~= keyboard or uis:GetFocusedTextBox() then return end
	local key = input.KeyCode
	if key ~= enum_kc.Four and key ~= enum_kc.Y then return end
	scripted_shoot()
end)

local sg = game:GetService('StarterGui')
local sg_sc = sg.SetCore
local sg_scp = {Button1 = 'OK', Duration = 4, Icon = 'rbxassetid://7440784829', Text = 'Script activated', Title = 'MM24'}
while true do if pcall(sg_sc, sg, 'SendNotification', sg_scp) then break else sleep(0.04) end end
clear(sg_scp)
coroutine_resume(coroutine_create(function()
	while true do
		data = get_plr_data:InvokeServer() or data
		sleep(name_tag_refresh_rate)
		local char = you.Character
		if not char then continue end
		local h = char:FindFirstChild('Humanoid')
		if not h or h.Health <= 0 or h:GetState() == dead then continue end
		if h.WalkSpeed ~= 0 then h.WalkSpeed = max(h.WalkSpeed, starter_player.CharacterWalkSpeed * speed_boost) end
		if h.UseJumpPower then
			if h.JumpPower == 0 then continue end
			h.JumpPower = max(h.JumpPower, starter_player.CharacterJumpPower * jump_boost)
		else
			if h.JumpHeight == 0 then continue end
			h.JumpHeight = max(h.JumpHeight, starter_player.CharacterJumpHeight * jump_boost)
		end
	end
end))

coroutine_resume(coroutine_create(function()
	while true do
		sleep(highlight_refresh_rate)
		for adornee, highlight in next, highlights do
			if typeof(adornee) ~= 'Instance' or not adornee:IsA('BasePart') then continue end
			local parent = adornee.Parent
			if not parent or not highlight.Parent then continue end
			highlight.Adornee = adornee
			highlight.Size = adornee.Size * if highlight.Name == 'SpecialHighlight' then ih_size_increase else 1
			local plr = plrs:GetPlayerFromCharacter(parent)
			if not plr then continue end
			local plr_tag = name_tags[plr]
			if not plr_tag then continue end
			highlight.Color3 = plr_tag.Label.TextColor3
		end
	end
end))

while true do
	sleep()
	for plr, plr_tag in next, name_tags do
		if not is_alive(plr) then plr_tag.Adornee, plr_tag.Enabled = nil, false continue end
		local color, lbl, role = colors_innocent, plr_tag.Label, upper((data[plr.Name] or data).Role or '')
		plr_tag.Adornee = plr.Character.Humanoid.RootPart
		plr_tag.Enabled = true
		if role == 'FREEZER' or role == 'INFECTED' or role == 'MURDERER' or role == 'ZOMBIE' then
			color = colors_murderer
		elseif role == 'HERO' or role == 'RUNNER' or role == 'SHERIFF' or role == 'SURVIVOR' then
			color = colors_sheriff
		end
		lbl.TextColor3 = color
		lbl.Stroke.Color = color
	end

	if not is_alive(you) then ui_btn.Parent = nil continue end
	local bp = you.Backpack
	local char = you.Character
	local hrp = char.Humanoid.RootPart
	local pos = hrp.Position
	if hrp and (hrp.AssemblyAngularVelocity.Magnitude > danger_speed or
		hrp.AssemblyLinearVelocity.Magnitude > danger_speed or pos.Y < danger_y_zone) then
		hrp.AssemblyAngularVelocity, hrp.AssemblyLinearVelocity, hrp.RotVelocity, hrp.Velocity = zero, zero, zero, zero
		local map = workspace:FindFirstChild('Normal')
		if map then
			local gun = bp:FindFirstChild('Gun') or char:FindFirstChild('Gun')
			local knife = bp:FindFirstChild('Knife') or char:FindFirstChild('Knife')
			local spawns = map:FindFirstChild('Spawns')
			local _, other_char = nearest_threat(pos, long_range_dist, if gun then 'Knife' elseif knife then 'Gun' else nil, false)
			if spawns then
				local list = spawns:GetChildren()
				local len = #list
				if len > 0 then
					if other_char then
						local pos = other_char.Humanoid.RootPart.Position
						sort(list, function(a, b) return (a.Position - pos).Magnitude > (b.Position - pos).Magnitude end)
						hrp.CFrame = list[1].CFrame
						clear(list)
					else
						hrp.CFrame = list[rng:NextInteger(1, len)].CFrame
					end
				else
					hrp.Anchored = true
				end
			end
		end
	end

	local equipped_knife = char:FindFirstChild('Knife')
	ui_btn.Parent = (char:FindFirstChild('Gun') or equipped_knife) and ui or nil
	if not equipped_knife then continue end
	local handle = equipped_knife:FindFirstChild('Handle')
	if not handle then continue end
	local _, other_char = nearest_threat(handle.Position, melee_hitbox_extender, nil, false)
	if not other_char then continue end
	local other_hrp = other_char.Humanoid.RootPart
	fti(handle, other_hrp, 1)
	fti(handle, other_hrp, 0)
end
