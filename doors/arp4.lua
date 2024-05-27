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
local defer = task.defer
local dev_computer_movement_mode = Enum.DevComputerMovementMode
local dev_touch_movement_mode = Enum.DevTouchMovementMode
local door_offset = cf_new(0, 0, 1.5)
local dynamic_thumbstick = dev_touch_movement_mode.DynamicThumbstick
local keyboard_mouse = dev_computer_movement_mode.KeyboardMouse
local never = Enum.AdornCullingMode.Never
local offset = vec3_new(0, -2.5, 0)
local path = game:GetService('PathfindingService'):CreatePath({AgentCanJump = false, AgentRadius = 0.6, WaypointSpacing = 6})
local path_compute_async = path.ComputeAsync
local physical_properties = PhysicalProperties.new(100, 2, 1, 1, 1)
local scriptable_0 = dev_computer_movement_mode.Scriptable
local scriptable_1 = dev_touch_movement_mode.Scriptable
local sleep = task.wait
local terrain = workspace.Terrain
local virtual_user = game:GetService('VirtualUser')
local virtual_user_button1_down = virtual_user.Button1Down
local virtual_user_button1_up = virtual_user.Button1Up
local vec2_zero = Vector2.zero
local vec3_zero = Vector3.zero
local fire_proximity_prompt = fireproximityprompt or fireProximityPrompt or FireProximityPrompt or fire_proximity_prompt or function(prompt)
	prompt:InputHoldBegin()
	defer(prompt.InputHoldEnd, prompt)
end

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

local function get_door(shift)
	return ((current_rooms:FindFirstChild(latest_room.Value + (shift or 0)) or game):FindFirstChild('Door') or game):FindFirstChild('Door')
end

local function get_locker()
	local closest = nil
	local descendants = current_rooms:GetDescendants()
	local dist = 4096
	local pos = plr.Character.HumanoidRootPart.Position
	for idx = 1, #descendants do
		local descendant = descendants[idx]
		if descendant.Name ~= 'Rooms_Locker' then continue end
		local door = descendant:FindFirstChild('Door')
		if door == nil then continue end
		local door_pos = door.Position
		if door_pos.Y <= -4 then continue end
		local hidden_player = descendant:FindFirstChild('HiddenPlayer')
		if hidden_player == nil or hidden_player.Value then continue end
		local new_dist = (door_pos - pos).Magnitude
		if new_dist >= dist then continue end
		closest, dist = door, new_dist
	end

	clear(descendants)
	return closest
end

local function is_safe()
	local children = workspace:GetChildren()

	for idx = 1, #children do
		local child = children[idx]
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
	if is_end == false then return end
	notify('Thank you for using my script!', 'Rooms', 'rbxassetid://4590662766', 3)
	pathfind_ui:Destroy()
end

local get_path = function() return is_safe() and get_door(0) or get_locker() end
local connection_0 = plr.Idled:Connect(function()
	if pathfind_ui.Parent == nil then return end
	pcall(virtual_user_button1_down, virtual_user, vec2_zero)
	sleep()
	pcall(virtual_user_button1_up, virtual_user, vec2_zero)
end)

local modules = plr.PlayerGui.MainUI.Initiator.Main_Game.RemoteListener.Modules
local a90 = modules:FindFirstChild('A90')
if a90 ~= nil then a90.Parent = nil end
local connection_1 = latest_room:GetPropertyChangedSignal('Value'):Connect(latest_room_changed)
latest_room_changed()
notify('The script has been activated', 'Rooms', '', 0)
while pathfind_ui.Parent ~= nil do
	for idx = 1, #boxes do boxes[idx].Parent = nil end
	local char = plr.Character
	if char == nil then sleep() continue end
	local collision = char:FindFirstChild('Collision')
	if collision == nil then sleep() continue end
	local collision_crouch = collision:FindFirstChild('CollisionCrouch')
	if collision_crouch == nil then sleep() continue end
	local h = char:FindFirstChildOfClass('Humanoid')
	if h == nil then sleep() continue end
	local hrp = h.RootPart
	if hrp == nil then sleep() continue end
	collision.CanCollide = false
	collision.CustomPhysicalProperties = physical_properties
	collision_crouch.CanCollide = false
	collision_crouch.CustomPhysicalProperties = physical_properties
	hrp.CanCollide = false
	local destination = get_path()
	if typeof(destination) ~= 'Instance' or not destination:IsA('BasePart') then sleep() continue end
	local grounded = hrp:IsGrounded()
	if hrp.Position.Y < -54 and not grounded then char:PivotTo(destination.CFrame * door_offset) end
	if grounded and is_safe() == false then
		h:Move(vec3_zero)
		sleep()
		continue
	end

	local succ = pcall(path_compute_async, path, hrp.Position + offset, destination.Position)
	if succ == false or path.Status.Value == 5 then sleep() continue end
	local waypoints = path:GetWaypoints()
	local waypoints_len = #waypoints
	if waypoints_len <= 0 then sleep() continue end
	for idx = 1, waypoints_len - 1 do
		local box = boxes[idx]
		if box == nil then
			box = instance_new('BoxHandleAdornment')
			box.AdornCullingMode = never
			box.Adornee = terrain
			box.AlwaysOnTop = true
			box.Archivable = false
			box.Color3 = _4
			box.Transparency = 0.644
			box.ZIndex = 4
			boxes[idx] = box
		end

		local a = waypoints[idx].Position
		local b = waypoints[idx + 1].Position
		box.CFrame = cf_new((a + b) / 2, a)
		box.Size = vec3_new(0.244, 0.244, (a - b).Magnitude)
		box.Parent = pathfind_ui
	end

	for idx = 2, waypoints_len do
		if (hrp:IsGrounded() and is_safe() == false) or pathfind_ui.Parent == nil then break end
		local pos = waypoints[idx].Position
		while h.Health > 0 and h:GetState().Value ~= 15 and
			pathfind_ui.Parent ~= nil and not (hrp:IsGrounded() and is_safe() == false) do
			local your_pos = hrp.Position
			local diff = pos - your_pos - offset
			if diff.Magnitude <= 1.24 then break end
			if not hrp:IsGrounded() then
				local parent = destination.Parent
				if parent ~= nil and parent.Name == 'Rooms_Locker' and (destination.Position - hrp.Position).Magnitude < 5 then
					local hide_prompt = parent:FindFirstChild('HidePrompt')
					if hide_prompt ~= nil then
						fire_proximity_prompt(hide_prompt)
					end
				end
			end

			h:Move(diff.Unit)
			sleep()
		end

		break
	end

	clear(waypoints)
end

if a90 ~= nil then a90.Parent = modules end
connection_0:Disconnect()
connection_1:Disconnect()
path:Destroy()
plr.DevComputerMovementMode = keyboard_mouse
plr.DevTouchMovementMode = dynamic_thumbstick
for idx = 1, #boxes do boxes[idx]:Destroy() end
clear(boxes)
local char = plr.Character
if char ~= nil then
	local collision = char:FindFirstChild('Collision')
	if collision ~= nil then
		local collision_crouch = collision:FindFirstChild('CollisionCrouch')
		collision.CanCollide = true
		collision.CustomPhysicalProperties = nil

		if collision_crouch ~= nil then
			collision_crouch.CanCollide = true
			collision_crouch.CustomPhysicalProperties = nil
		end
	end

	local h = char:FindFirstChildOfClass('Humanoid')
	if h ~= nil then h:Move(vec3_zero) end
	local hrp = h.RootPart
	if hrp ~= nil then hrp.CanCollide = true end
end
