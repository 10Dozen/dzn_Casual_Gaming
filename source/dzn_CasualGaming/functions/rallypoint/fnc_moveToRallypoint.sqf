#include "..\..\macro.hpp"

/* ----------------------------------------------------------------------------
Function: dzn_CasualGaming_fnc_moveToRallypoint

Description:
	Moves player to rallypoint.
	Should be spawned.

Parameters:
	_modeID -- rallypoint type (0,1: Personal rallypoint; 2: Global side rallypoint )

Returns:
	none

Examples:
    (begin example)
		[2] spawn dzn_CasualGaming_fnc_moveToRallypoint; // Moves player to global rallypoint
    (end)

Author:
	10Dozen
---------------------------------------------------------------------------- */

params["_modeID"];

private _pos = [0,0,0];
private _msgWord = "";
	
switch (_modeID) do {
	case 0: {
		_msgWord = "My";
		_pos = player getVariable [SVAR(RallypointPos), []];
	};
	case 1: {
		_msgWord = "Squad";
		_pos = (leader group player) getVariable [SVAR(RallypointPos), []];
	};
	case 2: {
		_msgWord = "Global";
		_pos = if (!isNil SVAR(GlobalRallypoint)) then { getPos GVAR(GlobalRallypoint) } else { [] };
	};
};
	
if (_pos isEqualTo []) exitWith {
	hint parseText format [
		"<t size='1.5' color='#FFD000' shadow='1'>Rallypoint</t><br /><br />%1 rallypoint is NOT AVAILABLE"
		, _msgWord
	];
};
	
// --- Safe move to new position
1000 cutText ["Re-deploying","BLACK OUT",1];
player allowDamage false;
sleep 2; 
openMap false;
moveOut player;
player setVelocity [0,0,0];
player setPos _pos;
1000 cutText ["Re-deploying","BLACK IN",1];
sleep 2;
player allowDamage true; 

[player, 4] call GVAR(fnc_logUserAction);