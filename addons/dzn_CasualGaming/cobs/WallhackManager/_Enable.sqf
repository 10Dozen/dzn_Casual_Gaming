#include "..\script_component.hpp"
#include "WallhackManager.h"

/* ----------------------------------------------------------------------------
Function: enable

Description:
    Enables Wallhack feature.

Parameters:
    none

Returns:
    none

Examples:
    (begin example)
        dzn_CasualGaming_cob_WallhackManager call ["enable"];
    (end)

Author:
    10Dozen
---------------------------------------------------------------------------- */

private _pfhTracker = [{
    cob_CALL((_this # 0), Track);
}, 0.2, _self] call CBA_fnc_addPerFrameHandler;

private _pfhRender = [{
    cob_CALL((_this # 0), Render);
}, nil, _self] call CBA_fnc_addPerFrameHandler;

self_SET(TrackPFH, _pfhTracker);
self_SET(RenderPFH, _pfhRender);
self_SET(Enabled, true);

[
    HINT_WALLHACK,
    format ["Enabled [%1 m]", self_GET(Range)],
    HINT_WALLHACK_SETTINGS_INFO
] call FUNC(hint);
