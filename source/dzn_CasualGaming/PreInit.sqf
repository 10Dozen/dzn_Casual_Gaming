
#include "macro.hpp"

call compile preprocessFileLineNumbers format ["%1\Functions.sqf", PATH];

["CBA_settingsInitialized", {
	[] call FUNC(init);
}] call CBA_fnc_addEventHandler;

call compile preprocessFileLineNumbers format ["%1\Settings.sqf", PATH];
