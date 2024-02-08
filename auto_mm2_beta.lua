-- check

if game.PlaceId ~= 142823291 then return end
local env = (getgenv or function() end)() or _ENV or shared or _G
if not env then return end
local table_clear = table.clear
local new_amm2 = not env.amm2 and true or nil
local properties = {Text = 'The script has been ' .. (new_amm2 and 'activated.' or 'deactivated.'), Title = 'Auto MM2 script'}
game:GetService('StarterGui'):SetCore('SendNotification', properties)
table_clear(properties)
env.amm2 = new_amm2
if not env.amm2 then return end

-- variables

local cf_new = CFrame.new
local current_camera = workspace.CurrentCamera
local fti = firetouchinterest
local gc = getconnections
local heartbeat = game:GetService('RunService').Heartbeat
local math_round = math.round
local offset = Vector3.new(0, -3.5, 0)
local plrs = game:GetService('Players')
local table_remove = table.remove
local table_sort = table.sort
local task_spawn = task.spawn
local vec2_zero = Vector2.zero
local vec3_zero = Vector3.zero
local vim = game:GetService('VirtualInputManager')
local vu = game:GetService('VirtualUser')
local you = plrs.LocalPlayer
local your_char_pos, killer_pos
local your_mouse = you:GetMouse()
local your_mouse_button_1_down = your_mouse.Button1Down
local your_mouse_button_1_up = your_mouse.Button1Up

-- functions

local function coin_score_func(a, b)
	local a_pos = a.Position or vec3_zero
	local a_score = -(a_pos - your_char_pos).Magnitude + math_round((a_pos - killer_pos).Magnitude / 20) * 20
	local b_pos = b.Position or vec3_zero
	local b_score = -(b_pos - your_char_pos).Magnitude + math_round((b_pos - killer_pos).Magnitude / 20) * 20
	return a_score > b_score
end

local function fire(signal, ...)
	local list = gc(signal)
	for idx = 1, #list do list[idx]:Fire(...) end
	table_clear(list)
end

local function get_closest_coin()
	local coins = workspace:FindFirstChild('CoinContainer', true)
	if not coins then return nil end
	local children = coins:GetChildren()

	for idx = #children, 1, -1 do
		local child = children[idx]

		if child.Name ~= 'Coin_Server' or (child.Position - your_char_pos).Magnitude > 304 or
			not child:FindFirstChildOfClass('Part') or child:FindFirstChild('BagFull') or
			child:FindFirstChild('RoundEnd') or child:FindFirstChild('SpinComplete') then
			table_remove(children, idx)
			continue
		end
	end

	table_sort(children, coin_score_func)
	local coin = children[1]
	table_clear(children)
	return coin
end

local function get_killer_pos()
	local has_knife = ((you:FindFirstChildOfClass('Backpack') or game):FindFirstChild('Knife') or
		(you.Character or game):FindFirstChild('Knife')) and true or false
	local dist = 10000
	local list = plrs:GetPlayers()
	local result = vec3_zero

	for idx = 1, #list do
		local plr = list[idx]
		if plr == you then continue end
		local bp = plr:FindFirstChildOfClass('Backpack')
		local char = plr.Character
		if not bp or not char or (has_knife and not bp:FindFirstChild('Gun') and not char:FindFirstChild('Gun')) or
			(not has_knife and not bp:FindFirstChild('Knife') and not char:FindFirstChild('Knife')) then continue end
		local new_killer_pos = char:GetPivot().Position
		local new_dist = (new_killer_pos - your_char_pos).Magnitude
		if new_dist >= dist then continue end
		dist = new_dist
		result = new_killer_pos
	end

	table_clear(list)
	return result
end

local function move_to(dt, model, pos)
	pos = pos or vec3_zero
	local children = model:GetChildren()

	for idx = 1, #children do
		local child = children[idx]
		if not child:IsA('BasePart') then continue end
		child.AssemblyAngularVelocity = vec3_zero
		child.AssemblyLinearVelocity = vec3_zero
	end

	table_clear(children)
	local r = pos - your_char_pos
	local u = r.Unit * dt
	local x = u.X

	if x == x then
		if r.Magnitude <= 0.5 then
			your_char_pos = pos
		else
			your_char_pos += u
		end

		model:PivotTo(cf_new(your_char_pos + offset, pos))
	else
		model:PivotTo(cf_new(your_char_pos + offset) * model:GetPivot().Rotation)
	end
end

local function tool_activate(tool)
	local cf = current_camera.CFrame
	vu:ClickButton1(vec2_zero, cf)
	fire(tool.Activated)
	fire(your_mouse_button_1_down)
	vim:SendMouseButtonEvent(0, 0, 0, true, nil, 0)
	vim:SendTouchEvent(0, 0, 0, 0)
	vu:Button1Down(vec2_zero, cf)
	tool:Activate()
	heartbeat:Wait()
	fire(tool.Deactivated)
	fire(your_mouse_button_1_up)
	vim:SendMouseButtonEvent(0, 0, 2, false, nil, 0)
	vim:SendTouchEvent(0, 2, 0, 0)
	vu:Button1Up(vec2_zero, current_camera.CFrame)
	tool:Deactivate()
	return nil
end

local function weapon_logic()
	if not workspace:FindFirstChild('BagFull', true) then return end
	local bp = you:FindFirstChildOfClass('Backpack')
	if not bp then return end
	local char = you.Character
	if not char then return end
	local knife = bp:FindFirstChild('Knife') or char:FindFirstChild('Knife')
	if knife then
		knife.Parent = char
		tool_activate(knife)
		local succ, err = pcall(tool_activate, knife)
		if not succ then warn('tool_activate, ln 159', err) end
		heartbeat:Wait()
		local children = workspace:GetChildren()
		local handle = knife.Handle

		for idx = 1, #children do
			local child = children[idx]
			if not child:IsA('Model') then continue end
			local torso = child:FindFirstChild('Torso') or child:FindFirstChild('UpperTorso')
			if not torso then continue end
			local h = child:FindFirstChildOfClass('Humanoid')
			if h.Health <= 0 or h:GetState().Value == 15 then continue end
			fti(handle, torso, 0)
			fti(handle, torso, 1)
		end

		table_clear(children)
	else
		local h = char:FindFirstChildOfClass('Humanoid')
		if not h then return end
		h.Health = 0

		while true do
			local a = workspace:FindFirstChild('BagFull', true)
			if a then a:Destroy() else break end
		end
	end
end

-- code

while env.amm2 do
	local dt = heartbeat:Wait()
	local char = you.Character
	if not char then continue end
	local new_pos = char:GetPivot().Position
	if not your_char_pos or (new_pos - your_char_pos).Magnitude > 15 then your_char_pos = new_pos end
	killer_pos = get_killer_pos()
	local h = char:FindFirstChildOfClass('Humanoid')
	if not h or h.Health <= 0 or h:GetState().Value == 15 then continue end
	local hrp = char:FindFirstChild('HumanoidRootPart')
	if not hrp then continue end
	local coin = get_closest_coin()
	h.PlatformStand = coin and true or false

	if coin then
		local coin_pos = coin.Position

		if (coin_pos - your_char_pos).Magnitude <= 12 then
			fti(hrp, coin, 0)
			fti(hrp, coin, 1)
		end

		move_to(dt * 25, char, coin_pos)
	else
		weapon_logic()
	end
end
