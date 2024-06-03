-- tfh4.lua
-- by @Vov4ik

local _4 = Color3.new(0, .4984, 0)

-- source code

local env = (getgenv or function(...) end)() or _ENV or shared or _G
local new_enabled = not env.tfh4 and true or nil
env.tfh4 = new_enabled
if not new_enabled then return end
local active = false
local cam = workspace.CurrentCamera
local clear = table.clear
local color3_from_rgb = Color3.fromRGB
local colors_black = color3_from_rgb(0, 0, 0)
local colors_white = color3_from_rgb(255, 255, 255)
local core_gui = game:GetService('CoreGui')
local floor = math.floor
local inst_new = Instance.new
local sleep = task.wait
local sg = game:GetService('StarterGui')
local sg_sc = sg.SetCore
local sg_scp = {}
local space = Enum.KeyCode.Space
local stroke = inst_new('UIStroke')
local udim2_from_scale = UDim2.fromScale
local ui = inst_new('ScreenGui')
local ui_btn = inst_new('TextButton')
local vim = game:GetService('VirtualInputManager')
local you = game:GetService('Players').LocalPlayer
local function notify(btn, dur, img, text, title)
	sg_scp.Button1 = btn
	sg_scp.Duration = dur
	sg_scp.Icon = img
	sg_scp.Text = text
	sg_scp.Title = title
	pcall(sg_sc, sg, 'SendNotification', sg_scp)
	clear(sg_scp)
end

-- logic

stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.Color = colors_black
stroke.Enabled = true
stroke.LineJoinMode = Enum.LineJoinMode.Round
stroke.Name = 'Stroke'
stroke.Thickness = 4
stroke.Parent = ui_btn

ui.Archivable = false
ui.AutoLocalize = false
ui.ClipToDeviceSafeArea = false
ui.DisplayOrder = 4000
ui.Name = 'tfh4_gui'
ui.ResetOnSpawn = false
ui.ScreenInsets = Enum.ScreenInsets.None
ui:SetAttribute('4', _4)

ui_btn.Active = true
ui_btn.AnchorPoint = Vector2.new(0.5, 0.5)
ui_btn.Archivable = false
ui_btn.AutoButtonColor = false
ui_btn.AutoLocalize = false
ui_btn.BackgroundColor3 = colors_black
ui_btn.BackgroundTransparency = 0.5
ui_btn.BorderColor3 = _4
ui_btn.BorderMode = Enum.BorderMode.Outline
ui_btn.BorderSizePixel = 0
ui_btn.FontFace = Font.new('rbxasset://fonts/families/Ubuntu.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
ui_btn.Interactable = true
ui_btn.MaxVisibleGraphemes = 1
ui_btn.Name = 'Button'
ui_btn.Position = udim2_from_scale(0.7, 0.725)
ui_btn.Size = udim2_from_scale(0.144, 0.144)
ui_btn.SizeConstraint = Enum.SizeConstraint.RelativeYY
ui_btn.Text = '4'
ui_btn.TextColor3 = colors_white
ui_btn.TextScaled = true
ui_btn.TextStrokeColor3 = _4
ui_btn.TextStrokeTransparency = 0
ui_btn.Visible = true
ui_btn.ZIndex = 4000
ui_btn:SetAttribute('4', _4)
ui_btn.Parent = ui
ui_btn.MouseButton1Down:Connect(function()
	if env.tfh4 == nil then return end
	active = not active
	--notify('OK', 4, 'rbxassetid://7440784829', 'Flying is o' .. (active and 'n.' or 'ff.'), 'TFH4')
end)

ui.Parent = pcall(tostring, core_gui) and core_gui or you:WaitForChild('PlayerGui')
notify('OK', 4, 'rbxassetid://7440784829', 'Script activated', 'TFH4')

while env.tfh4 do
	if not active then sleep(0.04) continue end
	local bp = you:FindFirstChildOfClass('Backpack')
	if bp == nil then sleep(0.04) continue end
	local char = you.Character
	if char == nil then sleep(0.04) continue end
	local h = char:FindFirstChildOfClass('Humanoid')
	if h == nil or h.Health <= 0 or h.RootPart == nil then sleep(0.04) continue end
	local state = h:GetState().Value
	if state == 13 or state == 15 then sleep(0.04) continue end
	local fusion_coil = bp:FindFirstChild('fusion') or
		char:FindFirstChild('fusion') or
		bp:FindFirstChild('gravity') or
		char:FindFirstChild('gravity')

	if fusion_coil == nil then
		active = false
		notify('OK', 4, 'rbxassetid://7440784829', 'You need a gravity/fusion coil for this.', 'TFH4')
		continue
	end

	local grappling_hook = bp:FindFirstChild('hook') or char:FindFirstChild('hook')
	if grappling_hook == nil then
		active = false
		notify('OK', 4, 'rbxassetid://7440784829', 'You need a grappling hook for this.', 'TFH4')
		continue
	end

	local ss = cam.ViewportSize
	local px = floor(ss.X * 0.554)
	local py = floor(ss.Y * 0.504)
	h:UnequipTools()
	grappling_hook.Parent = char
	sleep()
	vim:SendMouseButtonEvent(px, py, 0, true, nil, 0)
	sleep()
	vim:SendMouseButtonEvent(px, py, 0, false, nil, 0)
	vim:SendKeyEvent(true, space, false, nil)
	sleep()
	vim:SendKeyEvent(false, space, false, nil)
	sleep()
	h:UnequipTools()
	fusion_coil.Parent = char
	sleep(0.76684)
end

ui:Destroy()
notify('OK', 4, 'rbxassetid://7440784829', 'Script deactivated', 'TFH4')
