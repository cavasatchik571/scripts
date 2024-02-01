if game.PlaceId ~= 6839171747 then return end
local env = (getgenv or function() end)() or _ENV or shared or _G or {}
local new_auto_loot = not env.auto_loot and true or nil
env.auto_loot = new_auto_loot
if not new_auto_loot then return end
local current_camera = workspace.CurrentCamera
local current_rooms = workspace:WaitForChild('CurrentRooms')
local render_stepped = game:GetService('RunService').RenderStepped

while env.auto_loot do
	local descendants = current_rooms:GetDescendants()
	
	for idx = 1, #descendants do
		local descendant = descendants[idx]
		if descendant.Name ~= 'LootPrompt' or not descendant:IsA('ProximityPrompt') or
			(current_camera.CFrame.Position - descendant.Parent:GetPivot().Position).Magnitude > 32 then continue end
		
		fireproximityprompt(descendant)
	end
	
	render_stepped:Wait()
end
