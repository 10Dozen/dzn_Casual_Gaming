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
	params ["_player", "_actionID"];

	private _msg = format ["[dzn_CG][%1 %2] %3", name _player, getPlayerUID _player, GVAR(LogReasons) # _actionID];
	diag_log parseText _msg;
	systemChat _msg;
} else {
	_this remoteExec [QFUNC(logUserAction), 2];
};
