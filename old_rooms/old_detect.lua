--// monster_detector.lua
--// by @Vov4ik4124

local _4 = Color3.fromRGB(0, 64, 0)
local core_gui = game:GetService('CoreGui')
local run_service = game:GetService('RunService')
local starter_gui = game:GetService('StarterGui')

local color3_new = Color3.new
local instance_new = Instance.new
local string_find = string.find
local string_format = string.format
local string_upper = string.upper
local table_clear = table.clear
local udim2_new = UDim2.new
local vec2_new = Vector2.new

local center_vec2 = vec2_new(0.5, 0.5)
local current_camera = workspace.CurrentCamera
local distance_format = '%.2f'
local distance_lbl_size = udim2_new(4, 0, 0.5, 0)
local empty_vec2 = vec2_new(0, 0)
local enum_applystrokemode_border = Enum.ApplyStrokeMode.Border
local lbl_size = udim2_new(0, 34, 0, 34)
local monsters = {}
local monster_lbls = {}
local properties = {Button1 = 'OK', Title = 'Rooms'}
local render_stepped = run_service.RenderStepped
local top_center_udim2 = udim2_new(0.5, 0, -0.004, 0)
local top_center_vec2 = vec2_new(0.5, 1)
local white_color = color3_new(1, 1, 1)
local new_srmx = not _G.srmx
_G.srmx = new_srmx and true or nil

if new_srmx then
	if not
		string_find(string_upper(game:GetService('MarketplaceService'):GetProductInfo(game.PlaceId, Enum.InfoType.Asset).Name), 'ROOMS') then
		properties.Text = 'Rooms monster detector may not work.'
		starter_gui:SetCore('SendNotification', properties)
	end
else
	properties.Text = 'Rooms monster detector has been deactivated.'
	starter_gui:SetCore('SendNotification', properties)

	return
end

local screen_gui = instance_new('ScreenGui')
screen_gui.ClipToDeviceSafeArea = false
screen_gui.DisplayOrder = 2147483647
screen_gui.IgnoreGuiInset = true
screen_gui.ResetOnSpawn = false
screen_gui.SafeAreaCompatibility = Enum.SafeAreaCompatibility.FullscreenExtension
screen_gui.ScreenInsets = Enum.ScreenInsets.None
screen_gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
screen_gui.Parent = pcall(tostring, core_gui) and core_gui or game:GetService('Players').LocalPlayer:WaitForChild('PlayerGui')

pcall(function()
	screen_gui.OnTopOfCoreBlur = true
end)

local function create_lbl(decoration)
	local text_lbl = instance_new('TextLabel')
	text_lbl.AnchorPoint = center_vec2
	text_lbl.BackgroundTransparency = 1
	text_lbl.Size = lbl_size
	text_lbl.TextColor3 = _4
	text_lbl.TextScaled = true
	text_lbl.Visible = false
	text_lbl.ZIndex = 2147483647
	text_lbl.Parent = screen_gui

	if decoration then
		local ui_stroke = instance_new('UIStroke')
		ui_stroke.ApplyStrokeMode = enum_applystrokemode_border
		ui_stroke.Color = _4
		ui_stroke.Thickness = 4
		ui_stroke.Parent = text_lbl

		local distance_lbl = instance_new('TextLabel')
		distance_lbl.AnchorPoint = top_center_vec2
		distance_lbl.BackgroundTransparency = 1
		distance_lbl.Position = top_center_udim2
		distance_lbl.Size = distance_lbl_size
		distance_lbl.Text = '0'
		distance_lbl.TextColor3 = _4
		distance_lbl.TextScaled = true
		distance_lbl.ZIndex = 2147483647
		distance_lbl.Parent = text_lbl
	end

	return text_lbl
end

local function get_free_lbl()
	for idx = 1, 100 do
		local lbl = monster_lbls[idx]

		if not lbl.Visible then
			return lbl
		end
	end

	return
end

local function update_monsters()
	local children = workspace:GetChildren()
	table_clear(monsters)

	for idx = 1, #children do
		local child = children[idx]
		local name = child.Name
		local upper_name = string_upper(name)
		local match = string_find(name, '%a%d+') or
			string_find(upper_name, 'MONSTER%d*') or
			string_find(name, '%a%-%d+') or
			string_find(upper_name, 'MONSTER%-%d*')

		if child:IsA('BasePart') and match then
			monsters[#monsters + 1] = child
		end
	end
end

for idx = 1, 100 do
	local lbl = create_lbl(true)
	lbl.MaxVisibleGraphemes = 1
	lbl.Text = '4'
	monster_lbls[idx] = lbl
end

local y = lbl_size.Y
local spawned_lbl = create_lbl(false)
properties.Text = 'Rooms monster detector has been activated.'
spawned_lbl.AnchorPoint = center_vec2
spawned_lbl.Position = udim2_new(0.5, 0, 0, 44)
spawned_lbl.Size = udim2_new(1, 0, y.Scale, y.Offset)
spawned_lbl.Text = 'Monster has been spawned.'
starter_gui:SetCore('SendNotification', properties)

while _G.srmx do
	render_stepped:Wait()

	for idx = 1, 100 do
		monster_lbls[idx].Visible = false
	end

	spawned_lbl.Visible = false
	update_monsters()

	for idx = 1, #monsters do
		local monster = monsters[idx]
		local monster_lbl = get_free_lbl()

		if monster and monster_lbl then
			local active = monster:FindFirstChildOfClass('BoolValue')
			local hunting = true

			if active and not active.Value then
				hunting = false
			end

			local color = hunting and _4 or white_color
			local pos = monster.Position
			local offset = current_camera:WorldToViewportPoint(pos)
			local visible = offset.Z > 0
			monster_lbl.TextColor3 = color
			monster_lbl.UIStroke.Color = color
			monster_lbl.Visible = visible
			
			if hunting then
				spawned_lbl.Visible = hunting
			end

			if visible then
				local text_lbl = monster_lbl.TextLabel
				monster_lbl.Position = udim2_new(0, offset.X, 0, offset.Y)
				text_lbl.Text = string_format(distance_format, (pos - current_camera.CFrame.Position).Magnitude)
				text_lbl.Visible = hunting
			end
		end
	end
end

for idx = 1, 100 do
	monster_lbls[idx]:Destroy()
end

table_clear(monsters)
table_clear(monster_lbls)
table_clear(properties)
spawned_lbl:Destroy()
