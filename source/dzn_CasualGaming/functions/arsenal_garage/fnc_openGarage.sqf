#include "..\..\macro.hpp"
#define SELF GVAR(fnc_openGarage)

/* ----------------------------------------------------------------------------
Function: dzn_CasualGaming_fnc_openGarage

Description:
	Opens vanilla garage.

Parameters:
	none (some internal params exists)

Returns:
	none

Examples:
    (begin example)
		[] call dzn_CasualGaming_fnc_openGarage; // opens BIS garage
    (end)

Author:
	10Dozen
---------------------------------------------------------------------------- */

params [["_mode","OPEN"]];

switch (toUpper _mode) do {
	case "INIT": {
		GVAR(GaragePosition) = getPosATL BIS_fnc_garage_center;

		if (isNil SVAR(GarageClosedEH)) then {
			GVAR(GarageClosedEH) = [missionNamespace, "garageClosed", { ["HANDLE_CLOSED"] call SELF }] call BIS_fnc_addScriptedEventHandler;
		}
	};
	case "OPEN": {
		closeDialog 2;
		[player, 9] call GVAR(fnc_logUserAction);

		BIS_fnc_garage_center = createVehicle ["Land_HelipadEmpty_F", player getPos [20,getDir player], [], 0, "CAN_COLLIDE"];

		["INIT"] call SELF;
		["Open", true] call BIS_fnc_garage;
	};
	case "HANDLE_CLOSED": {
		// --- Remove EH to prevent collision to other garage sources
		[missionNamespace, "garageClosed", GVAR(GarageClosedEH)] call BIS_fnc_removeScriptedEventHandler;
		GVAR(GarageClosedEH) = nil;

		// --- Get vehicle info and remove local vehicle
		private _v = nearestObject [GVAR(GaragePosition), "AllVehicles"];
		private _vType = typeOf _v;
		private _vCustomizationStr = [_v,""] call BIS_fnc_exportVehicle;
		{ _v deleteVehicleCrew _x; } forEach (crew _v); 
		deleteVehicle _v;
		
		// --- Create new global vehicle with same settings
		[
			{
				params ["_vType","_vCustomizationStr","_pos"];

				private _gv = _vType createVehicle _pos;
				_gv setPosATL _pos;
				_gv call compile _vCustomizationStr;
				_gv setDir (getDir player);
				{ _gv deleteVehicleCrew _x; } forEach (crew _gv); 
			}
			, [_vType, _vCustomizationStr, GVAR(GaragePosition)]
		] call CBA_fnc_execNextFrame;
	};
};

