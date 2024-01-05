#include "..\script_component.hpp"
#include "reasons.hpp"
#include "..\auth\permission_map.hpp"

#define SELF FUNC(handleHotkey)
#define QSELF QFUNC(handleHotkey)

/* ----------------------------------------------------------------------------
Function: dzn_CasualGaming_fnc_handleHotkey

Description:
    Handles hotkey press - check for permissions and calls selected action

Parameters:
    _mode -- modes <STRING>
    _args -- (optional) call arguments <ARRAY>

Returns:
    none

Examples:
    (begin example)
        [""] call dzn_CasualGaming_fnc_handleHotkey;
    (end)

Author:
    10Dozen
---------------------------------------------------------------------------- */
#define EXIT_NOT_PERMITTED(FEATURE) if !(["CHECK_PERMISSION", FEATURE] call FUNC(manageAuth)) exitWith {};

params ["_mode", ["_args",[]]];

private _title = "";
private _result = true;

switch (toUpper _mode) do {
    case "INIT": {};

    case "KEY_HEAL": {
        EXIT_NOT_PERMITTED(PERM_HEAL);
        [true] call FUNC(heal);
    };
    case "KEY_RALLYPOINT": {
        EXIT_NOT_PERMITTED(PERM_RALLYPOINT);
        _args call FUNC(manageRallypoint);
    };
    case "KEY_ARSENAL": {
        EXIT_NOT_PERMITTED(PERM_ARSENAL);
        [_args] call FUNC(openArsenal);
    };
    case "KEY_GARAGE": {
        EXIT_NOT_PERMITTED(PERM_GARAGE);
        ["OPEN"] call FUNC(openGarage);
    };
    case "KEY_VEHICLE_SERVICE": {
        EXIT_NOT_PERMITTED(PERM_VEHICLE_SERVICE);
        ["REPAIR"] call FUNC(manageVehicle);
        ["REFUEL"] call FUNC(manageVehicle);
        ["REARM"] call FUNC(manageVehicle);
    };
    case "KEY_VEHICLE_CONTROL": {
        EXIT_NOT_PERMITTED(PERM_VEHICLE_CONTROL);
        [_args] call FUNC(manageVehicle);
    };
    case "KEY_PINNED_VEHICLE_QUICK_MENU": {
        EXIT_NOT_PERMITTED(PERM_PINNED_VEHICLES);
        ["QUICK_MENU"] call FUNC(managePinnedVehicle);
    };
    case "KEY_GROUP_AI": {
        EXIT_NOT_PERMITTED(PERM_GROUP_AI);
        [_args, units player] call FUNC(manageGroup);
    };
    case "KEY_CONSOLE": {
        EXIT_NOT_PERMITTED(PERM_CONSOLE);
        openMap false;
        closeDialog 2;
        [{ createDialog SVAR(Console_Group) }] call CBA_fnc_execNextFrame;
    };
    case "KEY_WALLHACK": {
        EXIT_NOT_PERMITTED(PERM_WALLHACK);
        openMap false;
        closeDialog 2;
        cob_CALL(COB(WallhackManager), Toggle);
    };
};

_result
