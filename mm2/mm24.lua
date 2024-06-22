--!nolint
--!nonstrict

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
name_tag_lbl.BorderColor3 = _4
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
ui_btn.Position = udim2_fs(0.75, 0.725)
ui_btn.Size = udim2_fs(0.144, 0.144)
ui_btn.SizeConstraint = Enum.SizeConstraint.RelativeYY
ui_btn.Text = '4'
ui_btn.TextColor3 = colors_white
ui_btn.TextScaled = true
ui_btn.TextStrokeColor3 = _4
ui_btn.TextStrokeTransparency = 0
ui_btn.ZIndex = 4000
stroke:Clone().Parent = ui_btn
ui.Parent = pcall(tostring, core_gui) and core_gui or you:WaitForChild('PlayerGui')

---4;  vov4/💚

local function create_beam(p0, p1): any
	local new_highlight = highlight_prefab:Clone()
	new_highlight.Adornee = terrain
	new_highlight.CFrame = cf_new((p0 + p1) / 2, p0)
	new_highlight.Size = vec3_new(0.244, 0.244, (p1 - p0).Magnitude)
	return new_highlight
end

local function child_added_lighting(e) if e:IsA('PostEffect') then e.Enabled = false end end
local function set(a: any, b: any, c: any) a[b] = c end
local special_func_checks: {any} = {
	function(e) return e.Parent and e.Name == 'GunDrop' end,
	function(e)
		local parent = e.Parent
		if parent and parent.Name == 'ThrowingKnife' then
			local blade_pos = parent:WaitForChild('BladePosition')
			local unit: any = 40 * blade_pos:WaitForChild('Vector3Value').Value
			blade_pos = blade_pos.Position
			local beam = create_beam(blade_pos - unit, blade_pos + unit)
			beam.Color3 = murderer_color
			beam.Parent = parent
			debris:AddItem(parent, 10)
			return true
		end
		return false
	end,
	function(e)
		local parent = e.Parent
		return parent and parent.Name == 'Trap' or false
	end,
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
	for i = 1, #args, 2 do other_mouse[args[i]] = args[i + 1] end
	clear(args)
end

local function check_special(e)
	for i = 1, #special_func_checks do if special_func_checks[i](e) then return true end end
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
			if not char then return end
			local plr = plrs:FindFirstChild(char.Name)
			if not plr or plr == you then return end
			local h = char:WaitForChild('Humanoid', 0.4)
			if not h or h.Health <= 0 or h:GetState() == dead then return end
		end
		local highlight = highlights[e]
		if highlight then return end
		local new_highlight = highlight_prefab:Clone()
		if special then new_highlight.Name, new_highlight.Transparency = 'SpecialHighlight', 0.24 end
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

local function get_plr(origin, dist, mode)
	local list = plrs:GetPlayers()
	local name = (mode == 'Murderer' and 'Knife') or (mode == 'Sheriff' and 'Gun') or nil
	local result
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
		if name and not bp:FindFirstChild(name) and not char:FindFirstChild(name) then continue end
		local new_dist = (hrp.Position - origin).Magnitude
		if new_dist >= dist then continue end
		dist, result = new_dist, element
	end
	clear(list)
	return result
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

local function target(hrp)
	local cam_pos = cam.CFrame.Position
	local hrp_pos = hrp.Position
	local pos = hrp_pos
	local screen_point = cam:WorldToScreenPoint(pos)
	local x, y = screen_point.X, screen_point.Y
	ui_btn.Interactable = true
	change_mouse_properties(
		'Hit', cf_new(pos), 'Origin', cf_new(cam_pos, pos), 'Target', hrp,
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
	local other_plr = get_plr(your_hrp.Position, 740, (is_gun and 'Murderer') or (is_knife and 'Sheriff') or nil)
	if not other_plr then return end
	local other_hrp = other_plr.Character:FindFirstChildOfClass('Humanoid').RootPart
	local apos = ui.AbsolutePosition
	local cx, cy = -apos.X, -apos.Y
	local mb = (is_gun and 0) or (is_knife and 1) or 0
	ui_btn.Interactable = false
	if uis:GetLastInputType() == touch then
		local x, y = target(other_hrp)
		vim:SendTouchEvent(14, 0, x + cx, y + cy)
		sleep(0.0204)
		local x, y = target(other_hrp)
		vim:SendTouchEvent(14, 2, x + cx, y + cy)
	else
		local x, y = target(other_hrp)
		x += cx
		y += cy
		vim:SendMouseButtonEvent(x, y, mb, true, nil, 0)
		sleep(0.0204)
		local x, y = target(other_hrp)
		x += cx
		y += cy
		vim:SendMouseButtonEvent(x, y, mb, false, nil, 0)
	end
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
local new_jh = starter_player.CharacterJumpHeight * 1.14
local new_jp = starter_player.CharacterJumpPower * 1.14
local new_ws = starter_player.CharacterWalkSpeed * 1.14
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

	local char = you.Character
	if not char then ui_btn.Parent = nil continue end
	local h = char:FindFirstChildOfClass('Humanoid')
	if not h or h.Health <= 0 or h:GetState() == dead then ui_btn.Parent = nil continue end
	local hrp = h.RootPart
	if not hrp then ui_btn.Parent = nil continue end
	local knife = char:FindFirstChild('Knife')
	ui_btn.Parent = (char:FindFirstChild('Gun') or knife) and ui or nil
	if knife then
		local handle = knife:FindFirstChild('Handle')
		if handle then
			local other_plr = get_plr(hrp.Position, 4.444, nil)
			if other_plr then
				local other_hrp = other_plr.Character:FindFirstChildOfClass('Humanoid').RootPart
				fti(handle, other_hrp, 1)
				fti(handle, other_hrp, 0)
			end
		end
	end
end
