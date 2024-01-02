#include "..\script_component.hpp"
#include "WallhackManager.h"
#include "\z\dzn_CasualGaming\addons\dzn_CasualGaming\reasons.hpp"

params ["_range"];

self_SET(Range, _range);

if (!self_GET(Enabled)) then {
    self_CALL(Enable);
};

[HINT_TEMPLATE_BASIC, "Range %1 m", _range] call FUNC(hint);
[player, REASON_WALLHACK_RANGE_CHANGED] call FUNC(logUserAction);
