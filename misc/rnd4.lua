--!nolint
--!nonstrict

local _4 = Color3.new(0, .4984, 0)

-- by Vov4ik

if game.PlaceId ~= 12208518151 then return end
local cc = checkcaller
local gncm = getnamecallmethod
local hf = hookfunction
local hmm = hookmetamethod
local ncc = newcclosure
local you = game:GetService('Players').LocalPlayer
if not cc or not gncm or not hf or not hmm or not ncc then return you:Kick('Your executor doesn\'t support RND4') end
local env = (gengenv or function() end)() or _ENV or shared or _G
if env.rnd4 then return end
env.rnd4 = true
local clear = table.clear
local color3_from_rgb = Color3.fromRGB
local colors_black = color3_from_rgb(0, 0, 0)
local colors_white = color3_from_rgb(255, 255, 255)
local core_gui = game:GetService('CoreGui')
local coroutine_create = coroutine.create
local coroutine_resume = coroutine.resume
local debris = game:GetService('Debris')
local find = string.find
local font = Font.new('rbxasset://fonts/families/Ubuntu.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
local format = string.format
local hb = game:GetService('RunService').Heartbeat
local ed = Enum.EasingDirection
local es = Enum.EasingStyle
local highlights = {}
local inst_new = Instance.new
local lighting = game:GetService('Lighting')
local remove = table.remove
local s1 = Enum.CameraType.Scriptable
local s2 = Enum.DevComputerMovementMode.Scriptable
local s3 = Enum.DevTouchMovementMode.Scriptable
local sleep = task.wait
local smooth = Enum.SurfaceType.Smooth
local starter_gui = game:GetService('StarterGui')
local udim2_fs = UDim2.fromScale
local udim2_new = UDim2.new
local udim_new = UDim.new
local uis = game:GetService('UserInputService')
local upper = string.upper
local vec2_new = Vector2.new
local vec3_new = Vector3.new
local your_gui = you:WaitForChild('PlayerGui')
local zero = Vector3.zero
local og_fs, og_gftb, og_hmm, og_sc
local highlight_size = vec3_new(0.244, 0.244, 0.244)
local paths = {
	'^Workspace%.godhand$',
	'^Workspace%.monster$',
	'^Workspace%.monster2$',
	'^Workspace%.next%.room%.battery$',
	'^Workspace%.next%.room%.door$',
	'^Workspace%.next%.room%.lever$',
	'^Workspace%.rooms%.%d+%.battery$',
	'^Workspace%.rooms%.%d+%.door$',
	'^Workspace%.rooms%.%d+%.lever$',
	'^Workspace%.spawn%.door$',
	'^Workspace%.Spirit$'
}

local highlight = inst_new('BoxHandleAdornment')
highlight.AlwaysOnTop = true
highlight.Color3 = _4
highlight.Name = 'Highlight'
highlight.Size = highlight_size
highlight.Transparency = 0.64
highlight.ZIndex = 4

local ui = inst_new('ScreenGui')
ui.ClipToDeviceSafeArea = false
ui.DisplayOrder = -400
ui.Name = '4Gui'
ui.ResetOnSpawn = false

local lbl_frame = inst_new('Frame')
lbl_frame.AnchorPoint = vec2_new(0.5, 0)
lbl_frame.BackgroundColor3 = colors_black
lbl_frame.BackgroundTransparency = 1
lbl_frame.BorderColor3 = colors_white
lbl_frame.BorderSizePixel = 0
lbl_frame.Name = 'NotificationCollection'
lbl_frame.Position = udim2_fs(0.5, 0.014)
lbl_frame.Size = udim2_fs(0.4, 0.144)
lbl_frame.Parent = ui

local light_inst = inst_new('PointLight')
light_inst.Brightness = 0.94
light_inst.Color = color3_from_rgb(164, 255, 164)
light_inst.Enabled = true
light_inst.Name = 'Light'
light_inst.Range = 60
light_inst.Shadows = false

local light_part = inst_new('Part')
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
light_part.Material = Enum.Material.SmoothPlastic
light_part.RightSurface = smooth
light_part.Size = zero
light_part.TopSurface = smooth
light_part.Transparency	= 1

local notification = inst_new('TextLabel')
notification.BackgroundColor3 = colors_black
notification.BackgroundTransparency = 0.5
notification.BorderColor3 = _4
notification.BorderSizePixel = 0
notification.FontFace = font
notification.Name = 'Notification'
notification.Size = udim2_fs(1, 1)
notification.Text = ''
notification.TextColor3 = _4
notification.TextScaled = true
notification.TextStrokeColor3 = colors_black
notification.TextStrokeTransparency = 1
notification.Visible = false

local notification_timer = inst_new('TextLabel')
notification_timer.AnchorPoint = vec2_new(1, 0)
notification_timer.AutomaticSize = Enum.AutomaticSize.X
notification_timer.BackgroundColor3 = colors_black
notification_timer.BackgroundTransparency = 1
notification_timer.BorderColor3 = _4
notification_timer.BorderSizePixel = 0
notification_timer.FontFace = font
notification_timer.Name = 'Timer'
notification_timer.Position = udim2_new(1, -4, 0, 4)
notification_timer.Size = udim2_fs(0, 0.194)
notification_timer.Text = '0.0s'
notification_timer.TextColor3 = colors_white
notification_timer.TextScaled = true
notification_timer.TextStrokeColor3 = _4
notification_timer.TextStrokeTransparency = 0
notification_timer.TextXAlignment = Enum.TextXAlignment.Right
notification_timer.TextYAlignment = Enum.TextYAlignment.Top
notification_timer.Parent = notification

local corner = inst_new('UICorner')
corner.CornerRadius = udim_new(0.144, 0)
corner.Name = 'Corner'
corner.Parent = notification

local ui_list_layout = inst_new('UIListLayout')
ui_list_layout.FillDirection = Enum.FillDirection.Vertical
ui_list_layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ui_list_layout.Padding = udim_new(0.1, 0)
ui_list_layout.SortOrder = Enum.SortOrder.LayoutOrder
ui_list_layout.VerticalAlignment = Enum.VerticalAlignment.Top
ui_list_layout.Parent = lbl_frame

light_inst.Parent = light_part
light_part.Parent = workspace
ui.Parent = if pcall(tostring, core_gui) then core_gui else your_gui

local function is_special(e)
	local name = e:GetFullName()
	for i = 1, #paths do local path = paths[i] if find(name, path, 1, false) == 1 then return true end end
	return false
end

local function monster_name_decipher(e, spawned)
	local name = e.Name
	if name == 'a90' then
		local children, count = workspace:GetChildren(), 0
		for i = 1, #children do
			local child = children[i]
			if child.Name ~= 'a90' then continue end
			count += 1
		end
		clear(children)
		return if count > 1 then 'Paralysis Prime will spawn!' else 'Paralysis will spawn!'
	elseif name == 'handdebris' then
		return if spawned then 'Kalypto might spawn!' else 'Kalypto may not spawn or has disappeared'
	elseif name == 'monster' then
		if e:WaitForChild('light').Color:ToHex() == 'ff0000' then
			return 'Multi Monster ' .. if spawned then 'spawned!' else 'disappeared!'
		else
			return 'Multi Monster Prime ' .. if spawned then 'spawned!' else 'disappeared!'
		end
	elseif name == 'monster2' then
		local children, count = workspace:GetChildren(), 0
		for i = 1, #children do
			local child = children[i]
			if child.Name ~= 'monster2' or child:WaitForChild('Thud').IsPlaying then continue end
			count += 1
		end
		clear(children)
		return (if e:WaitForChild('Thud').IsPlaying then 'Happy Scribble ' elseif count > 1 then 'Insidae Prime '
			else 'Insidae ') .. if spawned then 'spawned!' else 'disappeared!'
	end
	return name
end

local function show_notification(text, include_time)
	local new_notification = notification:Clone()
	local nt = new_notification.Timer
	if include_time then
		local connection, timer = nil, 0
		connection = hb:Connect(function(dt)
			if not new_notification then return connection:Disconnect() end
			timer += dt
			nt.Text = format('%.1fs', timer)
		end)
	else
		nt:Destroy()
	end
	new_notification.Text = '\n  ' .. (if typeof(text) == 'string' and #text > 0 then text else '4') .. '  \n'
	new_notification.Visible = true
	new_notification.Parent = lbl_frame
	debris:AddItem(new_notification, 60.04)
	return new_notification
end

---4

local function alert_if_monster(e, spawned)
	local name = e.Name
	if name ~= 'a90' and name ~= 'handdebris' and name ~= 'monster' and name ~= 'monster2' then return end
	return show_notification(monster_name_decipher(e, spawned), spawned)
end

local function destroy_link(from, to)
	if not from or not to then return end
	local connection
	connection = from.Changed:Connect(function(property)
		if from.Parent or property ~= 'Parent' then return end
		connection:Disconnect()
		to:Destroy()
	end)
end

local function descendant_added_w(e)
	sleep(0.104)
	destroy_link(e, alert_if_monster(e, true))
	if is_special(e) then
		if highlights[e] then return end
		local new_highlight = highlight:Clone()
		new_highlight.Adornee = e
		highlights[e] = new_highlight
		new_highlight.Parent = ui
	elseif e.Name == 'hidelocker' then
		local door = e:WaitForChild('door', 14)
		if not door then return end
		while true do
			sleep(0.04)
			local door_parent = door.Parent
			local parent = e.Parent
			local visible = door_parent and parent and tonumber(parent.Name) and not e:FindFirstChild('jack')
			if visible then
				if highlights[door] then continue end
				local new_highlight = highlight:Clone()
				new_highlight.Adornee = door
				highlights[door] = new_highlight
				new_highlight.Parent = ui
			else
				local old_highlight = highlights[door]
				if old_highlight then
					highlights[door] = nil
					old_highlight:Destroy()
				end
				if not door_parent or not parent then break end
			end
		end
	elseif e:IsA('MeshPart') and find(e.MeshId, '34384784', 1, true) then
		local part = inst_new('Part')
		part.Anchored = false
		part.CFrame = e.CFrame
		part.CanTouch = false
		part.Color = e.Color
		part.CustomPhysicalProperties = e.CustomPhysicalProperties
		part.Massless = true
		part.Material = e.Material
		part.Size = e.Size
		part.Transparency = 1
		local weld = inst_new('WeldConstraint')
		weld.Part0 = e
		weld.Part1 = part
		weld.Parent = e
		part.Parent = e.Parent
	end
end

og_fs = hf(inst_new('RemoteEvent').FireServer, ncc(function(self, arg_1, ...)
	if find(upper(self.Name), 'PLAYERREMOTE', 1, true) and find(upper(tostring(arg_1)), 'SERIOUS', 1, true) then return end
	return og_fs(self, arg_1, ...)
end))

og_gftb = hf(uis.GetFocusedTextBox, ncc(function(self, ...) return nil end))
og_hmm = hmm(game, '__namecall', ncc(function(self, arg_1, arg_2, ...)
	local is_mine = cc()
	local ncm = upper(gncm())
	if find(upper(self.Name), 'PLAYERREMOTE', 1, true) and find(upper(tostring(arg_1)), 'SERIOUS', 1, true) and
		find(ncm, 'FIRESERVER', 1, true) then return end
	if not is_mine and self == starter_gui and find(ncm, 'SETCORE', 1, true)
		and arg_1 == 'DevConsoleVisible' and arg_2 == false then return end
	if self == uis and ncm == 'GETFOCUSEDTEXTBOX' then return nil end
	return og_hmm(self, arg_1, arg_2, ...)
end))

og_sc = hf(starter_gui.SetCore, ncc(function(self, arg_1, arg_2, ...)
	if not cc() and self == starter_gui and arg_1 == 'DevConsoleVisible' and arg_2 == false then return end
	return og_sc(self, arg_1, arg_2, ...)
end))

workspace.DescendantAdded:Connect(descendant_added_w)
workspace.DescendantRemoving:Connect(function(e)
	debris:AddItem(alert_if_monster(e, false), 4)
	local old_highlight = highlights[e]
	if not old_highlight then return end
	highlights[e] = nil
	old_highlight:Destroy()
end)

your_gui.ChildAdded:Connect(function(e)
	if e.Name ~= 'a90' then return end
	debris:AddItem(alert_if_monster(e, false), 4)
	local cam = workspace.CurrentCamera
	local a, b, c = cam.CameraType, you.DevComputerMovementMode, you.DevTouchMovementMode
	cam.CameraType, you.DevComputerMovementMode, you.DevTouchMovementMode = s1, s2, s3
	sleep(0.4)
	cam.CameraType, you.DevComputerMovementMode, you.DevTouchMovementMode = a, b, c
end)

local list = workspace:GetDescendants()
for i = 1, #list do coroutine_resume(coroutine_create(descendant_added_w), list[i]) end
clear(list)
debris:AddItem(show_notification('rnd4 activated!', false), 4)
while true do
	sleep(0.1)
	light_part.CFrame = (workspace.CurrentCamera or light_part).CFrame
	lighting.GlobalShadows = false
	for e, highlight in next, highlights do
		highlight.Size = highlight_size:Max(if e:IsA('BasePart') then e.Size
			elseif e:IsA('Model') then select(2, e:GetBoundingBox()) else highlight_size)
	end
end
