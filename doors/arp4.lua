-- arp4.lua
-- by @Vov4ik4124

local _4 = Color3.new(0, .4984, 0)

-- source code

local instance_new = Instance.new
local properties = {Text = '', Title = ''}
local replicated_storage = game:GetService('ReplicatedStorage')
local starter_gui = game:GetService('StarterGui')
local sound_service = game:GetService('SoundService')
local function notify(text, title, id, volume)
	if text == nil or title == nil then return end
	properties.Text = text
	properties.Title = title
	starter_gui:SetCore('SendNotification', properties)
	if id == nil or id == '' or volume <= 0 then return end
	local err_sound = instance_new('Sound')
	err_sound.Archivable = false
	err_sound.SoundId = id
	err_sound.Volume = volume or 0.5
	sound_service:PlayLocalSound(err_sound)
	err_sound:Destroy()
end

if game.PlaceId ~= 6839171747 then
	notify('The game detected appears to not be rooms. Please execute this while in rooms', 'Invalid place', 'rbxassetid://550209561', 4)
	return
end

local game_data = replicated_storage:WaitForChild('GameData', 1.44)
if game_data == nil or game_data.Floor.Value ~= 'Rooms' then
	notify('The game detected appears to not be rooms. Please execute this while in rooms', 'Invalid place', 'rbxassetid://550209561', 4)
	return
end

local core_gui = game:GetService('CoreGui')
local latest_room = game_data:WaitForChild('LatestRoom')
local plr = game:GetService('Players').LocalPlayer
local ui = pcall(tostring, core_gui) and core_gui or plr:WaitForChild('PlayerGui')
local vec3_new = Vector3.new
if latest_room.Value == 1000 then
	notify('You\'ve already reached A-1000 room', 'Rooms', 'rbxassetid://550209561', 4)
	return
end

local pathfind_ui = ui:FindFirstChild('PathfindUI')
if pathfind_ui ~= nil then
	pathfind_ui:Destroy()
	notify('The script has been deactivated', 'Rooms', '', 0)
	return
end

-- logic

local boxes = {}
local cf_new = CFrame.new
local clear = table.clear
local current_rooms = workspace:WaitForChild('CurrentRooms')
local dev_computer_movement_mode = Enum.DevComputerMovementMode
local dev_touch_movement_mode = Enum.DevTouchMovementMode
local door_offset = cf_new(0, 0, 1.5)
local dynamic_thumbstick = dev_touch_movement_mode.DynamicThumbstick
local fire_proximity_prompt = fireproximityprompt or fireProximityPrompt or FireProximityPrompt or fire_proximity_prompt
local keyboard_mouse = dev_computer_movement_mode.KeyboardMouse
local never = Enum.AdornCullingMode.Never
local offset = vec3_new(0, -2.5, 0)
local path = game:GetService('PathfindingService'):CreatePath({AgentCanJump = false, AgentRadius = 0.6, WaypointSpacing = 6})
local path_compute_async = path.ComputeAsync
local physical_properties = PhysicalProperties.new(9e9, 9e9, 9e9, 1, 1)
local scriptable_0 = dev_computer_movement_mode.Scriptable
local scriptable_1 = dev_touch_movement_mode.Scriptable
local sleep = task.wait
local stick_size = vec3_new(0.5, 1.444, 0.5)
local terrain = workspace.Terrain
local virtual_user = game:GetService('VirtualUser')
local virtual_user_button1_down = virtual_user.Button1Down
local virtual_user_button1_up = virtual_user.Button1Up
local vec2_zero = Vector2.zero
local vec3_zero = Vector3.zero
pathfind_ui = instance_new('ScreenGui')
pathfind_ui.Archivable = false
pathfind_ui.ClipToDeviceSafeArea = false
pathfind_ui.DisplayOrder = 4096
pathfind_ui.Name = 'PathfindUI'
pathfind_ui.ResetOnSpawn = false
pathfind_ui.ScreenInsets = Enum.ScreenInsets.None
pathfind_ui.Parent = ui

local text_lbl = instance_new('TextLabel')
text_lbl.Archivable = false
text_lbl.BackgroundTransparency = 1
text_lbl.BorderColor3 = _4
text_lbl.Size = UDim2.new(0, 350, 0, 100)
text_lbl.TextColor3 = Color3.new(1, 1, 1)
text_lbl.TextSize = 40
text_lbl.TextStrokeColor3 = _4
text_lbl.TextStrokeTransparency = 0
text_lbl.Parent = pathfind_ui

local function get_locker()
	local closest
	local descendants = current_rooms:GetDescendants()
	local dist = 10000
	local pos = plr.Character.HumanoidRootPart.Position
	for idx = 1, #descendants do
		local descendant = descendants[idx]
		if descendant.Name ~= 'Rooms_Locker' then continue end
		local door = descendant:FindFirstChild('Door')
		if door == nil then continue end
		local door_pos = door.Position
		if door_pos.Y <= -3 then continue end
		local hidden_player = descendant:FindFirstChild('HiddenPlayer')
		if hidden_player == nil or hidden_player.Value then continue end
		local new_dist = (door_pos - pos).Magnitude
		if new_dist >= dist then continue end
		closest, dist = door, new_dist
	end

	clear(descendants)
	return closest
end

local function get_path()
	local monster = workspace:FindFirstChild('A60') or workspace:FindFirstChild('A120')
	return monster ~= nil and monster.Main.Position.Y >= -4 and get_locker() or
		((current_rooms:FindFirstChild(tostring(latest_room.Value)) or game):FindFirstChild('Door') or game):FindFirstChild('Door')
end

local function is_safe()
	local children = workspace:GetChildren()

	for idx = 1, #children do
		local child = child[idx]
		local name = child.Name
		if name ~= 'A60' and name ~= 'A120' then continue end
		local main = child:FindFirstChild('Main')
		if main == nil or main.Position.Y <= -4 then continue end
		clear(children)
		return false
	end

	clear(children)
	return true
end

local function latest_room_changed()
	if pathfind_ui.Parent == nil then return end
	local value = latest_room.Value
	local is_end = value == 1000
	plr.DevComputerMovementMode = is_end and keyboard_mouse or scriptable_0
	plr.DevTouchMovementMode = is_end and dynamic_thumbstick or scriptable_1
	text_lbl.Text = 'Room: ' .. value
	if not is_end then return end
	notify('Thank you for using my script!', 'Rooms', 'rbxassetid://4590662766', 3)
	pathfind_ui:Destroy()
end

local connection_0 = plr.Idled:Connect(function()
	if pathfind_ui.Parent == nil then return end
	pcall(virtual_user_button1_down, virtual_user, vec2_zero)
	sleep()
	pcall(virtual_user_button1_up, virtual_user, vec2_zero)
end)

local connection_1 = game:GetService('RunService').Heartbeat:Connect(function()
	if pathfind_ui.Parent == nil then return end
	local char = plr.Character
	if char == nil then return end
	local collision = char:FindFirstChild('Collision')
	if collision == nil then return end
	local h = char:FindFirstChildOfClass('Humanoid')
	if h == nil then return end
	local hrp = h.RootPart
	if hrp == nil then return end
	collision.CanCollide = false
	collision.CustomPhysicalProperties = physical_properties
	hrp.CanCollide = false
	local destination = get_path()
	if destination == nil then return end
	local monster = workspace:FindFirstChild('A60') or workspace:FindFirstChild('A120')
	if monster then
		local parent = destination.Parent
		if parent.Name ~= 'Rooms_Locker' or (destination.Position - hrp.Position).Magnitude >= 5 or hrp:IsGrounded() or is_safe() then return end
		local hide_prompt = parent:FindFirstChild('HidePrompt')
		if fire_proximity_prompt == nil or hide_prompt == nil then return end
		fire_proximity_prompt(hide_prompt)
	else
		if hrp:IsGrounded() or hrp.Position.Y >= -54 then return end
		char:PivotTo(destination.CFrame * door_offset)
	end
end)

local modules = plr.PlayerGui.MainUI.Initiator.Main_Game.RemoteListener.Modules
local connection_h
local a90 = modules:FindFirstChild('A90')
if a90 ~= nil then a90.Parent = nil end
local connection_2 = latest_room:GetPropertyChangedSignal('Value'):Connect(latest_room_changed)
latest_room_changed()
notify('The script has been activated', 'Rooms', '', 0)
while pathfind_ui.Parent ~= nil do
	for idx = 1, #boxes do boxes[idx].Parent = nil end
	local destination = get_path()
	if destination == nil then sleep() continue end
	local char = plr.Character
	if char == nil then sleep() continue end
	local h = char:FindFirstChildOfClass('Humanoid')
	if h == nil then sleep() continue end
	local hrp = h.RootPart
	if hrp == nil then sleep() continue end
	local signal = h.MoveToFinished
	local succ = pcall(path_compute_async, path, hrp.Position + offset, destination.Position)
	if not succ or path.Status == 5 then sleep() continue end
	local waypoints = path:GetWaypoints()
	local waypoints_len = #waypoints
	if waypoints_len <= 0 then sleep() continue end
	for idx = 1, waypoints_len do
		local box = boxes[idx] or instance_new('BoxHandleAdornment')
		box.AdornCullingMode = never
		box.Adornee = terrain
		box.AlwaysOnTop = true
		box.Archivable = false
		box.CFrame = cf_new(waypoints[idx].Position)
		box.Color3 = _4
		box.Size = stick_size
		box.Transparency = 0.644
		box.ZIndex = 4
		box.Parent = pathfind_ui
		boxes[idx] = box
	end

	for idx = 1, waypoints_len do
		if (hrp:IsGrounded() and not is_safe()) or pathfind_ui.Parent == nil then break end
		local active = true
		local pos = waypoints[idx].Position
		connection_h = signal:Connect(function() active = false end)
		while active and pathfind_ui.Parent ~= nil and not (hrp:IsGrounded() and not is_safe()) do
			h:Move((pos - hrp.Position - offset).Unit)
			h:MoveTo(pos)
			sleep()
		end

		h:Move(vec3_zero)
		h:MoveTo(hrp.Position)
	end

	clear(waypoints)
end

if a90 ~= nil then a90.Parent = modules end
if connection_h ~= nil then connection_h:Disconnect() end
connection_0:Disconnect()
connection_1:Disconnect()
connection_2:Disconnect()
path:Destroy()
plr.DevComputerMovementMode = keyboard_mouse
plr.DevTouchMovementMode = dynamic_thumbstick
for idx = 1, #boxes do boxes[idx]:Destroy() end
clear(boxes)
local char = plr.Character
if char == nil then return end
local collision = char:FindFirstChild('Collision')
if collision == nil then return end
local h = char:FindFirstChildOfClass('Humanoid')
if h == nil then return end
local hrp = h.RootPart
if hrp == nil then return end
collision.CanCollide = true
collision.CustomPhysicalProperties = nil
h:Move(vec3_zero)
h:MoveTo(hrp.Position)
hrp.CanCollide = true
