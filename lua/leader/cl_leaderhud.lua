surface.CreateFont( "LeaderText", {	font = "Arial", extended = false,size = 30, weight = 1000} );
surface.CreateFont( "LeaderName", {	font = "Arial", extended = false,size = 25, weight = 500} );
surface.CreateFont( "LeaderStatus", {	font = "Arial", extended = false,size = 100, weight = 500} );

LEADER.Colours = {
	background = Color(0,0,0,50);
	foreground = Color(64,64,64,255);
	text       = Color(255,255,255);
	deadtext   = Color(20,20,20,255);
	alivetext  = Color(255,0,0,255);
}

LEADER.y = ScrH() / 3;
LEADER.x = 10;
LEADER.w = 140;
LEADER.h = 140;

function LEADER.DrawBackground(x,y,w,h)
	draw.RoundedBox( 0, x - 4, y - 34, w + 8, h + 72, LEADER.Colours.background );
	draw.RoundedBox( 0, x , y + 2, w, h, LEADER.Colours.foreground );
	draw.RoundedBox( 0, x, y - 30, w, h/5, LEADER.Colours.foreground );
	draw.RoundedBox( 0, x, y + 146, w, h/5, LEADER.Colours.foreground );
		
	if !IsValid(LEADER.Avatar) then
		LEADER.Avatar = vgui.Create("AvatarImage");
		LEADER.Avatar:SetSize(128,128);
		LEADER.Avatar:SetPos( x + 6, y + 8);
		LEADER.Avatar:SetPlayer(LEADER.leader, 128);
	end
end

function LEADER.ShowName(x,y,w,h)
	draw.SimpleText("LEADER","LeaderText", x + 20, y - 32, LEADER.Colours.text);
		
	if IsValid(LEADER.leader) then
		draw.SimpleText(string.sub(LEADER.leader:Nick(),1,9),"LeaderName", x + 68, y + 146, LEADER.Colours.text, TEXT_ALIGN_CENTER);
	else
		draw.SimpleText("Disconnected","LeaderName", x + 68, y + 146, LEADER.Colours.text, TEXT_ALIGN_CENTER);
	end
end

function LEADER.Hud()
	if GetRoundState() ~= ROUND_ACTIVE or LEADER.ShowHud == false then return end
	
	local y = LEADER.y;
	local x = LEADER.x;
	local w = LEADER.w;
	local h = LEADER.h;
	
	LEADER.DrawBackground(x,y,w,h);
	LEADER.ShowName(x,y,w,h/5);
end
hook.Add("HUDPaint", "DrawLeader", LEADER.Hud);

function LEADER.RemoveAvatar(results)
	if IsValid(LEADER.Avatar) then
		LEADER.Avatar:Remove();
		LEADER.Avatar = NULL;
	end
end
hook.Add("TTTEndRound","CheckToPaintHud",LEADER.RemoveAvatar);

function LEADER.BeginRound()
	if LEADER.IsThereLeader() then
		LEADER.ShowHud = true;
	else 
		LEADER.ShowHud = false;
	end
end
hook.Add("TTTBeginRound","CheckToPaintHud",LEADER.BeginRound);

hook.Add ("Think", "loadplayer", function ()
    if IsValid (LocalPlayer ()) then
        net.Start("clientLoaded")
		net.SendToServer()
        hook.Remove ("Think", "loadplayer")
    end
end)

local function receiveLeader()
	local leaderName = net.ReadString();
	for k,v in pairs(player.GetAll()) do
		if v:Nick() == leaderName then
			LEADER.leader = v;
		end
	end
end
net.Receive("leaderInformation",receiveLeader);

--LEADER.leader:GetNWBool("body_found", false)