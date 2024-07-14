--!nolint
--!nonstrict

local _4 = Color3.new(0, .4984, 0)

-- by Vov4ik

if game.PlaceId ~= 12208518151 then return end
local gncm = getnamecallmethod
local hf = hookfunction
local hmm = hookmetamethod
local ncc = newcclosure
local you = game:GetService('Players').LocalPlayer
if not gncm or not hf or not hmm or not ncc then return you:Kick('Your executor doesn\'t support RND4') end
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
local max = math.max
local sleep = task.wait
local smooth = Enum.SurfaceType.Smooth
local udim2_fs = UDim2.fromScale
local udim2_new = UDim2.new
local udim_new = UDim.new
local uis = game:GetService('UserInputService')
local upper = string.upper
local vec2_new = Vector2.new
local vec3_new = Vector3.new
local your_gui = you:WaitForChild('PlayerGui')
local zero = Vector3.zero

local og_fs, og_gftb, og_hmm
local highlight_size = vec3_new(0.144, 0.64, 0.144)
local paths = {
	'^Workspace%.monster$',
	'^Workspace%.monster2$',
	'^Workspace%.next%.room%.battery$',
	'^Workspace%.next%.room%.lever$',
	'^Workspace%.rooms%.%d+%.battery$',
	'^Workspace%.rooms%.%d+%.lever$',
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
notification_timer.Size = udim2_fs(0, 0.164)
notification_timer.Text = '0.0s'
notification_timer.TextColor3 = colors_white
notification_timer.TextScaled = true
notification_timer.TextStrokeColor3 = _4
notification_timer.TextStrokeTransparency = 0
notification_timer.TextXAlignment = Enum.TextXAlignment.Right
notification_timer.TextYAlignment = Enum.TextYAlignment.Top
notification_timer.Parent = notification

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

local function show_notification(text)
	local connection
	local timer = 0
	local new_notification = notification:Clone()
	local nt = new_notification.Timer
	new_notification.Text = '\n  ' .. (if typeof(text) == 'string' and #text > 0 then text else '4') .. '  \n'
	new_notification.Visible = true
	new_notification.Parent = lbl_frame
	connection = hb:Connect(function(dt)
		if not new_notification then return connection:Disconnect() end
		timer += dt
		nt.Text = format('%.1fs', timer)
	end)
	return new_notification
end

---4

local function alert_if_monster(e, spawned)
	local name = e.Name
	if name ~= 'monster' and name ~= 'monster2' then return end
	return show_notification('A ' .. name .. ' has ' .. (if spawned then 'spawned' else 'despawned') .. '!')
end

local function descendant_added_w(e)
	sleep(0.4)
	local new_notification = alert_if_monster(e, true)
	if new_notification then
		local connection
		connection = e.Changed:Connect(function(property)
			if e.Parent or property ~= 'Parent' then return end
			connection:Disconnect()
			new_notification:Destroy()
		end)
	end
	if is_special(e) then
		if highlights[e] then return end
		local new_highlight = highlight:Clone()
		new_highlight.Adornee = e
		highlights[e] = new_highlight
		new_highlight.Parent = ui
	elseif e.Name == 'hidelocker' then
		local door = e:WaitForChild('door')
		local function set_highlight(enabled)
			if enabled then
				if highlights[door] then return end
				local new_highlight = highlight:Clone()
				new_highlight.Adornee = door
				highlights[door] = new_highlight
				new_highlight.Parent = ui
			else
				local old_highlight = highlights[door]
				if not old_highlight then return end
				highlights[door] = nil
				old_highlight:Destroy()
			end
		end
		local function func(child) if child.Name == 'jack' then set_highlight(true) end end
		e.ChildAdded:Connect(func)
		e.ChildRemoved:Connect(function(child) if child.Name == 'jack' then set_highlight(false) end end)
		local children = e:GetChildren()
		for i = 1, #children do func(children[i]) end
		clear(children)
	elseif e:IsA('MeshPart') and find(e.MeshId, '34384784', 1, true) then
		local part = inst_new('Part')
		part.Anchored = false
		part.CFrame = e.CFrame
		part.CanTouch = false
		part.CastShadow = e.CastShadow
		part.Color = e.Color
		part.Massless = true
		part.Material = e.Material
		part.Name = e.Name
		part.Reflectance = e.Reflectance
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
og_hmm = hmm(game, '__namecall', ncc(function(self, arg_1, ...)
	local ncm = upper(gncm())
	if find(upper(self.Name), 'PLAYERREMOTE', 1, true) and find(upper(tostring(arg_1)), 'SERIOUS', 1, true) and
		find(ncm, 'FIRESERVER', 1, true) then return end
	if self == uis and ncm == 'GETFOCUSEDTEXTBOX' then return nil end
	return og_hmm(self, arg_1, ...)
end))

workspace.DescendantAdded:Connect(descendant_added_w)
workspace.DescendantRemoving:Connect(function(e)
	debris:AddItem(alert_if_monster(e, false), 4)
	local old_highlight = highlights[e]
	if not old_highlight then return end
	highlights[e] = nil
	old_highlight:Destroy()
end)

local list = workspace:GetDescendants()
for i = 1, #list do coroutine_resume(coroutine_create(descendant_added_w), list[i]) end
clear(list)
while true do
	sleep(0.1)
	light_part.CFrame = (workspace.CurrentCamera or light_part).CFrame
	lighting.GlobalShadows = false
	for e, highlight in next, highlights do
		highlight.Size = highlight_size:Max(if e:IsA('BasePart') then e.Size
			elseif e:IsA('Model') then select(2, e:GetBoundingBox()) else highlight_size)
	end
end
