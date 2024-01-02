#include "..\script_component.hpp"

/* ----------------------------------------------------------------------------
Function: dzn_CasualGaming_fnc_logUserAction

Description:
    Invoke server to log user's action.

Parameters:
    _player -- player used action <OBJECT>
    _actionID -- ID of used action <NUMBER>

Returns:
    none

Examples:
    (begin example)
        [player, 5] call dzn_CasualGaming_fnc_logUserAction; // Logs "Rallypoint set" action
    (end)

Author:
    10Dozen
---------------------------------------------------------------------------- */

if !(GVAR(Log)) exitWith {};

params ["_player", "_actionID"];

private _name = name _player;
private _UID = getPlayerUID _player;

[_name, _UID, _actionID] remoteExec [QFUNC(logActionRemote), 2];
