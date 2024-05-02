local Players = game:GetService('Players')
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character
local Knife = Character:FindFirstChild('Knife')

if not (Knife and Knife:IsA('Tool')) then
	return
end

local Handle = Knife:WaitForChild('Handle')
local IgnoreNames = {'varvaralar100'}
local List = Players:GetPlayers()

task.wait(1 / 30)

for Index = 1, #List do
	local Player = List[Index]
	
	if Player == LocalPlayer or table.find(IgnoreNames, Player.Name) then
		continue
	end
	
	local Character = Player.Character
	
	if Character then
		local HumanoidRootPart = Character:FindFirstChild('HumanoidRootPart')
		
		if HumanoidRootPart then
			firetouchinterest(Handle, HumanoidRootPart, 1)
			firetouchinterest(HumanoidRootPart, Handle, 1)
			
			task.wait(1 / 30)
			
			firetouchinterest(Handle, HumanoidRootPart, 0)
			firetouchinterest(HumanoidRootPart, Handle, 0)
		end
	end
end
