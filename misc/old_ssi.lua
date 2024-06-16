-- variables

local cf_identity = CFrame.identity
local env = (getgenv or function() end)() or _ENV or shared or _G
local game_get_service = game.GetService
local hs = game:GetService('HttpService')
local hs_provider = pcall(tostring, game:GetService('CoreGui')) and game or hs
local http_get_async = hs_provider == game and game.HttpGet or hs.GetAsync
local instance_new = Instance.new
local math_min = math.min
local math_round = math.round
local string_find = string.find
local string_format = string.format
local string_gsub = string.gsub
local string_match = string.match
local table_clear = table.clear
local table_concat = table.concat
local table_find = table.find
local table_sort = table.sort
local terrain = workspace.Terrain

local copy = function(a, b, c) b[c] = a[c] return nil end
local get = function(a, b) return a[b] end
local set = function(a, b, c) a[b] = c return nil end

local instances = {}
local instances_len = 0
local temp_instances = {}
local downloaded_properties = env.Properties or {}
env.Properties = downloaded_properties

-- functions

local function download_properties_async(class)
	if type(class) ~= 'string' or #class <= 0 or class == '' or downloaded_properties[class] then return end
	local succ, result = pcall(
		http_get_async, hs_provider,
		'https://create.roblox.com/docs/_next/data/OzlUBb-03fHNBySF-LMVY/reference/engine/classes/' .. class .. '.json', true
	)

	if succ then
		local entry = downloaded_properties[class] or {}
		local len = #entry
		downloaded_properties[class] = entry

		local api = hs:JSONDecode(result).pageProps.data.apiReference
		local inherits = api.inherits
		for idx = 1, #inherits do downloaded_properties(inherits[idx]) end
		local list = api.properties
		for idx = 1, #list do
			len += 1
			entry[len] = string_match(list[idx].name or '', '%a+%.(.*)', 1) or ''
		end

		table_sort(entry)
	end
end

local function is_property_read_only(obj, k)
	local succ, err = pcall(copy, obj, obj, k)
	return not succ and string_find(tostring(err), 'read only', 1, true) ~= nil
end

local function stringify(e: any)
	local accurate_type = typeof(e)
	local type_value = type(e)

	if type_value == 'boolean' then
		return e and 'true' or 'false'
	elseif type_value == 'number' then
		local stringified = string_gsub(string_format('%.6f', e), '%.?0*$', '')
		return stringified == '-0' and '0' or stringified
	elseif type_value == 'string' then
		return '\'' .. string_gsub(e, '\'', '\\\'') .. '\''
	elseif type_value == 'table' then
		local r = '{'

		for key, value in next, e do
			r ..= '[' .. stringify(key) .. '] = ' .. stringify(value)

			if next(e, key) then
				r ..= ', '
			end
		end

		return r .. '}'
	elseif type_value == 'vector' or accurate_type == 'Vector3' or accurate_type == 'Vector3int16' then
		local x, y, z = e.X, e.Y, e.Z

		if x == 0 and y == 0 and z == 0 then
			return 'Vector3.zero'
		else
			return 'Vector3.new(' .. stringify(x) .. ', ' .. stringify(y) .. ', ' .. stringify(z) .. ')'
		end
	elseif accurate_type == 'Axes' then
		local len = 0
		local n0, n1, n2, n3, n4, n5 = e.Right, e.Top, e.Back, e.Left, e.Bottom, e.Front
		local t = {}

		if n0 and n3 then len += 1 t[len] = 'Enum.Axis.X'
		elseif n0 or n3 then len += 1 t[len] = 'Enum.NormalId.' .. (n0 and 'Right' or n3 and 'Left') end
		if n1 and n4 then len += 1 t[len] = 'Enum.Axis.Y'
		elseif n1 or n4 then len += 1 t[len] = 'Enum.NormalId.' .. (n1 and 'Top' or n4 and 'Bottom') end
		if n2 and n5 then len += 1 t[len] = 'Enum.Axis.Z'
		elseif n2 or n5 then len += 1 t[len] = 'Enum.NormalId.' .. (n2 and 'Back' or n5 and 'Front') end

		return 'Axes.new(' .. table_concat(t, ', ') .. ')'
	elseif accurate_type == 'BrickColor' then
		return 'BrickColor.new(' .. e.Number .. ')'
	elseif accurate_type == 'CFrame' then
		if e == cf_identity then return 'CFrame.identity' end
		local x, y, z, r00, r01, r02, r10, r11, r12, r20, r21, r22 = e:GetComponents()

		if e.Rotation == cf_identity then
			return string_format('CFrame.new(%s, %s, %s)', stringify(x), stringify(y), stringify(z))
		else
			return string_format('CFrame.new(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)', stringify(x), stringify(y), stringify(z),
				stringify(r00), stringify(r01), stringify(r02), stringify(r10), stringify(r11), stringify(r12),
				stringify(r20), stringify(r21), stringify(r22))
		end
	elseif accurate_type == 'Color3' then
		local r, g, b = e.R, e.G, e.B
		local t = {
			'Color3.fromRGB(' .. math_round(r * 255) .. ', ' .. math_round(g * 255) .. ', ' .. math_round(b * 255) .. ')',
			'Color3.new(' .. stringify(r) .. ', ' .. stringify(g) .. ', ' .. stringify(b) .. ')'
		}

		table_sort(t)
		local r = t[1]
		table_clear(t)
		return r
	elseif accurate_type == 'ColorSequence' then
		local k = e.Keypoints

		if #k == 2 then
			local c0 = k[1].Value
			local c1 = k[2].Value

			if c0 == c1 then
				return 'ColorSequence.new(' .. stringify(c0) .. ')'
			else
				return 'ColorSequence.new(' .. stringify(c0) .. ', ' .. stringify(c1) .. ')'
			end
		else
			return 'ColorSequence.new(' .. stringify(k) .. ')'
		end
	elseif accurate_type == 'ColorSequenceKeypoint' then
		return 'ColorSequenceKeypoint.new(' .. stringify(e.Time) .. ', ' .. stringify(e.Value) .. ')'
	elseif accurate_type == 'Enums' then
		return 'Enum'
	elseif accurate_type == 'Enum' then
		return 'Enum.' .. tostring(e)
	elseif accurate_type == 'EnumItem' then
		return tostring(e)
	elseif accurate_type == 'Faces' then
		local len = 0
		local t = {}

		if e.Back then len += 1 t[len] = 'Enum.NormalId.Back' end
		if e.Bottom then len += 1 t[len] = 'Enum.NormalId.Bottom' end
		if e.Front then len += 1 t[len] = 'Enum.NormalId.Front' end
		if e.Left then len += 1 t[len] = 'Enum.NormalId.Left' end
		if e.Right then len += 1 t[len] = 'Enum.NormalId.Right' end
		if e.Top then len += 1 t[len] = 'Enum.NormalId.Top' end

		return 'Faces.new(' .. table_concat(t, ', ') .. ')'
	elseif accurate_type == 'Font' then
		return 'Font.new(' .. stringify(e.Family) .. ', ' .. stringify(e.Weight) .. ', ' .. stringify(e.Style) .. ')'
	elseif accurate_type == 'Instance' then
		if e == workspace then return 'workspace' end
		if e == terrain then return 'workspace.Terrain' end
		local class_name = e.ClassName
		if e.Parent == game and pcall(game_get_service, game, class_name) then return 'game:GetService(\'' .. class_name .. '\')' end

		for idx = 1, instances_len do
			if instances[idx].Linked == e then
				return 'v' .. idx
			end
		end

		return 'nil'
	elseif accurate_type == 'NumberRange' then
		local v0, v1 = e.Max, e.Min

		if v0 == v1 or math_round(v0 * 100000) == math_round(v1 * 100000) then
			return 'NumberRange.new(' .. stringify(v0) .. ')'
		else
			return 'NumberRange.new(' .. stringify(v1) .. ', ' .. stringify(v0) .. ')'
		end
	elseif accurate_type == 'NumberSequence' then
		local k = e.Keypoints

		if #k == 2 then
			local n0 = k[1].Value
			local n1 = k[2].Value

			if n0 == n1 then
				return 'NumberSequence.new(' .. stringify(n0) .. ')'
			else
				return 'NumberSequence.new(' .. stringify(n0) .. ', ' .. stringify(n1) .. ')'
			end
		else
			return 'NumberSequence.new(' .. stringify(k) .. ')'
		end
	elseif accurate_type == 'NumberSequenceKeypoint' then
		return 'NumberSequenceKeypoint.new(' .. stringify(e.Time) .. ', ' .. stringify(e.Value) .. ', ' .. stringify(e.Envelope) .. ')'
	elseif accurate_type == 'PhysicalProperties' then
		return 'PhysicalProperties.new(' .. stringify(e.Density) .. ', ' ..
			stringify(e.Friction) .. ', ' ..
			stringify(e.Elasticity) .. ', ' ..
			stringify(e.FrictionWeight) .. ', ' ..
			stringify(e.ElasticityWeight) .. ')'
	elseif accurate_type == 'Ray' then
		return 'Ray.new(' .. stringify(e.Origin) .. ', ' .. stringify(e.Direction) .. ')'
	elseif accurate_type == 'Rect' then
		local max, min = e.Max, e.Min

		if max.Magnitude == 0 and min.Magnitude == 0 then
			return 'Rect.new()'
		else
			return 'Rect.new(' .. stringify(min) .. ', ' .. stringify(max) .. ')'
		end
	elseif accurate_type == 'Region3' then
		local center, half_size = e.CFrame.Position, e.Size / 2
		return 'Region3.new(' .. stringify(center - half_size) .. ', ' .. stringify(center + half_size) .. ')'
	elseif accurate_type == 'Region3int16' then
		return 'Region3int16.new(' .. stringify(e.Min) .. ', ' .. stringify(e.Max) .. ')'
	elseif accurate_type == 'TweenInfo' then
		return 'TweenInfo.new(' .. stringify(e.Time) .. ', ' ..
			stringify(e.EasingStyle) .. ', ' ..
			stringify(e.EasingDirection) .. ', ' ..
			stringify(e.RepeatCount) .. ', ' ..
			stringify(e.Reverses) .. ', ' ..
			stringify(e.DelayTime) .. ')'
	elseif accurate_type == 'UDim' then
		return 'UDim.new(' .. stringify(e.Scale) .. ', ' .. stringify(e.Offset) .. ')'
	elseif accurate_type == 'UDim2' then
		local x, y = e.X, e.Y
		local ox, oy, sx, sy = x.Offset, y.Offset, x.Scale, y.Scale

		if ox == 0 and oy == 0 and sx == 0 and sy == 0 then
			return 'UDim2.new()'
		elseif ox == 0 and oy == 0 then
			return 'UDim2.fromScale(' .. stringify(sx) .. ', ' .. stringify(sy) .. ')'
		elseif sx == 0 and sy == 0 then
			return 'UDim2.fromOffset(' .. stringify(ox) .. ', ' .. stringify(oy) .. ')'
		end

		return 'UDim.new(' .. stringify(sx) .. ', ' .. stringify(ox) .. ', ' .. stringify(sy) .. ', ' .. stringify(oy) .. ')'
	elseif accurate_type == 'Vector2' or accurate_type == 'Vector2int16' then
		local x, y = e.X, e.Y

		if x == 0 and y == 0 then
			return 'Vector2.zero'
		else
			return 'Vector2.new(' .. stringify(x) .. ', ' .. stringify(y) .. ')'
		end
	end

	return 'nil'
end

local function write_properties(obj)
	local class_name = obj.ClassName
	local temp_instance = temp_instances[class_name]

	if not temp_instance then
		local succ, result = pcall(instance_new, class_name)

		if succ and result then
			temp_instance = result
			temp_instances[class_name] = result
		else
			return
		end
	end

	local children = obj:GetChildren()
	download_properties_async(class_name)

	for idx = 1, #children do
		write_properties(children[idx])
	end

	local len = 0
	local properties = {}
	local values = {}

	for super_class, instance_properties in next, downloaded_properties do
		if obj:IsA(super_class) then
			for idx = 1, #instance_properties do
				local property = instance_properties[idx]
				if is_property_read_only(temp_instance, property) then continue end
				local succ, result = pcall(get, obj, property)
				if not succ or (temp_instance and temp_instance[property] == result) then continue end
				len += 1
				properties[len] = property
				values[len] = result
			end
		end
	end

	instances_len += 1
	instances[instances_len] = {Linked = obj, Properties = properties, Values = values}
end

-- code

env.SimpleSaveInstance = function(obj)
	local source = '-- This script was generated by SimpleSaveInstance function.\n'

	if typeof(obj) == 'Instance' then
		write_properties(obj)

		for idx = 1, instances_len do
			source ..= '\nlocal v' .. idx .. ' = Instance.new(\'' .. instances[idx].Linked.ClassName .. '\')'
		end

		source ..= '\n'

		for idx = 1, instances_len do
			local instance = instances[idx]
			local linked = instances[idx].Linked
			local properties = instance.Properties
			local parent_idx = table_find(properties, 'Parent')
			local values = instance.Values
			local variable_name = '\nv' .. idx .. '.'

			for idx = 1, math_min(#properties, #values) do
				local property = properties[idx]
				if idx == parent_idx or (linked:IsA('BasePart') and property == 'BrickColor') then continue end
				source ..=  variable_name .. property .. ' = ' .. stringify(values[idx])
			end

			if parent_idx then
				source ..=  variable_name .. 'Parent = ' .. stringify(values[parent_idx])
			end

			source ..= '\n'
		end

		for idx = 1, instances_len do
			local instance = instances[idx]
			table_clear(instance.Properties)
			table_clear(instance.Values)
			table_clear(instance)
		end

		for _, temp_instance in next, temp_instances do
			temp_instance:Destroy()
		end

		table_clear(instances)
		table_clear(temp_instances)
		instances_len = 0
	end

	return source
end
