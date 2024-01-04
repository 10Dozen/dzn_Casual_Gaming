#include "..\script_component.hpp"
#include "..\main\reasons.hpp"

/* ----------------------------------------------------------------------------
Function: dzn_CasualGaming_fnc_healAll

Description:
    Triggers global healing for all players.
    Should be spawned.

Parameters:
    none

Returns:
    none

Examples:
    (begin example)
        [] spawn dzn_CasualGaming_fnc_healAll; // Turns auto-heal on
    (end)

Author:
    10Dozen
---------------------------------------------------------------------------- */

[QFUNC(heal), [true]] call FUNC(remoteExecAll);

hint parseText "<t size='1.5' color='#FFD000' shadow='1'>Global Healing done</t>";
[player, REASON_HEALING_GLOBAL] call FUNC(logUserAction);
