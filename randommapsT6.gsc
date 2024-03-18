/*
*	 Black Ops 2 - GSC Studio by iMCSx
*
*	 Creator : Chenterito
*	 Project : randommapsT6
*    	Mode : Multiplayer
*	 Date : 2021/05/23 - 10:10:04	
*
*/	

main()
{
	replaceFunc( maps\mp\gametypes\_killcam::dofinalkillcam, ::mv_dofinalkillcam);
}

init()
{
	level.mapvotate=1;				
	level.poolmaps = "mp_la mp_dockside mp_carrier mp_drone mp_express mp_hijacked mp_meltdown mp_overflow mp_nightclub mp_raid mp_slums mp_village mp_turbine mp_socotra mp_nuketown_2020 mp_downhill mp_mirage mp_hydro mp_skate mp_concert mp_magma mp_vertigo mp_studio mp_uplink mp_bridge mp_castaway mp_paintball mp_dig mp_frostbite mp_pod mp_takeoff";
	level.poolgamemodes = "tdm.cfg dom.cfg";		
	level thread ramdommaps();
}

mv_dofinalkillcam()
{
	level waittill( "play_final_killcam" );
	level.infinalkillcam = 1;
	winner = "none";
	if ( isDefined( level.finalkillcam_winner ) )
	{
		winner = level.finalkillcam_winner;
	}
	if ( !isDefined( level.finalkillcamsettings[ winner ].targetentityindex ) )
	{	
		if(isdefined(level.mapvotate) && level.mapvotate == 1)
		{
			level notify("time_votemap");
			level waittill("votemap_end");
		}

		level.infinalkillcam = 0;
		level notify( "final_killcam_done" );
		return;
	}
	if ( isDefined( level.finalkillcamsettings[ winner ].attacker ) )
	{
		maps\mp\_challenges::getfinalkill( level.finalkillcamsettings[ winner ].attacker );
	}
	visionsetnaked( getDvar( "mapname" ), 0 );
	players = level.players;
	index = 0;
	while ( index < players.size )
	{
		player = players[ index ];
		player closemenu();
		player closeingamemenu();
		player thread finalkillcam( winner );
		index++;
	}
	wait 0.1;
	while ( areanyplayerswatchingthekillcam() )
	{
		wait 0.05;
	}
	if(isdefined(level.mapvotate) && level.mapvotate == 1)
	{
		level notify("time_votemap");
		level waittill("votemap_end");
	}	
	level notify( "final_killcam_done" );
	level.infinalkillcam = 0;
}

ramdommaps()
{
    level endon("votemap_end");
	level waittill("time_votemap"); 
	poolmaps = strTok(level.poolmaps, " ");
	poolgamemodes = strTok(level.poolgamemodes, " ");
    ramdomMapInt = randomIntRange(1,poolmaps.size);
    ramdomTypeInt = randomIntRange(1,poolgamemodes.size);
    
    wait .5;
    setDvar( "sv_maprotationcurrent", "exec " + poolgamemodes[ramdomTypeInt] + " map " + poolmaps[ramdomMapInt] + ";" );
    logPrint("exec " + poolgamemodes[ramdomTypeInt] + " map " + poolmaps[ramdomMapInt] + ";");
    printLn("exec " + poolgamemodes[ramdomTypeInt] + " map " + poolmaps[ramdomMapInt] + ";");
	wait .5;
    level notify("votemap_end");
}
