#include "..\script_component.hpp"
#include "WallhackManager.h"

/* ----------------------------------------------------------------------------
Function: toggleMapTrack

Description:
    Changes mode of the Track On Map mode.
    Enables Wallhack if it is not enabled yet.
    Shows hint with current state of the Wallhack feature settings.

Parameters:
    none

Returns:
    none

Examples:
    (begin example)
        dzn_CasualGaming_cob_WallhackManager call ["togglemaptack"];
    (end)

Author:
    10Dozen
---------------------------------------------------------------------------- */

#define MAP_CTRL (findDisplay 12 displayCtrl 51)

if (!self_GET(Enabled)) then {
    self_CALL(Enable);
};

private _newState = !self_GET(MapTrackEnabled);
self_SET(MapTrackEnabled, _newState);

if (_newState) then {
    // Enable
    private _handler = MAP_CTRL ctrlAddEventHandler ["Draw", {
        cob_CALL_WITH(COB(COB_SELF_NAME), RenderOnMap) _this VARSET;
    }];
    self_SET(OnMapDrawHandler, _handler);
} else {
    // Disable
    private _handler = self_GET(OnMapDrawHandler);
    MAP_CTRL ctrlRemoveEventHandler ["Draw", _handler];
};

[[
    HINT_WALLHACK,
    format ["Track on map %1", ["disabled", "enabled"] select _newState],
    HINT_WALLHACK_SETTINGS_INFO
]] call FUNC(hint);
