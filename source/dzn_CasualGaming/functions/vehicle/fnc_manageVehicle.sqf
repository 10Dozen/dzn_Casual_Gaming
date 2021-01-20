#include "..\..\macro.hpp"
#define SELF GVAR(fnc_manageVehicle)
#define QSELF SVAR(fnc_manageVehicle)

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

params ["_mode", ["_args",[]]];

private _title = "";
private _veh = vehicle player;
private _result = -1;

["Invoked. Mode: %1, Params: %2", _mode, _args] call CGV_Log;

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
		[player, 16] call GVAR(fnc_logUserAction);
	};
	case "LAND": {
		openMap false;

		_veh allowDamage false;
		_veh setVelocityModelSpace [0, 0, 0];

		private _pos = getPos _veh;
		_veh setPos [_pos # 0, _pos # 1, 2];

		[{_this allowDamage true}, _veh, 1] call CBA_fnc_waitAndExecute;

		_title = "Landed";
		[player, 21] call GVAR(fnc_logUserAction);
	};
	case "HOVER_TOGGLE": {
		openMap false;

		if (isNil SVAR(VehicleHover_PFH)) then {
			_title = "Auto-hover is ON";

			private _modelPos = getPosASL _veh; 
			private _modelVector = [vectorDir _veh, vectorUp _veh];

			["Model alt: %1, Model vector: %2", _modelPos, _modelVector] call CGV_Log;

			GVAR(VehicleHover_PFH) = [{
				(_this # 0) params ["_veh","_pos","_vector"];
				
				_veh setPosASL _modelPos;
				_veh setVectorDirAndUp _vector;
				_veh setVelocity [0, 0, 0];
			}, nil, [_veh, _modelPos, _modelVector]] call CBA_fnc_addPerFrameHandler;
		} else {
			_title = "Auto-hover is OFF";
			if (isNil SVAR(VehicleMenu)) then {
				GVAR(VehicleMenu) = [
					["RELEASE SPEED", true]
					,["100 kph", [2],"",-5,[["expression",format["['HOVER_RELEASE', 100] call %1", QSELF]]], "1","1"]
					,["0 kph", [3],"",-5,[["expression",format["['HOVER_RELEASE', 0] call %1", QSELF]]], "1","1"]
					,["50 kph", [4],"",-5,[["expression",format["['HOVER_RELEASE', 50] call %1", QSELF]]], "1","1"]
					,["200 kph", [5],"",-5,[["expression",format["['HOVER_RELEASE', 200] call %1", QSELF]]], "1","1"]
					,["400 kph", [6],"",-5,[["expression",format["['HOVER_RELEASE', 400] call %1", QSELF]]], "1","1"]
				];
			};

			showCommandingMenu format ["#USER:%1", SVAR(VehicleMenu)];
		};
		
		[player, 22] call GVAR(fnc_logUserAction);
	};
	case "HOVER_RELEASE": {
		// --- Conversion from KPH to M/S
		private _velocity = _args * 1000 / 3600;

		[GVAR(VehicleHover_PFH)] call CBA_fnc_removePerFrameHandler;
		GVAR(VehicleHover_PFH) = nil;

		[{
			private _veh = vehicle player;
			// --- Removes vehicle flip and adds speed
			_veh setPos (getPos _veh);
			_veh setVelocityModelSpace [0, _this, 2];
		}, _velocity] call CBA_fnc_execNextFrame;
	};
	case "CHANGE_SEAT_MENU": {
		// --- Get all empty seats
		private _seats = ["GET_EMPTY_SEATS"] call SELF;

		// --- Format menu
		GVAR(ChangeSeatsMenu) = [["CHANGE SEAT", true]];
		{
			_x params ["","_role","_cargoID","_turretID","_isFFV"];

			private ["_actionTitle"];
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
			private _actionArgs = [_role, _cargoID, _turretID];

			GVAR(ChangeSeatsMenu) pushBack [
				_actionTitle
				, [2 + _forEachIndex]
				,"",-5
				,[["expression", format ["['CHANGE_SEAT', %2] call %1", QSELF, _actionArgs]]]
				,"1"
				,"1"
			];
		} forEach _seats;

		showCommandingMenu format ["#USER:%1", SVAR(ChangeSeatsMenu)];
		_title = "Select seat!";
	};
	case "CHANGE_SEAT": {
		_args params ["_role", "_cargoID", "_turretID"];

		// -- Get empty seats and verify that seat selected by player is still empty
		private _seats = ["GET_EMPTY_SEATS"] call SELF;
		private _hasTargetSeat = _seats findIf {
			_x params ["","_xrole","_xcid","_xtid"];
			_xrole isEqualTo _role && _xcid isEqualTo _cargoID && _xtid isEqualTo _turretID
		};

		if (_hasTargetSeat < 0) exitWith {
			_title = "Selected seat is OCCUPIED!";
		};

		// --- Move out and move in player
		GVAR(vehicleEngineOn) = isEngineOn _veh;
		openMap false;
		player allowDamage false;
		moveOut player;

		// --- Move in
		[
			{
				_this params ["_veh","_args"];
				_args params ["_role", "_cargoID", "_turretID"];

				switch (toLower _role) do {
					case "driver": { player moveInDriver _veh; };
					case "cargo": { player moveInCargo [_veh, _cargoID] };
					case "gunner";
					case "turret": { 
						if (_turretID isEqualTo []) then {
							player moveInGunner _veh;
						} else {
							player moveInTurret [_veh, _turretID]; 
						};
					};
				};

				if (GVAR(vehicleEngineOn)) then {
					_veh engineOn true;
				};

				[{player allowDamage false;}, 0.5] call CBA_fnc_execNextFrame;
			}
			, [_veh, _args]
		] call CBA_fnc_execNextFrame;
		
		_title = "Seat changed!";
	};
	case "GET_EMPTY_SEATS": {
		_result = []
			+ fullCrew [_veh, "driver", true] 
			+ fullCrew [_veh, "gunner", true]
			+ fullCrew [_veh, "turret", true]
			+ fullCrew [_veh, "cargo", true] 
			- fullCrew _veh;
	};
};

if !(_title isEqualTo "") then {
	hint parseText format ["<t size='1.5' color='#FFD000' shadow='1'>Vehicle Service</t><br /><br />%1", _title];
};

_result