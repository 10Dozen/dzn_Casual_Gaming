#include "..\script_component.hpp"

/* ----------------------------------------------------------------------------
Function: dzn_CasualGaming_fnc_vehicle_releaseHover

Description:
    Restore vehicle velocity after exit hovering PFH

Parameters:
    _obj -- vehicle  <OBJECT>
    _releaseSpeed -- release speed in m/s <NUMBER>

Returns:
    none

Examples:
    (begin example)
        [vehicle player, 40] call dzn_CasualGaming_fnc_vehicle_releaseHover;
    (end)

Author:
    10Dozen
---------------------------------------------------------------------------- */

params ["_veh", "_releaseSpeed"];

[{
    _this params ["_veh","_speed"];
    // --- Removes vehicle flip and adds speed
    _veh setPos (getPos _veh);
    _veh setVelocityModelSpace [0, _speed, 0];
}, [_veh, _releaseSpeed]] call CBA_fnc_execNextFrame;
