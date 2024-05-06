game:GetService('ContextActionService'):BindAction('DropTool', function()
	game:GetService('Players').LocalPlayer.Character:FindFirstChildOfClass('Tool').Parent = workspace
end, true)
