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

private _pfhTracker = self_GET(TrackPFH);
private _pfhRender = self_GET(RenderPFH);

if (isNil "_pfhTracker" && isNil "_pfhRender") exitWith {};

_pfhTracker call CBA_fnc_removePerFrameHandler;
_pfhRender call CBA_fnc_removePerFrameHandler;

self_SET(TrackPFH, nil);
self_SET(RenderPFH, nil);
self_SET(Enabled, false);

[
    HINT_WALLHACK,
    "Disabled"
] call FUNC(hint);
