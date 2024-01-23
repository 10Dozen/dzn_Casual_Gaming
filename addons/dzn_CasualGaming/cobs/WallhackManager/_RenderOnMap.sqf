#include "..\script_component.hpp"
#include "WallhackManager.h"

/* ----------------------------------------------------------------------------
Function: renderOnMap

Description:
    Draw icon for each tracked unit on map. Tracking is made
    in the neighboor process, but with some timeout.

Parameters:
    none

Returns:
    none

Examples:
    (begin example)
        dzn_CasualGaming_cob_WallhackManager call ["renderonmap"];
    (end)

Author:
    10Dozen
---------------------------------------------------------------------------- */

#define ICON_INFANTRY_H 24
#define ICON_INFANTRY_W 24
#define ICON_VEHICLE_H 32
#define ICON_VEHICLE_W 32
#define ICON_LOOT_H 16
#define ICON_LOOT_W 16

#define ICON_PLAYER_H 32
#define ICON_PLAYER_W 24
#define TEXT_SIZE 0.035

#define BLUFOR_COLOR_RGBA [0, 0.5, 0.9, 1]
#define OPFOR_COLOR_RGBA  [0.8, 0, 0, 1]
#define GUER_COLOR_RGBA   [0, 0.8, 0, 1]
#define CIV_COLOR_RGBA    [0.6, 0, 0.8, 1]
#define PLAYER_COLOR_RGBA [0.76, 0.92, 0.53, 1]
#define LOOT_COLOR_RGBA   [0.93, 0.66, 0, 1]

#define ICON_PLAYER "\A3\ui_f\data\map\markers\military\triangle_CA.paa"

params ["_mapCtrl"];

if (!self_GET(Enabled)) exitWith {};
if (isGamePaused) exitWith {};
if (!isNull curatorCamera) exitWith {};

if (!self_GET(MapTrackEnabled) && isNull _mapCtrl) exitWith {};

private _player = [] call CBA_fnc_currentUnit;
private _range = self_GET(Range) * RANGE_MODIFIER;

// Player
_mapCtrl drawEllipse [_player, _range, _range, 0, PLAYER_COLOR_RGBA, ""];
_mapCtrl drawIcon [
    ICON_PLAYER, PLAYER_COLOR_RGBA,
    getPos _player,
    ICON_PLAYER_W, ICON_PLAYER_H,
    getDir _player, "You"
];


// Entities
private ["_iconW", "_iconH", "_icon", "_color"];

// Infantry
self_GET(TrackedEntities) params ["_units", "_vehicles"];

_iconH = ICON_INFANTRY_H;
_iconW = ICON_INFANTRY_W;
{
    _icon = (_x getVariable SVAR(WallhackInfo)) # 2;
    _color = switch (side _x) do {
        case west: { BLUFOR_COLOR_RGBA };
        case east: { OPFOR_COLOR_RGBA };
        case resistance: { GUER_COLOR_RGBA };
        case civilian: { CIV_COLOR_RGBA };
        default { [0,0,0,0] };
    };

    _mapCtrl drawIcon [_icon, _color, getPos _x, _iconH, _iconW,  getDir _x];
} forEach _units;

// Vehicles
_iconH = ICON_VEHICLE_H;
_iconW = ICON_VEHICLE_W;
{
    _icon = (_x getVariable SVAR(WallhackInfo)) # 2;
    _color = switch (side _x) do {
        case west: { BLUFOR_COLOR_RGBA };
        case east: { OPFOR_COLOR_RGBA };
        case resistance: { GUER_COLOR_RGBA };
        case civilian: { CIV_COLOR_RGBA };
        default { [0,0,0,0] };
    };

    _mapCtrl drawIcon [_icon, _color, getPos _x, _iconH, _iconW,  getDir _x];
} forEach _vehicles;


// Loot section
_icon = '\a3\ui_f\data\igui\cfg\simpletasks\types\box_ca.paa';
_iconH = ICON_LOOT_H;
_iconW = ICON_LOOT_W;
_dir = 0;
{
     _mapCtrl drawIcon [_icon, LOOT_COLOR_RGBA, getPos _x, _iconH, _iconW, 0];
} forEach self_GET(TrackedLoot);
