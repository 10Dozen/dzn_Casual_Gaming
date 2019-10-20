#include "..\..\macro.hpp"

/* ----------------------------------------------------------------------------
Function: dzn_CasualGaming_fnc_removeRallypoint

Description:
	Deletes rallypoint.

Parameters:
	_modeID -- rallypoint type (0,1: Personal rallypoint; 2: Global side rallypoint )

Returns:
	none

Examples:
    (begin example)
		[2] call dzn_CasualGaming_fnc_removeRallypoint; // Deletes global rallypoint
    (end)

Author:
	10Dozen
---------------------------------------------------------------------------- */

params["_modeID"];

private _namespace = "";
private _rpMrkName = "";
private _rpName = "";
private _rpDisplayName = "";

switch (_modeID) do {
	case 0;
	case 1: {
		_namespace = player;
		_rpMrkName = SVAR(RallypointMrk);
		_rpName = SVAR(Rallypoint);
		_rpDisplayName = "Rallypoint";		
	};
	case 2: {
		_namespace = missionNamespace;
		_rpMrkName = SVAR(globalRallypointMrk);
		_rpName = SVAR(GlobalRallypoint);
		_rpDisplayName = "Global Rallypoint";
	};
};

// --- Nulify rallypoint related info 
if !(isNull (_namespace getVariable [_rpName, objNull])) then {
	deleteVehicle (_namespace getVariable _rpName);
	_namespace setVariable [_rpName, nil, true];
};

// --- Deletes marker
deleteMarker _rpMrkName;

hint parseText format [
	"<t size='1.5' color='#FFD000' shadow='1'>%1</t><br /><br />Removed"
	, _rpDisplayName
];

[player, 23] call GVAR(fnc_logUserAction);