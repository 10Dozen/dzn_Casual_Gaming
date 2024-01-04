#include "..\script_component.hpp"
#include "WallhackManager.h"
#include "\z\dzn_CasualGaming\addons\dzn_CasualGaming\reasons.hpp"

/* ----------------------------------------------------------------------------
Function: toggle

Description:
    Toggles Wallhack feature ON or OFF.

Parameters:
    none

Returns:
    none

Examples:
    (begin example)
        dzn_CasualGaming_cob_WallhackManager call ["toggle"];
    (end)

Author:
    10Dozen
---------------------------------------------------------------------------- */

if (self_GET(Enabled)) then {
    self_CALL(Disable);
} else {
    self_CALL(Enable);
};

[player, REASON_WALLHACK_TOGGLED] call FUNC(logUserAction);
