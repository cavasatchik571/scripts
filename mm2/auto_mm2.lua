-- afk4.lua
-- by @Vov4ik4124

local _4 = Color3.new(0, .2514, 0)

-- execution check

if not game:IsLoaded() then game.Loaded:Wait() end
if not game:GetService('RunService'):IsStudio() and game.GameId ~= 66654135 then return end
local env = (getgenv or function() end)() or _ENV or shared or _G
if env.afk4 then return end
env.afk4 = true

-- fail-safe measures

local plrs = game:GetService('Players')
local gqt = function() return queueonteleport or (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport) end
local sleep = task.wait
local you = plrs.LocalPlayer
do
	local source_code = ''
	local sub = string.sub
	local get_source = function() return game:HttpGet('https://raw.githubusercontent.com/cavasatchik571/scripts/main/mm2/auto_mm2.lua', true) end
	while true do
		local succ, result = pcall(get_source)
		if succ then
			source_code = result
			break
		else
			if sub(result, 1, 29) == 'HttpGet is not a valid member' then break end
			sleep(2.4)
		end
	end
	if source_code then
		local c0
		c0 = you.OnTeleport:Connect(function()
			if not c0.Connected then return end
			local qt = gqt()
			if not qt then return end
			c0:Disconnect()
			qt(source_code)
		end)
	end
	local c1
	local ts = game:GetService('TeleportService')
	local ts_ttpi = ts.TeleportToPlaceInstance
	c1 = you.ChildRemoved:Connect(function(child)
		if not c1.Connected or not child:IsA('PlayerScripts') then return end
		c1:Disconnect()
		you:Kick('Rejoining...')
		while true do
			sleep(2.4)
			pcall(ts_ttpi, ts, game.PlaceId, game.JobId, you)
		end
	end)
	local vec2_zero = Vector2.zero
	local vu = game:GetService('VirtualUser')
	you.Idled:Connect(function()
		vu:Button1Down(vec2_zero)
		sleep()
		vu:Button1Up(vec2_zero)
	end)
end

-- API check

local fti = firetouchinterest or fire_touch_interest
local gncm = getnamecallmethod or get_namecall_method
local hf = hookfunction or hook_function
local hmm = hookmetamethod or hook_metamethod
local inst_new = Instance.new
local ncc = newcclosure or new_cclosure
do
	local core_gui = game:GetService('CoreGui')
	local ui = inst_new('ScreenGui')
	ui.Archivable = false
	ui.AutoLocalize = false
	ui.ClipToDeviceSafeArea = false
	ui.DisplayOrder = 2147483647
	ui.Enabled = true
	ui.Name = 'Logs4API'
	ui.ResetOnSpawn = false
	ui.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
	ui.ZIndexBehavior = Enum.ZIndexBehavior.Global
	pcall(function() ui.OnTopOfCoreBlur = true end)
	local missing = {}
	local missing_len = 0
	if not fti then missing_len += 1 missing[missing_len] = 'Fire Touch Interest' end
	if not gncm then missing_len += 1 missing[missing_len] = 'Get Namecall Method' end
	if not hf then missing_len += 1 missing[missing_len] = 'Hook Function' end
	if not hmm then missing_len += 1 missing[missing_len] = 'Hook Metamethod' end
	if not ncc then missing_len += 1 missing[missing_len] = 'New CClosure' end
	if not gqt() then missing_len += 1 missing[missing_len] = 'Queue On Teleport' end
	local logs = inst_new('TextLabel')
	logs.Active = false
	logs.AnchorPoint = Vector2.new(0, 1)
	logs.Archivable = false
	logs.AutoLocalize = false
	logs.AutomaticSize = Enum.AutomaticSize.XY
	logs.BackgroundColor3 = _4
	logs.BackgroundTransparency = 1
	logs.BorderColor3 = _4
	logs.BorderMode = Enum.BorderMode.Outline
	logs.BorderSizePixel = 4
	logs.FontFace = Font.new('rbxasset://fonts/families/Ubuntu.json', Enum.FontWeight.Regular, Enum.FontStyle.Normal)
	logs.Interactable = false
	logs.MaxVisibleGraphemes = -1
	logs.Name = 'Logs'
	logs.Position = UDim2.new(0, 4, 1, -4)
	logs.RichText = false
	logs.Rotation = 0
	logs.Selectable = false
	logs.Text = table.concat(missing, ' is missing\n')
	logs.TextColor3 = _4
	logs.TextDirection = Enum.TextDirection.LeftToRight
	logs.TextScaled = false
	logs.TextStrokeColor3 = _4
	logs.TextStrokeTransparency = 1
	logs.TextSize = 14
	logs.TextTransparency = 0
	logs.TextTruncate = Enum.TextTruncate.None
	logs.TextWrapped = false
	logs.TextXAlignment = Enum.TextXAlignment.Left
	logs.TextYAlignment = Enum.TextYAlignment.Bottom
	logs.Visible = true
	logs.ZIndex = 2147483647
	logs.Parent = ui
	ui.Parent = if pcall(tostring, core_gui) then core_gui else you:WaitForChild('PlayerGui')
end

-- states

local hst = Enum.HumanoidStateType
local hst_al = 1
local hst_approved = {hst.Freefall}
local hst_dead = hst.Dead
local hst_el = 14
local hst_exclude = {
	hst.FallingDown, hst.Ragdoll, hst.GettingUp, hst.Jumping, hst.Swimming, hst.Flying, hst.Landed, hst.Running,
	hst.RunningNoPhysics, hst.StrafingNoPhysics, hst.Climbing, hst.Seated, hst.PlatformStanding, hst.Physics
}

-- hooks

local find = table.find
local huge = math.huge
local your_h
if gncm and hf and hmm and ncc then
	local h = inst_new('Humanoid')
	local is_hst = function(e) return typeof(e) == 'EnumItem' and e.EnumType == hst end
	local old_gse, old_nc, old_sse
	old_gse = hf(h.GetStateEnabled, ncc(function(self, arg_1, ...)
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
	old_sse = hf(h.SetStateEnabled, ncc(function(self, arg_1, ...)
		if self ~= your_h or not is_hst(arg_1) then return old_sse(self, arg_1, ...) end
		return old_sse(self, arg_1, if find(hst_approved, arg_1) then true else false)
	end))
end

-- source code

local added_at = huge
local clear = table.clear
local create = coroutine.create
local coin_types = {'Coin'}
local coins = {}
local defer = task.defer
local remove = table.remove
local resume = coroutine.resume
local smooth = Enum.SurfaceType.Smooth
local smooth_plastic = Enum.Material.SmoothPlastic
local vec3_power = Vector3.new(huge, huge, huge)
local zero = Vector3.zero

local function is_coin_valid(e)
	return typeof(e) == 'Instance' and (e.Parent or game).Name == 'CoinContainer' and e.Name == 'Coin_Server' and
		e:FindFirstChild('CoinVisual') and find(coin_types, e:GetAttribute('CoinID')) and not e:GetAttribute('Collected')
end

local function cc_child_removed(child)
	local i = find(coins, child)
	if not i then return end
	remove(coins, i)
end

local function cc_child_added(child)
	sleep()
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
	elseif e:IsA('Attachment') or e:IsA('Constraint') or e:IsA('Explosion') or e:IsA('FloorWire') or e:IsA('ForceField') then
		e.Visible = false
	elseif e:IsA('BasePart') then
		if e ~= (if your_h then your_h.RootPart else nil) and name ~= 'Coin_Server' then e.CanTouch = false end
		e.BackSurface, e.BottomSurface, e.FrontSurface, e.LeftSurface, e.RightSurface, e.TopSurface = smooth, smooth, smooth, smooth, smooth, smooth
		e.CastShadow, e.Material, e.Reflectance = false, smooth_plastic, 0
	elseif e:IsA('Decal') then
		defer(e.Destroy, e)
	elseif e:IsA('Beam') or e:IsA('Fire') or e:IsA('Highlight') or e:IsA('Light') or
		e:IsA('ParticleEmitter') or e:IsA('Smoke') or e:IsA('Sparkles') or e:IsA('Trail') then
		e.Enabled = false
	end
end

local function remove_all_except(inst, ...)
	local args = {...}
	local children = inst:GetChildren()
	for i = 1, #children do
		local child = children[i]
		if not child.Parent or find(args, child.Name) then continue end
		child:Destroy()
	end
	clear(args)
end

local function reset_velocity(char)
	if not char then return end
	local descendants = char:GetDescendants()
	for i = 1, #descendants do
		local descendant = descendants[i]
		if not descendant:IsA('BasePart') then continue end
		descendant.AssemblyAngularVelocity, descendant.AssemblyLinearVelocity, descendant.RotVelocity, descendant.Velocity = zero, zero, zero, zero
		descendant.CanCollide, descendant.CanQuery, descendant.CanTouch = false, false, descendant.Name == 'HumanoidRootPart'
	end
	clear(descendants)
end

local dists = {}
local opponents_len = 0
local opponents_pos, your_prefix
local sg = game:GetService('StarterGui')
local sort = table.sort
local terrain = workspace.Terrain

local function sc_internal(a, b)
		local as, bs = tostring(a.Position), tostring(b.Position)
		local a_score, b_score = -dists[your_prefix .. as], -dists[your_prefix .. bs]
		for i = 1, opponents_len do
				local prefix = opponents_pos[i]
				a_score += dists[prefix .. as]
				b_score += dists[prefix .. bs]
		end
		return a_score > b_score
end

local function sort_coins(coins)
	opponents_pos = plrs:GetPlayers()
	opponents_len = #opponents_pos
	local coins_len = #coins
	for i = opponents_len, 1, -1 do
		local element = opponents_pos[i]
		if not element or not element:FindFirstChildOfClass('Backpack') then opponents_len -= 1 remove(opponents_pos, i) continue end
		local char = element.Character
		if not char then opponents_len -= 1 remove(opponents_pos, i) continue end
		local h = char:FindFirstChildOfClass('Humanoid')
		if not h or h.Health <= 0 or h:GetState() == hst_dead or not h.RootPart then opponents_len -= 1 remove(opponents_pos, i) continue end
		local pos = char:GetPivot().Position
		local prefix = tostring(pos) .. ':'
		for i = 1, coins_len do
			local coin_pos = coins[i].Position
			local id = prefix .. tostring(coin_pos)
			if dists[id] then continue end
			dists[id] = (coin_pos - pos).Magnitude * 100
		end
		if element == you then your_prefix = prefix opponents_len -= 1 remove(opponents_pos, i) else opponents_pos[i] = prefix end
	end
	sort(coins, sc_internal)
	clear(dists)
	clear(opponents_pos)
	opponents_pos, opponents_len, your_prefix = nil, 0, nil
end

local min = math.min
local rng = Random.new()
do
	workspace.DescendantAdded:Connect(descendant_added)
	workspace.DescendantRemoving:Connect(function(e)
		if e.Name ~= 'CoinContainer' then return end
		added_at = huge
		clear(coins)
		you:SetAttribute('Done', nil)
	end)

	local list = workspace:GetDescendants()
	for i = 1, #list do resume(create(descendant_added), list[i]) end
	local sg_sc = sg.SetCore
	local sg_scp = {Button1 = 'OK', Duration = 4, Icon = 'rbxassetid://7440784829', Text = 'Script activated', Title = 'AFK4'}
	while true do if pcall(sg_sc, sg, 'SendNotification', sg_scp) then break else sleep(0.04) end end
end

local function best_coin()
	sort_coins(coins)
	return coins[rng:NextInteger(1, min(8, #coins))]
end

local all = Enum.CoreGuiType.All
local cf_new = CFrame.new
local colors_black = Color3.fromRGB(0, 0, 0)
local lighting = game:GetService('Lighting')
local prev_coin
local safe_pos = cf_new(0, -64, 0)
local ss = game:GetService('SoundService')
game:GetService('Chat').BubbleChatEnabled = false
game:GetService('TextChatService'):WaitForChild('BubbleChatConfiguration').Enabled = false
pcall(function() settings().QualityLevel = Enum.QualityLevel.Level01 end)
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
			if not child.Parent or child:IsA('Humanoid') then continue end
			local name = child.Name
			if name == 'Head' or name == 'HumanoidRootPart' or name == 'LowerTorso' or name == 'Torso' or name == 'UpperTorso' then
				defer(remove_all_except, child, 'Neck', 'Root', 'RootJoint', 'Waist', 'WaistJoint')
				child.Transparency = 1
				continue
			end
			defer(child.Destroy, child)
		end
	end
	lighting.FogColor, lighting.FogEnd, lighting.FogStart, lighting.GlobalShadows = colors_black, 1000000, 1000000, false
	lighting:ClearAllChildren()
	defer(remove_all_except, workspace, 'Camera', 'Normal', 'Terrain', unpack(list))
	sg:SetCoreGuiEnabled(all, false)
	ss:ClearAllChildren()
	terrain.WaterReflectance, terrain.WaterTransparency, terrain.WaterWaveSize, terrain.WaterWaveSpeed = 0, 0, 0, 0
	workspace.Gravity = 0
	local bp = you:FindFirstChildOfClass('Backpack')
	if not bp or not bp.Parent then sleep(0.04) continue end
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
		bav.Archivable = false
		bav.MaxTorque = vec3_power
		bav.Name = 'BAV'
		bav.P = 1250
		bav.Parent = rp
		local bv = inst_new('BodyVelocity')
		bv.Archivable = false
		bv.MaxForce = vec3_power
		bv.Name = 'BV'
		bv.P = 1250
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
			if not (bp:FindFirstChild('Knife') or char:FindFirstChild('Knife')) then your_h:ChangeState(hst_dead) continue end
		end
		local t = 0.4
		while char and char.Parent and t > 0 do
			t -= sleep()
			reset_velocity(char)
			char:PivotTo(safe_pos)
		end
	else
		local coin = best_coin()
		local dist = if prev_coin then (coin.Position - prev_coin.Position).Magnitude else 384
		local t = if dist >= 384 then 1.44 else dist ^ 0.6 / 1.64
		prev_coin = coin

		while char and char.Parent and t > 0 do
			local dt = sleep()
			t -= if is_coin_valid(coin) then 0 else dt
			local cf = coin.CFrame
			reset_velocity(char)
			char:PivotTo(cf)
			if not fti then continue end
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
	end
end
