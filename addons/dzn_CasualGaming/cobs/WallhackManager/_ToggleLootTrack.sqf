#include "..\script_component.hpp"
#include "WallhackManager.h"

/* ----------------------------------------------------------------------------
Function: toggleLootTrack

Description:
    Changes mode of the filters or HUD settings. Each mode is handled by
    ToggleHandler COB.
    Enables Wallhack if it is not enabled yet.
    Shows hint with current state of the Wallhack feature settings.

Parameters:
    0: _modeHandlerID - toggleHandler enum value from WallhackManager.h <ENUM>
    1: _modeKey - identifier of the switch to change in ToggleHandler <ENUM>

Returns:
    none

Examples:
    (begin example)
        dzn_CasualGaming_cob_WallhackManager call ["toggleLootTrack"];
    (end)

Author:
    10Dozen
---------------------------------------------------------------------------- */

#define LOOT_TRACKER_TIMEOUT 20

if (!self_GET(Enabled)) then {
    self_CALL(Enable);
};

private _newState = !self_GET(LootTrackEnabled);
self_SET(LootTrackEnabled, _newState);

if (_newState) then {
    private _pfhLootTracker = [
        { cob_CALL((_this # 0), TrackLoot); },
        LOOT_TRACKER_TIMEOUT,
        _self
    ] call CBA_fnc_addPerFrameHandler;

    self_SET(LootTrackerPFH, _pfhLootTracker);
} else {
    [self_GET(LootTrackerPFH)] call CBA_fnc_removePerFrameHandler;
    self_SET(LootTrackerPFH, nil);
    self_SET(LootTrackerScriptHandler, scriptNull);
    self_SET(TrackedLoot, []);
};

[
    HINT_WALLHACK,
    format ["Loot track %1", ["disabled", "enabled"] select _newState],
    HINT_WALLHACK_SETTINGS_INFO
] call FUNC(hint);
