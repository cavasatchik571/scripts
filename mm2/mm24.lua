--!strict

local _4 = Color3.new(0, .4984, 0)

-- by @Vov4ik4124

if game.PlaceId ~= 142823291 then return end
local fti = firetouchinterest or fire_touch_interest
local gncm = getnamecallmethod or get_namecall_method
local hmm = hookmetamethod or hook_meta_method
local nc = newcclosure
local plrs = game:GetService('Players')
local you = plrs.LocalPlayer
if not fti or not gncm or not hmm or not nc then return you:Kick('MM24 doesn\'t support your executor') end
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
local data = {}
local dead = Enum.HumanoidStateType.Dead
local debris = game:GetService('Debris')
local defer = task.defer
local destroy = game.Destroy
local enum_uit = Enum.UserInputType
local get_plr_data = game:GetService('ReplicatedStorage'):WaitForChild('Remotes'):WaitForChild('Extras'):WaitForChild('GetPlayerData')
local gs = game:GetService('GuiService')
local highlights = {}
local inst_new = Instance.new
local key_code = Enum.KeyCode.Four
local keyboard = enum_uit.Keyboard
local lighting = game:GetService('Lighting')
local min = math.min
local name_tags = {}
local other_mouse = {}
local ray_new = Ray.new
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
local vec3_zero = Vector3.zero
local vim = game:GetService('VirtualInputManager')

local innocent_color = colors_white
local murderer_color = color3_from_rgb(255, 0, 0)
local sheriff_color = color3_from_rgb(0, 0, 255)

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
name_tag.Enabled = false
name_tag.ExtentsOffsetWorldSpace = vec3_new(0, 1, 0)
name_tag.LightInfluence = 0
name_tag.MaxDistance = 740
name_tag.Name = 'NameTag'
name_tag.ResetOnSpawn = false
name_tag.Size = udim2_fs(6, 1.44)
name_tag.StudsOffsetWorldSpace = vec3_new(0, 1.94, 0)

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
name_tag_lbl.ZIndex = 4000
name_tag_lbl.Parent = name_tag

local ray_params = RaycastParams.new()
ray_params.FilterType = Enum.RaycastFilterType.Include
ray_params.IgnoreWater = true
ray_params.RespectCanCollide = true

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
ui.DisplayOrder = 4000
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
ui_btn.Position = udim2_fs(0.7, 0.734)
ui_btn.Size = udim2_fs(0.174, 0.174)
ui_btn.SizeConstraint = Enum.SizeConstraint.RelativeYY
ui_btn.Text = '4'
ui_btn.TextColor3 = colors_white
ui_btn.TextScaled = true
ui_btn.TextStrokeColor3 = _4
ui_btn.TextStrokeTransparency = 0
ui_btn.ZIndex = 4000
stroke:Clone().Parent = ui_btn
ui.Parent = pcall(tostring, core_gui) and core_gui or you:WaitForChild('PlayerGui')

---4💚

local function change_mouse_properties(...)
	clear(other_mouse)
	local args = {...}
	for i = 1, #args, 2 do other_mouse[args[i]] = args[i + 1] end
	clear(args)
end

local function child_added_lighting(e) if e:IsA('PostEffect') then e.Enabled = false end end
local function create_beam(p0, p1): any
	local new_highlight = highlight_prefab:Clone()
	new_highlight.Adornee = terrain
	new_highlight.CFrame = cf_new((p0 + p1) / 2, p0)
	new_highlight.Size = vec3_new(0.24, 0.24, (p0 - p1).Magnitude)
	return new_highlight
end

local function get_end_point(p0, p1)
	local list = {workspace:FindFirstChild('Normal')}
	ray_params.FilterDescendantsInstances = list
	local ray_result = workspace:Raycast(p0, p1 - p0, ray_params)
	clear(list)
	return ray_result and ray_result.Position or p1
end

local function get_plr(origin, dist, name)
	local list = plrs:GetPlayers()
	local dist_with_tool, dist_without = dist, dist
	local result_with_tool, result_without = nil, nil
	for i = 1, #list do
		local element = list[i]
		if not element or element == you then continue end
		local bp = element:FindFirstChildOfClass('Backpack')
		if not bp then continue end
		local char = element.Character
		if not char then continue end
		local h = char:FindFirstChildOfClass('Humanoid')
		if not h or h.Health <= 0 or h:GetState() == dead then continue end
		local hrp = h.RootPart
		if not hrp then continue end
		local new_dist = (hrp.Position - origin).Magnitude
		if name and (bp:FindFirstChild(name) or char:FindFirstChild(name)) then
			if new_dist >= dist_with_tool then continue end
			dist_with_tool, result_with_tool = new_dist, element
		else
			if new_dist >= dist_without then continue end
			dist_without, result_without = new_dist, element
		end
	end
	clear(list)
	return result_with_tool or result_without
end

local function set(a: any, b: any, c: any) a[b] = c end
local special_func_checks: {any} = {
	function(e)
		if not e.Parent or e.Name ~= 'GunDrop' then return end
		return true, sheriff_color, 0.24
	end,
	function(e)
		local parent = e.Parent
		if not parent or parent.Name ~= 'ThrowingKnife' then return end
		local blade_pos: any = parent:WaitForChild('BladePosition').Position
		local unit: any = 400 * parent:WaitForChild('Vector3Value').Value
		local beam = create_beam(blade_pos, get_end_point(blade_pos, blade_pos + unit))
		beam.Color3 = murderer_color
		beam.Parent = parent
		debris:AddItem(parent, 10)
		return true, murderer_color, 0.24
	end,
	function(e)
		local parent = e.Parent
		if not parent or parent.Name ~= 'Trap' then return end
		return true, murderer_color, 0.24
	end,
	function(e)
		local parent = e.Parent
		if not parent or parent.Name == 'Handle' then return end
		local effect = parent:FindFirstChildOfClass('ParticleEmitter')
		if not effect or effect.Texture ~= 'rbxassetid://16885815956' then return end
		return true, _4, 0.24
	end
}

local function check_special(e)
	for i = 1, #special_func_checks do
		local succ, color, transparency = special_func_checks[i](e)
		if succ then return color, transparency end
	end
	return
end

local function descendant_added_w(e)
	local name = e.Name
	if name == 'GunDisplay' or name == 'KnifeDisplay' then defer(destroy, e) return end
	if e:IsA('BasePart') then
		e.BackSurface, e.BottomSurface, e.FrontSurface, e.LeftSurface, e.RightSurface, e.TopSurface = smooth, smooth, smooth, smooth, smooth, smooth
		e.Material, e.Reflectance = smooth_plastic, 0
		local highlight = highlights[e]
		if highlight then return end
		local color, transparency = check_special(e)
		if not color then
			sleep(0.004)
			local char = e.Parent
			if not char then return end
			local plr = plrs:FindFirstChild(char.Name)
			if not plr or plr == you then return end
			local h = char:WaitForChild('Humanoid', 0.4)
			if not h or h.Health <= 0 or h:GetState() == dead then return end
		end
		local new_highlight = highlight_prefab:Clone()
		if color then new_highlight.Color3, new_highlight.Name, new_highlight.Transparency = color, 'SpecialHighlight', transparency end
		highlights[e] = new_highlight
		new_highlight.Parent = ui
	elseif e:IsA('Beam') then
		e.Enabled = false
		local a0, a1 = e.Attachment0, e.Attachment1
		if not a0 or not a1 then return end
		local beam = create_beam(a0.WorldPosition, a1.WorldPosition)
		beam.Color3 = sheriff_color
		beam.Parent = ui
		debris:AddItem(beam, 0.644)
	elseif e:IsA('Decal') then
		e.Transparency = 1
	elseif e:IsA('Fire') or e:IsA('Highlight') or e:IsA('Light') or e:IsA('ParticleEmitter') or
		e:IsA('PostEffect') or e:IsA('Smoke') or e:IsA('Sparkles') or e:IsA('Trail') then
		e.Enabled = false
	elseif e:IsA('Attachment') or e:IsA('Constraint') or e:IsA('Explosion') or e:IsA('FloorWire') or e:IsA('ForceField') then
		e.Visible = false
	end
end

local function plr_added(plr)
	if plr == you then return end
	local plr_tag = name_tags[plr]
	if plr_tag then return end
	plr_tag = name_tag:Clone()
	plr_tag.Label.Text = plr.Name
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
lighting.FogColor, lighting.FogEnd, lighting.FogStart, lighting.GlobalShadows = colors_black, 9e9, 9e9, false
terrain.WaterReflectance, terrain.WaterTransparency, terrain.WaterWaveSize, terrain.WaterWaveSpeed = 0, 0, 0, 0
if did_exist then
	local rendering = rendering_stuff.Rendering
	pcall(set, rendering, 'EagerBulkExecution', false)
	pcall(set, rendering, 'EditQualityLevel', lowest_quality)
	pcall(set, rendering, 'EnableFRM', false)
	pcall(set, rendering, 'FrameRateManager', Enum.FramerateManagerMode.Off)
	pcall(set, rendering, 'QualityLevel', lowest_quality)
end

local function get_vulnerable_spot(char)
	local cast_points, ignore_list, len, sum, children = {}, {char, you.Character}, 0, vec3_zero, char:GetChildren()
	for i = 1, #children do
		local child = children[i]
		if not child:IsA('BasePart') then continue end
		local pos = child.Position
		cast_points[1] = pos
		if #cam:GetPartsObscuringTarget(cast_points, ignore_list) > 0 then continue end
		len += 1
		sum += pos
	end
	return if len > 0 then sum / len else char:FindFirstChildOfClass('Humanoid').RootPart.Position
end

local function set_mouse_to(pos, cx, cy)
	local cam_pos = cam.CFrame.Position
	local screen_point = cam:WorldToScreenPoint(pos)
	local x, y = screen_point.X + cx, screen_point.Y + cy
	change_mouse_properties(
		'Hit', cf_new(pos), 'Origin', cf_new(cam_pos, pos),
		'UnitRay', ray_new(cam_pos, (pos - cam_pos).Unit), 'X', x, 'Y', y
	)

	return x, y
end

local function scripted_shoot()
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
	local other_plr = get_plr(your_hrp.Position, 740, (is_gun and 'Knife') or (is_knife and 'Gun') or nil)
	if not other_plr then return end
	local apos = ui.AbsolutePosition
	local char = other_plr.Character
	local cx, cy = -apos.X, -apos.Y
	local id, mb = 24, (is_gun and 0) or (is_knife and 1) or 0
	local is_touch = uis:GetLastInputType() == touch
	ui_btn.Interactable = false
	for _ = 1, 4 do 
		if is_touch then
			vim:SendTouchEvent(id, 0, set_mouse_to(get_vulnerable_spot(char), cx, cy))
			vim:SendTouchEvent(id, 2, set_mouse_to(get_vulnerable_spot(char), cx, cy))
		else
			local x, y = set_mouse_to(get_vulnerable_spot(char), cx, cy)
			vim:SendMouseButtonEvent(x, y, mb, true, nil, 0)
			local x, y = set_mouse_to(get_vulnerable_spot(char), cx, cy)
			vim:SendMouseButtonEvent(x, y, mb, false, nil, 0)
		end
	end
	if is_touch then vim:SendTouchEvent(id, 2, -1, -1) else vim:SendMouseButtonEvent(-1, -1, mb, false, nil, 0) end
	change_mouse_properties()
	ui_btn.Interactable = true
end

uis.InputBegan:Connect(function(input, gpe)
	if gpe or gs.MenuIsOpen or input.KeyCode ~= key_code or input.UserInputType ~= keyboard or uis:GetFocusedTextBox() then return end
	scripted_shoot()
end)

local old_func
old_func = hmm(game, '__index', nc(function(self, key) return self == you:GetMouse() and other_mouse[key] or old_func(self, key) end))
ui_btn.Activated:Connect(scripted_shoot)
local sg = game:GetService('StarterGui')
local sg_sc = sg.SetCore
local sg_scp = {Button1 = 'OK', Duration = 4, Icon = 'rbxassetid://7440784829', Text = 'Script activated', Title = 'MM24'}
while true do if pcall(sg_sc, sg, 'SendNotification', sg_scp) then break else sleep(0.04) end end
clear(sg_scp)
local new_jh = starter_player.CharacterJumpHeight * 1.044
local new_jp = starter_player.CharacterJumpPower * 1.044
local new_ws = starter_player.CharacterWalkSpeed * 1.144
coroutine_resume(coroutine_create(function()
	while true do
		data = get_plr_data:InvokeServer() or data
		sleep(1.44)
		local char = you.Character
		if not char then continue end
		local h = char:FindFirstChildOfClass('Humanoid')
		if not h or h.Health <= 0 or h:GetState() == dead then continue end
		if h.UseJumpPower then if h.JumpPower ~= 0 then h.JumpPower = new_jp end else if h.JumpHeight ~= 0 then h.JumpHeight = new_jh end end
		if h.WalkSpeed ~= 0 then h.WalkSpeed = new_ws end
	end
end))

coroutine_resume(coroutine_create(function()
	while true do
		sleep(0.144)
		for adornee, highlight in next, highlights do
			if typeof(adornee) ~= 'Instance' or not adornee:IsA('BasePart') then continue end
			local parent = adornee.Parent
			if not parent or not highlight.Parent then continue end
			highlight.Adornee = adornee
			highlight.Size = adornee.Size * (highlight.Name == 'SpecialHighlight' and 2 or 1)
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
	local pos = workspace.CurrentCamera.CFrame.Position
	for plr, plr_tag in next, name_tags do
		if not plr_tag or not plr then continue end
		local bp = plr:FindFirstChildOfClass('Backpack')
		if not bp then plr_tag.Adornee, plr_tag.Enabled = nil, false continue end
		local char = plr.Character
		if not char then plr_tag.Adornee, plr_tag.Enabled = nil, false continue end
		local h = char:FindFirstChildOfClass('Humanoid')
		if not h or h.Health <= 0 or h:GetState() == dead then plr_tag.Adornee, plr_tag.Enabled = nil, false continue end
		local hrp = h.RootPart
		if not hrp then plr_tag.Adornee, plr_tag.Enabled = nil, false continue end
		local color = innocent_color
		local lbl = plr_tag.Label
		local role = upper((data[plr.Name] or data).Role or '')
		plr_tag.Adornee, plr_tag.Enabled = hrp, true
		if bp:FindFirstChild('Knife') or char:FindFirstChild('Knife') or
			role == 'FREEZER' or role == 'INFECTED' or role == 'MURDERER' or role == 'ZOMBIE' then
			color = murderer_color
		elseif bp:FindFirstChild('Gun') or char:FindFirstChild('Gun') or
			role == 'HERO' or role == 'RUNNER' or role == 'SHERIFF' or role == 'SURVIVOR' then
			color = sheriff_color
		end
		local stroke = lbl.Stroke
		lbl.TextColor3, stroke.Color, stroke.Thickness = color, color, min(4, 100 / (hrp.Position - pos).Magnitude)
	end
	local bp = you:FindFirstChildOfClass('Backpack')
	if not bp then ui_btn.Parent = nil continue end
	local char = you.Character
	if not char then ui_btn.Parent = nil continue end
	local h = char:FindFirstChildOfClass('Humanoid')
	if not h or h.Health <= 0 or h:GetState() == dead then ui_btn.Parent = nil continue end
	local hrp = h.RootPart
	if not hrp then ui_btn.Parent = nil continue end
	if hrp and (hrp.AssemblyAngularVelocity.Magnitude >= 240 or hrp.AssemblyLinearVelocity.Magnitude >= 240 or hrp.Position.Y <= -400) then
		hrp.AssemblyAngularVelocity, hrp.AssemblyLinearVelocity, hrp.RotVelocity, hrp.Velocity = vec3_zero, vec3_zero, vec3_zero, vec3_zero
		local map = workspace:FindFirstChild('Normal')
		if map then
			local is_gun = bp:FindFirstChild('Gun') or char:FindFirstChild('Gun')
			local is_knife = bp:FindFirstChild('Knife') or char:FindFirstChild('Knife')
			local other_plr = get_plr(hrp.Position, 740, (is_gun and 'Knife') or (is_knife and 'Gun') or nil)
			local spawns = map:FindFirstChild('Spawns')
			if other_plr and spawns then
				local list = spawns:GetChildren()
				local pos = other_plr.Character:FindFirstChildOfClass('Humanoid').RootPart.Position
				sort(list, function(a, b) return (a.Position - pos).Magnitude > (b.Position - pos).Magnitude end)
				local best_spawn = list[1]
				if best_spawn then
					hrp.CFrame = best_spawn.CFrame
					clear(list)
				end
			end
		end
	end
	local knife = char:FindFirstChild('Knife')
	ui_btn.Parent = (char:FindFirstChild('Gun') or knife) and ui or nil
	if knife then
		local handle = knife:FindFirstChild('Handle')
		if handle then
			local other_plr = get_plr(hrp.Position, 4.44, nil)
			if other_plr then
				local other_hrp = other_plr.Character:FindFirstChildOfClass('Humanoid').RootPart
				fti(handle, other_hrp, 1)
				fti(handle, other_hrp, 0)
			end
		end
	end
end
