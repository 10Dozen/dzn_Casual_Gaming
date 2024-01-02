#include "..\script_component.hpp"

/* ----------------------------------------------------------------------------
Function: dzn_CasualGaming_fnc_logActionRemote

Description:
    Logs usage of CasualGaming actions to RPT on server side.

Parameters:
    _name -- player's name <STRING>
    _UID -- player's UID <STRING>
    _actionID -- ID of used action <NUMBER>

Returns:
    none

Examples:
    (begin example)
        ["GoodBoi","7124242421424", 5] call dzn_CasualGaming_fnc_logActionRemote;
        // Logs "Rallypoint set" action
    (end)

Author:
    10Dozen
---------------------------------------------------------------------------- */

if !(GVAR(Log)) exitWith {};

params ["_name", "_UID", "_actionID"];

private _msg = format ["[dzn_CG][%1 %2] %3", _name, _UID, GVAR(LogReasons) # _actionID];
diag_log parseText _msg;
systemChat _msg;
