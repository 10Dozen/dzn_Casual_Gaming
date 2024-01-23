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

#define ICON_INFANTRY_H 0.7
#define ICON_INFANTRY_W 0.7
#define ICON_VEHICLE_H 0.6
#define ICON_VEHICLE_W 1.1
#define ICON_PLAYER_H 1.25
#define ICON_PLAYER_W 0.75
#define TEXT_SIZE 0.035

#define LOOT_COLOR_RGB(ALPHA) [0.93, 0.66, 0, ALPHA]
#define BLUFOR_COLOR_RGB(ALPHA) [0, 0.5, 0.9, ALPHA]
#define OPFOR_COLOR_RGB(ALPHA) [0.8, 0, 0, ALPHA]
#define GUER_COLOR_RGB(ALPHA) [0, 0.8, 0, ALPHA]
#define CIV_COLOR_RGB(ALPHA) [0.6, 0, 0.8, ALPHA]
#define PLAYER_COLOR_RGB [0.76, 0.92, 0.53, 1]

#define PLAYER_ICON "\A3\ui_f\data\map\markers\military\triangle_CA.paa"

#define __DRAW_MARK(COLOR, POS, MARK) \
    drawIcon3D ['', COLOR, POS, 0, 0, 0, MARK , 2, TEXT_SIZE, 'puristaMedium', 'center', true]
#define __DRAW_RANGE(ICON, COLOR, POS, WIDTH, HEIGHT, TEXT) \
    drawIcon3D [ICON, COLOR, POS, WIDTH, HEIGHT, 0, TEXT, 1, TEXT_SIZE, 'puristaMedium', 'center', false, 0, -0.05]

if (!self_GET(Enabled)) exitWith {};
if (isGamePaused) exitWith {};
if (!isNull curatorCamera) exitWith {};

private _player = [] call CBA_fnc_currentUnit;
private _selectedHUD = cob_CALL(self_GET(DetailLevel), GetValue);
private _showMark = HUD_MARK in _selectedHUD;
private _showIcon = HUD_ICON in _selectedHUD;
private _showRange = HUD_RANGE in _selectedHUD;

private _range = self_GET(Range) * RANGE_MODIFIER;

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
    _dist = _player distance _x;
    if (_dist > _range) then { continue; };
    _markPos = _x modelToWorldVisual (_x selectionPosition "head");
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
        __DRAW_MARK(_color, _markPos, _mark);
    };

    if (_showIcon || _showRange) then {
        _distanceText = if (_showRange) then { format ["%1 m", str round(_dist)] } else { '' };
        _iconPos = [_markPos # 0, _markPos # 1, (_markPos # 2) + 2];
        __DRAW_RANGE(_icon, _color, _iconPos, _iconW, _iconH, _distanceText);
    };
} forEach _units;


_mark = "+";
_iconH = ICON_VEHICLE_H;
_iconW = ICON_VEHICLE_W;
{
    _dist = _player distance _x;
    if (_dist > _range) then { continue; };
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
        __DRAW_MARK(_color, _markPos, _mark);
    };

    if (_showIcon || _showRange) then {
        _distanceText = if (_showRange) then { format ["%1 m", str round(_dist)] } else { '' };
        _iconPos = [_markPos # 0, _markPos # 1, (_markPos # 2) + 2];
        __DRAW_RANGE(_icon, _color, _iconPos, _iconW, _iconH, _distanceText);
    };
} forEach _vehicles;


// Loot section
_mark = '§';
_icon = 'a3\ui_f_curator\data\displays\rscdisplaycurator\modemodules_ca.paa';
_iconH = ICON_INFANTRY_H;
_iconW = _iconH * 1.1;
{
    _dist = _player distance _x;
    if (_dist > _range) then { continue; };
    _markPos = getPosVisual _x;
    _markPos set [2, 0.1]; // put mark pos a little above the ground
    _alpha = linearConversion [50, _range, _dist, 1, 0.1, true];
    _color = LOOT_COLOR_RGB(_alpha);

    if (_showMark) then {
        __DRAW_MARK(_color, _markPos, _mark);
    };

    if (_showIcon || _showRange) then {
        _distanceText = if (_showRange) then { format ["%1 m", str round(_dist)] } else { '' };
        _iconPos = [_markPos # 0, _markPos # 1, (_markPos # 2) + 2];
        __DRAW_RANGE(_icon, _color, _iconPos, _iconW, _iconH, _distanceText);
    };
} forEach self_GET(TrackedLoot);
