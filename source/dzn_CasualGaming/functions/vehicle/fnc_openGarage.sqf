#include "..\..\macro.hpp"
#include "..\main\reasons.hpp"

#define SELF FUNC(openGarage)

/* ----------------------------------------------------------------------------
Function: dzn_CasualGaming_fnc_openGarage

Description:
	Opens vanilla garage and handles creation of the vehicle globally.

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
		GVAR(GarageDeployRequested) = false;

		if (isNil SVAR(GarageOpenedEH)) then {
			GVAR(GarageOpenedEH) = [missionNamespace, "garageOpened", { ["HANDLE_OPENED"] call SELF }] call BIS_fnc_addScriptedEventHandler;
		};
		if (isNil SVAR(GarageClosedEH)) then {
			GVAR(GarageClosedEH) = [missionNamespace, "garageClosed", { ["HANDLE_CLOSED"] call SELF }] call BIS_fnc_addScriptedEventHandler;
		};
	};
	case "OPEN": {
		closeDialog 2;
		[player, REASON_GARAGE_OPENED] call FUNC(logUserAction);

		BIS_fnc_garage_center = createVehicle ["Land_HelipadEmpty_F", player getPos [20,getDir player], [], 0, "CAN_COLLIDE"];

		["INIT"] call SELF;
		["Open", true] call BIS_fnc_garage;
	};
	case "HANDLE_OPENED": {
		// --- Remove EH to prevent collision to other garage sources 
		[missionNamespace, "garageOpened", GVAR(GarageOpenedEH)] call BIS_fnc_removeScriptedEventHandler;
		GVAR(GarageOpenedEH) = nil;

		// --- Adds button to deploy vehicle 
		private _display = uinamespace getvariable "RscDisplayGarage";

		private _ctrlBg = _display ctrlCreate ["RscStructuredText", -1];
		private _ctrlBtn = _display ctrlCreate ["RscButton", -1];
		_ctrlBtn ctrlSetText "DEPLOY";

		_ctrlBg ctrlSetBackgroundColor [0,0.5,0,0.5];

		_ctrlBg ctrlSetPosition [0.1875,1,0.5,0.085];
		_ctrlBtn ctrlSetPosition [0.1875,1,0.5,0.085]; // [0.375,1,0.25,0.05];
		_ctrlBg ctrlCommit 0;
		_ctrlBtn ctrlCommit 0;

		_ctrlBtn ctrlAddEventHandler ["ButtonClick", {
			GVAR(GarageDeployRequested) = true;
			(uinamespace getvariable "RscDisplayGarage") closeDisplay 2;
		}];
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

		// --- Exit if player closed garage any other way except clicking Deploy button
		if !(GVAR(GarageDeployRequested)) exitWith {};
		
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
