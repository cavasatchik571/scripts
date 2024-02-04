-- check

if game.PlaceId ~= 6839171747 then return end
local env = (getgenv or function() end)() or _ENV or shared or _G
local new_auto_doors = not env.auto_doors and true or nil
env.auto_doors = new_auto_doors
if not new_auto_doors then return end

-- variables

local current_camera = workspace.CurrentCamera
local current_rooms = workspace:WaitForChild('CurrentRooms')
local plr = game:GetService('Players').LocalPlayer
local latest_room = game:GetService('ReplicatedStorage'):WaitForChild('GameData'):WaitForChild('LatestRoom')
local render_stepped = game:GetService('RunService').RenderStepped
local table_clear = table.clear
local vec3_y_axis = Vector3.yAxis
local vec3_zero = Vector3.zero

local backpack = plr:WaitForChild('Backpack')
local char = plr.Character
local h = char:WaitForChild('Humanoid')
local hrp = char:WaitForChild('HumanoidRootPart')
local offset = Vector3.new(0, 0, 1.5)

-- functions

local function is_monster_near()
	local children = workspace:GetChildren()
	local pos = current_camera.CFrame.Position

	for idx = 1, #children do
		local child = children[idx]
		if not child:IsA('Model') then continue end
		local name = child.Name
		if name ~= 'RushMoving' and name ~= 'AmbushMoving' then continue end
		if (child:GetPivot().Position - pos).Magnitude > 400 then continue end
		table_clear(children)
		return true
	end

	table_clear(children)
	return false
end

local function get_safe_pos()
	local children = current_rooms:GetChildren()
	local safe_pos = vec3_zero

	for idx = 1, #children do
		local cf, new_size = children[idx]:GetBoundingBox()
		local new_safe_pos = cf.Position + new_size * vec3_y_axis

		if new_safe_pos.Y > safe_pos.Y then
			safe_pos = new_safe_pos
		end
	end

	table_clear(children)
	return safe_pos
end

local function set_pos(pos)
	if type(pos) ~= 'vector' then return end
	hrp.AssemblyAngularVelocity = vec3_zero
	hrp.AssemblyLinearVelocity = vec3_zero
	hrp.Position = pos
	hrp.RotVelocity = vec3_zero
	hrp.Velocity = vec3_zero
end

-- code

while env.auto_doors do
	if is_monster_near() then
		set_pos(get_safe_pos())
	else
		local latest_room_value = latest_room.Value

		if latest_room_value == 100 then
			--TODO room 100
		else
			if latest_room_value == 50 then latest_room_value += 1 end
			local current_room = current_rooms[latest_room_value]
			local assets = current_room:WaitForChild('Assets')
			local key = assets:FindFirstChild('KeyObtain')
			
			if key then
				local backpack_key = backpack:FindFirstChild('Key')

				if backpack_key then
					h:UnequipAllTools()
					render_stepped:Wait()
					backpack_key.Parent = char
				end

				if char:FindFirstChild('Key') then
					set_pos(current_room:WaitForChild('Door'):WaitForChild('Door').CFrame * offset)
				else
					set_pos(key:GetPivot().Position)
				end
			else
				set_pos(current_room:WaitForChild('Door'):WaitForChild('Door').CFrame * offset)
			end
		end
	end

	render_stepped:Wait()
end
