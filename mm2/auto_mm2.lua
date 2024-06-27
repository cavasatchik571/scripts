--!nolint
--!nonstrict

local _4 = Color3.new(0, .4984, 0)

-- by @Vov4ik4124

local place_id = game.PlaceId
if place_id ~= 142823291 then return end
local fti = firetouchinterest or fire_touch_interest
local plrs = game:GetService('Players')
local qot = queueonteleport or queue_on_teleport
local you = plrs.LocalPlayer
local your_name = you.Name
if not fti or not qot then return you:Kick('AFK4 doesn\'t support your executor') end
local env = shared or _G
if env.afk4 then return end
env.afk4 = true
qot('loadstring(game:HttpGet(\'https://raw.githubusercontent.com/cavasatchik571/scripts/main/mm2/auto_mm2.lua\', true))()')
local all = Enum.CoreGuiType.All
local check = 0
local cf_new = CFrame.new
local dead = Enum.HumanoidStateType.Dead
local lighting = game:GetService('Lighting')
local min = math.min
local remove = table.remove
local rng = Random.new()
local sleep = task.wait
local sort = table.sort
local sound_service = game:GetService('SoundService')
local starter_gui = game:GetService('StarterGui')
local string_find = string.find
local table_find = table.find
local ts = game:GetService('TeleportService')
local ts_ttpi = ts.TeleportToPlaceInstance
local upper = string.upper
local vec2_zero = Vector2.zero
local vec3_new = Vector3.new
local vec3_zero = Vector3.zero
local vu = game:GetService('VirtualUser')
local vu_b1d = vu.Button1Down
local vu_b1u = vu.Button1Up
local nearest_plr_pos, point_of_interest = vec3_zero, vec3_zero

local offset_pos, speed, speed_lb, speed_ub = vec3_new(0, -2, 0), 20.14, -4, 0

---4 with/💚

local function clear_velocity(inst)
	local children = inst:GetChildren()
	for i = 1, #children do
		local child = children[i]
		if not child:IsA('BasePart') then continue end
		child.AssemblyAngularVelocity = vec3_zero
		child.AssemblyLinearVelocity = vec3_zero
	end
end

local function filter_coins(cc)
	for i = #cc, 1, -1 do
		local c = cc[i]
		if c.Name ~= 'Coin_Server' or c.Transparency ~= 1 then remove(cc, i) continue end
		local cv = c:FindFirstChild('CoinVisual')
		if not cv then remove(cc, i) continue end
		local inst = cv:FindFirstChild('MainCoin')
		if not inst or inst.Transparency ~= 0 then remove(cc, i) continue end
	end
end

local function is_alive(plr)
	local bp = plr:FindFirstChildOfClass('Backpack')
	if not bp then return false end
	local char = plr.Character
	if not char or not char.Parent then return false end
	local h = char:FindFirstChildOfClass('Humanoid')
	if not h or h.Health <= 0 or h:GetState() == dead or not h.RootPart then return false end
	return true
end

local function near_plr()
	local dist = 10000
	local list = plrs:GetPlayers()
	local pos = you.Character:FindFirstChildOfClass('Humanoid').RootPart.Position
	local result
	for i = 1, #list do
		local element = list[i]
		if element == you or not is_alive(element) then continue end
		local new_dist = (element.Character:FindFirstChildOfClass('Humanoid').RootPart.Position - pos).Magnitude
		if new_dist >= dist then continue end
		dist = new_dist
		result = element
	end
	return result
end

local function remove_all_except(inst, ...)
	local args = {...}
	local children = inst:GetChildren()
	for i = 1, #children do
		local child = children[i]
		if table_find(args, child.Name) then continue end
		child:Destroy()
	end
end

local function sort_coins(a, b)
	local a_score = -(point_of_interest - a.Position).Magnitude + (nearest_plr_pos - a.Position).Magnitude
	local b_score = -(point_of_interest - b.Position).Magnitude + (nearest_plr_pos - b.Position).Magnitude
	return a_score > b_score
end

you.ChildRemoved:Connect(function(child)
	if not child:IsA('PlayerScripts') then return end
	while true do
		sleep(1)
		pcall(ts_ttpi, ts, place_id, game.JobId, you)
	end
end)

you.Idled:Connect(function()
	if not env.afk4 then return end
	pcall(vu_b1d, vu, vec2_zero)
	sleep()
	pcall(vu_b1u, vu, vec2_zero)
end)

local sg = game:GetService('StarterGui')
local sg_sc = sg.SetCore
local sg_scp = {Button1 = 'OK', Duration = 4, Icon = 'rbxassetid://7440784829', Text = 'Script activated', Title = 'AFK4'}
while true do if pcall(sg_sc, sg, 'SendNotification', sg_scp) then break else sleep(0.04) end end
while true do
	local dt = sleep()
	local list = plrs:GetPlayers()
	for i = 1, #list do
		local plr = list[i]
		list[i] = plr.Name
		local char = plr.Character
		if not char then continue end
		local children = char:GetChildren()
		for j = 1, #children do
			local child = children[j]
			if child:IsA('Humanoid') then continue end
			local name = child.Name
			if name == 'Head' or name == 'HumanoidRootPart' or name == 'LowerTorso' or name == 'Torso' or name == 'UpperTorso' then
				remove_all_except(child, 'Neck', 'Root', 'RootJoint', 'Waist', 'WaistJoint')
				child.Transparency = 1
				continue
			end
			child:Destroy()
		end
	end
	remove_all_except(workspace, 'Camera', 'Normal', 'Terrain', unpack(list))
	lighting:ClearAllChildren()
	sound_service:ClearAllChildren()
	starter_gui:SetCoreGuiEnabled(all, false)
	if not is_alive(you) then continue end
	local your_gui = you:FindFirstChildOfClass('PlayerGui')
	if not your_gui then continue end
	local char = you.Character
	clear_velocity(char)
	local h = char:FindFirstChildOfClass('Humanoid')
	h.PlatformStand = true
	workspace.Gravity = 0
	clear_velocity(char)
	local map = workspace:FindFirstChild('Normal')
	if not map then you:SetAttribute('4', nil) continue end
	remove_all_except(map, 'CoinContainer')
	local cc = map:FindFirstChild('CoinContainer')
	if not cc then continue end
	local hrp = h.RootPart
	if you:GetAttribute('4') == _4 then continue end
	if check >= 40 then
		check = 0
		local descendants = your_gui:GetDescendants()
		for i = 1, #descendants do
			local descendant = descendants[i]
			if not descendant:IsA('TextLabel') or not descendant.Visible or not string_find(upper(descendant.Text), 'FULL') then continue end
			local succ = true
			while descendant ~= your_gui do
				if descendant:IsA('GuiObject') and not descendant.Visible then
					succ = false
					break
				end
				descendant = descendant.Parent
			end
			if not succ then continue end
			you:SetAttribute('4', _4)
			break
		end
	else
		check += 1
	end
	if you:GetAttribute('4') == _4 then
		if you:FindFirstChildOfClass('Backpack'):FindFirstChild('Knife') or char:FindFirstChild('Knife') then
			local init = hrp:GetAttribute('SafeCFrame')
			if not init then
				init = hrp.CFrame + vec3_new(0, 240, 0)
				hrp:SetAttribute('SafeCFrame', init)
			end
			hrp.CFrame = init
		else
			h.Health = 0
		end
		continue
	end
	local plr = near_plr()
	if not plr or not is_alive(plr) then continue end
	local list = cc:GetChildren()
	filter_coins(list)
	local len = #list
	if len == 0 then continue end
	local p0 = hrp.Position
	nearest_plr_pos = plr.Character:FindFirstChildOfClass('Humanoid').RootPart.Position
	point_of_interest = p0
	sort(list, sort_coins)
	local p1 = list[1]:GetPivot().Position
	local diff = p1 + offset_pos - p0
	local dist = diff.Magnitude
	if dist <= 0.2444 then
		continue
	elseif dist >= 666 then
		hrp.CFrame = cf_new(offset_pos + p1, p1)
	else
		local pos = p0 + (dist == 0 and vec3_zero or diff.Unit) * (speed + rng:NextNumber(speed_lb, speed_ub)) * dt
		hrp.CFrame = cf_new(pos) * cf_new(offset_pos + p1, p1).Rotation
	end
	for i = 1, len do
		local part = list[i]
		if (hrp.Position - part.Position).Magnitude >= 8 then continue end
		fti(hrp, part, 1)
		fti(hrp, part, 0)
	end
end
