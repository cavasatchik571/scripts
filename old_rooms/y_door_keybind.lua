game:GetService('UserInputService').InputBegan:Connect(function(Input, GPE)
if not GPE and Input.UserInputType == Enum.UserInputType.Keyboard and Input.KeyCode == Enum.KeyCode.Y then
local Children = workspace:GetChildren()

for Index = #Children, 1, -1 do
 local Value = Children[Index]
 
 if (Value:IsA('Folder') or Value:IsA('Model')) and not Value.Name:upper():find('GUMMY') then
  local door = Value:FindFirstChild('door')
  
  if door then
   fireclickdetector(door:FindFirstChildOfClass('ClickDetector'))
  end
 end
end
end
end)
