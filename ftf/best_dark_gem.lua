local items = game.ReplicatedStorage.ItemDatabase:GetChildren()
local database = require(game.ReplicatedStorage.ShopCrates)
local math_max = math.max
local string_match = string.match
local table_remove = table.remove

local function exclude(list, pattern)
	if not list or not pattern then
		return
	end
	
	local end_idx = #list
	local start_idx = 1
	local succ = true
	
	while true do
		succ = true
		
		for idx = start_idx, end_idx do
			local val = list[idx]
			
			if string_match(val.Name, pattern) ~= nil then
				table_remove(list, idx)
				end_idx, start_idx, succ = #list, idx, false
				
				break
			end
		end
		
		if succ then
			break
		end
	end
end

print()

local function get_color_brightness(c3)
	return math_max(c3.R, c3.G, c3.B)
end

local function get_color_value(c3)
	return math.sqrt((c3.R * 255) ^ 2 + (c3.G * 255) ^ 2 + (c3.B * 255) ^ 2)
end

local function get_value_light(a)
	return a.Brightness * get_color_value(a.Color) * get_color_brightness(a.Color) * a.Range * (a.Shadows and 0.1 or 1) * (a.Enabled and 1 or 0)
end

local function sort_function(a, b)
	local a_light = a.Model.Handle:FindFirstChild('PointLight')
	local b_light = b.Model.Handle:FindFirstChild('PointLight')
	
	return get_value_light(a_light) < get_value_light(b_light)
end

exclude(items, 'H%w+')
table.sort(items, sort_function)

for idx = 1, 5 do
	print(items[idx])
end
