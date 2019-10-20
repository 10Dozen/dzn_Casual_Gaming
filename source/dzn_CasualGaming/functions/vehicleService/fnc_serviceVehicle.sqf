#include "..\..\macro.hpp"
#define SELF GVAR(fnc_serviceVehicle)

/* ----------------------------------------------------------------------------
Function: dzn_CasualGaming_fnc_serviceVehicle

Description:
	Apply service action to vehicle:
		- full repair "REPAIR"
		- full refuel "REFUEL"
		- full rearm "REARM"
		- add AI driver "DRIVER_ADD"
		- remove AI driver "DRIVER_REMOVE"
		- set in flight "SET_IN_FLIGHT"
		- land "LAND"
		- hover "HOVER_TOGGLE"
		- switch between seats "CHANGE_SEAT_ACTION_ADD"/"CHANGE_SEAT_ACTION_REMOVE"

Parameters:
	_mode -- service modes <STRING>
	_args -- (optional) call arguments <ARRAY>

Returns:
	none

Examples:
    (begin example)
		["REFUEL"] call dzn_CasualGaming_fnc_serviceVehicle; // refuels vehicle
    (end)

Author:
	10Dozen
---------------------------------------------------------------------------- */

params ["_mode", ["_args",[]]];

private _title = "";
private _veh = vehicle player;

if (_veh isEqualTo player) exitWith {
	hint parseText "<t size='1.5' color='#FFD000' shadow='1'>Vehicle Service</t><br /><br />Player is not in vehicle!";
};
	
switch (toUpper _mode) do {
	case "REPAIR": {
		_title = "Repaired";
		_veh setDamage 0;
		[player, 12] call GVAR(fnc_logUserAction);
	};
	case "REFUEL": {
		_title = "Refueled";
		_veh setFuel 1;
		[player, 13] call GVAR(fnc_logUserAction);
	};
	case "REARM": {
		_title = "Rearmed";
		_veh setVehicleAmmo 1;
		[player, 14] call GVAR(fnc_logUserAction);
	};
	case "DRIVER_ADD": {
		if (!isNull (driver _veh)) exitWith {
			_title = "Driver NOT added. Driver place is already occupied!";
		};

		_title = "Driver added";
		private _grp = createGroup (side player);
		private _u = _grp createUnit [typeof player, getPos _veh, [], 0, "FORM"];
		_u setUnitLoadout (getUnitLoadout player);
		_u assignAsDriver _veh;
		_u moveInDriver _veh;
		_veh setVariable [SVAR(AIDriver), _u];

		[player, 15] call GVAR(fnc_logUserAction);
	};
	case "DRIVER_REMOVE": {
		_title = "Driver removed";
		private _driver = driver _veh;
		if (!isNull _driver && {!isPlayer _driver}) then {
			// --- Delete current AI driver of current vehicle
			moveOut _driver;
			_veh deleteVehicleCrew _driver;
		} else {
			// --- Delete AI unit if there is no AI on driver seat: unit was moved out for some reason
			private _assignedDriver = _veh getVariable [SVAR(AIDriver), objNull];
			if (!isNull _assignedDriver) then { deleteVehicle _assignedDriver; };
			_veh setVariable [SVAR(AIDriver), nil];
		};

		[player,20] call GVAR(fnc_logUserAction);
	};
	case "SET_IN_FLIGHT": {
		openMap false;

		_veh engineOn true;
		[_veh, 200, 2] call CBA_fnc_setHeight;
		if (getPosASL _veh # 2 < 10) exitWith { _title = "Set In Flight -- Aborted"; };
		
		_veh setVelocityModelSpace [0, if (_veh isKindOf "Plane") then { 150 } else { 50 }, 0];
	
		_title = "Set In Flight";
		[player, 16] call GVAR(fnc_logUserAction);
	};
	case "LAND": {
		openMap false;

		_veh allowDamage false;
		_veh setVelocityModelSpace [0, 0, 0];
		[_veh, 0.5, 2] call CBA_fnc_setHeight;

		[{vehicle player allowDamage true}, [], 1] call CBA_fnc_waitAndExecute;

		_title = "Landed";
		[player, 21] call GVAR(fnc_logUserAction);
	};
	case "HOVER_TOGGLE": {
		openMap false;

		if (isNil SVAR(VehicleHover_PFH)) then {
			_title = "Auto-hover is ON";

			GVAR(VehicleHover_PFH) = [{
				private _veh = vehicle player;
				
				[_veh, getPosATL _veh # 2, 2] call CBA_fnc_setHeight;
				_veh setVelocityModelSpace [0, 0, 0];
			}] call CBA_fnc_addPerFrameHandler;
		} else {
			_title = "Auto-hover is OFF";
			[GVAR(VehicleHover_PFH)] call CBA_fnc_removePerFrameHandler;
			GVAR(VehicleHover_PFH) = nil;
		};
		
		[player, 22] call GVAR(fnc_logUserAction);
	};
	case "CHANGE_SEAT_ACTION_ADD": {
		// --- Get all empty seats
		private _seats = []
			+ fullCrew [_veh, "driver", true] 
			+ fullCrew [_veh, "gunner", true]
			+ fullCrew [_veh, "turret", true]
			+ fullCrew [_veh, "cargo", true] 
			- fullCrew _veh;

		// --- Clear old actions and add new 
		["CHANGE_SEAT_ACTION_REMOVE"] call SELF;

		GVAR(ChangeSeatsActionsVehicle) = _veh;
		GVAR(ChangeSeatsActions) = [];
		{
			_x params ["","_role","_cargoID","_turretID"];

			private ["_actionTitle"];
			if (_cargoID > -1) then {
				_actionTitle = format ["[ Move in %1 %2 ]", toUpper _role, _cargoID];
			} else {
				if (_turretID isEqualTo []) then {
					_actionTitle = format ["[ Move in %1 ]", toUpper _role];
				} else {
					_actionTitle = format ["[ Move in %1 %2 ]", toUpper _role, _turretID];
				};
			};

			private _action = _veh addAction [
				format ["<t color='#FF6633'>%1</t>", _actionTitle]
				, {	["CHANGE_SEAT", _this # 3] call SELF; }
				, [_role, _cargoID, _turretID], 6, true, true
			];

			GVAR(ChangeSeatsActions) pushBack _action;
		} forEach _seats;

		_title = "Change seat actions added!";
	};
	case "CHANGE_SEAT_ACTION_REMOVE": {
		if (isNil SVAR(ChangeSeatsActions)) exitWith {};

		{
			GVAR(ChangeSeatsActionsVehicle) removeAction _x;
		} forEach GVAR(ChangeSeatsActions);

		GVAR(ChangeSeatsActions) = nil;
		GVAR(ChangeSeatsActionsVehicle) = nil;

		_title = "Change seat actions removed!";
	};
	case "CHANGE_SEAT": {
		// --- Move out and move in player
		player allowDamage false;
		moveOut player;

		// --- Move in
		[
			{
				_this params ["_veh","_args"];
				_args params ["_role", "_cargoID", "_turretID"];

				switch (toLower _role) do {
					case "driver": { player moveInDriver _veh; };
					case "gunner": { player moveInGunner _veh; };
					case "turret": { player moveInTurret [_veh, _turretID]; };
					case "cargo": { player moveInCargo [_veh, _cargoID] };
				};

				[{
					player allowDamage false;
					["CHANGE_SEAT_ACTION_ADD"] call SELF;
				}, 0.5] call CBA_fnc_execNextFrame;
			}
			, [_veh, _args]
		] call CBA_fnc_execNextFrame;

		// --- Re-add actions to exclude new player's position and add previous to actions
		
		_title = "Seat changed!";
	};
};

hint parseText format [
	"<t size='1.5' color='#FFD000' shadow='1'>Vehicle Service</t><br /><br />%1"
	, toUpper(_title)
];
