-- rooms_pathfinding.lua
-- original by @lolcat

local _4 = Color3.new(0, 0.2514, 0)

-- source code

local instance_new = Instance.new
local properties = {Text = '', Title = ''}
local replicated_storage = game:GetService('ReplicatedStorage')
local starter_gui = game:GetService('StarterGui')
local sound_service = game:GetService('SoundService')

local function notify(text, title, id, volume)
	if not text or not title then return end
	properties.Text = text
	properties.Title = title
	starter_gui:SetCore('SendNotification', properties)
	if not id or id == '' or volume <= 0 then return end
	local err_sound = instance_new('Sound')
	err_sound.Archivable = false
	err_sound.SoundId = id
	err_sound.Volume = volume or 0.5
	sound_service:PlayLocalSound(err_sound)
	err_sound:Destroy()
end

if game.PlaceId ~= 6839171747 then
	notify('The game detected appears to not be rooms. Please execute this while in rooms.', 'Invalid place', 'rbxassetid://550209561', 4)
	return
end

local game_data = replicated_storage:WaitForChild('GameData', 1.4)

if not game_data or game_data.Floor.Value ~= 'Rooms' then
	notify('The game detected appears to not be rooms. Please execute this while in rooms.', 'Invalid place', 'rbxassetid://550209561', 4)
	return
end

local core_gui = game:GetService('CoreGui')
local latest_room = game_data:WaitForChild('LatestRoom')
local plr = game:GetService('Players').LocalPlayer
local ui = pcall(tostring, core_gui) and core_gui or plr:WaitForChild('PlayerGui')
local vec3_new = Vector3.new

if latest_room.Value == 1000 then
	notify('You\'ve already reached A-1000 room.', 'Rooms', 'rbxassetid://550209561', 4)
	return
end

if ui:FindFirstChild('PathfindUI') then
	notify('The script has been already activated.', 'Rooms', 'rbxassetid://550209561', 4)
	return
end

-- logic

notify('The script has been activated.', 'Rooms', '', 0)

local boxes = {}
local cam_lock = replicated_storage:WaitForChild('EntityInfo'):WaitForChild('CamLock')
local cf_new = CFrame.new
local current_rooms = workspace:WaitForChild('CurrentRooms')
local dev_computer_movement_mode = Enum.DevComputerMovementMode
local fire_proximity_prompt = fireproximityprompt or fireProximityPrompt or FireProximityPrompt or fire_proximity_prompt
local keyboard_mouse = dev_computer_movement_mode.KeyboardMouse
local math_clamp = math.clamp
local never = Enum.AdornCullingMode.Never
local offset = vec3_new(0, -2.5, 0)
local path = game:GetService('PathfindingService'):CreatePath({AgentCanJump = false, AgentRadius = 0.6, WaypointSpacing = 2})
local path_compute_async = path.ComputeAsync
local pathfind_ui = instance_new('ScreenGui')
local physical_properties = PhysicalProperties.new(9e9, 9e9, 9e9, 1, 1)
local render_stepped = game:GetService('RunService').RenderStepped
local scriptable = dev_computer_movement_mode.Scriptable
local stick_size = vec3_new(0.5, 1.44, 0.5)
local task_defer = task.defer
local terrain = workspace.Terrain
local virtual_user = game:GetService('VirtualUser')
local virtual_user_button1_up = virtual_user.Button1Down
local zero_vec2 = Vector2.zero
pathfind_ui.Archivable = false
pathfind_ui.ClipToDeviceSafeArea = false
pathfind_ui.DisplayOrder = 2514
pathfind_ui.Name = 'PathfindUI'
pathfind_ui.ResetOnSpawn = false
pathfind_ui.ScreenInsets = Enum.ScreenInsets.None
pathfind_ui.Parent = ui

local text_lbl = instance_new('TextLabel')
text_lbl.Archivable = false
text_lbl.BackgroundTransparency = 1
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
		if not door then continue end
		local door_pos = door.Position
		if door_pos.Y <= -3 then continue end
		local hidden_player = descendant:FindFirstChild('HiddenPlayer')
		if not hidden_player or hidden_player.Value then continue end
		local new_dist = (door_pos - pos).Magnitude
		if new_dist < dist then
			closest = door
			dist = new_dist
		end
	end

	return closest
end

local function get_path()
	local monster = workspace:FindFirstChild('A60') or workspace:FindFirstChild('A120')
	return monster and monster.Main.Position.Y > -4 and get_locker() or current_rooms[latest_room.Value].Door.Door
end

local function latest_room_changed()
	local value = latest_room.Value
	text_lbl.Text = 'Room: ' .. math_clamp(value, 1, 1000)
	local is_end = value == 1000
	plr.DevComputerMovementMode = is_end and keyboard_mouse or scriptable
	if not is_end then return end
	notify('Thank you for using my script!', 'Rooms', 'rbxassetid://4590662766', 3)
	pathfind_ui:Destroy()
end

local connection_0 = plr.Idled:Connect(function()
	if not pathfind_ui.Parent then return end
	pcall(virtual_user_button1_up, virtual_user, zero_vec2)
	render_stepped:Wait()
	task_defer(pcall, virtual_user_button1_up, virtual_user, zero_vec2)
end)

local connection_1 = render_stepped:Connect(function()
	if not pathfind_ui.Parent then return end
	local char = plr.Character
	if not char then return end
	local collision = char.Collision
	local h = char.Humanoid
	local hrp = char.HumanoidRootPart
	local monster = workspace:FindFirstChild('A60') or workspace:FindFirstChild('A120')
	local path = get_path()
	collision.CanCollide = false
	collision.CustomPhysicalProperties = physical_properties
	h.WalkSpeed = 40
	hrp.CanCollide = false

	if monster then
		local y = monster.Main.Position.Y

		if path then
			local parent = path.Parent

			if parent.Name == 'Rooms_Locker' and y > -4 and (hrp.Position - path.Position).Magnitude < 5 and not hrp:IsGrounded() then
				local hide_prompt = parent:FindFirstChild('HidePrompt')

				if fire_proximity_prompt then
					fire_proximity_prompt(hide_prompt)
				end
			end
		end

		if y < -4 and hrp:IsGrounded() then
			cam_lock:FireServer()
		end
	else
		if hrp:IsGrounded() then return end
		cam_lock:FireServer()
	end
end)

local connection_2 = latest_room:GetPropertyChangedSignal('Value'):Connect(latest_room_changed)
latest_room_changed()

local a90 = plr.PlayerGui.MainUI.Initiator.Main_Game.RemoteListener.Modules:FindFirstChild('A90')

if a90 then
	a90:Destroy()
end

while pathfind_ui.Parent do
	for idx = 1, #boxes do boxes[idx].Parent = nil end
	local destination = get_path()
	if not destination then  render_stepped:Wait() continue end
	local char = plr.Character
	if not char then render_stepped:Wait() continue end
	local h = char.Humanoid
	local h_move_to_finished = h.MoveToFinished
	local hrp = char.HumanoidRootPart
	local succ = pcall(path_compute_async, path, hrp.Position + offset, destination.Position)
	if not succ or path.Status == 5 then render_stepped:Wait() continue end
	local waypoints = path:GetWaypoints()
	local waypoints_len = #waypoints
	if waypoints_len <= 0 then render_stepped:Wait() continue end

	for idx = 1, waypoints_len do
		local box = boxes[idx] or instance_new('BoxHandleAdornment')
		box.AdornCullingMode = never
		box.Adornee = terrain
		box.AlwaysOnTop = true
		box.Archivable = false
		box.CFrame = cf_new(waypoints[idx].Position)
		box.Color3 = _4
		box.Size = stick_size
		box.Transparency = 0.64
		box.ZIndex = 4
		box.Parent = pathfind_ui
		boxes[idx] = box
	end

	for idx = 1, waypoints_len do
		if hrp:IsGrounded() then break end
		h:MoveTo(waypoints[idx].Position)
		h_move_to_finished:Wait()
	end
end

connection_0:Disconnect()
connection_1:Disconnect()
connection_2:Disconnect()

for idx = 1, #boxes do
	boxes[idx]:Destroy()
end

table.clear(boxes)
