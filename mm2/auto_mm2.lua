-- source code

local place_id = 142823291
if game.PlaceId ~= place_id then return end
local code = `loadstring(game:HttpGet('https://raw.githubusercontent.com/cavasatchik571/scripts/main/mm2/auto_mm2.lua', true))()`
local env = (getgenv or function() end)() or _ENV or shared or _G
if not env.MF_injected then (queueonteleport or queue_on_teleport)(code) end
env.MF_injected = true
local new_enabled = not env.MF and true or nil
env.MF = new_enabled
if not new_enabled then return end

local offset = Vector3.new(0, -2, 0)
local speed = 20.14

local cf_new = CFrame.new
local cf_yxz = CFrame.fromEulerAnglesYXZ
local clear = table.clear
local defer = task.defer
local pi = math.pi
local plrs = game:GetService('Players')
local ps = game:GetService('RunService').PreSimulation
local remove = table.remove
local rng = Random.new()
local round = math.round
local sleep = task.wait
local sort = table.sort
local starter_gui = game:GetService('StarterGui')
local step = 4
local ts = game:GetService('TeleportService')
local ts_ttpi = ts.TeleportToPlaceInstance
local you = plrs.LocalPlayer
local vec2_zero = Vector2.zero
local vec3_zero = Vector3.zero
local vu = game:GetService('VirtualUser')
local vu_b1d = vu.Button1Down
local vu_b1u = vu.Button1Up

local _set = function(a, b, c) a[b] = c end
local fti = firetouchinterest or fire_touch_interest or function(p0, p1, uint)
	if uint then warn('UInt is unsupported') end
	local fct0, fct1, fp0 = p0.CanTouch, p1.CanTouch, p0.Position
	p0.CanTouch, p1.CanTouch, p0.Position = true, true, p1.Position
	defer(_set, p0, 'CanTouch', fct0)
	defer(_set, p1, 'CanTouch', fct1)
	defer(_set, p0, 'Position', fp0)
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

local function get_is_alive(plr)
	if typeof(plr) ~= 'Instance' or not plr:IsA('Player') or not plr:FindFirstChildOfClass('Backpack') then return false end
	local bp = plr:FindFirstChildOfClass('Backpack')
	if not bp then return false end
	local char = plr.Character
	if not char then return false end
	local h = char:FindFirstChildOfClass('Humanoid')
	if not h or h.Health <= 0 or h:GetState().Value == 15 or not h.RootPart then return false end
	return true
end

local function get_stepped(e)
	if typeof(e) ~= 'number' then return 0 end
	return step == 0 and e or (round(e / step) * step)
end

local function get_threat()
	local char = you.Character
	local char_pos = char:GetPivot().Position
	--local item_name = (you:FindFirstChildOfClass('Backpack'):FindFirstChild('Knife') or char:FindFirstChild('Knife')) and 'Gun' or 'Knife'
	local list = plrs:GetPlayers()
	local radius = 400
	local result
	for i = 1, #list do
		local element = list[i]
		if element == you or not get_is_alive(element) then continue end
		local other_char = element.Character
		--if not element:FindFirstChildOfClass('Backpack'):FindFirstChild(item_name) and not other_char:FindFirstChild(item_name) then continue end
		local dist = (char_pos - other_char:GetPivot().Position).Magnitude
		if dist > radius then continue end
		radius, result = dist, element
	end
	clear(list)
	return result
end

local function reset_velocity(inst)
	local list = inst:GetDescendants()
	for i = 1, #list do
		local element = list[i]
		if not element:IsA('BasePart') then continue end
		element.AssemblyAngularVelocity, element.AssemblyLinearVelocity = vec3_zero, vec3_zero
		element.CanCollide, element.CanQuery = false, false
	end
	clear(list)
end

local function sort_coins(a, b)
	local ap, bp = a.Position or vec3_zero, b.Position or vec3_zero
	local p0 = you.Character:GetPivot().Position
	local score_a, score_b = -(ap - p0).Magnitude, -(bp - p0).Magnitude
	local threat = get_threat()
	if threat then
		local p1 = threat.Character:GetPivot().Position
		score_a += get_stepped((ap - p1).Magnitude) / 4
		score_b += get_stepped((bp - p1).Magnitude) / 4
	end
	return score_a > score_b
end

-- logic

local connection_0 = you.Idled:Connect(function()
	if not env.MF then return end
	pcall(vu_b1d, vu, vec2_zero)
	ps:Wait()
	pcall(vu_b1u, vu, vec2_zero)
end)

local connection_1 = you.ChildRemoved:Connect(function(child)
	if not child:IsA('PlayerScripts') then return end
	while true do
		sleep(1)
		pcall(ts_ttpi, ts, place_id, game.JobId, you)
	end
end)

starter_gui:SetCore('SendNotification', {Button1 = 'OK', Duration = 4, Title = 'MM2', Text = 'Auto farm script has been activated.'})
while env.MF do
	local dt = ps:Wait()
	step = rng:NextNumber(4, 6)
	if not get_is_alive(you) then continue end
	local bp = you:FindFirstChildOfClass('Backpack')
	local char = you.Character
	local h = char:FindFirstChildOfClass('Humanoid')
	local hrp = h.RootPart
	h.PlatformStand = false
	local map = workspace:FindFirstChild('Normal')
	if not map then workspace.Gravity = 196.2 continue end
	local cc = map:FindFirstChild('CoinContainer')
	if not cc then workspace.Gravity = 196.2 continue end
	local children = map:GetChildren()
	for i = 1, #children do
		local child = children[i]
		if child == cc then continue end
		child:Destroy()
	end
	clear(children)
	reset_velocity(char)
	local particle_emitter
	local descendants = cc:GetDescendants()
	for i = 1, #descendants do
		local descendant = descendants[i]
		if not descendant:IsA('ParticleEmitter') or descendant.Texture ~= 'rbxassetid://16885815956' or
			descendant.Parent:FindFirstChildWhichIsA('MeshPart').Transparency > 0 then continue end
		particle_emitter = descendant
		break
	end
	clear(descendants)
	if particle_emitter then
		hrp.CFrame = particle_emitter.Parent:GetPivot()
		continue
	else
		if bp:FindFirstChild('Knife') or char:FindFirstChild('Knife') then
			local function tp_to_safe_zone()
				local init = hrp:GetAttribute('SafeCFrame')
				if not init then
					init = hrp.CFrame + vec3_new(0, 200, 0)
					hrp:SetAttribute('SafeCFrame', init)
				end
				hrp.CFrame = init
			end

			pcall(function() if you.PlayerGui.MainGUI.Game.CoinBags.Container.Coin.Full.Visible then tp_to_safe_zone() end end)
			pcall(function() if you.PlayerGui.MainGUI.Lobby.Dock.CoinBags.Container.Coin.Full.Visible then tp_to_safe_zone() end end)
		else
			pcall(function() if you.PlayerGui.MainGUI.Game.CoinBags.Container.Coin.Full.Visible then h.Health = 0 end end)
			pcall(function() if you.PlayerGui.MainGUI.Lobby.Dock.CoinBags.Container.Coin.Full.Visible then h.Health = 0 end end)
		end
	end
	local coins = cc:GetChildren()
	local p0 = hrp:GetPivot().Position
	filter_coins(coins)
	if #coins <= 0 then continue end
	sort(coins, sort_coins)
	local coin = coins[1]
	clear(coins)
	local p1 = coin.Position
	local diff = p1 + offset - p0
	local dist = diff.Magnitude
	if dist > 1400 then
		hrp.CFrame = coin.CFrame
	else
		local pos = p0 + (diff.Magnitude == 0 and vec3_zero or diff.Unit) * dt * (speed - rng:NextNumber(0, 4))
		hrp.CFrame = cf_new(pos) * cf_yxz(pi, select(2, cf_new(pos, p1).Rotation:ToEulerAnglesYXZ()), 0)
	end
	h.PlatformStand, workspace.Gravity = true, 0
	fti(hrp, coin, 1)
	fti(hrp, coin, 0)
end

starter_gui:SetCore('SendNotification', {Button1 = 'OK', Duration = 4, Title = 'MM2', Text = 'Auto farm script has been deactivated.'})
connection_0:Disconnect()
connection_1:Disconnect()
if not get_is_alive(you) then return end
you.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
