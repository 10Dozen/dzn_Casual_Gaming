#include "..\..\macro.hpp"

/* ----------------------------------------------------------------------------
Function: dzn_CasualGaming_fnc_logUserAction

Description:
	Logs usage of CasualGaming actions to RPT on server side.

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

if (isServer) then {
	params ["_name", "_UID", "_actionID"];
	private _msg = format ["[dzn_CG][%1 %2] %3", _name, _UID, GVAR(LogReasons) # _actionID];
	diag_log parseText _msg;
	systemChat _msg;
} else {
	params ["_player", "_actionID"];
	private _name = name _player;
	private _UID = getPlayerUID _player;
	[_name, _UID, _actionID] remoteExec [QFUNC(logUserAction), 2];
};
