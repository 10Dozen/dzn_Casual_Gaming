#include "..\..\macro.hpp"
#define SELF GVAR(fnc_setAuthoHealHandler)

/* ----------------------------------------------------------------------------
Function: dzn_CasualGaming_fnc_setAuthoHealHandler

Description:
	Adds auto-heal handler.

Parameters:
	none (some internal parameters are "INIT", "SET", "UPDATE_TIME" and "REMOVE")

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
		GVAR(AutoHealEnabled) = false;
		GVAR(AutoHealTimer) = 30;
		GVAR(AutoHeal_Handler) = -1;
	};
	case "SET": {
		if (isNil SVAR(AutoHeal_Handler)) then {
			["INIT"] call SELF;

			GVAR(AutoHeal_Handler) = [
				{ if (GVAR(AutoHealEnabled)) then { [false] call GVAR(fnc_heal); }; }
				, GVAR(AutoHealTimer)
			] call CBA_fnc_addPerFrameHandler;
		} else {
			["UPDATE_TIMER"] call SELF;
		};
	};
	case "UPDATE_TIMER": {
		(CBA_common_perFrameHandlerArray # GVAR(AutoHeal_Handler)) set [1, GVAR(AutoHealTimer)];
	};
	case "REMOVE": {
		GVAR(AutoHeal_Handler) call CBA_fnc_removePerFrameHandler;
		GVAR(AutoHeal_Handler) = -1;
	};
};