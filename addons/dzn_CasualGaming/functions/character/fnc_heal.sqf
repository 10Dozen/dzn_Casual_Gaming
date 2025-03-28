#include "..\script_component.hpp"
#include "..\main\reasons.hpp"

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

if (!hasInterface) exitWith {};

private _player = [] call CBA_fnc_currentUnit;

// --- Vanilla healing
_player setDamage 0;

// --- ACE Healing
if (!isNil "ace_medical_treatment_fnc_fullHealLocal") then {
    [_player] call ace_medical_treatment_fnc_fullHealLocal;
};

// --- BIS Revive
["", 1, _player] call BIS_fnc_reviveOnState;
player setVariable ["#rev", 1, true];


if (_showHint) then {
    ["<t size='1.5' color='#FFD000' shadow='1'>Healed</t>"] call FUNC(hint);
};
[player, REASON_HEALING] call FUNC(logUserAction);
