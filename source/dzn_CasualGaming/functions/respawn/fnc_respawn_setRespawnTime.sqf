#include "..\..\macro.hpp"

/* ----------------------------------------------------------------------------
Function: dzn_CasualGaming_fnc_respawn_setRespawnTime

Description:
	Sets respawn time for player.

Parameters:
	_this --- new respawn time (in seconds) to set <NUMBER>

Returns:
	none

Examples:
    (begin example)
		15 call dzn_CasualGaming_fnc_respawn_setRespawnTime; // Sets respawn time to 15 seconds
    (end)

Author:
	10Dozen
---------------------------------------------------------------------------- */

setPlayerRespawnTime _this;

hint parseText format [
	"<t size='1.5' color='#FFD000' shadow='1'>Respawn Time</t><br /><br />Set to %1 seconds"
	, _this
];

[player, 11] call GVAR(fnc_logUserAction);