#include "..\..\macro.hpp"

/* ----------------------------------------------------------------------------
Function: dzn_CasualGaming_fnc_openArsenal

Description:
	Opens vanilla or ACE arsenal. 

Parameters:
	_mode -- arsenal to open "BIS" (default) or "ACE" <STRING>

Returns:
	none

Examples:
    (begin example)
		[] call dzn_CasualGaming_fnc_openArsenal; // opens BIS arsenal
		["ACE"] call dzn_CasualGaming_fnc_openArsenal // opens ACE arsenal
    (end)

Author:
	10Dozen
---------------------------------------------------------------------------- */

params [["_mode","BIS"]];

closeDialog 2;

switch (toUpper _mode) do {
	case "ACE": {
		[player, player, true] spawn ace_arsenal_fnc_openBox;
	};
	default {
		["Open", true] call BIS_fnc_Arsenal;
	};
};

[player, 6] call GVAR(fnc_logUserAction);