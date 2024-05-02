local L = game.Lighting
local R = game:GetService('RunService')

while R.Heartbeat:Wait() do
	L.ClockTime = 14.5
	L.Brightness = 5
end
