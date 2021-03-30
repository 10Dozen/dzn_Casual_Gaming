#include "..\..\macro.hpp"
#include "..\main\reasons.hpp"
#include "..\auth\permission_map.hpp"
#include "defines.hpp"

#define SELF FUNC(manageRallypoint)
#define QSELF QFUNC(manageRallypoint)

/* ----------------------------------------------------------------------------
Function: dzn_CasualGaming_fnc_manageRallypoint

Description:
	Manage personal, squad and global rallypoints:
		- create rallypoints
		- delete rallypoints
		- safe move to selected rallypoint

Parameters:
	_mode -- mode <STRING>
	_args -- (optional) call arguments <ARRAY>

Returns:
	none

Examples:
    (begin example)
		// creates global rallypoint
		["CREATE", "global"] call dzn_CasualGaming_fnc_manageRallypoint;
    (end)

Author:
	10Dozen
---------------------------------------------------------------------------- */

params ["_mode", ["_args",[]]];

private _title = "";
private _result = -1;

switch toUpper(_mode) do {
	case "INIT": {
		GVAR(RallyPointClass) = "Pole_F";
		if !(["CHECK_PERMISSION", PERM_RALLYPOINT] call FUNC(manageAuth)) exitWith {};
		[] call FUNC(addRallypointActionsToACE);
	};
	case "SET": {
		private _type = _args;
		private _pos = getPos (call CBA_fnc_currentUnit);
		private _settings = ["GET_SETTINGS", _type] call SELF;

		if (["CHECK_EXISTS", _type] call SELF) then {
			["UPDATE", [_pos, _settings]] call SELF;
		} else {
			["CREATE", [_pos, _settings]] call SELF;
		};

		_title = format [
			"<t color='#FFD033' shadow='1'>%1</t> set at grid %2"
			, ["GET_NAME_BY_TYPE", _type] call SELF
			, mapGridPosition _pos
		];

		[player, REASON_RALLYPOINT_SET] call FUNC(logUserAction);
	};
	case "CREATE": {
		private _pos = _args # 0;
		(_args # 1) params ["_rpDisplayName", "_namespace", "_rpMarkerName", "_rpVarName", "_public"];

		_namespace setVariable [_rpVarName, GVAR(RallyPointClass) createVehicle _pos, _public];

		call compile format [
			'createMarker%1 ["%2", _pos];
			"%2" setMarkerShape "ICON";
			"%2" setMarkerType%1 "mil_pickup";
			"%2" setMarkerAlpha%1 0.5;
			"%2" setMarkerColor%1 "ColorUNKNOWN";
			"%2" setMarkerText%1 "%3";'
			, if (_public) then { "" } else { "Local" }
			, _rpMarkerName
			, _rpDisplayName
		];
	};
	case "UPDATE": {
		private _pos = _args # 0;
		(_args # 1) params ["", "_namespace", "_rpMarkerName", "_rpVarName"];

		(_namespace getVariable _rpVarName) setPos _pos;
		_rpMarkerName setMarkerPos _pos;
	};
	case "REMOVE": {
		private _type = _args;
		private _settings = ["GET_SETTINGS", _type] call SELF;
		_settings params ["", "_namespace", "_rpMarkerName", "_rpVarName"];

		// --- Nulify rallypoint related info
		if !(isNull (_namespace getVariable [_rpVarName, objNull])) then {
			deleteVehicle (_namespace getVariable _rpVarName);
			_namespace setVariable [_rpVarName, nil, true];
		};

		// --- Deletes marker
		deleteMarker _rpMarkerName;

		_title = format [
			"<t color='#FFD000' shadow='1'>%1</t> removed"
			, ["GET_NAME_BY_TYPE", _type] call SELF
		];

		[player, REASON_RALLYPOINT_REMOVED] call FUNC(logUserAction);
	};

	case "DEPLOY_TO": {
		private _type = _args;
		private _rp = ["GET", _type] call SELF;

		if (isNull _rp) exitWith {
			_title = format [
				"<t color='#FFD000' shadow='1'>%1</t> is NOT AVAILABLE"
				, ["GET_NAME_BY_TYPE", _type] call SELF
			];
		};

		[call CBA_fnc_currentUnit, getPos _rp] spawn FUNC(safeMove);
		[player, REASON_RALLYPOINT_DEPLOYED] call FUNC(logUserAction);
	};
	case "CHECK_EXISTS": {
		private _type = _args;
		private _rp = ["GET", _type] call SELF;
		_result = !isNull _rp;
	};

	case "GET": {
		private _type = _args;

		(switch toLower(_type) do {
			case RP_GLOBAL: {
				[missionNamespace, SVAR(GlobalRallypoint)]
			};
			case RP_SQUAD: {
				[(leader group call CBA_fnc_currentUnit), SVAR(Rallypoint)]
			};
			default {
				[call CBA_fnc_currentUnit, SVAR(Rallypoint)]
			};
		}) params ["_namespace", "_rpVarName"];

		_result = _namespace getVariable [_rpVarName, objNull];
	};
	case "GET_SETTINGS": {
		// Settings: "_rpDisplayName", "_namespace", "_rpMarkerName", "_rpVarName", "_public"
		_result = switch toLower(_args) do {
			case RP_GLOBAL: {
				[
					"Global Rallypoint",
					missionNamespace,
					SVAR(GlobalRallypointMrk),
					SVAR(GlobalRallypoint),
					true
				]
			};
			default {
				[
					"Rallypoint",
					call CBA_fnc_currentUnit,
					SVAR(RallypointMrk),
					SVAR(Rallypoint),
					false
				]
			};
		};
	};
	case "GET_NAME_BY_TYPE": {
		_result = format [
			"%1 Rallypoint",
			switch toLower(_args) do {
				case RP_GLOBAL: { "Global" };
				case RP_SQUAD: { "Squad" };
				default { "My" };
			}
		];
	};
};


if !(_title isEqualTo "") then {
	hint parseText format ["<t size='1.5' color='#FFD000' shadow='1'>Rallypoints</t><br /><br />%1", _title];
};

_result
