#include "..\script_component.hpp"

/* ----------------------------------------------------------------------------
Function: dzn_CasualGaming_fnc_safeMove

Description:
    Safely moves unit out of vehicle and teleports to given position.

Parameters:
    _unit - unit to move (OBJECT)
    _posStatement - position to move (POS3D) or code that returns position (CODE)

Returns:
    none

Examples:
    (begin example)
        [player, getPos Logic1] call dzn_CasualGaming_fnc_safeMove;
    (end)

Author:
    10Dozen
---------------------------------------------------------------------------- */

params ["_unit","_posStatement"];

#define IS_PLAYER (call CBA_fnc_currentUnit) isEqualTo _unit

// --- Safe move to new position
if (IS_PLAYER) then { 1000 cutText ["Re-deploying","BLACK OUT",1]; };

_unit allowDamage false;
[{
    params ["_unit","_posStatement"];

    if (IS_PLAYER) then { openMap false; };
    moveOut _unit;
    _unit setVelocity [0,0,0];

    private _pos = if (_posStatement isEqualType {}) then {
        [] call _posStatement
    } else {
        _posStatement
    };
    _unit setPos _pos;

    if (IS_PLAYER) then { 1000 cutText ["Re-deploying","BLACK IN",1]; };

    [{_this allowDamage true}, _unit, 2] call CBA_fnc_waitAndExecute;
}, [_unit, _posStatement], 2] call CBA_fnc_waitAndExecute;
