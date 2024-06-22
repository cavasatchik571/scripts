-- source code

local sleep = task.wait
local vec2_zero = Vector2.zero
local vu = game:GetService('VirtualUser')
local vu_b1d = vu.Button1Down
local vu_b1u = vu.Button1Up

-- logic

game:GetService('Players').LocalPlayer.Idled:Connect(function()
	pcall(vu_b1d, vu, vec2_zero)
	sleep()
	pcall(vu_b1u, vu, vec2_zero)
end)
