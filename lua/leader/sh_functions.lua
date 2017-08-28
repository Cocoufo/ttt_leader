function LEADER.IsThereLeader()
	local livingCount = 0;
        for k,v in pairs(player.GetAll()) do
			if v:Alive() then
				livingCount = livingCount  + 1;
			end
		end		
	if livingCount >= LEADER.Config.RequiredPlayers then
		return true
	else
		return false
	end
end
