-- source code

local lighting = game:GetService('Lighting')
local task_wait = task.wait

-- logic

while true do
	lighting.ClockTime = 14.5
	lighting.Brightness = 5
	task_wait()
end
