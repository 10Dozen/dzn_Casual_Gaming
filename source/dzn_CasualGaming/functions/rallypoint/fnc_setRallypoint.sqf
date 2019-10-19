#include "..\..\macro.hpp"

/* ----------------------------------------------------------------------------
Function: dzn_CasualGaming_fnc_setRallypoint

Description:
	Creates/moves rallypoint to player's position.

Parameters:
	_modeID -- rallypoint type (0,1: Personal rallypoint; 2: Global side rallypoint )

Returns:
	none

Examples:
    (begin example)
		[2] call dzn_CasualGaming_fnc_setRallypoint; // Creates global rallypoint on player's position
    (end)

Author:
	10Dozen
---------------------------------------------------------------------------- */

params["_modeID"];

private _pos = getPos player;
private _namespace = "";
private _rpMrkName = "";
private _rpName = "";
private _rpDisplayName = "";
private _publish = false;

switch (_modeID) do {
	case 0;
	case 1: {
		player setVariable [SVAR(RallypointPos), _pos, true];
		
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
		_publish = true;
	};
};

if (isNull (_namespace getVariable [_rpName, objNull])) then {		
	_namespace setVariable [_rpName, GVAR(RallyPointClass) createVehicle _pos, _publish];

	call compile format [
		'createMarker%1 ["%2", _pos];
		"%2" setMarkerShape "ICON";
		"%2" setMarkerType%1 "mil_pickup";
		"%2" setMarkerAlpha%1 0.5;
		"%2" setMarkerColor%1 "ColorUNKNOWN";
		"%2" setMarkerText%1 "%3";'
		, if (_publish) then { "" } else { "Local" }
		, _rpMrkName
		, _rpDisplayName
	];		
} else {
	(_namespace getVariable _rpName) setPos _pos;
	_rpMrkName setMarkerPos _pos;
};

hint parseText format [
	"<t size='1.5' color='#FFD000' shadow='1'>%1</t><br /><br />Set at grid %2"
	, _rpDisplayName
	, mapGridPosition _pos
];

[player, 5] call GVAR(fnc_logUserAction);