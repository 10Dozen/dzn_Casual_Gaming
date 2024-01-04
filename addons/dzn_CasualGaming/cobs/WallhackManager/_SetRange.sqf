#include "..\script_component.hpp"
#include "WallhackManager.h"
#include "\z\dzn_CasualGaming\addons\dzn_CasualGaming\reasons.hpp"

params ["_range"];

self_SET(Range, _range);

if (!self_GET(Enabled)) then {
    self_CALL(Enable);
};

[
    HINT_WALLHACK,
    "Range changed!",
    HINT_WALLHACK_SETTINGS_INFO
] call FUNC(hint);

[player, REASON_WALLHACK_RANGE_CHANGED] call FUNC(logUserAction);
