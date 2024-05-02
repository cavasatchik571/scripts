local LocalPlayer = game:GetService('Players').LocalPlayer
repeat wait() until
LocalPlayer and
	LocalPlayer:FindFirstChildWhichIsA('PlayerGui') and
	LocalPlayer.Character and
	LocalPlayer.Character:FindFirstChildWhichIsA('Humanoid') and
	LocalPlayer.Character:FindFirstChild('Head') and
	LocalPlayer:GetMouse()

local PlayerGui = LocalPlayer:FindFirstChildWhichIsA('PlayerGui')
local Mouse = LocalPlayer:GetMouse()
local Character = LocalPlayer.Character
local Humanoid = Character:FindFirstChildWhichIsA('Humanoid')
local HumanoidRootPart = Character:FindFirstChild('HumanoidRootPart')

-- Services

local Workspace = game:GetService('Workspace')

-- Variables

local Colors = {
	['Error'] = Color3.new(0.768627, 0.156863, 0.109804),
	['Available'] = Color3.new(0.0509804, 0.411765, 0.67451),
	['Hacked'] = Color3.new(0.156863, 0.498039, 0.278431)
}

-- Functions

local function BindComputer(ComputerTable)
	if (ComputerTable) and type(ComputerTable) == 'userdata' then
		repeat wait() until ComputerTable and ComputerTable:FindFirstChildWhichIsA('BasePart')
		local Adornments = {}

		for _, v in pairs(ComputerTable:GetDescendants()) do
			if (v) and type(v) == 'userdata' and v:IsA('BasePart') then
				local Color = Colors.Available
				if ComputerTable:FindFirstChild('Screen') then
					Color = ComputerTable:FindFirstChild('Screen').Color
				end

				local Adornment = Instance.new('BoxHandleAdornment')
				Adornment.Parent = v
				Adornment.Name = 'Adornment'
				Adornment.Color3 = Color
				Adornment.Transparency = 0.75
				Adornment.Size = v.Size
				Adornment.Adornee = v
				Adornment.ZIndex = 10
				Adornment.AlwaysOnTop = true

				table.insert(Adornments, Adornment)
			end
		end

		if ComputerTable:FindFirstChild('Screen') then
			local Screen = ComputerTable:FindFirstChild('Screen')

			Screen.Changed:Connect(function(Property)
				if (Screen) and Property == 'Color' then
					for _, v in pairs(Adornments) do
						if (v) and type(v) == 'userdata' then
							v.Color3 = Screen.Color
						end
					end
				end
			end)
		end
	end
end

-- Code

for _, v in pairs(Workspace:GetDescendants()) do
	if v and string.find(v.Name, 'ComputerTable') then
		local ComputerTable = v

		BindComputer(ComputerTable)
	end
end

Workspace.DescendantAdded:Connect(function(Descendant)
	if Descendant and string.find(Descendant.Name, 'ComputerTable') then
		local ComputerTable = Descendant

		BindComputer(ComputerTable)
	end
end)
