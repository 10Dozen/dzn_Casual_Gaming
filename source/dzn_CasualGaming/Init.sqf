
#include "macro.hpp"
#include "functions\main\reasons.hpp"

// Comment for addon
call compile preprocessFileLineNumbers format ["%1\Settings.sqf", PATH];
sleep 2;

call compile preprocessFileLineNumbers format ["%1\Functions.sqf", PATH]; 

if (isServer) then {
	GVAR(LogReasons) = call compile preprocessFileLineNumbers format [
		"%1\functions\main\mapLogReasons.sqf",
		PATH
	];
};

// Exit at dedicated or headless client
if !(hasInterface) exitWith {};

// --- Init
// --- Exit if not authorized
if !(["CHECK_AUTHORIZED"] call FUNC(manageAuth)) exitWith {};
[player, REASON_AUTHORIZED] call FUNC(logUserAction);

// --- Save default mission loadout to mission loadout 1
missionNamespace setVariable [format ["%1_%2", SVAR(Loadout), 1], getUnitLoadout player];

// --- Init modules
["INIT"] call FUNC(manageAuth);
["INIT"] call FUNC(manageRallypoint);
["INIT"] call FUNC(manageWallhack);
["INIT"] call FUNC(managePinnedVehicle);

// --- Adds topics handler
[SVAR(AddTopicsEvent), {
	if (isNil QFUNC(manageAuth)) exitWith {};
	if (["CHECK_EXISTS"] call FUNC(manageTopics)) exitWith {};
	["ADD_ALL"] call FUNC(manageTopics);
}] call CBA_fnc_addEventHandler;

// --- Adding topics few seconds after mission start
[{ [SVAR(AddTopicsEvent),[]] call CBA_fnc_localEvent; }, [], 2] call CBA_fnc_waitAndExecute;
