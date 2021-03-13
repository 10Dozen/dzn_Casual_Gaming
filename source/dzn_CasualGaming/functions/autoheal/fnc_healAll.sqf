#include "..\..\macro.hpp"
#include "..\main\reasons.hpp"

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

[QFUNC(heal)] call FUNC(publishFunction);

[true] call FUNC(heal);

{
	[true] remoteExec [QFUNC(heal), _x];
	sleep 0.5;
} forEach (call BIS_fnc_listPlayers);
	
hint parseText "<t size='1.5' color='#FFD000' shadow='1'>Global Healing done</t>";
[player, REASON_HEALING_GLOBAL] call FUNC(logUserAction);
