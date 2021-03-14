#include "..\..\macro.hpp"
#include "..\rallypoint\defines.hpp"
#include "..\main\reasons.hpp"

#define SELF FUNC(manageVehicle)
#define QSELF QFUNC(manageVehicle)

/* ----------------------------------------------------------------------------
Function: dzn_CasualGaming_fnc_manageVehicle

Description:
	Apply service action to vehicle:
		- full repair "REPAIR"
		- full refuel "REFUEL"
		- full rearm "REARM"
		- add AI driver "DRIVER_ADD"
		- remove AI driver "DRIVER_REMOVE"
		- set in flight "SET_IN_FLIGHT" in different altitudes
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
		["REFUEL"] call dzn_CasualGaming_fnc_manageVehicle; // refuels vehicle
    (end)

Author:
	10Dozen
---------------------------------------------------------------------------- */

#define CHECK_FOR_VEHICLE_IN_ARGS  if (typename _args == typename objNull) then { _veh = _args; }
#define PUBLIC_METHODS [ \
	"GET_SEATS_OPTIONS", \
	"GET_MOVEOUT_OPTIONS", \
	"IS_HOVER_ENABLED", \
	"HOVER_ENABLE", \
	"HOVER_DISABLE" \
]

params ["_mode", ["_args",[]]];

private _title = "";
private _veh = vehicle player;
private _result = -1;

// ["Invoked. Mode: %1, Params: %2", _mode, _args] call CGV_Log;

if (_veh isEqualTo player && !(_mode in PUBLIC_METHODS)) exitWith {
	hint parseText "<t size='1.5' color='#FFD000' shadow='1'>Vehicle Service</t><br /><br />Player is not in vehicle!";
};
	
switch (toUpper _mode) do {
	case "REPAIR": {
		_title = "Repaired";
		_veh setDamage 0;
		[player, REASON_VEHICLE_REPAIR] call FUNC(logUserAction);
	};
	case "REFUEL": {
		_title = "Refueled";
		_veh setFuel 1;
		[player, REASON_VEHICLE_REFUEL] call FUNC(logUserAction);
	};
	case "REARM": {
		_title = "Rearmed";
		_veh setVehicleAmmo 1;
		[player, REASON_VEHICLE_REARM] call FUNC(logUserAction);
	};
	case "DRIVER_ADD": {
		if (!isNull (driver _veh)) exitWith {
			_title = "Driver NOT added. Driver place is already occupied!";
		};
		if (side player isEqualTo sideEnemy) exitWith {
			_title = "Driver NOT added. Player's rating is too low!";
		};

		_title = "Driver added";

		private _grp = createGroup (side player);
		private _u = _grp createUnit [typeof player, getPos _veh, [], 0, "FORM"];
		_u assignAsDriver _veh;
		_u moveInDriver _veh;

		[
			{
				params ["_veh","_u"];
				if (driver _veh isEqualTo _u) then {
					_veh setVariable [SVAR(AIDriver), _u];
					_u setUnitLoadout (getUnitLoadout player);
				} else {
					deleteVehicle _u;
					deleteGroup _grp;
					hint parseText "<t size='1.5' color='#FFD000' shadow='1'>Vehicle Service</t><br /><br />Failed to add driver (no seat?)"; 
				};
			},
			[_veh, _u, _grp]
		] call CBA_fnc_execNextFrame;

		[player, REASON_VEHICLE_DRIVER_ADDED] call FUNC(logUserAction);
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

		[player, REASON_VEHICLE_DRIVER_REMOVED] call FUNC(logUserAction);
	};
	case "SET_IN_FLIGHT": {
		openMap false;

		private _altitude = [_args, 50] select (_args isEqualTo []);
		private _velocity = velocityModelSpace _veh;
		private _pos = getPos _veh;
		private _currentAltitude = _pos # 2;
		private _terrainHeight = getTerrainHeightASL _pos;

		_pos set [2, _altitude];

		_veh engineOn true;
		_veh setVehiclePosition [_pos, [], 0, "FLY"];
		_veh setPos _pos;

		if (getPos _veh # 2 < 10) exitWith { 
			// --- Avoid adding speed if something gone wrong during setting altitude
			_title = "Set In Flight -- Aborted"; 
		};
		
		private _minVelocity = ([80, 300] select (_veh isKindOf "Plane")) * 1000/3600;
		if (_currentAltitude < 20 || (_velocity # 1) < _minVelocity) then {
			// --- Update velocity if wasn't in air
			_veh setVelocityModelSpace [0, (_velocity # 1) + _minVelocity, 0];
		} else {
			// --- Restore velocity if already in air
			_veh setVelocityModelSpace _velocity;
		};

		_title = "Set In Flight";
		[player, REASON_VEHICLE_SET_IN_AIR] call FUNC(logUserAction);
	};
	case "LAND": {
		openMap false;

		_veh allowDamage false;
		_veh setVelocityModelSpace [0, 0, 0];

		private _pos = getPos _veh;
		_veh setPos [_pos # 0, _pos # 1, 2];

		[{_this allowDamage true}, _veh, 1] call CBA_fnc_waitAndExecute;

		_title = "Landed";
		[player, REASON_VEHICLE_LANDED] call FUNC(logUserAction);
	};
	case "HOVER_TOGGLE": {
		openMap false;

		if (_veh getVariable [SVAR(Vehicle_HoverPFH), -1] < 0) then {
			["HOVER_ENABLE", _veh] call SELF;
			_title = "Auto-hover is ON";
		} else {
			private _storedSpeed = _veh getVariable [SVAR(Vehicle_SpeedBeforeHover), -999];
			private _options = [];
			if (_storedSpeed != -999) then {
				_options pushBack round(_storedSpeed);
			};
			_options = _options + [0, 50, 100, 200, 400];

			[
				"RELEASE SPEED",
				'["HOVER_DISABLE", _args] call ' + QSELF,
				_options apply { format ["%1 kph", _x] },
				_options apply { [_veh, _x] }
			] call FUNC(vehicle_showMenu);

			_title = "Auto-hover is OFF";
		};
		
		[player, REASON_VEHICLE_HOVER_TOGGLED] call FUNC(logUserAction);
	};
	case "CHANGE_SEAT_MENU": {
		CHECK_FOR_VEHICLE_IN_ARGS;

		private _options = ["GET_SEATS_OPTIONS", _veh] call SELF;
		[
			"CHANGE SEAT",
			'["CHANGE_SEAT", _args] call ' + QSELF,
			_options apply { _x # 0 },
			_options
		] call FUNC(vehicle_showMenu);

		_title = "Select seat!";
	};
	case "LEAVE_VEHICLE": {
		private _options = ["GET_MOVEOUT_OPTIONS", _veh] call SELF;
		
		[
			"MOVE OUT TO",
			'["SELECT_MOVEOUT_MENU_ACTION", _args] call ' + QSELF,
			_options apply { _x # 1 },
			_options
		] call FUNC(vehicle_showMenu);

		_title = "Select position to leave.<br />Note: Hovering will NOT be disabled!";
	};

	case "IS_HOVER_ENABLED": {
		_veh = _args;

		_result = _veh getVariable [SVAR(Vehicle_HoverPFH), -1] > -1;
	};
	case "HOVER_ENABLE": {
		_veh = _args;

		// --- Exit if already in hover 
		if (["IS_HOVER_ENABLED", _veh] call SELF) exitWith {};

		// --- Save position and tilt
		private _modelPos = getPosASL _veh; 
		private _modelVector = [vectorDir _veh, vectorUp _veh];

		// --- Save velocity
		_veh setVariable [SVAR(Vehicle_SpeedBeforeHover), speed _veh, true];

		if (local _veh) then {
			[_veh, _modelPos, _modelVector] call FUNC(vehicle_addHoverPFH);
		} else {
			[QFUNC(vehicle_addHoverPFH)] call FUNC(publishFunction);
			[_veh, _modelPos, _modelVector] remoteExec [QFUNC(vehicle_addHoverPFH), _veh];
		};
	};
	case "HOVER_DISABLE": {
		_args params [
			"_veh", 
			["_releaseSpeed", (_args # 0) getVariable [SVAR(Vehicle_SpeedBeforeHover), 0]]
		];

		// --- Remove per frame handler
		private _pfhID = _veh getVariable [SVAR(Vehicle_HoverPFH), -1];
		if (_pfhID < 0) exitWith {};

		private _pfhOwner = _veh getVariable [SVAR(Vehicle_HoverPFH_Owner), clientOwner];
		if (_pfhOwner isEqualTo clientOwner) then {
			[_pfhID] call CBA_fnc_removePerFrameHandler;
		} else {
			[_pfhID] remoteExec ["CBA_fnc_removePerFrameHandler", _pfhOwner];
		};
		_veh setVariable [SVAR(Vehicle_HoverPFH), nil, true];

		// --- Conversion from KPH to M/S
		private _speed = _releaseSpeed * 1000 / 3600;
		if (local _veh) then {
			[_veh, _speed] call FUNC(vehicle_releaseHover);
		} else {
			[QFUNC(vehicle_releaseHover)] call FUNC(publishFunction);
			[_veh, _speed] remoteExec [QFUNC(vehicle_releaseHover), _veh];
		};
	};
	case "CHANGE_SEAT": {
		_args params ["_title", "_vehicle", "_role", "_cargoID", "_turretID"];

		[_vehicle, _role, _cargoID, _turretID] call FUNC(vehicle_changeSeat);

		_title = format ["Seat changed to [%1]!", _title];
	};
	case "SELECT_MOVEOUT_MENU_ACTION": {
		_args params ["_veh", "", "_pos"];
		[player, _pos] call FUNC(safeMove);

		// --- Report LEAVE action
		[player, REASON_VEHICLE_LEAVED] call FUNC(logUserAction);
	};

	case "GET_SEATS_OPTIONS": {
		_veh = _args;
		private _seats = [_veh] call FUNC(vehicle_getEmptySeats);
		
		_result = [];
		{
			_x params ["","_role","_cargoID","_turretID","_isFFV"];
			private _actionTitle = "";

			if (_cargoID > -1) then {
				// --- Cargo
				if (_isFFV) then {
					_actionTitle = format ["CARGO / FFV %1", _turretID];
				} else {
					_actionTitle = format ["%1 %2", toUpper _role, _cargoID];
				};
			} else {
				if (_turretID isEqualTo []) then {
					// --- Driver
					_actionTitle = format ["%1", toUpper _role];
				} else {
					// --- Turret
					_actionTitle = format ["%1 %2", toUpper _role, _turretID];
				};
			};
			_result pushBack [_actionTitle, _veh, _role, _cargoID, _turretID];
		} forEach _seats;
	};
	case "GET_MOVEOUT_OPTIONS": {
		_veh = _args;
		_result = [];

		// --- Current position or current position, but at 0m
		_result pushBack [_veh, "Current position 0m",  { private _pos = getPos (call CBA_fnc_currentUnit); [_pos # 0, _pos # 1, 0] }];
		_result pushBack [_veh, "Eject", { getPos (call CBA_fnc_currentUnit) }];

		// -- Rallypoint positions 
		{
			if (["CHECK_EXISTS", _x # 1] call FUNC(manageRallypoint)) then {
				_result pushBack [_veh, _x # 0, getPos (["GET", _x # 1] call FUNC(manageRallypoint))];
			};
		} forEach [
			["My rallypoint", RP_CUSTOM],
			["Squad rallypoint", RP_SQUAD],
			["Global rallypoint", RP_GLOBAL]
		];
	};
};

if !(_title isEqualTo "") then {
	hint parseText format ["<t size='1.5' color='#FFD000' shadow='1'>Vehicle Service</t><br /><br />%1", _title];
};


// ["Finished. Mode: %1, Params: %2, Result: %3", _mode, _args, [_result, "Success"] select (_result isEqualTo -1)] call CGV_Log;

_result
