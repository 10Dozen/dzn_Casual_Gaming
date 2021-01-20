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

["Garage fnc invoked: %1", _mode] call CGG_Log;

switch (toUpper _mode) do {
	case "INIT": {
		["Init invoked"] call CGG_Log;
		GVAR(GaragePosition) = getPosATL BIS_fnc_garage_center;
		GVAR(GarageDeployRequested) = false;

		if (isNil SVAR(GarageOpenedEH)) then {
			GVAR(GarageOpenedEH) = [missionNamespace, "garageOpened", { ["HANDLE_OPENED"] call SELF }] call BIS_fnc_addScriptedEventHandler;
			["OpenedEH added: %1", GVAR(GarageOpenedEH)] call CGG_Log;
		};
		if (isNil SVAR(GarageClosedEH)) then {
			GVAR(GarageClosedEH) = [missionNamespace, "garageClosed", { ["HANDLE_CLOSED"] call SELF }] call BIS_fnc_addScriptedEventHandler;
			["ClosedEG added: %1", GVAR(GarageClosedEH)] call CGG_Log;
		};

		["Init done"] call CGG_Log;
	};
	case "OPEN": {
		["Open invoked"] call CGG_Log;

		closeDialog 2;
		[player, 9] call GVAR(fnc_logUserAction);

		BIS_fnc_garage_center = createVehicle ["Land_HelipadEmpty_F", player getPos [20,getDir player], [], 0, "CAN_COLLIDE"];

		["INIT"] call SELF;
		["Open", true] call BIS_fnc_garage;
	};
	case "HANDLE_OPENED": {
		["OpenedEH >> invoked!"] call CGG_Log;

		// --- Remove EH to prevent collision to other garage sources 
		[missionNamespace, "garageOpened", GVAR(GarageOpenedEH)] call BIS_fnc_removeScriptedEventHandler;
		GVAR(GarageOpenedEH) = nil;

		

		// --- Adds button to deploy vehicle 
		private _display = uinamespace getvariable "RscDisplayGarage";

		private _ctrlBtn = _display ctrlCreate ["RscButton", -1];
		_ctrlBtn ctrlSetText  "DEPLOY";
		_ctrlBtn ctrlSetPosition [0.1875,1,0.5,0.075]; // [0.375,1,0.25,0.05];
		_ctrlBtn ctrlCommit 0;

		_ctrlBtn ctrlAddEventHandler ["ButtonClick", {
			GVAR(GarageDeployRequested) = true;
			(uinamespace getvariable "RscDisplayGarage") closeDisplay 2;

			["OpenedEH >> Deploy selected!: %1", GVAR(GarageDeployRequested)] call CGG_Log;
		}];
	};
	case "HANDLE_CLOSED": {
		["ClosedEH >> invoked!"] call CGG_Log;


		// --- Remove EH to prevent collision to other garage sources
		[missionNamespace, "garageClosed", GVAR(GarageClosedEH)] call BIS_fnc_removeScriptedEventHandler;
		GVAR(GarageClosedEH) = nil;

		// --- Get vehicle info and remove local vehicle
		["ClosedEH >> deleting vehicle"] call CGG_Log;
		private _v = nearestObject [GVAR(GaragePosition), "AllVehicles"];
		private _vType = typeOf _v;
		private _vCustomizationStr = [_v,""] call BIS_fnc_exportVehicle;

		["ClosedEH >> vehicle params: %1 (%2)", _v, _vType] call CGG_Log;

		{ _v deleteVehicleCrew _x; } forEach (crew _v); 
		deleteVehicle _v;

		["ClosedEH >> Vehicle deleted?: %1", _v] call CGG_Log;

		// --- Exit if player closed garage any other way except clicking Deploy button
		if !(GVAR(GarageDeployRequested)) exitWith {
			["ClosedEH >> exit, as not Deploy selected"] call CGG_Log;
		};
		
		// --- Create new global vehicle with same settings
		["ClosedEH >> Spawning vehicle globally"] call CGG_Log;
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

