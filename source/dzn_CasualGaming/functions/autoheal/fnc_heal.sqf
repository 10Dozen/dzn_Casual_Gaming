#include "..\..\macro.hpp"

/* ----------------------------------------------------------------------------
Function: dzn_CasualGaming_fnc_heal

Description:
	Heals player in vanilla, BIS revive and ACE way.

Parameters:
	_showHint -- flag to show hint with action result <BOOL>

Returns:
	none

Examples:
    (begin example)
		[true] call dzn_CasualGaming_fnc_heal; // Heals with hing displayed
    (end)

Author:
	10Dozen
---------------------------------------------------------------------------- */

params ["_showHint"];

// --- Vanilla healing
player setDamage 0;

// --- ACE Healing
if (!isNil "ace_medical_fnc_treatmentAdvanced_fullHealLocal") then {
	[player ,player] call ace_medical_fnc_treatmentAdvanced_fullHealLocal;
};

// --- BIS Revive
["", 1, player] call BIS_fnc_reviveOnState;
player setVariable ["#rev", 1, true];


if (_showHint) then {
	hint parseText "<t size='1.5' color='#FFD000' shadow='1'>Healed</t>";
};
[player, 1] call GVAR(fnc_logUserAction);
