queueonteleport(`loadstring(game:HttpGet('https://raw.githubusercontent.com/cavasatchik571/scripts/main/rf/auto_rf2.lua', true))()`)

local lobbyPlace = 7991339063
local gamePlace = 13622981808
local plr = game:GetService('Players').LocalPlayer
local gui = plr:WaitForChild('PlayerGui')
local character
while not (character and character.Parent) do
	character = plr.Character
	task.wait(0.04)
end

local h = character:WaitForChild('Humanoid')

if game.PlaceId == lobbyPlace then
	local prevWalkSpeed = h.WalkSpeed
	h.WalkSpeed *= 1.1
	
	while true and task.wait(0.04) do
		h:MoveTo(workspace.mapint.matchmaking.ring_01.neon.Position)
	end
	
	h.WalkSpeed = prevWalkSpeed
	
	return
end

gui:WaitForChild('PermanentGUI'):WaitForChild('DeathFrame'):WaitForChild('ReturnToLobby')
plr:WaitForChild('Backpack')

while true do
	if gui.PermanentGUI.DeathFrame.Visible and
		gui.PermanentGUI.DeathFrame.ReturnToLobby.Visible and
		gui.PermanentGUI.DeathFrame.ReturnToLobby.Button.Visible and 
		gui.PermanentGUI.Enabled then
	
		return game:GetService('TeleportService'):Teleport(lobbyPlace, plr)
	end
	
	local rndCFrame = CFrame.new(math.random(), math.random(), math.random())
	local children = workspace:GetChildren()
	local succ
	
	for index = 1, #children do
		local value = children[index]
		
		if value.Name == 'LightBulb' or value.Name == 'GasCanister' or value.Name == 'CakeMix' then
			local t = value:FindFirstChild('TouchTrigger')
			
			if t then
				t.CFrame = character:GetPivot() * rndCFrame
				succ = true
			
				pcall(firetouchinterest, character.HumanoidRootPart, t, 0)
				pcall(firetouchinterest, character.HumanoidRootPart, t, 1)
			end
		elseif value.Name == 'OrangeRideCart' then
			if not h.Sit then
				local t = value:FindFirstChild('pivot')
				
				if t then
					game.ReplicatedStorage.modules.Coaster.Network.ProximitySeatRequest:FireServer(1, t.Position)
				end
			end
		end
	end
	
	local gbs = workspace:FindFirstChild('GroupBuildStructures')
	
	if gbs then
		local t = gbs:FindFirstChild('Trigger', true)
		
		if t then
			t.CFrame = character:GetPivot() * rndCFrame
			
			pcall(firetouchinterest, character.HumanoidRootPart, t, 0)
			pcall(firetouchinterest, character.HumanoidRootPart, t, 1)
		end
	end
	
	local ignore = workspace:FindFirstChild('ignore')
	
	if ignore then
		local children = ignore:GetChildren()
		
		for index = 1, #children do
			local value = children[index]
			
			if value.Name == 'Looky' then
				local c = value:FindFirstChild('collision')
				local rp = value:FindFirstChild('RootPart')
				
				if c and rp then
					c.CFrame = character:GetPivot() * rndCFrame
					rp.CFrame = character:GetPivot() * rndCFrame
					succ = true
				end
			end
		end
	end
	
	if h.Sit then
		local m = workspace:FindFirstChild('CoasterAnimationModels', true)
		
		if m then
			local orange = m:FindFirstChild('Orange')
			local blue = m:FindFirstChild('Blue')
			local bird = m:FindFirstChild('Bird')
			local cyan = m:FindFirstChild('Cyan_Animatable')
			local leanDir = 0
			
			if orange and (orange.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude <= 80 then
				leanDir = 1
			else
				if blue and (blue.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude <= 120 then
					leanDir = 1
				else
					if bird and (bird.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude <= 90 then
						leanDir = -1
					else
						if cyan and (cyan.Body.Position - character.HumanoidRootPart.Position).Magnitude <= 100 then
							leanDir = 1
						end
					end
				end
			end
			
			game.ReplicatedStorage.modules.Coaster.Network.UpdateLeanDirection:FireServer(leanDir)
			game.ReplicatedStorage.modules.Coaster.Network.UpdateLeanDirection:FireServer(leanDir)
		end
	else
		if succ and workspace.CurrentCamera and workspace.CurrentCamera.CameraType ~= Enum.CameraType.Scriptable then
			character:PivotTo(CFrame.new(53, 136, -8))
		else
			character:PivotTo(CFrame.new(1258, -168, 533.4))
		end
	end
	
	game.ReplicatedStorage.modules['GameHandler_cl']['VoteSkip_cl'].Network.VotedYes:FireServer()
	game.ReplicatedStorage.communication.boxes.cl.ControllerLoaded:FireServer()
	
	if (character.HumanoidRootPart.Position - Vector3.new(972, -182, 501)).Magnitude <= 70 then
		character:PivotTo(CFrame.new(1258, -168, 533.4))
		
		break
	end
	
	task.wait(0.04)
end

while env.Enabled do
	if gui.PermanentGUI.DeathFrame.Visible and
		gui.PermanentGUI.DeathFrame.ReturnToLobby.Visible and
		gui.PermanentGUI.DeathFrame.ReturnToLobby.Button.Visible and 
		gui.PermanentGUI.Enabled then
	
		return game:GetService('TeleportService'):Teleport(lobbyPlace, plr)
	end
	
	if (character.HumanoidRootPart.Position - Vector3.new(972, -182, 501)).Magnitude <= 70 then
		character:PivotTo(CFrame.new(1258, -168, 533.4))
	end
	
	task.wait(0.5)
end
