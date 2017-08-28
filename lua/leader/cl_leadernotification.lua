local function notifyLeaderMessage()
	local msg = net.ReadString();
	notification.AddLegacy( msg, NOTIFY_GENERIC, 5 );
	surface.PlaySound( "buttons/button15.wav" );
end
net.Receive("notfiyLeader",notifyLeaderMessage);