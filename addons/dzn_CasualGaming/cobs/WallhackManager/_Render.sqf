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

#define LOOT_COLOR_RGB(ALPHA) [0.93, 0.66, 0, ALPHA]
#define BLUFOR_COLOR_RGB(ALPHA) [0, 0.5, 0.9, ALPHA]
#define OPFOR_COLOR_RGB(ALPHA) [0.8, 0, 0, ALPHA]
#define GUER_COLOR_RGB(ALPHA) [0, 0.8, 0, ALPHA]
#define CIV_COLOR_RGB(ALPHA) [0.6, 0, 0.8, ALPHA]

#define __DRAW_MARK drawIcon3D ['', _color, _markPos, 0, 0, 0, _mark , 2, TEXT_SIZE, 'puristaMedium', 'center', true]
#define __DRAW_RANGE drawIcon3D [_icon, _color, _iconPos, _iconW, _iconH, 0, _distanceText, 1, TEXT_SIZE, 'puristaMedium', 'center', false, 0, -0.05]


if (!self_GET(Enabled)) exitWith {};
if (isGamePaused) exitWith {};
if (!isNull curatorCamera) exitWith {};

private _selectedHUD = cob_CALL(self_GET(DetailLevel), GetValue);
private _showMark = HUD_MARK in _selectedHUD;
private _showIcon = HUD_ICON in _selectedHUD;
private _showRange = HUD_RANGE in _selectedHUD;

private _range = self_GET(Range) * RANGE_MODIFIER;

//  self_GET(TrackedEntities);

private [
    "_dist",
    "_mark", "_markPos",
    "_icon", "_iconH", "_iconW", "_iconPos",
    "_distanceText", "_alpha", "_color"
];

// Entities
// Infantry
self_GET(TrackedEntities) params ["_units", "_vehicles"];

_mark = '•';
_iconH = ICON_INFANTRY_H;
_iconW = ICON_INFANTRY_W;
{
    _dist = player distance _x;
    if (_dist > _range) exitWith {};
    _markPos = _x modelToWorld (_x selectionPosition "head");
    _icon = (_x getVariable SVAR(WallhackInfo)) # 1;
    _alpha = linearConversion [50, _range, _dist, 1, 0.1, true];
    _color = switch (side _x) do {
        case west: { BLUFOR_COLOR_RGB(_alpha) };
        case east: { OPFOR_COLOR_RGB(_alpha) };
        case resistance: { GUER_COLOR_RGB(_alpha) };
        case civilian: { CIV_COLOR_RGB(_alpha) };
        default { [0,0,0,0] };
    };

    if (_showMark) then {
        __DRAW_MARK;
    };

    if (_showIcon || _showRange) then {
        _distanceText = if (_showRange) then { format ["%1 m", str round(_dist)] } else { '' };
        _iconPos = [_markPos # 0, _markPos # 1, (_markPos # 2) + 2];
        __DRAW_RANGE;
    };
} forEach _units;


_mark = "+";
_iconH = ICON_VEHICLE_H;
_iconW = ICON_VEHICLE_W;
{
    _dist = player distance _x;
    if (_dist > _range) exitWith {};
    _markPos = getPosVisual _x;
    _markPos set [2, _markPos # 2 + 2]; // put mark pos above the ground
    _icon = (_x getVariable SVAR(WallhackInfo)) # 1;
    _alpha = linearConversion [50, _range, _dist, 1, 0.1, true];
    _color = switch (side _x) do {
        case west: { BLUFOR_COLOR_RGB(_alpha) };
        case east: { OPFOR_COLOR_RGB(_alpha) };
        case resistance: { GUER_COLOR_RGB(_alpha) };
        case civilian: { CIV_COLOR_RGB(_alpha) };
        default { [0,0,0,0] };
    };

    if (_showMark) then {
        __DRAW_MARK;
    };

    if (_showIcon || _showRange) then {
        _distanceText = if (_showRange) then { format ["%1 m", str round(_dist)] } else { '' };
        _iconPos = [_markPos # 0, _markPos # 1, (_markPos # 2) + 2];
        __DRAW_RANGE;
    };
} forEach _vehicles;


// Loot section
_mark = '§';
_icon = 'a3\ui_f_curator\data\displays\rscdisplaycurator\modemodules_ca.paa';
_iconH = ICON_INFANTRY_H;
_iconW = _iconH * 1.1;

{
    _dist = player distance _x;
    if (_dist > _range) exitWith {};
    _markPos = getPosVisual _x;
    _markPos set [2, 0.1]; // put mark pos a little above the ground
    _alpha = linearConversion [50, _range, _dist, 1, 0.1, true];
    _color = LOOT_COLOR_RGB(_alpha);

    if (_showMark) then {
        __DRAW_MARK;
    };

    if (_showIcon || _showRange) then {
        _distanceText = if (_showRange) then { format ["%1 m", str round(_dist)] } else { '' };
        _iconPos = [_markPos # 0, _markPos # 1, (_markPos # 2) + 2];
        __DRAW_RANGE;
    };
} forEach self_GET(TrackedLoot);
