#include "..\..\macro.hpp"

/* ----------------------------------------------------------------------------
Function: dzn_CasualGaming_fnc_ratingFixAll

Description:
	Triggers rating fix (make it positive) for all players.
	Should be spawned.

Parameters:
	none

Returns:
	none

Examples:
    (begin example)
		[] spawn dzn_CasualGaming_fnc_ratingFixAll; 
    (end)

Author:
	10Dozen
---------------------------------------------------------------------------- */

[SVAR(fnc_ratingFix)] call GVAR(fnc_publishFunction);

[true] call GVAR(fnc_ratingFix);

{
	[true] remoteExec [SVAR(fnc_ratingFix), _x];
	sleep 0.5;
} forEach (call BIS_fnc_listPlayers);
	
hint parseText "<t size='1.5' color='#FFD000' shadow='1'>Global Rating fix done</t>";
[player, 25] call GVAR(fnc_logUserAction);
