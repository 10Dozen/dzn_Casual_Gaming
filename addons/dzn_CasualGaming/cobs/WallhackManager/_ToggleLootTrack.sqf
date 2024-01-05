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

if (!self_GET(Enabled)) then {
    self_CALL(Enable);
};

private _newState = !self_GET(LootTrackEnabled);
self_SET(LootTrackEnabled, _newState);

[
    HINT_WALLHACK,
    format ["Loot track %1", ["disabled", "enabled"] select _newState],
    HINT_WALLHACK_SETTINGS_INFO
] call FUNC(hint);
