-- Fly script (no BodyMover instances)
-- by * unknown *

local env = (getgenv and getgenv()) or shared or _ENV or _G
local new_fly = not env.fly and true or nil
env.fly = new_fly

if not new_fly then return end

-- variables

local cf_new = CFrame.new
local cf_yxz = CFrame.fromEulerAnglesYXZ
local core_gui = game:GetService('CoreGui')
local fly = false
local instance_new = Instance.new
local math_abs = math.abs
local math_sqrt = math.sqrt
local plr = game:GetService('Players').LocalPlayer
local plr_gui = plr:WaitForChild('PlayerGui')
local rs = game:GetService('RunService')
local task_wait = task.wait
local uis = game:GetService('UserInputService')
local vec3_new = Vector3.new
local zero_vec3 = vec3_new(0, 0, 0)
local screen_gui = instance_new('ScreenGui')
screen_gui.ClipToDeviceSafeArea = false
screen_gui.DisplayOrder = 1000
screen_gui.ResetOnSpawn = false
screen_gui.ScreenInsets = Enum.ScreenInsets.None

local text_btn = instance_new('TextButton')
text_btn.AnchorPoint = Vector2.new(0.5, 1)
text_btn.BackgroundColor3 = Color3.new(1, 1, 1)
text_btn.Font = Enum.Font.SourceSansSemibold
text_btn.Position = UDim2.new(0.7, 4, 1, -4)
text_btn.Size = UDim2.fromScale(0.2, 0.075)
text_btn.SizeConstraint = Enum.SizeConstraint.RelativeYY
text_btn.Text = 'Fly: OFF'
text_btn.TextScaled = true
text_btn.ZIndex = 1000
text_btn.Parent = screen_gui
text_btn.Activated:Connect(function()
	fly = not fly
	text_btn.Text = fly and 'Fly: ON' or 'Fly: OFF'
end)

local ui_corner = instance_new('UICorner')
ui_corner.CornerRadius = UDim.new(1, 0)
ui_corner.Parent = text_btn
screen_gui.Parent = pcall(tostring, core_gui) and core_gui or plr_gui

local function alter_velocity()
	local camera = workspace.CurrentCamera
	local char = plr.Character
	if not camera or not char then return end
	local h = char:FindFirstChildOfClass('Humanoid')
	if not h then return end
	--h.PlatformStand = fly
	local hrp = char:FindFirstChild('HumanoidRootPart')
	if not fly or not hrp then return end
	local cf = camera.CFrame
	local direction = zero_vec3
	local rotation = cf.Rotation
	local touch_gui = plr_gui:FindFirstChild('TouchGui')

	if h.MoveDirection.Magnitude > 0 then
		if uis.KeyboardEnabled and (uis:IsKeyDown(119) or uis:IsKeyDown(97) or uis:IsKeyDown(115) or uis:IsKeyDown(100)) then
			direction = rotation * vec3_new(
				(uis:IsKeyDown(97) and -1 or 0) + (uis:IsKeyDown(100) and 1 or 0),
				0,
				(uis:IsKeyDown(119) and -1 or 0) + (uis:IsKeyDown(115) and 1 or 0)
			) * h.WalkSpeed * 2
		elseif uis.TouchEnabled and touch_gui then
			local element = touch_gui:FindFirstChild('TouchControlFrame')
			if element then
				local element = element:FindFirstChild('DynamicThumbstickFrame')
				if element then
					local a = element:FindFirstChild('ThumbstickStart')
					local b = element:FindFirstChild('ThumbstickEnd')
					if a and b then
						local unit = (b.AbsolutePosition - a.AbsolutePosition).Unit
						local x = unit.X
						local y = unit.Y
						direction = rotation * vec3_new(
							x == x and x or 0,
							0,
							y == y and y or 0
						) * h.WalkSpeed * 2
					end
				end
			end
		end
	end

	local descendants = char:GetDescendants()
	local y, x, z = rotation:ToEulerAnglesYXZ()
	local new_rot = cf_yxz(y * 0.01, x, z * 0.01) -- 0.8; 1; 1

	for idx = 1, #descendants do
		local descendant = descendants[idx]

		if descendant:IsA('BasePart') then
			descendant.AssemblyAngularVelocity = zero_vec3
			descendant.AssemblyLinearVelocity = zero_vec3
			descendant.RotVelocity = zero_vec3
			descendant.Velocity = zero_vec3
		end
	end

	hrp.AssemblyAngularVelocity = zero_vec3
	hrp.Velocity = zero_vec3
	hrp.CFrame = cf_new(hrp.Position) * new_rot
	hrp.RotVelocity = zero_vec3
	hrp.AssemblyLinearVelocity = direction + vec3_new(0, math_abs(workspace.Gravity) / 100, 0)
end

rs.Heartbeat:Connect(alter_velocity)
rs.RenderStepped:Connect(alter_velocity)
rs.Stepped:Connect(alter_velocity)

while true do
	alter_velocity()
	task_wait()
	alter_velocity()
end
