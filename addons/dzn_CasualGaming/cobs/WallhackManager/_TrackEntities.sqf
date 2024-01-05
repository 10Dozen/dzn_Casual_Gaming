#include "..\script_component.hpp"
#include "WallhackManager.h"

/* ----------------------------------------------------------------------------
Function: trackEntites

Description:
    Tracks entities around the player according to selected filters.
    Then collected objects will be used by Draw3d PFH (see _RenderObjects.sqf)

Parameters:
    none

Returns:
    none

Examples:
    (begin example)
        dzn_CasualGaming_cob_WallhackManager call ["trackentities"];
    (end)

Author:
    10Dozen
---------------------------------------------------------------------------- */

#define RANGE_MODIFIER 1.1

if (!self_GET(Enabled)) exitWith {};
if (isGamePaused) exitWith {};
if (!isNull curatorCamera) exitWith {};

private _range = self_GET(Range) * RANGE_MODIFIER;

private _typeFilter = cob_CALL(self_GET(TypeFilter), GetValue);
private _sideFilter = cob_CALL(self_GET(SideFilter), GetValue);
private _entities = (player nearEntities [_typeFilter, _range]) select {
    self_CALL_WITH(FilterObjects) [_x, _sideFilter] VARSET
};

private _infantry = [];
private _vehicles = [];
private ["_whInfo", "_isVehicle", "_icon"];
{
    _whInfo = _x getVariable [SVAR(WallhackInfo), nil];

    if (!isNil "_whInfo") then {
        (if (_whInfo # 0) then { _vehicles } else { _infantry }) pushBack _x;
        continue;
    };

    _isVehicle = !(_x isKindOf "CAManBase");

    if (_isVehicle) then {
        _vehicles pushBack _x;
        _icon = getText (configfile >> "CfgVehicles" >> (typeOf _x) >> "picture");
        if (_icon isEqualTo "") then {
            _icon = getText (configfile >> "CfgVehicles" >> (typeOf _x) >> "icon");;
        };
    } else {
        _infantry pushBack _x;
        _icon = getText (configfile >> "CfgVehicles" >> (typeOf _x) >> "icon");
    };

    _x setVariable [SVAR(WallhackInfo), [_isVehicle, _icon]];
} forEach _entities;

self_SET_WITH(TrackedEntities) [_infantry, _vehicles] VARSET;
