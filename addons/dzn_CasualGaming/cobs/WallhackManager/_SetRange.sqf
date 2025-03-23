#include "..\script_component.hpp"
#include "WallhackManager.h"
#include "\z\dzn_CasualGaming\addons\dzn_CasualGaming\reasons.hpp"

/* ----------------------------------------------------------------------------
Function: setMode

Description:
    Changes range of the Wallhack feature.
    Enables Wallhack if it is not enabled yet.
    Shows hint with current state of the Wallhack feature settings.

Parameters:
    0: _range - new range to set <NUMBER>

Returns:
    none

Examples:
    (begin example)
        dzn_CasualGaming_cob_WallhackManager call ["setrange", [500]];
    (end)

Author:
    10Dozen
---------------------------------------------------------------------------- */

params ["_range"];

self_SET(Range, _range);

if (!self_GET(Enabled)) then {
    self_CALL(Enable);
};

[[
    HINT_WALLHACK,
    "Range changed!",
    HINT_WALLHACK_SETTINGS_INFO
]] call FUNC(hint);

[player, REASON_WALLHACK_RANGE_CHANGED] call FUNC(logUserAction);
