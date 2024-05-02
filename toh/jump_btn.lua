-- source code

local udim2_from_offset = UDim2.fromOffset
local udim2_from_scale = UDim2.fromScale
local ui = game:GetService('Players').LocalPlayer:WaitForChild('PlayerGui')

-- logic

local jump_btn = ui:WaitForChild('TouchGui'):WaitForChild('TouchControlFrame'):WaitForChild('JumpButton')
jump_btn.Position = udim2_from_scale(0.875, 0.575)
jump_btn.Size = udim2_from_offset(150, 150)

local lbl = ui:WaitForChild('MobileShiftLock'):WaitForChild('BottomLeftControl'):WaitForChild('MouseLockLabel')
lbl.Position = udim2_from_scale(-1, -1)
lbl.Size = udim2_from_offset(100, 100)
