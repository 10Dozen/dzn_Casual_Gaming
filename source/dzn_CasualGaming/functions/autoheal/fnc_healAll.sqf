#include "..\..\macro.hpp"

/* ----------------------------------------------------------------------------
Function: dzn_CasualGaming_fnc_healAll

Description:
	Triggers global healing for all players.
	Should be spawned.

Parameters:
	none

Returns:
	none

Examples:
    (begin example)
		[] spawn dzn_CasualGaming_fnc_healAll; // Turns auto-heal on 
    (end)

Author:
	10Dozen
---------------------------------------------------------------------------- */

[SVAR(fnc_heal)] call GVAR(fnc_publishFunction);

[true] call GVAR(fnc_heal);

{
	[true] remoteExec [SVAR(fnc_heal), _x];
	sleep 0.5;
} forEach (call BIS_fnc_listPlayers);
	
hint parseText "<t size='1.5' color='#FFD000' shadow='1'>Global Healing done</t>";
[player, 2] call GVAR(fnc_logUserAction);
