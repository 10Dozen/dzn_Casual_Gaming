#include "macro.hpp"

GVAR(fnc_checkUserAuthorized) = {
	// --- Player is admin
	if ((serverCommandAvailable "#logout") || !(isMultiplayer) || isServer) exitWith { true };

	// --- Return True if both names and UIDs are empty 
	if (GVAR(AuthorizedUsers) isEqualTo [] && GVAR(AuthorizedUIDs) isEqualTo []) exitWith { true };

	// --- Player is in authorized user names 
	if ((name player) in GVAR(AuthorizedUsers)) exitWith { true };

	// --- Player is in authorized UIDs 
	if ((getPlayerUID player) in GVAR(AuthorizedUIDs)) exitWith { true };

	false
};

GVAR(fnc_logUserAction) = {	
	if !(GVAR(Log)) exitWith {};
	
	if (isServer) then {
		params ["_player", "_actionID"];

		if (isNil SVAR(LogReasons)) then {
			GVAR(LogReasons) = [
				/* 0 */ "Authorized"
				, /* 1 */ "Healing"
				, /* 2 */ "Global Healing"
				, /* 3 */ "Fatigue toggled"
				, /* 4 */ "Deployed to rallypoint"
				, /* 5 */ "Rallypoint set"
				, /* 6 */ "Accessing Arsenal"
				, /* 7 */ "Loadout saved"
				, /* 8 */ "Loadout applied"
				, /* 9 */ "Accessing Garage"
				, /* 10 */ "Loadout copied"
				, /* 11 */ "Respawn timer changed"
				, /* 12 */ "Vehicle repaired"
				, /* 13 */ "Vehicle refueled"
				, /* 14 */ "Vehicle rearmed"
				, /* 15 */ "Vehicle Driver added"
				, /* 16 */ "Vehicle moved in air"
				, /* 17 */ "Wallhack toggled"
				, /* 18 */ "Splendid Camera opened"
				, /* 19 */ "Console opened"
			]
		};


		private _msg = format ["[dzn_CG][%1 %2] %3", name _player, getPlayerUID _player, GVAR(LogReasons) # _actionID];
		diag_log parseText _msg;
		systemChat _msg;
	} else {
		_this remoteExec [SVAR(fnc_logUserAction), 2];
	};
};