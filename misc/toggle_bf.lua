-- source code

local core_gui = game:GetService('CoreGui')
local plr_gui = game:GetService('Players').LocalPlayer:WaitForChild('PlayerGui')
local your_gui = if pcall(tostring, core_gui) then core_gui else plr_gui

-- logic

local gui = your_gui:FindFirstChild('BlackFrameGui')
if gui then return gui:Destroy() end
local inst_new = Instance.new
gui = inst_new('ScreenGui')
gui.ClipToDeviceSafeArea = false
gui.DisplayOrder = if your_gui == core_gui then -2147483648 else 2147483647
gui.Name = 'BlackFrameGui'
gui.ResetOnSpawn = false
gui.ScreenInsets = Enum.ScreenInsets.None

local frame = inst_new('Frame')
frame.AnchorPoint = Vector2.one / 2
frame.BackgroundColor3 = Color3.new(0, 0, 0)
frame.Size = UDim2.fromScale(1000, 1000)
frame.Parent = gui
gui.Parent = your_gui
