#include "..\..\macro.hpp"

/* ----------------------------------------------------------------------------
Function: dzn_CasualGaming_fnc_checkUserAuthorized

Description:
	Checks is user authorized to use Casual Gaming 

Parameters:
	none

Returns:
	BOOL (true if authorized)

Examples:
    (begin example)
		_isAuthorized = [] call dzn_CasualGaming_fnc_checkUserAuthorized; // true
    (end)

Author:
	10Dozen
---------------------------------------------------------------------------- */


// --- Player is admin
if ((serverCommandAvailable "#logout") || !(isMultiplayer) || isServer) exitWith { true };

// --- Return True if both names and UIDs lists are empty 
if (GVAR(AuthorizedUsers) isEqualTo [] && GVAR(AuthorizedUIDs) isEqualTo []) exitWith { true };

// --- Player is in authorized user names 
if ((name player) in GVAR(AuthorizedUsers)) exitWith { true };

// --- Player is in authorized UIDs 
if ((getPlayerUID player) in GVAR(AuthorizedUIDs)) exitWith { true };

false