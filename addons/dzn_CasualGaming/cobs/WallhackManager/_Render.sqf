#include "..\script_component.hpp"
#include "WallhackManager.h"

/* ----------------------------------------------------------------------------
Function: render

Description:
    Draw icon for each tracked unit on screen, on each frame. Tracking is made
    in the neighboor process, but with some timeout.

Parameters:
    none

Returns:
    none

Examples:
    (begin example)
        dzn_CasualGaming_cob_WallhackManager call ["render"];
    (end)

Author:
    10Dozen
---------------------------------------------------------------------------- */

#define RANGE_MODIFIER 1.1
#define ICON_INFANTRY_H 0.7
#define ICON_INFANTRY_W 0.7
#define ICON_VEHICLE_H 0.6
#define ICON_VEHICLE_W 1.1
#define TEXT_SIZE 0.035

if (!self_GET(Enabled)) exitWith {};
if (isGamePaused) exitWith {};
if (!isNull curatorCamera) exitWith {};

private _range = self_GET(Range) * RANGE_MODIFIER;
private _selectedHUD = cob_CALL(self_GET(DetailLevel), GetValue);
self_GET(TrackedObjects) params ["_objects", "_pickables"];

{
    private _obj = _x;
    private _dist = player distance _obj;
    if (_dist > _range) exitWith {}; // In case object was teleported out of range
    private _pos = getPosVisual _obj;
    _pos set [2, _pos # 2 + 2];

    private _mark = '+';
    private _icon = getText (configfile >> "CfgVehicles" >> (typeOf _obj) >> "icon");
    private _iconH = ICON_VEHICLE_H;
    private _iconW = ICON_VEHICLE_W;

    if (_obj in _pickables) then {
        _mark = '§';
        _pos set [2, 0.1];
        _icon = 'a3\ui_f_curator\data\displays\rscdisplaycurator\modemodules_ca.paa';
        _iconH = ICON_INFANTRY_H;
        _iconW = _iconH * 1.1;
    } else {
        if (_obj isKindOf "CAManBase") then {
            _pos = _obj modelToWorld (_obj selectionPosition "head");
            _mark = '•';
            _icon = getText (configfile >> "CfgVehicles" >> (typeOf _obj) >> "icon");
            _iconH = ICON_INFANTRY_H;
            _iconW = ICON_INFANTRY_W;
        } else {
            private _picture = getText (configfile >> "CfgVehicles" >> (typeOf _obj) >> "picture");
            if (_picture isNotEqualTo "") then {
                // Use picture if provided (may be missing for mods)
                _icon = _picture;
            };
        };
    };

    private _iconPos = [_pos # 0, _pos # 1, (_pos # 2) + 2];
    private _distanceText = '';
    if (HUD_RANGE in _selectedHUD) then {
        _distanceText = format ["%1 m", str(round _dist)];
    };

    private _textAlpha = linearConversion [50, _range, _dist, 1, 0.1, true];
    private _color = switch (side _x) do {
        case west:       { [0, 0.5, 0.9, _textAlpha] };
        case east:       { [0.8, 0, 0, _textAlpha] };
        case resistance: { [0, 0.8, 0, _textAlpha] };
        case civilian:   { [0.6, 0, 0.8, _textAlpha] };
        default { [0,0,0,0] };
    };
    if !(HUD_ICON in _selectedHUD) then { _icon = ''; };

    if (_icon != '' || _distanceText != '') then {
        drawIcon3D [
            _icon, _color, _iconPos, _iconW, _iconH, 0, _distanceText, 1, TEXT_SIZE,
            'puristaMedium', 'center', false, 0, -0.05
        ];
    };
    if (HUD_MARK in _selectedHUD) then {
        drawIcon3D [
            '', _color, _pos, 0, 0, 0, _mark , 2, TEXT_SIZE,
            'puristaMedium', 'center', true
        ];
    };
} forEach _objects;
