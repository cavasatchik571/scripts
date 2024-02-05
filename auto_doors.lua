-- check

if game.PlaceId ~= 6839171747 then return end
local env = (getgenv or function() end)() or _ENV or shared or _G
local new_auto_doors = not env.auto_doors and true or nil
env.auto_doors = new_auto_doors
if not new_auto_doors then return end

-- variables

local cf_new = CFrame.new
local cf_yxz = CFrame.fromEulerAnglesYXZ
local current_camera = workspace.CurrentCamera
local current_rooms = workspace:WaitForChild('CurrentRooms')
local fpp = fireproximityprompt or fire_proximity_prompt
local plr = game:GetService('Players').LocalPlayer
local math_rad = math.rad
local render_stepped = game:GetService('RunService').RenderStepped
local replicated_storage = game:GetService('ReplicatedStorage')
local rng = Random.new()
local table_clear = table.clear
local task_wait = task.wait
local vec3_new = Vector3.new
local vec3_y_axis = Vector3.yAxis
local vec3_zero = Vector3.zero

local backpack = plr:WaitForChild('Backpack')
local char = plr.Character
local ebf = replicated_storage:WaitForChild('EntityInfo'):WaitForChild('EBF')
local h = char:WaitForChild('Humanoid')
local hrp = char:WaitForChild('HumanoidRootPart')
local latest_room = replicated_storage:WaitForChild('GameData'):WaitForChild('LatestRoom')
local offset_0 = vec3_new(0, 0, 2)
local offset_1 = vec3_new(0, 0, -2)

-- functions

local function is_monster_near()
	local children = workspace:GetChildren()
	local pos_0 = current_camera.CFrame.Position
	local pos_1 = current_rooms:WaitForChild(latest_room.Value):WaitForChild('Door'):WaitForChild('Door').Position

	for idx = 1, #children do
		local child = children[idx]
		if not child:IsA('Model') then continue end
		local name = child.Name
		if name ~= 'RushMoving' and name ~= 'AmbushMoving' then continue end
		local monster_pos = child:GetPivot().Position
		if (monster_pos - pos_0).Magnitude > 500 and (monster_pos - pos_1).Magnitude > 500 then continue end
		table_clear(children)
		return true
	end

	table_clear(children)
	return false
end

local function get_safe_pos()
	local cf, new_size = current_rooms:WaitForChild(latest_room.Value):GetBoundingBox()
	return cf.Position + new_size * vec3_y_axis
end

local function set_pos(pos)
	if type(pos) ~= 'vector' then return end
	local children = char:GetChildren()

	for idx = 1, #children do
		local child = children[idx]
		if not child:IsA('BasePart') then continue end
		child.AssemblyAngularVelocity = vec3_zero
		child.AssemblyLinearVelocity = vec3_zero
	end

	table_clear(children)
	char:PivotTo(cf_new(pos) * char:GetPivot().Rotation * cf_yxz(0, math_rad(rng:NextInteger(-180, 180)), 0))
	h:MoveTo(pos + rng:NextUnitVector())
end

-- code

local modules = plr.PlayerGui.MainUI.Initiator.Main_Game.RemoteListener.Modules
local a90 = modules:FindFirstChild('A90')
if a90 then a90:Destroy() end
local screech = modules:FindFirstChild('Screech')
if screech then screech:Destroy() end
local skip_prompt = workspace:FindFirstChild('SkipPrompt', true)
if skip_prompt then fpp(skip_prompt) end

while env.auto_doors do
	render_stepped:Wait()

	if is_monster_near() then
		set_pos(get_safe_pos())
	else
		local latest_room_value = latest_room.Value

		if latest_room_value == 100 then
			break
		else
			if latest_room_value >= 99 or (latest_room_value >= 90 and (workspace:FindFirstChild('RushMoving') or
				workspace:FindFirstChild('AmbushMoving'))) then continue end

			if latest_room_value == 50 then latest_room_value += 1 end
			local current_room = current_rooms:FindFirstChild(tostring(latest_room_value))
			if not current_room then continue end
			local assets = current_room:WaitForChild('Assets')
			local door = current_room:WaitForChild('Door')
			local key = assets:FindFirstChild('KeyObtain', true)

			if key then
				local backpack_key = backpack:FindFirstChild('Key')

				if backpack_key then
					h:UnequipTools()
					render_stepped:Wait()
					backpack_key.Parent = char
				end

				if char:FindFirstChild('Key') then
					set_pos(door:WaitForChild('Door').CFrame * offset_0)
					fpp(door:WaitForChild('Lock'):WaitForChild('UnlockPrompt'))
				else
					set_pos(key:GetPivot().Position)
					fpp(key:WaitForChild('ModulePrompt'))
				end
			else
				set_pos(door:WaitForChild('Door').CFrame * offset_0)
				door:WaitForChild('ClientOpen'):FireServer()
			end
		end
	end
end

task_wait(0.4)
local current_room = current_rooms:WaitForChild('100')
local children = current_room:GetChildren()
local ed = current_room:WaitForChild('ElectricalDoor', 5)
if ed then ed:Destroy() end

for idx = 1, #children do
	local child = children[idx]
	if child.Name ~= 'LiveBreakerPolePickup' then continue end
	local prompt = child:WaitForChild('ActivateEventPrompt')
	while prompt.Parent do
		set_pos(child:WaitForChild('Base').Position)
		fpp(prompt)
		render_stepped:Wait()
	end
end

table_clear(children)
task_wait(0.4)
local box = current_room:WaitForChild('IndustrialGate'):WaitForChild('Box')

for _ = 1, 10 do
	set_pos(box:GetPivot().Position)
	fpp(box:WaitForChild('ActivateEventPrompt'))
	render_stepped:Wait()
end

local elevator_breaker_empty = current_room:WaitForChild('ElevatorBreakerEmpty')
local ebe_pos = elevator_breaker_empty:WaitForChild('Door').CFrame * offset_1
local ebe_prompt = elevator_breaker_empty:WaitForChild('Prompt')

while (char:GetPivot().Position - ebe_pos).Magnitude > 4 do
	render_stepped:Wait()
	if hrp:IsGrounded() then continue end
	set_pos(ebe_pos)
end

fpp(ebe_prompt)
task_wait(3)
ebf:FireServer()
task_wait(3)

local new_pos = (current_room:WaitForChild('ElevatorCar'):WaitForChild('ElevatorRoot').CFrame + vec3_new(0, 2.5, 0)) *
	rng:NextUnitVector() * vec3_new(3, 0, 3)

while (char:GetPivot().Position - new_pos).Magnitude > 4 do
	render_stepped:Wait()
	if hrp:IsGrounded() then continue end
	set_pos(new_pos)
end
