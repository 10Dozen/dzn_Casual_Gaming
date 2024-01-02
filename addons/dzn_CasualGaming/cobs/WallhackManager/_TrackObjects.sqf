#include "..\script_component.hpp"
#include "WallhackManager.h"

/* ----------------------------------------------------------------------------
!!:TBD:!!

Function: dzn_CasualGaming_fnc_handleWallhackEH

Description:
    Draw icon for each unit on screen, on each frame.
    Filters list of units/vehicles by in-game visibility and enable status.
    Also applies custom SQF code to filter specific conditions.

Parameters:
    none

Returns:
    none

Examples:
    (begin example)
        [dzn_CasualGaming_fnc_handleWallhackEH] call CBA_fnc_addPerFrameHandler;
    (end)

Author:
    10Dozen
---------------------------------------------------------------------------- */

if (!self_GET(Enabled)) exitWith {};

private _range = self_GET(Range) * 1.1;
private _objects = (player nearEntities [GVAR(WallhackClasslist), _range]) select {
    self_CALL_WITH(FilterObjects) _x VARSET;
};

{
    private _dist = player distance _x;
    private _pos = getPosATL _x;
    _pos set [2, _pos # 2 + 2];

    private _mark = '+';
    private _icon = getText (configfile >> "CfgVehicles" >> (typeOf _x) >> "icon");
    private _iconH = 0.5;
    private _iconW = 1;

    if (_x isKindOf "CAManBase") then {
        _pos = _x modelToWorld (_x selectionPosition "head");
        _mark = '•';
        _icon = getText (configfile >> "CfgVehicles" >> (typeOf _x) >> "icon");
        _iconH = 0.5;
        _iconW = 0.5;
    } else {
        private _picture = getText (configfile >> "CfgVehicles" >> (typeOf _x) >> "picture");
        if (_picture isNotEqualTo "") then {
            // Use picture if provided (may be missing for mods)
            _icon = _picture;
        };
    };

    private _iconPos = [_pos # 0, _pos # 1, (_pos # 2) + 2];
    private _distanceText = format ["%1 m", str(round _dist)];
    private _textAlpha = linearConversion [
        50, _range,
        _dist,
        1, 0.1, true
    ];
    private _color = switch (side _x) do {
        case west:       { [0, 0.5, 0.9, _textAlpha] };
        case east:       { [0.8, 0, 0, _textAlpha] };
        case resistance: { [0, 0.8, 0, _textAlpha] };
        case civilian:   { [0.6, 0, 0.8, _textAlpha] };
    };

    drawIcon3D [
        _icon, _color, _iconPos, _iconW, _iconH, 0, _distanceText, 2, 0.035,
        'puristaMedium', 'center', true, 0, -0.05
    ];
    drawIcon3D ['', _color, _pos, 0, 0, 0, _mark , 2, 0.035, 'puristaMedium'];
} forEach _objects;
