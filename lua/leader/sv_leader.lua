function LEADER.decideLeader()
	LEADER.leader = nil
	if LEADER.IsThereLeader() then
		while true do
			local selectedPly = math.random(1,#player.GetAll());
			selectedPly = player.GetAll()[selectedPly];
			if selectedPly:GetRole() == ROLE_INNOCENT then
				LEADER.leader = selectedPly;
				break;
			elseif LEADER.Config.AllowDLeader and selectedPly:GetRole() == ROLE_DETECTIVE then
				LEADER.leader = selectedPly;
				break;
			elseif LEADER.Config.AllowTLeader and selectedPly:GetRole() == ROLE_TRAITOR then
				LEADER.leader = selectedPly;
				break;
			end
		end
		print(LEADER.leader)
		LEADER.sendLeaderInformation()
		timer.Create("OverridePlayerModels",0.5,1,LEADER.setupLeader);
	end
end
hook.Add("TTTBeginRound","MakePlayerLeader",LEADER.decideLeader);

function LEADER.setupLeader()
	local ply = LEADER.leader;
	if LEADER.Config.UniqueModel then ply:SetModel(LEADER.Config.LeaderModel); end
	if LEADER.Config.ChangeArmor then ply:SetArmor(LEADER.Config.LeaderArmor); end
	if LEADER.Config.ChangeHealth then ply:SetHealth(LEADER.Config.LeaderHealth); end
	if LEADER.Config.PreventPrimaryPickup then LEADER.removePrimary(ply); end
	LEADER.sendLeaderNotification(ply);
end

function LEADER.removePrimary(ply)
	for k,wep in pairs(ply:GetWeapons()) do
		if wep.Kind == WEAPON_HEAVY then
			ply:StripWeapon(wep:GetClass());
		end
	end
end

function LEADER.sendLeaderNotification(ply)
	net.Start( "notfiyLeader" );
	net.WriteString(LEADER.Config.LeaderNotification);
	net.Send( ply );
end

function LEADER.sendLeaderInformation()
	net.Start( "leaderInformation" );
	local leaderName = LEADER.leader:Nick()
	net.WriteString(leaderName);
	net.Broadcast( );
end

function LEADER.preventPrimaryPickup(ply,wep)
	if LEADER.IsThereLeader  then
		if LEADER.Config.PreventPrimaryPickup then
			if ply == LEADER.leader then
				if wep.Kind == WEAPON_HEAVY then 
					return false;
				end
			end
		end
	end
end
hook.Add( "PlayerCanPickupWeapon", "NoPrimary", LEADER.preventPrimaryPickup);

function LEADER.onkillLeader(ply,item,attacker)
	if LEADER.IsThereLeader then
		if ply == LEADER.leader and attacker:GetRole() == ROLE_TRAITOR then
			attacker:PS2_AddStandardPoints(LEADER.Config.PointsForKilling,LEADER.Config.MessageForKilling);
		end
	end
end
hook.Add("PlayerDeath","LeaderDies",onkillLeader);

local function sendLeaderInformationToPlayer(len,ply)
	if IsValid(LEADER.leader) then
		net.Start( "leaderInformation" );
		local leaderName = LEADER.leader:Nick()
		net.WriteString(leaderName);
		net.Send( ply );
	end
end
net.Receive("clientLoaded", sendLeaderInformationToPlayer)