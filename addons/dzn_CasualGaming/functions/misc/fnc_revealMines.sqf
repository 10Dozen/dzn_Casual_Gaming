#include "..\script_component.hpp"
#include "..\main\reasons.hpp"

/* ----------------------------------------------------------------------------
Function: dzn_CasualGaming_fnc_revealMines

Description:
    Reveal all mines on map to player's unit side.

Parameters:
    none

Returns:
    none

Examples:
    (begin example)
        [] call dzn_CasualGaming_fnc_revealMines;
    (end)

Author:
    10Dozen
---------------------------------------------------------------------------- */

private _playerSide = side ([] call CBA_fnc_currentUnit);
private _mines = allMines;

{
    _playerSide revealMine _x;
} forEach _mines;

hint parseText format [
    "<t size='1.5' color='#FFD000' shadow='1'>Mines revealed</t><br/>%1 mines",
    count _mines
];

[player, REASON_MINES_REVEALED] call FUNC(logUserAction);
