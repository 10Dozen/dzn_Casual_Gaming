#include "..\..\macro.hpp"
#include "reasons.hpp"

/* ----------------------------------------------------------------------------
Function: dzn_CasualGaming_fnc_init

Description:
	Initialize components

Parameters:
	none

Returns:
	none

Examples:
    (begin example)
		[] call dzn_CasualGaming_fnc_init
    (end)

Author:
	10Dozen
---------------------------------------------------------------------------- */

// Exit at dedicated or headless client
if !(hasInterface) exitWith {};

if !(["CHECK_AUTHORIZED"] call FUNC(manageAuth)) exitWith {
	diag_log parseText "dzn_CasualGaming :: User not authorized (exit)";
};
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
	if !(["CHECK_AUTHORIZED"] call FUNC(manageAuth)) exitWith {};
	if (["CHECK_EXISTS"] call FUNC(manageTopics)) exitWith {};
	["ADD_ALL"] call FUNC(manageTopics);
}] call CBA_fnc_addEventHandler;

// --- Adding topics few seconds after mission start
[SVAR(AddTopicsEvent),[]] call CBA_fnc_localEvent;
