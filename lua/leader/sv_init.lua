LEADER = LEADER or { };

AddCSLuaFile( "leader/cl_init.lua" );
AddCSLuaFile( "leader/cl_leadernotification.lua" );
AddCSLuaFile( "leader/cl_leaderhud.lua" );
AddCSLuaFile( "leader/config.lua" );
AddCSLuaFile( "leader/sh_functions.lua" );

include( "leader/sv_leader.lua" );
include( "leader/config.lua" );
include( "leader/sh_functions.lua" );

util.AddNetworkString( "notfiyLeader" );
util.AddNetworkString( "leaderInformation" );
util.AddNetworkString( "clientLoaded" );