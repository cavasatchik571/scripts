-- afk4.lua
-- by @Vov4ik4124

local _4 = Color3.new(0, .2514, 0)

-- check APIs

if game.GameId ~= 66654135 then return end
local env = (getgenv or function() end)() or _ENV or shared or _G
if env.afk4 then return end
local fti = firetouchinterest or fire_touch_interest
local gncm = getnamecallmethod or get_namecall_method
local hf = hookfunction or hook_function
local hmm = hookmetamethod or hook_meta_method
local ncc = newcclosure or new_cclosure
local plrs = game:GetService('Players')
local qt = queueonteleport or (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)
local you = plrs.LocalPlayer
if not fti or not gncm or not hf or not hmm or not ncc or not qt then return you:Kick('Your client doesn\'t support AFK4.') end
env.afk4 = true

-- fail-safe measures

local sleep = task.wait
local ts = game:GetService('TeleportService')
local ts_ttpi = ts.TeleportToPlaceInstance
local vec2_zero = Vector2.zero
local vu = game:GetService('VirtualUser')
you.Idled:Connect(function()
	vu:Button1Down(vec2_zero)
	sleep()
	vu:Button1Up(vec2_zero)
end)

local aqt = true
local source_code = ''
while true do
	local succ, new_code = pcall(game.HttpGet, game, 'https://raw.githubusercontent.com/cavasatchik571/scripts/main/mm2/auto_mm2.lua', true)
	if succ then
		source_code = new_code
		break
	else
		sleep(4)
	end
end

you.OnTeleport:Connect(function() if aqt then aqt = false qt(source_code) end end)
you.ChildRemoved:Connect(function(child)
	if not child:IsA('PlayerScripts') then return end
	while true do
		sleep(4)
		pcall(ts_ttpi, ts, game.PlaceId, game.JobId, you)
	end
end)

-- states

local hst = Enum.HumanoidStateType
local hst_al = 1
local hst_approved = {hst.Freefall}
local hst_dead = hst.Dead
local hst_el = 15
local hst_exclude = {
	hst.FallingDown, hst.Ragdoll, hst.GettingUp, hst.Jumping, hst.Swimming, hst.Flying, hst.Landed, hst.Running,
	hst.RunningNoPhysics, hst.StrafingNoPhysics, hst.Climbing, hst.Seated, hst.PlatformStanding, hst.Physics
}

-- hooks

local find = table.find
local inst_new = Instance.new
local your_h
do
	local is_hst = function(e) return typeof(e) == 'EnumItem' and e.EnumType == hst end
	local old_gse, old_nc, old_sse
	local test_h = inst_new('Humanoid')
	old_gse = hf(test_h.GetStateEnabled, ncc(function(self, arg_1, ...)
		if self ~= your_h or not is_hst(arg_1) then return old_gse(self, arg_1, ...) end
		return if find(hst_approved, arg_1) then true else false
	end))
	old_nc = hmm(game, '__namecall', ncc(function(self, arg_1, ...)
		if self == your_h and is_hst(arg_1) then
			local ncm = gncm()
			if ncm == 'GetStateEnabled' then
				return if find(hst_approved, arg_1) then true else false
			elseif ncm == 'SetStateEnabled' then
				return old_nc(self, arg_1, if find(hst_approved, arg_1) then true else false)
			end
		end
		return old_nc(self, arg_1, ...)
	end))
	old_sse = hf(test_h.SetStateEnabled, ncc(function(self, arg_1, ...)
		if self ~= your_h or not is_hst(arg_1) then return old_sse(self, arg_1, ...) end
		return old_sse(self, arg_1, if find(hst_approved, arg_1) then true else false)
	end))
	test_h:Destroy()
end

-- set-up

local create = coroutine.create
local huge = math.huge
local resume = coroutine.resume
local vec3_power = Vector3.new(huge, huge, huge)
local zero = Vector3.zero

-- source code

local added_at = huge
local clear = table.clear
local coin_types = {'Coin'}
local coins = {}
local remove = table.remove

local function is_coin_valid(e)
	return (e.Parent or game).Name == 'CoinContainer' and e.Name == 'Coin_Server' and
		e:FindFirstChild('CoinVisual') and find(coin_types, e:GetAttribute('CoinID')) and not e:GetAttribute('Collected')
end

local function cc_child_removed(child)
	local i = find(coins, child)
	if not i then return end
	remove(coins, i)
end

local function cc_child_added(child)
	sleep(0.01)
	if not is_coin_valid(child) then return end
	coins[#coins + 1] = child
	local c0, c1, c2
	local function clean_up()
		if is_coin_valid(child) then return end
		c0:Disconnect()
		c1:Disconnect()
		c2:Disconnect()
		cc_child_removed(child)
	end

	c0 = child.Changed:Connect(clean_up)
	c1 = child.ChildRemoved:Connect(clean_up)
	c2 = child:GetAttributeChangedSignal('Collected'):Once(clean_up)
end

local function descendant_added(e)
	if not e.Parent then return end
	local name = e.Name
	if name == 'CoinContainer' then
		added_at = tick()
		clear(coins)
		e.ChildAdded:Connect(cc_child_added)
		e.ChildRemoved:Connect(cc_child_removed)
		local list = e:GetChildren()
		for i = 1, #list do cc_child_added(list[i]) end
		clear(list)
	elseif e:IsA('BasePart') and e ~= (if your_h then your_h.RootPart else nil) and name ~= 'Coin_Server' then
		e.CanTouch = false
	end
end

local function remove_all_except(inst, ...)
	local args = {...}
	local children = inst:GetChildren()
	for i = 1, #children do
		local child = children[i]
		if find(args, child.Name) then continue end
		child:Destroy()
	end
	clear(args)
end

local function reset_velocity(char)
	local descendants = char:GetDescendants()
	for i = 1, #descendants do
		local descendant = descendants[i]
		if not descendant:IsA('BasePart') then continue end
		descendant.AssemblyAngularVelocity = zero
		descendant.AssemblyLinearVelocity = zero
		descendant.CanCollide = false
		descendant.CanQuery = false
		descendant.CanTouch = descendant.Name == 'HumanoidRootPart'
		descendant.RotVelocity = zero
		descendant.Velocity = zero
	end
	clear(descendants)
end

workspace.DescendantAdded:Connect(descendant_added)
workspace.DescendantRemoving:Connect(function(e)
	if e.Name ~= 'CoinContainer' then return end
	added_at = huge
	clear(coins)
	you:SetAttribute('Done', nil)
end)

local sg = game:GetService('StarterGui')
do
	local list = workspace:GetDescendants()
	for i = 1, #list do resume(create(descendant_added), list[i]) end
	local sg_sc = sg.SetCore
	local sg_scp = {Button1 = 'OK', Duration = 4, Icon = 'rbxassetid://7440784829', Text = 'Script activated', Title = 'AFK4'}
	while true do if pcall(sg_sc, sg, 'SendNotification', sg_scp) then break else sleep(0.04) end end
end

local all = Enum.CoreGuiType.All
local cf_new = CFrame.new
local lighting = game:GetService('Lighting')
local rng = Random.new()
local safe_pos = cf_new(0, -24, 0)
local ss = game:GetService('SoundService')
while true do
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
	lighting:ClearAllChildren()
	remove_all_except(workspace, 'Camera', 'Normal', 'Terrain', unpack(list))
	sg:SetCoreGuiEnabled(all, false)
	ss:ClearAllChildren()
	workspace.Gravity = 0
	local char = you.Character
	if not char or not char.Parent then sleep(0.04) continue end
	local new_h = char:FindFirstChildOfClass('Humanoid')
	if not new_h or new_h.Health <= 0 or new_h:GetState() == hst_dead then sleep(0.04) continue end
	your_h = new_h
	if not new_h:GetAttribute('Done') then
		new_h:SetAttribute('Done', true)
		for i = 1, hst_el do new_h:SetStateEnabled(hst_exclude[i], false) end
		for i = 1, hst_al do
			local state = hst_approved[i]
			new_h:SetStateEnabled(state, true)
			if state == hst_dead then continue end
			new_h:ChangeState(state)
		end
	end
	local rp = your_h.RootPart
	if not rp or not rp.Parent then sleep(0.04) continue end
	if not rp:FindFirstChild('BAV') then
		local bav = inst_new('BodyAngularVelocity')
		bav.AngularVelocity = zero
		bav.MaxTorque = vec3_power
		bav.Name = 'BAV'
		bav.Parent = rp
		local bv = inst_new('BodyVelocity')
		bv.MaxForce = vec3_power
		bv.Name = 'BV'
		bv.Velocity = zero
		bv.Parent = rp
	end
	local map = workspace:FindFirstChild('Normal')
	if not map then sleep(0.04) continue end
	remove_all_except(map, 'CoinContainer')
	local len = #coins
	if len == 0 then
		if (tick() - added_at) >= 24 and not you:GetAttribute('Done') then
			you:SetAttribute('Done', true)
			local bp = you:FindFirstChildOfClass('Backpack')
			if not (bp:FindFirstChild('Knife') or char:FindFirstChild('Knife')) then your_h:ChangeState(hst_dead) continue end
		end
		local t = 0.2514
		while t > 0 do
			t -= sleep()
			reset_velocity(char)
			char:PivotTo(safe_pos)
		end
	else
		local coin = coins[rng:NextInteger(1, len)]
		local t = 2.514
		while is_coin_valid(coin) and t > 0 do
			t -= sleep()
			local cf = coin:GetPivot()
			char:PivotTo(cf)
			local len = #coins
			if len == 0 then continue end
			local your_pos = cf.Position
			for i = 1, len do
				local part = coins[i]
				if not part or (part.Position - your_pos).Magnitude > 8 then continue end
				fti(rp, part, 1)
				fti(rp, part, 0)
			end
		end
		while t > 0 do
			t -= sleep()
			reset_velocity(char)
			char:PivotTo(safe_pos)
		end
	end
end
