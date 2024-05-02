local target = 'PUT SOMEONE NAME HERE'
local a = getgenv()
local b = task.wait
local c = Random.new()
local d = math.pi
local e = Vector3.new
a.w = not a.w

while a.w do
	b()
	local l = workspace:FindFirstChild(target)
	if not l then continue end
	local y = game.Players.LocalPlayer.Character
	if not y then continue end

	local f = e(c:NextNumber(-500, 500), 500, c:NextNumber(-500, 500))
	local g = e(c:NextNumber(-1000, 1000), c:NextNumber(-1000, 1000), c:NextNumber(-1000, 1000))
	local cf, size = l:GetBoundingBox()

	for _, hrp in next, y:GetDescendants() do
		if not hrp:IsA('BasePart') then continue end
		hrp.AssemblyAngularVelocity = g
		hrp.AssemblyLinearVelocity = f
		hrp.CFrame = cf * CFrame.fromEulerAnglesYXZ(c:NextNumber(-d, d), c:NextNumber(-d, d), c:NextNumber(-d, d)) + e(c:NextNumber(-1, 1), -size.Y / 4 + c:NextNumber(-2, 0), c:NextNumber(-1, 1))
	end
end
