-- tfh4.lua
-- by @Vov4ik4124

local _4 = Color3.fromRGB(0, 64, 0)

-- source code

local env = (getgenv or function() end)() or _ENV or shared or _G
local new_enabled = not env.tfh4 and true or nil
env.tfh4 = new_enabled
if not new_enabled then return end
local active = false
local clear = table.clear
local color3_new = Color3.new
local core_gui = game:GetService('CoreGui')
local inst_new = Instance.new
local interval = 0.0144
local properties = {}
local udim2_from_scale = UDim2.fromScale
local ui = inst_new('ScreenGui')
local ui_black = color3_new(0, 0, 0)
local starter_gui = game:GetService('StarterGui')
local task_defer = task.defer
local task_wait = task.wait
local toggle_btn = inst_new('TextButton')
local vim = game:GetService('VirtualInputManager')
local vim_ske = vim.SendKeyEvent
local vim_smbe = vim.SendMouseButtonEvent
local vim_smme = vim.SendMouseMoveEvent
local vim_smwe = vim.SendMouseWheelEvent

local function key_press(x)
	return pcall(vim_ske, vim, true, x or 0, true, nil) and true or false
end

local function key_release(x)
	return pcall(vim_ske, vim, false, x or 0, false, nil) and true or false
end

local function mouse_press(x, y, z)
	return pcall(vim_smbe, vim, x or 0, y or 0, z or 0, true, nil, 0) and true or false
end

local function mouse_release(x, y, z)
	return pcall(vim_smbe, vim, x or 0, y or 0, z or 0, false, nil, 0) and true or false
end

local function send(...)
	clear(properties)
	local args = {...}
	for idx = 1, #args, 2 do properties[args[idx]] = args[idx + 1] end
	clear(args)
	starter_gui:SetCore('SendNotification', properties)
end

local function toggle()
	active = not active
	toggle_btn.BorderColor3 = active and _4 or ui_black
	send('Button1', 'OK', 'Duration', 4, 'Icon', 'rbxassetid://7440784829', 'Text', active and 'Activated' or 'Deactivated', 'Title', '4')
end

-- logic

toggle_btn.AnchorPoint = Vector2.new(0.825, 1)
toggle_btn.Archivable = false
toggle_btn.AutoLocalize = false
toggle_btn.BackgroundColor3 = ui_black
toggle_btn.BackgroundTransparency = 0
toggle_btn.BorderColor3 = ui_black
toggle_btn.BorderMode = Enum.BorderMode.Inset
toggle_btn.BorderSizePixel = 4
toggle_btn.FontFace = Font.fromEnum(Enum.Font.Ubuntu)
toggle_btn.MaxVisibleGraphemes = 4
toggle_btn.Position = udim2_from_scale(0.825, 1)
toggle_btn.Size = udim2_from_scale(0.125, 0.075)
toggle_btn.Text = 'tfh4'
toggle_btn.TextColor3 = color3_new(1, 1, 1)
toggle_btn.TextScaled = true
toggle_btn.TextStrokeColor3 = _4
toggle_btn.TextStrokeTransparency = 0
toggle_btn.Parent = ui
toggle_btn.Activated:Connect(toggle)

ui.Archivable = false
ui.AutoLocalize = false
ui.ClipToDeviceSafeArea = false
ui.DisplayOrder = 4000
ui.ResetOnSpawn = false
ui.ScreenInsets = Enum.ScreenInsets.None
ui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ui.Parent = pcall(tostring, core_gui) and core_gui or game:GetService('Players').LocalPlayer:WaitForChild('PlayerGui')
send('Button1', 'OK', 'Duration', 4, 'Icon', 'rbxassetid://7440784829', 'Text', 'Loaded', 'Title', '4')

while toggle_btn.Parent do
	task_wait(0.01)
	if not active then continue end
	key_press(50)
	task_wait(0.004)
	mouse_press(0, 0, 0)
	key_press(32)
	task_wait(interval)
	key_release(50)
	mouse_release(0, 0, 0)
	task_wait(0.024)
	key_press(49)
	task_wait(interval)
	key_release(49)
	key_release(32)
	task_wait(0.8204)
end

ui:Destroy()
send('Button1', 'OK', 'Duration', 4, 'Icon', 'rbxassetid://7440784829', 'Text', 'Unloaded', 'Title', '4')
