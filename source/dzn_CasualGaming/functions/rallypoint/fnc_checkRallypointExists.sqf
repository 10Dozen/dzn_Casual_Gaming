
#include "..\..\macro.hpp"

/* ----------------------------------------------------------------------------
Function: dzn_CasualGaming_fnc_checkRallypointExists

Description:
	Creates/moves rallypoint to player's position.

Parameters:
	none

Returns:
	<ARRAY> -- exist flags for personal and squad reallypoiny, in format [<BOOL>,<BOOL>]

Examples:
    (begin example)
		_exists = [] call dzn_CasualGaming_fnc_checkRallypointExists; // [true,false]
    (end)

Author:
	10Dozen
---------------------------------------------------------------------------- */

[
	!(player getVariable [SVAR(RallypointPos), []] isEqualTo [])
	,!((leader group player) getVariable [SVAR(RallypointPos), []] isEqualTo [])
]