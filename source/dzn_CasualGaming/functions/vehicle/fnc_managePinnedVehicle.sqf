#include "..\..\macro.hpp"
#include "..\main\reasons.hpp"

#define SELF FUNC(managePinnedVehicle)
#define QSELF QFUNC(managePinnedVehicle)

/* ----------------------------------------------------------------------------
Function: dzn_CasualGaming_fnc_managePinnedVehicle

Description:
	Manage Pinned Vehicle feature:
		- Pin vehicle
		- Clear pin
		- Use vehicle
		- Disable vehicle
		- Enable vehicle
		- Show vehicle info
		- inner functions

Parameters:
	_mode -- modes <STRING>
	_args -- (optional) call arguments <ARRAY>

Returns:
	none

Examples:
	(begin example)
		["USE", 1] call dzn_CasualGaming_fnc_managePinnedVehicle; // moves user in the vehicle at slot 1
	(end)

Author:
	10Dozen
---------------------------------------------------------------------------- */


/*
- Vehicle shortcut:
+  - 5 slots for vehicles that player can access during mission
+  - Player is able to save (PIN) his current vehicle to this slot 
+  - Player is able to unpin vehicle from slot
+  - Player is able to then Disable the vehicle - it will be removed from the game (hidden/disableSimul)
  - On disable vehicle:
+  -  saves current mission position & velocity (for arial) (simply disables simulation and hides - vic remains the same position)
F  -  abort if there are other players in vehicle
+  -  if player is currently in the vehicle pinned to slot - player become moved out 
+  -  on move out - show menu with options: teleport to my rally, to squad rally, to global rally, no teleport, to ground position under 
+  -  AI units become disabled and hidden if needed
  - Player is able to then Enable the vehicle: vehicle will be shown and enableSimul
  - On enable: 
+  -  ai in the vehicle will be enabled
+  -  before enabling player will be promted with menu of change seat
+  -  vehicle restore it's position, for aerial vehicles in air -- restore velocity and engine state 
+  - Player is able to select USE action for slot - on select, user will be promted with Change seat menu
+  - Player is able to select INFO action for slot - ons select user will see vehicle icon on the map and see brief info hint
+  - Each time user interact with slot - brief vehicle info will be shown in hint, including:
+  -  Vehicle display name
+  -  Vehicle type name (e.g. Car, APC, IPC, etc.)
+  -  Ammo, HP and Fuel values
+  -  For aerial vics: is vehicle is mid air or not

F  - In purpose to make feature MP-compatible - all variables related to slot should be stored in vehicle's object namespace and shared on network
    (so several users may use vehicle, enable or disable it without collision)
+  - Log user actions: USE, ENABLE, DISABLE

  - Fix all TODOs

*/

/* TESTIG:

*/

#define SLOTS_COUNT 5
#define IS_SLOTID_VALID(SLOTID) (SLOTID > 0 && SLOTID <= SLOTS_COUNT)

#define EXIT_SLOTID_INVALID(SLOTID) if !IS_SLOTID_VALID(SLOTID) exitWith { ["Exit. Invalid slot id!"] call CVP_Log; }
#define EXIT_NOT_IN_VEHICLE if (vehicle player == player) exitWith { ["Exit. Not in vehicle!"] call CVP_Log; }		
#define EXIT_NULL_SLOT if (isNull _veh) exitWith { _title = "Slot is empty"; ["Exit. Null object"] call CVP_Log;}
#define EXIT_NOT_ALIVE(VEH) if (!alive VEH) exitWith { _title = "Vehicle destroyed"; ["Exit. Destroyed"] call CVP_Log; }

#define SET_TITLE_INFO_MESSAGE(VEH, MSG) _title = format ["%1<br/>%2", ["GET_INFO",[VEH]] call SELF, MSG]

params ["_mode", ["_args",[]]];

private _title = "";
private _slotId = -1;
private _result = -1;

["Invoked. Mode: %1, Params: %2", _mode, _args] call CVP_Log;


switch toUpper(_mode) do {
	case "INIT": {
		if (isNil SVAR(PV_Slots)) then {
			private _slots = [];
			for "_i" from 1 to SLOTS_COUNT do {
				_slots pushBack objNull;
			};
			GVAR(PV_Slots) = _slots;
		};
	};

	// --- Public methods
	case "PIN": {
		EXIT_NOT_IN_VEHICLE;

		_slotId = _args;
		EXIT_SLOTID_INVALID(_slotId);
		
		private _veh = vehicle player;
		EXIT_NOT_ALIVE(_veh);

		// --- Save vehicle to slot
		GVAR(PV_Slots) set [_slotId - 1, _veh];

		// --- Grab vehicle static info 
		if (isNil {_veh getVariable SVAR(PV_NAME)}) then {
			private _class = typeof _veh;
			private _name = getText (configFile >> "CfgVehicles" >> _class >> "displayName"); 
			private _type = getText (configFile >> "CfgVehicles" >> _class >> "textSingular");

			_veh setVariable [SVAR(PV_Name), _name];
			_veh setVariable [SVAR(PV_Type), _type];
		};

		// --- Report PIN action
		[player, REASON_PINNED_VEHICLE_PINNED] call FUNC(logUserAction);

		SET_TITLE_INFO_MESSAGE(_veh, "Vehicle pinned");
	};
	case "UNPIN": {
		_slotId = _args;
		private _veh = ["GET", _slotId] call SELF;
		EXIT_NULL_SLOT;

		// --- Enable alive vehicle on unpin
		if (alive _veh && !(_veh getVariable [SVAR(PV_Enabled), true])) then {
			["ENABLE_VEHICLE_AND_CREW", _veh] call SELF;
		};
		GVAR(PV_Slots) set [_slotId - 1, objNull];

		SET_TITLE_INFO_MESSAGE(_veh, "Vehicle unpinned");
	};
	case "USE": {
		_slotId = _args;

		private _veh = ["GET", _slotId] call SELF;
		EXIT_NULL_SLOT;
		EXIT_NOT_ALIVE(_veh);

		if (_veh getVariable [SVAR(PV_Enabled), true]) then {
			private _options = ["GET_SEATS_OPTIONS", _veh] call FUNC(manageVehicle);
			[
				"SELECT SEAT",
				'["SELECT_SEAT", _args] call ' + QSELF,
				_options apply { _x # 0 },
				_options
			] call FUNC(vehicle_showMenu);

			SET_TITLE_INFO_MESSAGE(_veh, "Select seat!");
		} else {
			["SHOW_MOVE_IN_MENU", _veh] call SELF;
		};
	};
	case "DISABLE": {
		_slotId = _args;
		private _veh = ["GET", _slotId] call SELF;
		EXIT_NULL_SLOT;
		EXIT_NOT_ALIVE(_veh);

		if !(_veh getVariable [SVAR(PV_Enabled), true]) exitWith {
			_title = "[NOT POSSIBLE]<br />Vehicle is disabled already";
		};

		private _crew = crew _veh - [player];
		if (_crew findIf {isPlayer _x} > -1) exitWith {
			_title = "[NOT POSSIBLE]<br />Vehicle is occupied by players";
		}; 

		if (vehicle player == _veh) then {
			// --- Move out player via menu and then disable
			["SHOW_MOVE_OUT_MENU", _veh] call SELF;
		} else {
			// --- Disable vehicle
			["DISABLE_VEHICLE_AND_CREW", _veh] call SELF;

			// --- Report OFF action
			[player, REASON_PINNED_VEHICLE_DISABLED] call FUNC(logUserAction);
		};
	};
	case "INFO": {
		_slotId = _args;

		private _veh = ["GET", _slotId] call SELF;
		EXIT_NULL_SLOT;

		_title = ["GET_INFO", [_veh, true]] call SELF;
		["MARK_VEHICLE", _veh] call SELF;
	};

	// -- Private methods 
	case "ENABLE_VEHICLE_AND_CREW": {
		private _veh = _args;

		// --- Enable crew 
		{
			["TOGGLE_ENTITY_CACHE", [_x, false]] call SELF;
		} forEach crew _veh;

		// --- Disable vehicle 
		["TOGGLE_ENTITY_CACHE", [_veh, false]] call SELF;

		// --- Unlock vehicle and apply vehicle states
		_veh lock false;

		// --- Restore velocity and engine state
		if ((getPos _veh # 2) > 10) then {
			[{
				if (_this getVariable [SVAR(PV_IsHovering), false]) then {
					// --- If was on hover before disabling -- restore pre-hover velocity
					private _velocity = (_this getVariable [SVAR(Vehicle_SpeedBeforeHover), 0]) * 1000 / 3600;
					_this setPos (getPos _veh);
					_this setVelocityModelSpace [0,_velocity,0];

					_this setVariable [SVAR(Vehicle_SpeedBeforeHover), nil, true];
					_this setVariable [SVAR(PV_IsHovering), nil, true];
				} else {
					// --- Restore pre-disabled velocity
					_this setVelocityModelSpace (_this getVariable [SVAR(PV_Velocity), [0,0,0]]);
				};

				_this engineOn (_this getVariable [SVAR(PV_EngineOn), false]);
			}, _veh] call CBA_fnc_execNextFrame;
		};

		_veh setVariable [SVAR(PV_Enabled), true, true];

		SET_TITLE_INFO_MESSAGE(_veh, "Vehicle Enabled!"); // TODO: Color code and constants
	};
	case "DISABLE_VEHICLE_AND_CREW": {
		private _veh = _args;

		// --- Lock vehicle and get vehicle states
		_veh lock true;

		// --- Disable AI crew 
		{
			["TOGGLE_ENTITY_CACHE", [_x, true]] call SELF;
		} forEach crew _veh;

		// --- Disable vehicle 
		["TOGGLE_ENTITY_CACHE", [_veh, true]] call SELF;
		_veh setVariable [SVAR(PV_Enabled), false, true];

		SET_TITLE_INFO_MESSAGE(_veh, "Vehicle Disabled!"); // TODO: Move to constants and Color code!
	};

	case "SHOW_MOVE_IN_MENU": {
		private _veh = _args;
		private _options = ["GET_SEATS_OPTIONS", _veh] call FUNC(manageVehicle);
		_options pushBack ["Don't get in", _veh, "", -1, []];

		[
			"SELECT SEAT",
			'["SELECT_SELECTSEAT_MENU_ACTION", _args] call ' + QSELF,
			_options apply { _x # 0 },
			_options
		] call FUNC(vehicle_showMenu);
	};
	case "SHOW_MOVE_OUT_MENU": {
		private _veh = _args;
		private _options = ["GET_MOVEOUT_OPTIONS", _veh] call FUNC(manageVehicle);

		// --- Show menu with options 
		[
			"MOVE OUT TO",
			'["SELECT_MOVEOUT_MENU_ACTION", _args] call ' + QSELF,
			_options apply { _x # 1 },
			_options
		] call FUNC(vehicle_showMenu);
	};
	case "SELECT_MOVEOUT_MENU_ACTION": {
		_args params ["_veh", "", "_pos"];

		// --- Get vehicle engine state/velocity before leaving it (if player is driver - engine is turned off on player exit)
		_veh setVariable [SVAR(PV_EngineOn), isEngineOn _veh, true];
		_veh setVariable [SVAR(PV_Velocity), velocityModelSpace _veh, true];
		_veh setVariable [SVAR(PV_IsHovering), ["IS_HOVER_ENABLED", _veh] call FUNC(manageVehicle), true];

		// --- 'Freeze' vehicle during caching 
		["HOVER_ENABLE", _veh] call FUNC(manageVehicle);

		[player, _pos] call FUNC(safeMove);

		// --- Wait for move out and Disable vehicle
		[
			{ vehicle player !=  _this }, 
			{
				[
					{
						// --- Unfreeze vehicle and cache it
						["HOVER_DISABLE", [_this]] call FUNC(manageVehicle);
						["DISABLE_VEHICLE_AND_CREW", _this] call SELF; 
					},
					_this,
					1.25
				] call CBA_fnc_waitAndExecute;
			},
			_veh
		] call CBA_fnc_waitUntilAndExecute;

		// --- Report OFF action
		[player, REASON_PINNED_VEHICLE_DISABLED] call FUNC(logUserAction); 
	};
	case "SELECT_SELECTSEAT_MENU_ACTION": {
		_args params ["_title", "_vehicle", "_role", "_cargoID", "_turretID"];

		// --- Enable vehicle
		["ENABLE_VEHICLE_AND_CREW", _vehicle] call SELF;

		// --- Change seat
		if !(_role isEqualTo "") then {
			[_vehicle, _role, _cargoID, _turretID] call FUNC(vehicle_changeSeat);
		};

		// --- Report ENABLE action
		[player, REASON_PINNED_VEHICLE_ENABLED] call FUNC(logUserAction);
	};
	case "TOGGLE_ENTITY_CACHE": {
		_args params ["_entity", "_doCache"];
		if (local _entity) then {
			[_entity, _doCache] call FUNC(vehicle_toggleCache);
		} else {
			[QFUNC(vehicle_toggleCache)] call FUNC(publishFunction);
			[_entity, _doCache] remoteExec [QFUNC(vehicle_toggleCache), _x];
		};
	};
	
	case "GET": {
		_slotId = _args;
		EXIT_SLOTID_INVALID(_slotId);
		_result = GVAR(PV_Slots) select (_slotId - 1);
	};
	case "GET_INFO": {
		_args params ["_veh", ["_extended", false]];

		private _name = _veh getVariable [SVAR(PV_Name), ""];
		private _type = _veh getVariable [SVAR(PV_Type), ""];
		private _enabledInfo = ["<br /><t color='#d32222'>-- DISABLED --</t>", ""] select (_veh getVariable [SVAR(PV_Enabled), true]);

		if (_extended) then {
			private _fuel = round (100 * fuel _veh);
			private _dmg = round (100 * damage _veh);
			private _ammoInfo = ["GET_AMMO_INFO", _veh] call SELF;
			private _crewSize = format ["<br />Crew: %1", count crew  _veh];
			private _inAir = (getPos _veh # 2) > 10;

			private _dmgColor = '#ffffff';
			if (_dmg > 20) then {
				if (_dmg == 100) then {
					_dmgColor = '#d32222';
				} else {
					_dmgColor = '#e09c1d';
				};
			};

			_result = format [
				"<t size='1.25' color='#FFD000' shadow='1'>%1 (%2)</t><br />[Fuel: %3%9]<t color='%10'>[Damage: %4%9]</t><br />Ammo: %5<br />---%6%7%8",
				_name,
				_type,			
				_fuel,
				_dmg,
				_ammoInfo,
				_crewSize,
				["","<br /><t color='#59aabd'>** In flight **</t>"] select _inAir,
				_enabledInfo,
				"%",
				_dmgColor
			];
		} else {
			_result = format ["<t size='1.25' color='#FFD000' shadow='1'>%1 (%2)</t><br />%5<br />", _name, _type, _enabledInfo];
		};
	};
	case "MARK_VEHICLE": {
		private _veh = _args;

		// --- Disable any marking if was enabled 
		["UNMARK_VEHICLE", _veh] call SELF;

		// --- Adds marker on the map
		private _mrk = createMarkerLocal [SVAR(PV_VehicleMarker), getPos _veh];
		_mrk setMarkerColorLocal "ColorBLUFOR";
		_mrk setMarkerShapeLocal "icon";
		_mrk setMarkerTypeLocal "hd_dot";
		_mrk setMarkerTextLocal (_veh getVariable [SVAR(PV_Name), ""]);

		// --- Adds 3d marker with name and distance
		GVAR(PV_VehicleMarker3D) = [
			{ 
				["DRAW_3D", _this # 0] call SELF;
			}, 0, _veh
		] call CBA_fnc_addPerFrameHandler;

		// --- Waits 10 seconds and disable
		GVAR(PV_MarkID) = CBA_missionTime;
		[
			{
				// --- If mark id was changed during timeout - don't do anything, as user triggered creation of new marker
				if !(GVAR(PV_MarkID) isEqualTo _this) exitWith {};
				["UNMARK_VEHICLE"] call SELF;
			}, GVAR(PV_MarkID), 10
		] call CBA_fnc_waitAndExecute;
	};
	case "UNMARK_VEHICLE": {
		private _veh = _args;
		deleteMarkerLocal SVAR(PV_VehicleMarker);
		[GVAR(PV_VehicleMarker3D)] call CBA_fnc_removePerFrameHandler;
	};
	case "DRAW_3D": {
		private _veh = _args;
		
		private _d = player distance _veh;
		private _name = (_veh getVariable [SVAR(PV_Name), ""]);
		private _text = format ["%1 (%2 m)", _name, str(round _d)];
		private _color = [1,0.83,0.05,1];
		private _posV = getPosATL _veh;
		private _textPos = [_posV # 0, _posV # 1, (_posV # 2) + 2 + 0.025 * _d];
	
		drawIcon3D ['', _color, _posV, 0, 0, 0, "^", 2, 0.035, 'puristaMedium'];
		drawIcon3D ['', _color, _textPos, 0, 0, 0, _text , 2, 0.035, 'puristaMedium'];
	};

	case "SELECT_SEAT": {
		_args params ["_title", "_vehicle", "_role", "_cargoID", "_turretID"];

		[_vehicle, _role, _cargoID, _turretID] call FUNC(vehicle_changeSeat);

		_title = "Seat used!";

		// --- Report USE action
		[player, REASON_PINNED_VEHICLE_USED] call FUNC(logUserAction);
	};
	case "GET_AMMO_INFO": {
		private _veh = _args;		
		private _magClasses = [];
		private _magInfo = [];

		{
			_x params ["_class", "_ammo"];
			private _id = _magClasses findIf { _x == _class };

			if (_id > -1) then {
				private _subMagInfo = _magInfo select _id;
				_subMagInfo set [1, _ammo + _subMagInfo # 1];
			} else {
				_magClasses pushBack _class;
				_magInfo pushBack [
					getText (configFile >> "CfgMagazines" >> _class >> "displayName"),
					_ammo
				];
			};
		} forEach (magazinesAmmoFull _veh);

		private _line = "";
		{
			_line = _line + format ["<br />%2x %1", _x # 0, _x # 1];
		} forEach _magInfo;

		_result = _line;
	};
};

// --- Show hint if needed
if !(_title isEqualTo "") then {
	private _slotInfo = "";
	if IS_SLOTID_VALID(_slotId) then {
		_slotInfo = format ["<t size='1.25' color='#FFD000' shadow='1'>Slot #%1</t><br />", _slotId];
	};

	hint parseText format [
		"<t size='1.5' color='#FFD000' shadow='1'>Pinned Vehicle</t><br /><br />%1%2", 
		_slotInfo, 
		_title
	];
};


_result
