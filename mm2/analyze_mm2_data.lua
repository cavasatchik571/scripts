local function iter(n,k,v)
	print(string.rep('>', n) .. ' - ' .. tostring(k) .. ' : ' .. tostring(v))
	
	if type(v)=='table'then
		for k,v in next,v do
			iter(n+1,k,v)
		end
	end
end

iter(0,'',game.ReplicatedStorage.Remotes.Extras.GetPlayerData:InvokeServer())
