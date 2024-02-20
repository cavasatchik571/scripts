-- check

local env = _ENV or shared or _G
local new_rooms = not env.rooms and true or nil
env.rooms = new_rooms
if not new_rooms then return end

-- variables

local camera = workspace.CurrentCamera
local cf_new = CFrame.new
local getting_up = Enum.HumanoidStateType.GettingUp
local heartbeat = game:GetService('RunService').Heartbeat
local rooms = workspace:WaitForChild('Rooms')
local table_clear = table.clear
local vec3_new = Vector3.new
local vec3_t0 = vec3_new(2, 0, 0)
local vec3_t1 = vec3_new(-2, 0, 0)
local vec3_zero = Vector3.zero
local you = game:GetService('Players').LocalPlayer

-- functions

local function is_unsafe()
  local children = workspace:GetChildren()

  for idx = 1, #children do
    local child = children[idx]
    local name = child.Name
    if (name ~= 'A60' and name ~= 'A120') or child:GetAttribute('done') then continue end
    table_clear(children)
    return true
  end

  table_clear(children)
  return false
end

local function fpp(prompt)
  prompt:InputHoldBegin()
  heartbeat:Wait()
  prompt:InputHoldEnd()
end

local function get_door()
  local room = 0
  local children = rooms:GetChildren()

  for idx = #children, 1, -1 do
    local new_room = tonumber(children[idx].Name)
    if new_room > room then room = new_room end
  end

  table_clear(children)
  return rooms[tostring(room)]:WaitForChild('Door'):WaitForChild('Union')
end

local function get_locker()
  local children = rooms:GetChildren()
  local dist = 10000
  local pos = you.Character:GetPivot().Position
  local union

  for idx = 1, #children do
    local room_children = children[idx]:GetChildren()

    for idx = 1, #room_children do
      local child = room_children[idx]
      if child.Name ~= 'Locker' or child.Seat.Occupant then continue end
      local new_union = child.Union
      local new_dist = (new_union.Position - pos).Magnitude
      if new_dist < dist then dist, union = new_dist, new_union end
    end

    table_clear(room_children)
  end

  table_clear(children)
  return union
end

local function get_path()
  return is_unsafe() and get_locker() or get_door()
end

-- code

local a90 = you:FindFirstChild('A90', true)
if a90 then a90:Destroy() end

while env.rooms do
  heartbeat:Wait()
  local char = you.Character
  if not char then continue end
  local h = char:FindFirstChildOfClass('Humanoid')
  if not h then continue end
  local hrp = char:FindFirstChild('HumanoidRootPart')
  if not hrp then continue end
  local path = get_path()
  if not path then continue end
  local parent = path.Parent
  local new_pos = path.CFrame * (parent.Name == 'Locker' and vec3_t0 or vec3_t0)
  local new_cf = cf_new(new_pos, path.Position)
  local t = 1.2

  while t > 0 do
    t -= heartbeat:Wait()
    camera.CFrame = new_cf
    char:PivotTo(new_cf)
    h:ChangeState(getting_up)
    h:MoveTo(new_pos)
    local prompt = parent:FindFirstChildWhichIsA('ProximityPrompt', true)
    if prompt then fpp(prompt) end
    local children = char:GetChildren()

    for idx = 1, #children do
      local child = children[idx]
      if not child:IsA('BasePart') then continue end
      child.AssemblyAngularVelocity = vec3_zero
      child.AssemblyLinearVelocity = vec3_zero
    end

    table_clear(children)
  end
end
