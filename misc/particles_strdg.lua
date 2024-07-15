-- source code

local env = (getgenv or function() end)() or _ENV or shared or _G
local enabled = if env.IAS then nil else true
env.IAS = enabled
if not enabled then return end
local run = true
local sleep = task.wait
local you = game:GetService('Players').LocalPlayer

-- logic

coroutine.resume(coroutine.create(function()
 local re = game:GetService('ReplicatedStorage'):WaitForChild('RemoteEvent')
 while run do
  if not run then return end
  re:FireServer('invisibilityboostprompt')
  if not run then return end
  sleep()
  if not run then return end
  re:FireServer('speedboostprompt')
  if not run then return end
  sleep(10.044)
  if not run then return end
  re:FireServer('speedboostprompt')
  if not run then return end
  sleep(10.044)
  if not run then return end
  sleep()
  if not run then return end
 end
end))

while env.IAS do
 sleep()
 local char = you.Character
 if not char then continue end
 local h = char:FindFirstChildOfClass('Humanoid')
 if not h then continue end
 h.WalkSpeed = 30
end

run = nil

