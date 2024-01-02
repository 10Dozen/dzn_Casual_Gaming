/* ----------------------------------------------------------------------------
Function: dzn_CasualGaming_fnc_vehicle_getEmptySeats

Description:
    Return list of empty positions in vehicle

Parameters:
    _veh -- vehicle to check <OBJECT>

Returns:
    none

Examples:
    (begin example)
        [vehicle player] call dzn_CasualGaming_fnc_vehicle_getEmptySeats;
    (end)

Author:
    10Dozen
---------------------------------------------------------------------------- */

params ["_veh"];

( fullCrew [_veh, "driver", true]
+ fullCrew [_veh, "gunner", true]
+ fullCrew [_veh, "turret", true]
+ fullCrew [_veh, "cargo", true]
- fullCrew _veh)
