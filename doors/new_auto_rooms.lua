-- auto_rooms.lua
-- by unknown

local _4 = Color3.new(0, 0.2514, 0)

-- source code

if game.PlaceId ~= 6839171747 then return end
local env = (getgenv or function() end)() or _ENV or shared or _G
local new_auto_rooms = not env.auto_rooms and true or nil
env.auto_rooms = new_auto_rooms
if not new_auto_rooms then return end

local cf_new = CFrame.new
local core_gui = game:GetService('CoreGui')
local current_camera = workspace.CurrentCamera
local current_rooms = workspace:WaitForChild('CurrentRooms')
local dev_computer_movement_mode = Enum.DevComputerMovementMode
local dev_touch_movement_mode = Enum.DevTouchMovementMode
local dynamic_thumbstick = dev_touch_movement_mode.DynamicThumbstick
local fpp = fireproximityprompt or fire_proximity_prompt
local keyboard_mouse = dev_computer_movement_mode.KeyboardMouse
local latest_room = game:GetService('ReplicatedStorage'):WaitForChild('GameData'):WaitForChild('LatestRoom')
local offset = Vector3.new(0, 0, 2)
local render_stepped = game:GetService('RunService').RenderStepped
local scriptable_0 = dev_computer_movement_mode.Scriptable
local scriptable_1 = dev_touch_movement_mode.Scriptable
local table_clear = table.clear
local you = game:GetService('Players').LocalPlayer
local your_char = you.Character or you.CharacterAdded:Wait()
local your_h = your_char:WaitForChild('Humanoid')
local your_highlight = Instance.new('Highlight')
local your_hrp = your_char:WaitForChild('HumanoidRootPart')

local function get_locker()
	local closest
	local descendants = current_rooms:GetDescendants()
	local dist = 10000
	local pos = your_char:GetPivot().Position

	for idx = 1, #descendants do
		local descendant = descendants[idx]
		if descendant.Name ~= 'Rooms_Locker' then continue end
		local door = descendant:FindFirstChild('Door')
		if not door then continue end
		local hidden_player = descendant:FindFirstChild('HiddenPlayer')
		if not hidden_player or hidden_player.Value then continue end
		local new_dist = (door.Position - pos).Magnitude
		if new_dist < dist then
			closest = door
			dist = new_dist
		end
	end
	
	table_clear(descendants)
	return closest
end

local function is_monster_near()
	local children = workspace:GetChildren()
	local pos_0 = current_camera.CFrame.Position
	local pos_1 = current_rooms:WaitForChild(latest_room.Value):WaitForChild('Door'):WaitForChild('Door').Position

	for idx = 1, #children do
		local child = children[idx]
		if not child:IsA('Model') then continue end
		local name = child.Name
		if name ~= 'A60' and name ~= 'A120' then continue end
		local monster_pos = child:GetPivot().Position
		if (monster_pos - pos_0).Magnitude > 200 and (monster_pos - pos_1).Magnitude > 200 then continue end
		table_clear(children)
		return true
	end

	table_clear(children)
	return false
end

local function move_to(pos)
	your_char:PivotTo(cf_new(pos))
	your_h:MoveTo(pos)
end

-- logic

local a90 = you.PlayerGui.MainUI.Initiator.Main_Game.RemoteListener.Modules:FindFirstChild('A90')
if a90 then a90:Destroy() end
you.DevComputerMovementMode = scriptable_0
you.DevTouchMovementMode = scriptable_1
your_highlight.Archivable = false
your_highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
your_highlight.Enabled = true
your_highlight.FillColor = _4
your_highlight.FillTransparency = 0.64
your_highlight.Name = '4'
your_highlight.OutlineColor = _4
your_highlight.OutlineTransparency = 1
your_highlight.Parent = pcall(tostring, core_gui) and core_gui or you:WaitForChild('PlayerGui')
your_highlight:SetAttribute('4', _4)

while env.auto_rooms do
	render_stepped:Wait()
	
	if is_monster_near() then
		local locker = get_locker()
		if not locker or your_hrp:IsGrounded() then continue end
		your_highlight.Adornee = locker
		move_to(locker.CFrame * offset)
		fpp(locker.Parent:WaitForChild('HidePrompt'))
	else
		local idx = latest_room.Value
		if idx >= 1000 then env.auto_rooms = nil break end
		local door = current_rooms:WaitForChild(tostring(idx)):WaitForChild('Door')
		local part = door:WaitForChild('Door')
		your_highlight.Adornee = part
		move_to(part.CFrame * offset)
		door:WaitForChild('ClientOpen'):FireServer()
	end
end

you.DevComputerMovementMode = keyboard_mouse
you.DevTouchMovementMode = dynamic_thumbstick
your_highlight:Destroy()
