#include "..\script_component.hpp"
#include "WallhackManager.h"

/* ----------------------------------------------------------------------------
Function: trackLoot

Description:
    Tracks loot objects (ammo boxes, weapon holders and corpses) around the
    player if enabled.
    Then collected objects will be used by Draw3d PFH (see _RenderObjects.sqf)

Parameters:
    none

Returns:
    none

Examples:
    (begin example)
        dzn_CasualGaming_cob_WallhackManager call ["trackloot"];
    (end)

Author:
    10Dozen
---------------------------------------------------------------------------- */

#define RANGE_MODIFIER 1.1
#define PER_ITEM_DELAY 0.01

if (isGamePaused || !isNull curatorCamera) exitWith {};
if (!self_GET(Enabled) || !isNull self_GET(LootTrackerScriptHandler)) exitWith {};
if !(self_GET(LootTrackEnabled)) exitWith {
    self_SET(TrackedLoot, []);
};

private _lootClasses = [
    "WeaponHolderSimulated",
    "WeaponHolder",
    "ReammoBox_F"
];
private _range = self_GET(Range) * RANGE_MODIFIER;

private _handle = [_range, _lootClasses] spawn {
    params ["_range", "_lootClasses"];

    private _loot = [];
    private _currentLoot = cob_GET(COB(WallhackManager), TrackedLoot);
    if (_currentLoot isEqualTo []) then {
        _loot = _currentLoot;
    };
    // Fill loot list one by one
    {
        private _item = _x;
        if (
            (_item isKindOf "CAManBase" && !alive _item) ||
            (_lootClasses findIf {_item isKindOf _x} > -1)
        ) then {
            _loot pushBack _item;
        };

        sleep PER_ITEM_DELAY;
    } forEach (player nearSupplies _range);

    cob_SET(COB(WallhackManager), LootTrackerScriptHandler, scriptNull);
    cob_SET(COB(WallhackManager), TrackedLoot, _loot);
};

self_SET(LootTrackerScriptHandler, _handle);
