-- no_dmg.lua
-- by @Vov4ik4124

local _4 = Color3.new(0, 0.2514, 0)

-- source code

local clear = table.clear
local create = coroutine.create
local dead = Enum.HumanoidStateType.Dead
local defer = task.defer
local dummy_h = inst_new('Humanoid')
local ff = inst_new('ForceField')
local hp = 2147483647
local inst_new = Instance.new
local offset = 0
local resume = coroutine.resume
local sleep = task.wait
local unused_event = inst_new('BindableEvent').Event
local you = game:GetService('Players').LocalPlayer
local old_bj, old_gse, old_i, old_nm, old_sse, old_td, old_ts, your_char, your_h

local function get_value()
	offset += 1
	offset %= 4
	return hp - offset
end

local function char_added(char)
	local function descendant_added(descendant)
		if not descendant:IsA('JointInstance') or descendant:GetAttribute('4') == _4 then return end
		local f = function() descendant.Parent = char end
		descendant.Changed:Connect(function(property)
			if property ~= 'Enabled' and property ~= 'Parent' then return end
			defer(pcall, f)
			descendant.Enabled = true
			local succ, err = pcall(f)
			if succ then return end
			local joint = inst_new(descendant.ClassName)
			joint.C0 = descendant.C0
			joint.C1 = descendant.C1
			joint.Part0 = descendant.Part0
			joint.Part1 = descendant.Part1
			joint:SetAttribute('4', _4)
			joint.Parent = char
		end)
	end

	ff:Clone().Parent = char
	your_char = char

	local h = char:WaitForChild('Humanoid')
	h.RequiresNeck = false
	h.MaxHealth = get_value()
	h.Health = get_value()
	h.BreakJointsOnDeath = false
	h:SetStateEnabled(dead, false)
	ff:Clone().Parent = h
	your_h = h

	char.DescendantAdded:Connect(descendant_added)
	local list = char:GetDescendants()
	for idx = 1, #list do descendant_added(list[idx]) end
	clear(list)
end

-- logic

ff.Archivable = false
ff.Name = 'FF'
ff.Visible = false
ff:SetAttribute('4', _4)

old_bj = hookfunction(inst_new('Model').BreakJoints, newcclosure(function(self, ...)
	if self == your_char then return end
	return old_bj(self, ...)
end))

old_gse = hookfunction(dummy_h.GetStateEnabled, newcclosure(function(self, arg_1, ...)
	if self == your_h and arg_1 == dead then return false end
	return old_gse(self, arg_1, ...)
end))

old_i = hookmetamethod(game, '__index', newcclosure(function(self, key, ...)
	if self == your_h then
		if key == 'RequiresNeck' then
			return false
		elseif key == 'MaxHealth' then
			return get_value()
		elseif key == 'Health' then
			return get_value()
		elseif key == 'Died' then
			return unused_event
		elseif key == 'BreakJointsOnDeath' then
			return false
		end
	end

	return old_i(self, key, ...)
end))

old_nm = hookmetamethod(game, '__namecall', newcclosure(function(self, arg_1, arg_2, ...)
	local method = getnamecallmethod()

	if self == your_char then
		if method == 'BreakJoints' or method == 'breakJoints' then
			return
		end
	elseif self == your_h then
		if method == 'ChangeState' and arg_1 == dead then
			return
		elseif method == 'GetStateEnabled' and arg_1 == dead then
			return false
		elseif method == 'SetStateEnabled' and arg_1 == dead and arg_2 == true then
			return old_nm(self, arg_1, false, ...)
		elseif method == 'TakeDamage' or method == 'takeDamage' then
			return
		end
	end

	return old_nm(self, arg_1, arg_2, ...)
end))

old_sse = hookfunction(dummy_h.SetStateEnabled, newcclosure(function(self, arg_1, arg_2, ...)
	if self == your_h and arg_1 == dead and arg_2 == true then return old_sse(self, arg_1, false, ...) end
	return old_sse(self, arg_1, arg_2, ...)
end))

old_td = hookfunction(dummy_h.TakeDamage, newcclosure(function(self, ...)
	if self == your_h then return end
	return old_td(self, ...)
end))

old_ts = hookfunction(dummy_h.ChangeState, newcclosure(function(self, arg_1, ...)
	if self == your_h and arg_1 == dead then return end
	return old_ts(self, arg_1, ...)
end))

you.CharacterAdded:Connect(char_added)
local char = you.Character
if char then resume(create(char_added), char) end
while you.Parent ~= nil do
	sleep()
	if your_char == nil then continue end
	if your_char:FindFirstChild('FF') == nil then ff:Clone().Parent = your_char end
	if your_h == nil then continue end
	if your_h:FindFirstChild('FF') == nil then ff:Clone().Parent = your_h end
	your_h.RequiresNeck = false
	your_h.MaxHealth = get_value()
	your_h.Health = get_value()
	your_h.BreakJointsOnDeath = false
	your_h:SetStateEnabled(dead, false)
end
