#include "..\script_component.hpp"

/* ----------------------------------------------------------------------------
Function: dzn_CasualGaming_fnc_vehicle_addHoverPFH

Description:
    Handles hovering by setting position/tilt/speed by adding on each frame handler

Parameters:
    _veh -- vehicle to check <OBJECT>
    _modelPos -- position to restore <ARRAY>
    _modelVector -- vector dir and up to restore <ARRAY>

Returns:
    none

Examples:
    (begin example)
        [vehicle player, _modelPos, _modelVector] call dzn_CasualGaming_fnc_vehicle_addHoverPFH;
    (end)

Author:
    10Dozen
---------------------------------------------------------------------------- */

params ["_veh", "_modelPos", "_modelVector"];

private _pfh = [{
    (_this # 0) params ["_veh","_pos","_vector"];

    // --- Check for locality and re-add pfh if locality was changed
    if (!local _veh) then {
        [_this # 1] call CBA_fnc_removePerFrameHandler;
        [_veh,_pos,_vector] remoteExec [QFUNC(vehicle_addHoverPFH), _veh];
    };

    // --- "Freezes" vehicle in the same position/tilt each frame
    _veh setPosASL _modelPos;
    _veh setVectorDirAndUp _vector;
    _veh setVelocity [0, 0, 0];
}, nil, [_veh, _modelPos, _modelVector]] call CBA_fnc_addPerFrameHandler;

_veh setVariable [SVAR(Vehicle_HoverPFH), _pfh, true];
_veh setVariable [SVAR(Vehicle_HoverPFH_Owner), clientOwner, true];
