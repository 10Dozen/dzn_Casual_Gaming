#include "..\script_component.hpp"
#include "WallhackManager.h"

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
