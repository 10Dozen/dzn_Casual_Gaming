#include "..\script_component.hpp"
#include "WallhackManager.h"

/* ----------------------------------------------------------------------------
Function: disable

Description:
    Disables Wallhack feature.

Parameters:
    none

Returns:
    none

Examples:
    (begin example)
        dzn_CasualGaming_cob_WallhackManager call ["disable"];
    (end)

Author:
    10Dozen
---------------------------------------------------------------------------- */

private _pfh = self_GET(PFH);
if (isNil "_pfh") exitWith {};

_pfh call CBA_fnc_removePerFrameHandler;

self_SET(PFH, nil);
self_SET(Enabled, false);

[
    HINT_WALLHACK,
    "Disabled"
] call FUNC(hint);
