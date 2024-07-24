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
if not fti or not gncm or not hf or not hmm or not ncc or not qt then return you:Kick('Your client doesn\'t support AFK4') end

-- fail-safe measure

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
local hst_approved = {hst.Freefall}
local hst_al = #hst_approved
local hst_ignore = hst:GetEnumItems()
local hst_il = #hst_ignore
local remove = table.remove
local table_find = table.find
for i = hst_il, 1, -1 do
	if table_find(hst_approved, hst_ignore[i]) then
		remove(hst_ignore, i)
		hst_il -= 1
	end
end

-- hooks

local your_h
do
	local inst_new = Instance.new
	local old_gse, old_hmm, old_sse
	local test_h = inst_new('Humanoid')
	local function is_hst(e)
		return typeof(e) == 'EnumItem' and e.EnumType == hst
	end
	old_gse = hf(test_h.GetStateEnabled, ncc(function(self, arg_1, ...)
		if self ~= your_h or not is_hst(arg_1) then return old_gse(self, arg_1, ...) end
		return if table_find(hst_approved, arg_1) then true else false
	end))
	old_hmm = hmm(game, '__namecall', ncc(function(self, arg_1, ...)
		if self == your_h and is_hst(arg_1)then
			local ncm = gncm()
			if ncm == 'GetStateEnabled' then
				return if table_find(hst_approved, arg_1) then true else false
			elseif ncm == 'SetStateEnabled' then
				return old_hmm(self, arg_1, if table_find(hst_approved, arg_1) then true else false)
			end
		end
		return old_hmm(self, arg_1, ...)
	end))
	old_sse = hf(test_h.SetStateEnabled, ncc(function(self, arg_1, ...)
		if self ~= your_h or not is_hst(arg_1) then return old_sse(self, arg_1, ...) end
		return old_sse(self, arg_1, if table_find(hst_approved, arg_1) then true else false)
	end))
	test_h:Destroy()
end

-- logic

local clear = table.clear
local coins = {}
local dead = hst.Dead
local vec3_new = Vector3.new
local zero = Vector3.zero
local function cc0(child) coins[#coins + 1] = child end
local function cc1(child)
	local i = table_find(coins, child)
	if not i then return end
	remove(coins, i)
end

local function descendant_added(e)
	local parent = e.Parent
	if e.Name == 'CoinContainer' then
		clear(coins)
		local list = e:GetChildren()
		for i = 1, #list do coins[i] = list[i] end
		e.ChildAdded:Connect(cc0)
		e.ChildRemoved:Connect(cc1)
	elseif e:IsA('BasePart') and e ~= (if your_h then your_h.RootPart else nil) and parent.Name ~= 'CoinContainer' then
		e.CanTouch = false
	end
end

workspace.DescendantAdded:Connect(descendant_added)
workspace.DescendantRemoving:Connect(function(e)
	if e.Name ~= 'CoinContainer' then return end
	clear(coins)
	you:SetAttribute('Done', nil)
end)

do
	local list = workspace:GetDescendants()
	for i = 1, #list do descendant_added(list[i]) end
end

---4💚

local all = Enum.CoreGuiType.All
local checks = 0
local lighting = game:GetService('Lighting')
local rng = Random.new()
local ss = game:GetService('SoundService')
local string_find = string.find
local upper = string.upper

local function full_bag_of(main_gui, t)
	if not main_gui or not t then return false end
	local descendants = main_gui:GetDescendants()
	local ut = upper(tostring(t))
	if ut == '' then return false end
	for i = 1, #descendants do
		if i % 140 == 0 then sleep() end
		local descendant = descendants[i]
		if not descendant:IsA('TextLabel') or not descendant.Visible or
			string_find(upper(descendant.Text), 'FULL', 1, false) ~= 1 then continue end
		local parent = descendant.Parent
		if not string_find(upper(parent.Name), ut) then continue end
		local succ = true
		while parent ~= main_gui do
			if (parent:IsA('GuiObject') and not parent.Visible) or parent:IsA('LocalScript') then succ = false break end
			parent = parent.Parent
		end
		if succ then return true end
	end
	return false
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

local function set_cf(part, cf)
	local pos = cf.Position
	part.Velocity = zero
	part.RotVelocity = zero
	part.Position = pos
	part.CFrame = cf
	part.CanTouch = true
	part.CanCollide = false
	part.AssemblyLinearVelocity = zero
	part.AssemblyAngularVelocity = zero
end

coroutine.resume(coroutine.create(function()
	while true do
		sleep(0.04)
		if you:GetAttribute('Done') or
			not your_h or
			your_h.Health <= 0 or
			your_h:GetState() == dead or
			not workspace:FindFirstChild('Normal') then continue end

		local char = you.Character
		local h = char:FindFirstChildOfClass('Humanoid')
		local hrp = h.RootPart
		local your_gui = you:FindFirstChildOfClass('PlayerGui')
		if not your_gui then continue end
		if checks >= 8 then
			checks = 0
			local succ, result = pcall(full_bag_of, your_gui:FindFirstChild('MainGUI'), 'Coin')
			if not succ or not result then continue end
			you:SetAttribute('Done', true)
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
		else
			checks += 1
		end
	end
end))

local sg = game:GetService('StarterGui')
do
	local sg_sc = sg.SetCore
	local sg_scp = {Button1 = 'OK', Duration = 4, Icon = 'rbxassetid://7440784829', Text = 'Script activated', Title = 'AFK4'}
	while true do if pcall(sg_sc, sg, 'SendNotification', sg_scp) then break else sleep(0.04) end end
	clear(sg_scp)
end

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
	local map = workspace:FindFirstChild('Normal')
	if map then remove_all_except(map, 'CoinContainer') end
	local char = you.Character
	if not char then sleep(0.04) continue end
	your_h = char:FindFirstChildOfClass('Humanoid')
	if not your_h then sleep(0.04) continue end
	if not your_h:GetAttribute('Done') then
		your_h:SetAttribute('Done', true)
		local sse = your_h.SetStateEnabled
		for i = 1, hst_il do pcall(sse, your_h, hst_ignore[i], false) end
		for i = 1, hst_al do
			local state = hst_approved[i]
			pcall(sse, your_h, state, true)
			if state == dead then continue end
			your_h:ChangeState(state)
		end
	end
	if not your_h or your_h.Health <= 0 or your_h:GetState() == dead then sleep(0.04) continue end
	local rp = your_h.RootPart
	if not rp or not rp.Parent then sleep(0.04) continue end
	local len = #coins
	if len == 0 then sleep(0.04) continue end
	local coin = coins[rng:NextInteger(1, len)]
	if not coin or not coin.Parent then sleep(0.04) continue end
	if you:GetAttribute('Done') then
		sleep(0.04)
	else
		local t = 1.4
		while coin and coin.Parent and t > 0 do
			for i = 1, #coins do
				local part = coins[i]
				if not part or not part.Parent then continue end
				fti(rp, part, 1)
				fti(rp, part, 0)
			end
			set_cf(rp, coin.CFrame)
			t -= sleep()
		end
	end
end
