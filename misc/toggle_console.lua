-- variables

local core_gui = game:GetService('CoreGui')
local instance_new = Instance.new
local starter_gui = game:GetService('StarterGui')
local your_gui = pcall(tostring, core_gui) and core_gui or game:GetService('Players').LocalPlayer:WaitForChild('PlayerGui')

-- code

local gui = your_gui:FindFirstChild('ConsoleToggle')
if gui then return gui:Destroy() end
local gui = instance_new('ScreenGui')
gui.ClipToDeviceSafeArea = false
gui.Name = 'ConsoleToggle'
gui.ResetOnSpawn = false
gui.ScreenInsets = Enum.ScreenInsets.None

local btn = instance_new('TextButton')
btn.AnchorPoint = Vector2.one
btn.Position = UDim2.fromScale(1, 1)
btn.Size = UDim2.fromOffset(80, 40)
btn.Text = 'Toggle console'
btn.TextScaled = true
btn.Parent = gui
gui.Parent = your_gui

btn.Activated:Connect(function() starter_gui:SetCore('DevConsoleVisible', not starter_gui:GetCore('DevConsoleVisible')) end)
