-- xrf4.lua
-- by @Vov4ik4124

local _4 = Color3.new(0, .4984, 0)

-- source code

local env = (getgenv or function(...) end)() or _ENV or shared or _G
local new_enabled = not env.xrf4 and true or nil
env.xrf4 = new_enabled
if not new_enabled then return end
local bha4 = Instance.new('BoxHandleAdornment')
local bha4_size = Vector3.new(1.4, 1.444, 1.4)
local clear = table.clear
local create = coroutine.create
local find = string.find
local highlights = {}
local resume = coroutine.resume
local sg = game:GetService('StarterGui')
local sg_sc = sg.SetCore
local sg_scp = {}
local sleep = task.wait
bha4.AdornCullingMode = Enum.AdornCullingMode.Never
bha4.AlwaysOnTop = true
bha4.Color3 = _4
bha4.Name = 'Highlight'
bha4.Size = bha4_size
bha4.Transparency = 0.4
bha4.Visible = true
bha4.ZIndex = 4
bha4:SetAttribute('4', _4)

local paths = {
	'^Workspace%.Battery%d*$',
	'^Workspace%.Block%d*$',
	'^Workspace%.CakeMix$',
	'^Workspace%.Food%a*$',
	'^Workspace%.Fuse%d*$',
	'^Workspace%.GasCanister$',
	'^Workspace%.LightBulb$',
	'^Workspace%.Monsters%.Bird$',
	'^Workspace%.Monsters%.Blue$',
	'^Workspace%.Monsters%.Cyan$',
	'^Workspace%.Monsters%.Green$',
	'^Workspace%.Monsters%.Orange$',
	'^Workspace%.Monsters%.Purple%.VisibleCharModel$',
	'^Workspace%.Purple_ArmIdle$',
	'^Workspace%.Ticket$',
	'^Workspace%.ignore%.Looky$'
}

local paths_len = #paths
local function compare_path(name)
	for idx = 1, paths_len do if find(name, paths[idx]) == 1 then return true end end
	return false
end

local function descendant_added(descendant)
	if not descendant:IsA('PVInstance') or highlights[descendant] ~= nil or not compare_path(descendant:GetFullName()) then return end
	local cloned = bha4:Clone()
	cloned.Adornee = descendant
	cloned.Size = bha4_size:Max((descendant:IsA('BasePart') and descendant.Size) or (descendant:IsA('Model') and select(2, descendant:GetBoundingBox())) or bha4_size)
	cloned.Parent = descendant
	highlights[descendant] = cloned
end

local function notify(btn, dur, img, text, title)
	sg_scp.Button1 = btn
	sg_scp.Duration = dur
	sg_scp.Icon = img
	sg_scp.Text = text
	sg_scp.Title = title
	pcall(sg_sc, sg, 'SendNotification', sg_scp)
	clear(sg_scp)
end

-- logic

local connections = {workspace.DescendantAdded:Connect(descendant_added), workspace.DescendantRemoving:Connect(function(descendant)
	local highlight = highlights[descendant]
	if highlight == nil then return end
	highlight:Destroy()
	highlights[descendant] = nil
end)}

local list = workspace:GetDescendants()
for idx = 1, #list do resume(create(descendant_added), list[idx]) end
clear(list)
notify('OK', 4, 'rbxassetid://7440784829', 'Script activated', 'XRF4')
while env.xrf4 do
	sleep()

	for adornee, highlight in next, highlights do
		highlight.Size = bha4_size:Max((adornee:IsA('BasePart') and adornee.Size) or (adornee:IsA('Model') and select(2, adornee:GetBoundingBox())) or bha4_size)
	end
end

for _, highlight in next, highlights do highlight:Destroy() end
for idx = 1, #connections do connections[idx]:Disconnect() end
clear(connections)
clear(highlights)
clear(paths)
notify('OK', 4, 'rbxassetid://7440784829', 'Script deactivated', 'XRF4')
