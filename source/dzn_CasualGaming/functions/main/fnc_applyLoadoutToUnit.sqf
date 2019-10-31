#include "..\..\macro.hpp"

/* ----------------------------------------------------------------------------
Function: dzn_CasualGaming_fnc_applyLoadoutToUnit

Description:
	Applies given loadout to unit and set variables needed for other functions (like Re-arm)

Parameters:
	_unit -- target unit <OBJECT>
	_loadout -- loadout to apply <ARRAY>

Returns:
	none

Examples:
    (begin example)
		[player, _loadout] call dzn_CasualGaming_fnc_applyLoadoutToUnit; 
    (end)

Author:
	10Dozen
---------------------------------------------------------------------------- */

params ["_unit", "_loadout"];

if (_loadout isEqualTo []) exitWith {};

_unit setVariable [SVAR(UnitLoadout), _loadout];
_unit setUnitLoadout _loadout;