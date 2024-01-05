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

#define ENTITY_TRACKER_TIMEOUT 0.5

private _pfhEntityTracker = [
    { cob_CALL((_this # 0), TrackEntities); },
    ENTITY_TRACKER_TIMEOUT,
    _self
] call CBA_fnc_addPerFrameHandler;

private _pfhRenderer = [
    { cob_CALL((_this # 0), Render); },
    nil,
    _self
] call CBA_fnc_addPerFrameHandler;


self_SET(EntityTrackerPFH, _pfhEntityTracker);
self_SET(RendererPFH, _pfhRenderer);
self_SET(Enabled, true);

[
    HINT_WALLHACK,
    format ["Enabled [%1 m]", self_GET(Range)],
    HINT_WALLHACK_SETTINGS_INFO
] call FUNC(hint);
