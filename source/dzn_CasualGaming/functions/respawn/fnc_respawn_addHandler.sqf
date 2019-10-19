#include "..\..\macro.hpp"

/* ----------------------------------------------------------------------------
Function: dzn_CasualGaming_fnc_respawn_addHandler

Description:
	Adds RespawnEH to force show player's model on respawn.

Parameters:
	none

Returns:
	none

Examples:
    (begin example)
		[] call dzn_CasualGaming_fnc_respawn_addHandler;
    (end)

Author:
	10Dozen
---------------------------------------------------------------------------- */

GVAR(RespawnHandler) = player addEventHandler [
	"Respawn"
	, { [player, false] remoteExec ["hideObjectGlobal", 2]; }
];
