#include "..\..\macro.hpp"

/* ----------------------------------------------------------------------------
Function: dzn_CasualGaming_fnc_vehicle_changeSeat

Description:
	Return list of empty positions in vehicle

Parameters:
	_vehicle -- vehicle to change seat in <OBJECT>
	_role -- selected role <STRING>
	_cargoID -- cargo seat <NUMBER>
	_turretID -- turret path <NUMBER or ARRAY>

Returns:
	none

Examples:
    (begin example)
		[vehicle, "driver", -1, []] call dzn_CasualGaming_fnc_vehicle_changeSeat;
    (end)

Author:
	10Dozen
---------------------------------------------------------------------------- */

params ["_vehicle", "_role", "_cargoID", "_turretID"];

// -- Get empty seats and verify that seat selected by player is still empty
private _seats = [_vehicle] call FUNC(vehicle_getEmptySeats);
private _hasTargetSeat = _seats findIf {
	_x params ["","_xrole","_xcid","_xtid"];
	_xrole isEqualTo _role && _xcid isEqualTo _cargoID && _xtid isEqualTo _turretID
};

if (_hasTargetSeat < 0) exitWith {
	_title = "Selected seat is OCCUPIED!";
};

// --- Move out and move in player
_vehicle setVariable [SVAR(EngineOn), isEngineOn _vehicle];

openMap false;
player allowDamage false;
moveOut player;

// --- Move in
[
	{
		_this params ["_vehicle", "_role", "_cargoID", "_turretID"];

		switch (toLower _role) do {
			case "driver": { player moveInDriver _vehicle; };
			case "cargo": { player moveInCargo [_vehicle, _cargoID] };
			case "gunner";
			case "turret": { 
				if (_turretID isEqualTo []) then {
					player moveInGunner _vehicle;
				} else {
					player moveInTurret [_vehicle, _turretID]; 
				};
			};
		};

		if (_vehicle getVariable [SVAR(EngineOn), true]) then {
			_vehicle setVariable [SVAR(EngineOn), nil];
			_vehicle engineOn true;
		};

		[{player allowDamage false;}, 0.5] call CBA_fnc_execNextFrame;
	}
	, _this
] call CBA_fnc_execNextFrame;
