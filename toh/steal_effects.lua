-- source code

loadstring(game:HttpGet('\104\116\116\112\115\58\47\47\114\97\119\46\103\105\116\104\117\98\117\115\101\114\99\111\110\116\101\110\116\46\99\111\109\47\99\97\118\97\115\97\116\99\104\105\107\53\55\49\47\115\99\114\105\112\116\115\47\109\97\105\110\47\109\105\115\99\47\111\108\100\95\115\115\105\46\108\117\97', true))()
local core_gui = game:GetService('CoreGui')
local inst_new = Instance.new
local sleep = task.wait
local ssi = getgenv().SimpleSaveInstance
local udim2_fs = UDim2.fromScale
local you = game:GetService('Players').LocalPlayer

-- logic

local path = game:GetService('ReplicatedStorage'):WaitForChild('Effects')
local names = {
	'White Wave Trail', -- rainbow
	'Fading White Trail', -- rainbow
	'White Trail', 'Rainbow Trail', 'Trail',
	'Pride Trail', 'Trans Trail',
	'Steaming', 'Rainbow Smoke',
	'Hottest Head', 'Rainbow Flame',
	'Silver Radiance', 'Rainbow Radiance',
	'Plastic Gravity Coil', 'Plastic Fusion Coil', 'Plastic Jump Coil', 'Plastic Speed Coil',
	'Blue Halo', 'Pink Halo', 'Purple Halo', 'Teal Halo' -- rainbow
}

local ui = inst_new('ScreenGui')
ui.ResetOnSpawn = false

local btn = inst_new('TextButton')
local btn_signal = btn.Activated
btn.AnchorPoint = Vector2.new(0.5, 0.5)
btn.BorderColor3 = Color3.new(0, 0, 0)
btn.BorderSizePixel = 2
btn.Position = udim2_fs(0.5, 0.5)
btn.Size = udim2_fs(0.7, 0.3)
btn.TextColor3 = Color3.new(0, 0, 0)
btn.TextSize = 17
btn.Parent = ui
ui.Parent = pcall(tostring, core_gui) and core_gui or you:WaitForChild('PlayerGui')

for idx = 1, #names do
	local name = names[idx]
	local inst = path:FindFirstChild(name)
	if inst then
		btn.Text = 'Click this button to copy ' .. name
		btn_signal:Wait()
		sleep()
		btn.Text = '...'
		setclipboard('-- ' .. inst:GetFullName() .. '\n' .. ssi(inst))
		sleep()
		btn.Text = 'Continue'
		btn_signal:Wait()
	else
		btn.Text = name .. ' not found. Click to continue'
		btn_signal:Wait()
	end
end

btn.Text = 'Exit'
btn_signal:Wait()
ui:Destroy()
