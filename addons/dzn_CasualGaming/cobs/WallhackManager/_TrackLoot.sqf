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

if (!self_GET(Enabled)) exitWith {};
if (isGamePaused) exitWith {};
if (!isNull curatorCamera) exitWith {};
if !(self_GET(LootTrackEnabled)) exitWith {
    self_SET(TrackedLoot, []);
};

private _range = self_GET(Range) * RANGE_MODIFIER;
private _loot = (allDeadMen select { _x distance player <= _range }); // corpses
_loot append (player nearObjects ["ReammoBox_F", _range]); // boxes
_loot append (player nearObjects ["ReammoBox", _range]); // weapon holders

self_SET(TrackedLoot, _loot);
