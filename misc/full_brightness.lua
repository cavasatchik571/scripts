-- source code

local colors_white = Color3.new(1, 1, 1)
local lighting = game:GetService('Lighting')
local task_wait = task.wait

-- logic

while true do
	lighting.Ambient = colors_white
	lighting.Brightness = 2
	lighting.ClockTime = 14
	lighting.ColorShift_Bottom = colors_white
	lighting.ColorShift_Top = colors_white
	lighting.EnvironmentDiffuseScale = 0.5
	lighting.EnvironmentSpecularScale = 0.5
	lighting.ExposureCompensation = 0
	lighting.FogEnd = 9e9
	lighting.FogStart = 9e9
	lighting.GeographicLatitude = 41.733
	lighting.GlobalShadows = false
	lighting.OutdoorAmbient = colors_white
	task_wait()
end
