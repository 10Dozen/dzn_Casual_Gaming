#include "..\script_component.hpp"
#include "WallhackManager.h"
#include "\z\dzn_CasualGaming\addons\dzn_CasualGaming\reasons.hpp"

if (self_GET(Enabled)) then {
    self_CALL(Disable);
} else {
    self_CALL(Enable);
};

[player, REASON_WALLHACK_TOGGLED] call FUNC(logUserAction);
