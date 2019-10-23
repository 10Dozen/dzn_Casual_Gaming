#include "..\..\macro.hpp"

/* ----------------------------------------------------------------------------
Function: dzn_CasualGaming_fnc_toggleWallhack

Description:
	Toggles Wallhack feature on/off.

Parameters:
	none

Returns:
	none

Examples:
    (begin example)
		[] call dzn_CasualGaming_fnc_toggleWallhack;
    (end)

Author:
	10Dozen
---------------------------------------------------------------------------- */

GVAR(WallhackEnabled) = !( GVAR(WallhackEnabled) );
if (GVAR(WallhackEnabled)) then {
	GVAR(Wallhack_PFH) = [GVAR(fnc_handleWallhackEH)] call CBA_fnc_addPerFrameHandler;
} else {	
	GVAR(Wallhack_PFH) call CBA_fnc_removePerFrameHandler;
};

hint parseText format [
	"<t size='1.5' color='#FFD000' shadow='1'>Wallhack toggled to %1</t>"
	, if (GVAR(WallhackEnabled)) then { "ON" } else { "OFF" }
];
[player, 17] call GVAR(fnc_logUserAction);