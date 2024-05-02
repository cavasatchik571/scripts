local ReplicatedStorage = game:GetService('ReplicatedStorage')
local StarterGui = game:GetService('StarterGui')

if not _G['FTF_NEVER_FAIL'] then
	_G['FTF_NEVER_FAIL'] = true
	
	StarterGui:SetCore('SendNotification', {
		Title = 'Script by Vov4ik4124';
		Text = 'Execute Script again to Deactivate.';
		Duration = 2;
		Button1 = 'OK';
	})
else
	_G['FTF_NEVER_FAIL'] = nil
	
	StarterGui:SetCore('SendNotification', {
		Title = 'Script by Vov4ik4124';
		Text = 'Execute Script again to Activate.';
		Duration = 2;
		Button1 = 'OK';
	})
	
	return
end

local FTF_RM = nil

while _G['FTF_NEVER_FAIL'] do
	if ReplicatedStorage then
		if not FTF_RM then
			FTF_RM = ReplicatedStorage:FindFirstChild('RemoteEvent')
		end
		
		if FTF_RM then
			FTF_RM:FireServer('SetPlayerMinigameResult', true)
		end
	end
	
	task.wait(0.25)
end

FTF_RM = nil
