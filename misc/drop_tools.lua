-- source code

local l = game:GetService('Players').LocalPlayer
local t = l.Character
local p = t:FindFirstChild('Torso') or t:FindFirstChild('UpperTorso') or t:FindFirstChild('HumanoidRootPart')
assert(p ~= nil)
local c = table.clear
local cf = p.CFrame * CFrame.new(0, 0, -3)
local s = task.wait

-- logic

local d0 = workspace.Tools:GetDescendants()
local l0 = 0
local p0 = {}

for i = 1, #d0 do
	local d = d0[i]
	if not d:IsA('BasePart') then continue end
	firetouchinterest(d, p, 0)
	l0 += 1
	p0[l0] = d
end

c(d0)
s()
for i = 1, l0 do firetouchinterest(p0[i], p, 1) end
c(p0)

local d1 = l.Backpack:GetChildren()
local d2 = t:GetChildren()
local l1 = 0
local t1 = {}
local function w(d)
	if not d:IsA('Tool') then return end
	local p1 = d:GetDescendants()

	for j = 1, #p1 do
		local e = p1[j]
		if not e:IsA('BasePart') then continue end
		e.CanCollide = true
	end

	c(p1)
	--d:PivotTo(cf)
	d.Parent = t
	l1 += 1
	t1[l1] = d
end

for i = 1, #d1 do w(d1[i]) end
for i = 1, #d2 do w(d2[i]) end
c(d1)
c(d2)
s(0.004)
for i = 1, l1 do t1[i].Parent = workspace end
c(t1)
