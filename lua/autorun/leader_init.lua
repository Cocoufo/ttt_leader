if SERVER then

	AddCSLuaFile();
	include( "leader/sv_init.lua" );
	
elseif CLIENT then

	include( "leader/cl_init.lua" );
	
end