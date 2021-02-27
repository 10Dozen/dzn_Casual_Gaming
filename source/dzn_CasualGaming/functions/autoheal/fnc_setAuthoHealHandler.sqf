#include "..\..\macro.hpp"
#define SELF FUNC(setAuthoHealHandler)

/* ----------------------------------------------------------------------------
Function: dzn_CasualGaming_fnc_setAuthoHealHandler

Description:
	Adds auto-heal handler.

Parameters:
	none (some internal parameters are "INIT", "SET", "RESET" and "REMOVE")

Returns:
	none

Examples:
    (begin example)
		[] call dzn_CasualGaming_fnc_setAuthoHealHandler; // Disables fatigue
    (end)

Author:
	10Dozen
---------------------------------------------------------------------------- */

params [["_mode","SET"]];

switch (toUpper _mode) do {
	case "INIT": {
		GVAR(AutoHealEnabled) = true;
		GVAR(AutoHealTimer) = 30;
		GVAR(AutoHeal_Handler) = -1;
	};
	case "SET": {
		if (isNil SVAR(AutoHeal_Handler)) then { ["INIT"] call SELF; };
		if (GVAR(AutoHeal_Handler) > -1) then { ["REMOVE"] call SELF; };

		["START"] call SELF;
	};
	case "START": {
		GVAR(AutoHeal_Handler) = [
			{ if (GVAR(AutoHealEnabled)) then { [false] call FUNC(heal); }; }
			, GVAR(AutoHealTimer)
		] call CBA_fnc_addPerFrameHandler;
	};
	case "REMOVE": {
		GVAR(AutoHeal_Handler) call CBA_fnc_removePerFrameHandler;
		GVAR(AutoHeal_Handler) = -1;
	};
};
