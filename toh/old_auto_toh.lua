-- source code

local properties = {Button1 = 'OK', Duration = 5, Text = '', Title = 'Tower of Hell'}
local run_service = game:GetService('RunService')
local starter_gui = game:GetService('StarterGui')
local table_clear = table.clear
local table_insert = table.insert

if not run_service:IsStudio() then
	local ids = {1962086868, 3582763398, 5253186791, 7227293156, 7237794334, 7237795212}
	local is_compatible = table.find(ids, game.PlaceId)
	table_clear(ids)

	if not is_compatible then
		properties.Text = 'This script is incompatible with the current game.'
		starter_gui:SetCore('SendNotification', properties)
		return table_clear(properties)
	end
end

local env = (getgenv or function() end)() or _ENV or shared or _G
local new_enabled = not env.toh_enabled or nil
env.toh_enabled = new_enabled
properties.Text = 'The script is ' .. (new_enabled and 'enabled.' or 'disabled.')
starter_gui:SetCore('SendNotification', properties)
table_clear(properties)
if not new_enabled then return end
local cf_new = CFrame.new
local freefall = Enum.HumanoidStateType.Freefall
local heartbeat = run_service.Heartbeat
local math_huge = math.huge
local sort_waypoints = function(a, b) return type(a) == 'vector' and type(b) == 'vector' and a.Y < b.Y end
local string_find = string.find
local string_upper = string.upper
local table_sort = table.sort
local vec3_new = Vector3.new
local vec3_offset = vec3_new(0, 2.5, 0)
local vec3_zero = Vector3.zero
local you = game:GetService('Players').LocalPlayer

local function change_state(h, s, v)
	if typeof(h) ~= 'Instance' or not h:IsA('Humanoid') then return end
	
	if v == false then
		h:SetStateEnabled(s, false)
	elseif v == nil then
		h:ChangeState(s)
	elseif v == true then
		h:SetStateEnabled(s, true)
	end
end

local function no_velocity(root)
	if typeof(root) ~= 'Instance' then return end
	local descendants = root:GetDescendants()

	for idx = 1, #descendants do
		local descendant = descendants[idx]
		if not descendant:IsA('BasePart') then continue end
		descendant.AssemblyAngularVelocity, descendant.AssemblyLinearVelocity = vec3_zero, vec3_zero
	end

	table_clear(descendants)
end

local function normalize(v)
	return type(v) == 'vector' and v.X == v.X and v or vec3_zero
end

local function reach(model, position, method, ...)
	if typeof(model) ~= 'Instance' or not model:IsA('PVInstance') or
		type(position) ~= 'vector' or type(method) ~= 'string' or method == '' then return false end

	local new_method = string_upper(tostring(method) or '')

	if new_method == 'TIME' then
		local pos, t, duration = model:GetPivot().Position, 0, ...
		
		if type(duration) ~= 'number' or duration ~= duration or
			duration <= 0 or duration >= math_huge then return false end

		while t < duration do
			t += heartbeat:Wait()
			local next_pos = pos:Lerp(position, t / duration)
			if not env.toh_enabled or not model.Parent or (model:GetPivot().Position - next_pos).Magnitude > 10 then return false end
			model:PivotTo(cf_new(next_pos, position))
			no_velocity(model)
		end

		model:PivotTo(cf_new(position) * model:GetPivot().Rotation)
		return env.toh_enabled and model.Parent and t >= duration
	elseif new_method == 'VELOCITY' then
		local velocity = ...

		if type(velocity) ~= 'number' or velocity ~= velocity or
			velocity <= 0 or velocity >= math_huge then return false end

		while true do
			local curr_pos = model:GetPivot().Position
			local next_pos = curr_pos + normalize((position - curr_pos).Unit) * velocity * heartbeat:Wait()
			local dist = (curr_pos - next_pos).Magnitude
			if not env.toh_enabled or not model.Parent or dist > 10 then return false end
			model:PivotTo(cf_new(next_pos, position))
			no_velocity(model)
			if (model:GetPivot().Position - next_pos).Magnitude >= dist then break end
		end

		model:PivotTo(cf_new(position) * model:GetPivot().Rotation)
		return env.toh_enabled and model.Parent and true or false
	end

	return false
end

local function set_killpart_triggers(root, enabled)
	if typeof(root) ~= 'Instance' then return end
	local descendants = root:GetDescendants()

	for idx = 1, #descendants do
		local descendant = descendants[idx]
		if not descendant:IsA('BasePart') or not descendant:FindFirstChild('kills') then continue end
		descendant.CanTouch = enabled
	end

	table_clear(descendants)
end

-- logic

while env.toh_enabled do
	heartbeat:Wait()
	local char = you.Character
	if not char then continue end
	local h = char:FindFirstChildOfClass('Humanoid')
	if not h then continue end
	local tower = workspace:FindFirstChild('tower')
	if not tower then continue end
	local sections = tower:FindFirstChild('sections')
	if not sections then continue end
	local finish = sections:FindFirstChild('finish')
	if not finish then continue end
	local finish_glow = finish:FindFirstChild('FinishGlow')
	if not finish_glow or finish_glow:GetAttribute('IsDone') then continue end
	local children = sections:GetChildren()
	local waypoints = {}
	local y = char:GetPivot().Y

	for idx = 1, #children do
		local start = children[idx]:FindFirstChild('start')
		if not start then continue end
		local pos = start.Position + vec3_offset
		if y > pos.Y then continue end
		table_insert(waypoints, pos)
	end

	local run = true
	table_clear(children)
	table_insert(waypoints, finish_glow.CFrame * vec3_new(-finish_glow.Size.X * 2, 0, 0))
	table_sort(waypoints, sort_waypoints)

	for idx = 1, #waypoints do
		set_killpart_triggers(sections, false)
		change_state(h, freefall, false)
		local r = reach(char, waypoints[idx], 'Time', 15)
		change_state(h, freefall, true)
		if not r then break end
	end

	set_killpart_triggers(sections, true)
	table_clear(waypoints)
	if not char.Parent or not env.toh_enabled then continue end
	finish_glow:SetAttribute('IsDone', true)
end
