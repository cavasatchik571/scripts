-- eds4.lua4
-- by @Vov4ik4124

local _4 = Color3.new(0, .4984, 0)

-- source code

if _G.library_solver then return end
_G.libary_solver = true
local border = Enum.ApplyStrokeMode.Border
local color3_from_rgb = Color3.fromRGB
local coroutine_create = coroutine.create
local coroutine_resume = coroutine.resume
local inst_new = Instance.new
local re = game:GetService('ReplicatedStorage')
local rel_yy = Enum.SizeConstraint.RelativeYY
local round = Enum.LineJoinMode.Round
local table_clear = table.clear
local table_concat = table.concat
local udim2_from_scale = UDim2.fromScale

local black = color3_from_rgb(0, 0, 0)
local latest_room = re:WaitForChild('GameData'):WaitForChild('LatestRoom')
local ubuntu = Font.new('rbxasset://fonts/families/Ubuntu.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
local white = color3_from_rgb(255, 255, 255)
local you = game:GetService('Players').LocalPlayer

local function get_library_code()
	local bp = you.Backpack or game
	local char = you.Character or game
	local he = you.PlayerGui.PermUI:FindFirstChild('Hints')
	local paper = (bp:FindFirstChild('LibraryHintPaper') or bp:FindFirstChild('LibraryHintPaperHard') or
		char:FindFirstChild('LibraryHintPaper') or char:FindFirstChild('LibraryHintPaperHard'))

	if not he or not paper then return '' end
	local code = {}
	local hints = he:GetChildren()
	local map = {}
	local ui = paper.UI:GetChildren()
	for idx = 1, #hints do
		local icon = hints[idx]
		if icon.Name ~= 'Icon' then continue end
		map[icon.ImageRectOffset.X] = icon.TextLabel.Text
	end

	for idx = 1, #ui do
		local child = ui[idx]
		local id = tonumber(child.Name)
		if not id then continue end
		local number = map[child.ImageRectOffset.X]
		if not number then continue end
		code[id] = number
	end

	local result = table_concat(code)
	table_clear(code)
	table_clear(hints)
	table_clear(map)
	table_clear(ui)
	return result
end

local function solve_ebf(real) real.EBF:FireServer() end
local function solve_pl(real, prompt) real.PL:FireServer(typeof(prompt) == 'string' and tonumber(prompt) and prompt or '00000') end
local function descendant_added_you(descendant)
	if typeof(descendant) ~= 'Instance' or descendant.Name ~= 'MinigameBackout' or descendant:FindFirstChild('Interact') then return end
	local interact_btn = inst_new('TextButton')
	interact_btn.AutoButtonColor = false
	interact_btn.AutoLocalize = false
	interact_btn.BackgroundColor3 = black
	interact_btn.BackgroundTransparency = 0.5
	interact_btn.BorderColor3 = _4
	interact_btn.BorderMode = Enum.BorderMode.Outline
	interact_btn.BorderSizePixel = 0
	interact_btn.FontFace = ubuntu
	interact_btn.MaxVisibleGraphemes = 1
	interact_btn.Name = 'Interact'
	interact_btn.Position = udim2_from_scale(0, -1.05)
	interact_btn.Size = udim2_from_scale(0.64, 0.64)
	interact_btn.SizeConstraint = rel_yy
	interact_btn.Text = '4'
	interact_btn.TextColor3 = white
	interact_btn.TextScaled = true
	interact_btn.TextStrokeColor3 = _4
	interact_btn.TextStrokeTransparency = 0

	local stroke = inst_new('UIStroke')
	stroke.ApplyStrokeMode = border
	stroke.Color = black
	stroke.Enabled = true
	stroke.LineJoinMode = round
	stroke.Name = 'Stroke'
	stroke.Thickness = 4
	stroke.Parent = interact_btn
	interact_btn.Parent = descendant
	interact_btn.Activated:Connect(function()
		local real = re:FindFirstChild('RemotesFolder') or re:FindFirstChild('EntityInfo')
		if not real then return end
		local room = latest_room.Value
		if room == 50 then
			solve_pl(real, get_library_code())
		elseif room == 100 then
			solve_ebf(real)
		end
	end)
end

-- logic

you.DescendantAdded:Connect(descendant_added_you)
local descendants = you:GetDescendants()
for idx = 1, #descendants do coroutine_resume(coroutine_create(descendant_added_you), descendants[idx]) end
table_clear(descendants)
