#include "..\script_component.hpp"
#include "..\main\reasons.hpp"

/* ----------------------------------------------------------------------------
Function: dzn_CasualGaming_fnc_ratingFixAll

Description:
    Triggers rating fix (make it positive) for all players.
    Should be spawned.

Parameters:
    none

Returns:
    none

Examples:
    (begin example)
        [] spawn dzn_CasualGaming_fnc_ratingFixAll;
    (end)

Author:
    10Dozen
---------------------------------------------------------------------------- */

[QFUNC(ratingFix), [true]] call FUNC(remoteExecAll);

["<t size='1.5' color='#FFD000' shadow='1'>Global Rating fix done</t>"] call FUNC(hint);
[player, REASON_RATING_FIXED_GLOBAL] call FUNC(logUserAction);
