#include "..\..\macro.hpp"
#include "..\main\reasons.hpp"

#define SELF FUNC(handleConsole)

/* ----------------------------------------------------------------------------
Function: dzn_CasualGaming_fnc_handleConsole

Description:
	Handles console feature, code execution and stuff.

Parameters:
	_mode -- call mode ("HANDLE", "EXECUTE", "WATCH", "RESTORE_LAST", "UPDATE_PLAYER_LIST") <STRING>
	_payload -- (optional) arguments for call mode <ANY>

Returns:
	none

Examples:
    (begin example)
		["HANDLE"] call dzn_CasualGaming_fnc_handleConsole;
		["RESTORE_LAST"] call dzn_CasualGaming_fnc_handleConsole;
    (end)

Author:
	10Dozen
---------------------------------------------------------------------------- */

params [["_mode","HANDLE"],["_payload",[]]];

switch (toUpper _mode) do {
	case "OPEN": {
		["UPDATE_PLAYER_LIST"] call SELF;
		["RESTORE_LAST"] call SELF;
		["WATCH"] call SELF;

		[player, REASON_CONSOLE_OPENED] call FUNC(logUserAction);
	};
	case "UPDATE_PLAYER_LIST": {
		private _list = call BIS_fnc_listPlayers;
		private _ctrl = findDisplay 192001 displayCtrl 2100;
		
		GVAR(PlayersList) = _list apply { [name _x, _x] };
		
		lbClear _ctrl;
		{ _ctrl lbAdd (_x select 0); } forEach GVAR(PlayersList);
		
		lbSort _ctrl;
		_ctrl lbSetCurSel 0;
		
		_ctrl ctrlCommit 0;
	};
	case "EXECUTE": {
		_payload params ["_code", "_execType"];

		switch toUpper(_execType) do {
			case "LOCAL": {		[] spawn _code; };
			case "GLOBAL": {	[[], _code] remoteExec ["bis_fnc_call", 0]; };
			case "SERVER": {	[[], _code] remoteExec ["bis_fnc_call", 2]; };
			case "PLAYER": {
				[[], _code] remoteExec [
					"bis_fnc_call"
					, (GVAR(PlayersList) select { _x # 0 == (lbText [2100, lbCurSel 2100]) }) # 0 # 1
				];
			};
		};
		
		hint "Executed";
		
		[{ ["WATCH"] call SELF; }] call CBA_fnc_execNextFrame;
	};
	case "HANDLE": {
		private _type = _payload;
		private _text = ctrlText 1400;
		profileNamespace setVariable [SVAR(Console_LastExecute), _text];

		["EXECUTE", [compile _text, _type]] call SELF;
	};
	case "WATCH": {
		private _code = ctrlText 1401;
		private _output = call compile _code;
		profileNamespace setVariable [SVAR(Console_LastWatch), _code];
		
		ctrlSetText [1402, if (isNil "_output") then { "--nil--" } else { str(_output) }];
	};
	case "RESTORE_LAST": {
		if (!isNil {profileNamespace getVariable SVAR(Console_LastWatch)}) then {
			ctrlSetText [1401, profileNamespace getVariable SVAR(Console_LastWatch)];
			["WATCH"] call SELF;
		};
		
		if (!isNil {profileNamespace getVariable SVAR(Console_LastExecute)}) then {
			ctrlSetText [1400, profileNamespace getVariable SVAR(Console_LastExecute)];
		};
	};
};
