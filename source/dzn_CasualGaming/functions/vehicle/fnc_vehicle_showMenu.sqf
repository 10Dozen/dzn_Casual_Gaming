#include "..\..\macro.hpp"

/* ----------------------------------------------------------------------------
Function: dzn_CasualGaming_fnc_vehicle_showMenu

Description:
	Shows command menu with given options and title. 
	Each menu item calls given function and pass it next arguments to be used in fnc_vehicle_changeSeat function:
	 [_vehicle, _role, _cargoID, _turretID]

Parameters:
	_menuTitle -- menu's title <STRING>
	_callbackString -- code string with placeholder _args for action args to be executed on menu item select <STRING>
	_displayOptions -- list of option names to display <ARRAY>
	_optionsArgList -- list of arguments for each option to pass to callback as action args <ARRAY>

Returns:
	none

Examples:
    (begin example)
		[
			"CHANGE SEAT", // Menu  title
			'["CHANGE_SEAT", _args] call fnc_manageVehicle", // Callback 
			["Pilot","Gunner"], // Display options 
			[[_veh, "pilot"], [_veh, "gunner"]] // Values for options
		] call dzn_CasualGaming_fnc_vehicle_showMenu;
    (end)


Author:
	10Dozen
---------------------------------------------------------------------------- */

params ["_menuTitle", "_callbackString", "_displayOptions", "_optionsArgList"];

GVAR(Menu) = [[_menuTitle, true]];
GVAR(MenuOptions) = _optionsArgList;

{
	GVAR(Menu) pushBack [
		_x,
		[2 + _forEachIndex],
		"",-5,
		[["expression", format ["_args = %1 select %2; %3", SVAR(MenuOptions), _forEachIndex, _callbackString]]],
		"1",
		"1"
	];
} forEach _displayOptions;

showCommandingMenu format ["#USER:%1", SVAR(Menu)];
