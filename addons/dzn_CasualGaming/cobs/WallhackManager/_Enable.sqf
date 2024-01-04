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

private _pfh = [{
    (_this # 0) call [cob_PAR(TrackObjects)];
}, nil, _self] call CBA_fnc_addPerFrameHandler;

self_SET(PFH, _pfh);
self_SET(Enabled, true);

[
    HINT_WALLHACK,
    format ["Enabled [%1 m]", self_GET(Range)],
    HINT_WALLHACK_SETTINGS_INFO
] call FUNC(hint);
