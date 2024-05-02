_G['CaptureAllCoins'] = not _G['CaptureAllCoins'] and true or nil

if not _G['CaptureAllCoins'] then
	return print('Disabled capture all coins.')
end

local LocalPlayer = game:GetService('Players').LocalPlayer

print('Enabled capture all coins.')

while _G['CaptureAllCoins'] do
	task.wait(0.5)

	local Character = LocalPlayer.Character
	
	if Character then
		local HumanoidRootPart = Character:WaitForChild('HumanoidRootPart')
		local Descendants = workspace:GetDescendants()
		
		for Index = 1, #Descendants do
			local Descendant = Descendants[Index]
			
			if Descendant.Name == 'Coin_Server' and Descendant:FindFirstChildOfClass('TouchTransmitter') then
				firetouchinterest(HumanoidRootPart, Descendant, 1)
				firetouchinterest(HumanoidRootPart, Descendant, 0)
			end
		end
	end
end
