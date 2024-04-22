--// auto_pls_donate.lua
--// by unknown

local _4 = Color3.new(0, 0.2514, 0)

-- check

local place_id = 8737602449
if game.PlaceId ~= place_id then return end

-- variables

local booth_interactions = workspace:WaitForChild('BoothInteractions')
local channel = game:GetService('TextChatService'):WaitForChild('TextChannels'):WaitForChild('RBXGeneral')
local heartbeat = game:GetService('RunService').Heartbeat
local http_service = game:GetService('HttpService')
local math_abs = math.abs
local plrs = game:GetService('Players')
local rng = Random.new()
local server_api = 'https://games.roblox.com/v1/games/' .. tostring(place_id) .. '/servers/0?sortOrder=2&excludeFullGames=true&limit=100'
local table_clear = table.clear
local table_find = table.find
local task_wait = task.wait
local teleport_service = game:GetService('TeleportService')
local teleport_service_teleport = teleport_service.Teleport
local teleport_service_teleport_to_place_instance = teleport_service.TeleportToPlaceInstance
local user_names = {4749189650, 4749190407, 4749194055, 4749195466, 4758373552, 5019066514}
local vec3_new = Vector3.new
local virtual_user = game:GetService('VirtualUser')
local you = plrs.LocalPlayer
local your_char = you.Character
local your_gui = you:WaitForChild('PlayerGui')
local zero_vec2 = Vector2.zero

local max_plrs = plrs.MaxPlayers - 4
local point = vec3_new(166, 5, 305)
local random_messages_len = 40
local random_messages = {
	'Please donate, thank you for understanding.',
	'Please donate guys, I\'ll appreciate your efforts.',
	'Please donate, we\'ll appreciate your efforts :)',
	'Can you donate please?',
	'Can you donate? Thanks.',
	'Can you donate? Many thanks.',
	'Bring me closer to my dream item :)',
	'Please, donate me, thanks :)',
	'I\'m waiting for your donation.',
	'Even small amount of robux is very useful :)',
	'* waits for donation :) *',
	'* please donate :) *',
	'Please donate to support our cause.',
	'Help us with a donation if you can.',
	'Your donation matters. Thank you!',
	'Support us with a donation today.',
	'Make a difference - donate now!',
	'Пожалуйста, поддержите нас пожертвованием.',
	'Помогите нам пожертвованием, если можете.',
	'Ваше пожертвование важно. Спасибо!',
	'Поддержите нас пожертвованием уже сегодня.',
	'Сделайте вклад - пожертвуйте сейчас!',
	'Please, provide support :)',
	'Разделите радость с нами и сделайте пожертвование.',
	'Ваше щедрое пожертвование поможет нам достичь цели.',
	'Поддержите наше дело и сделайте пожертвование сегодня.',
	'Feel free to donate any amount, your support is valuable :)',
	'Please donate, anything helps us!',
	'Don\'t ignore our messages, thank you.',
	':(',
	'* shivers in the cold *',
	'I\'m waiting for you!',
	'Come here, please :((',
	'Any amount is appreciated!',
	'Don\'t be toxic.',
	':<',
	'Are there any generous donators online?',
	'Thank you so much :D',
	'I understand, this is hard, but don\'t worry, please. :(',
	'Ahh, if there would be nice players around me...'
}

-- functions

local function check_restricted_user()
	local list = plrs:GetPlayers()

	for idx = 1, #list do
		if not table_find(user_names, list[idx].UserId) then continue end
		table_clear(list)
		return true
	end

	table_clear(list)
	return false
end

local function get_available_claim_trigger()
	local children = booth_interactions:GetChildren()

	for idx = 1, #children do
		local booth_interaction = children[idx]
		local pos = booth_interaction.Position
		if math_abs(pos.Y - 4.97) > 0.004 or (point - pos).Magnitude > 90 then continue end
		local claim_trigger = booth_interaction:FindFirstChild('Claim')
		if not claim_trigger.Enabled then continue end
		return claim_trigger
	end

	return nil
end

local function get_servers(desired_plr_count, cursor)
	local data = http_service:JSONDecode(game:HttpGet(server_api .. (cursor and '&cursor=' .. cursor or ''), true))
	local cursor = data.nextPageCursor or ''
	local list = data.data
	local result = {}
	local result_len = 0
	
	if list then

		for idx = 1, #list do
			local element = list[idx]

			if element.playing <= desired_plr_count then
				result_len += 1
				result[result_len] = element.id
			end
		end

		if result_len <= 0 then
			local other_services, len = get_servers(desired_plr_count, cursor)
			
			for idx = 1, len do
				result_len += 1
				result[result_len] = other_services[idx]
			end
		end
	end

	return result, result_len
end

local function get_your_booth_interaction()
	local your_booth = your_gui:FindFirstChild('YourBooth')

	if your_booth then
		local booth_interaction = your_booth.Adornee

		if booth_interaction then
			return booth_interaction
		end
	end

	return nil
end

local function teleport()
	local servers, len = get_servers(max_plrs)

	while true do
		task_wait(1)

		if len > 0 then
			pcall(teleport_service_teleport_to_place_instance, teleport_service, 8737602449, servers[rng:NextInteger(1, len)], you)
		else
			pcall(teleport_service_teleport, teleport_service, 8737602449, servers[rng:NextInteger(1, len)], you)
		end
	end
end

-- code

local booth_interaction = get_your_booth_interaction()
table.remove(user_names, table_find(user_names, you.UserId))
you.ChildRemoved:Connect(function(child)
	if not child:IsA('PlayerScripts') then return end
	task_wait(0.5)
	queue_on_teleport('loadstring(game:HttpGet(\'https://pastebin.com/raw/EUdKD3hp\', true))()')
	teleport()
end)

you.Idled:Connect(function()
	local cf = (workspace.CurrentCamera or workspace.Terrain).CFrame
	virtual_user:Button2Down(zero_vec2, cf)
	task_wait(1)
	virtual_user:Button2Up(zero_vec2, cf)
end)

while not booth_interaction do
	local claim_trigger = get_available_claim_trigger()

	if check_restricted_user() or not claim_trigger then
		teleport()
	end

	if claim_trigger then
		your_char:PivotTo(claim_trigger.Parent:GetPivot())
		claim_trigger:InputHoldBegin()
	end

	booth_interaction = get_your_booth_interaction()
	heartbeat:Wait()
end

your_char:PivotTo(
	booth_interaction.CFrame * CFrame.fromEulerAnglesYXZ(
		0,
		math.pi,
		0
	) + vec3_new(0, 10, 0)
)

task_wait(1)
local idx = rng:NextInteger(1, 3)
plrs:Chat('/e dance' .. (idx == 1 and '' or tostring(idx)))
task_wait(0.5)

while true do
	local t = 30

	while t > 0 do
		t -= heartbeat:Wait()
		if not check_restricted_user() then continue end
		teleport()
	end

	channel:SendAsync(random_messages[rng:NextInteger(1, random_messages_len)])
end
