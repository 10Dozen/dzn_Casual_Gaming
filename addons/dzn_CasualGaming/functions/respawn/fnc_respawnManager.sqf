#include "..\script_component.hpp"
#include "..\main\reasons.hpp"

#define SELF FUNC(respawnManager)

/* ----------------------------------------------------------------------------
Function: dzn_CasualGaming_fnc_respawnManager

Description:
    Handle Respawn manager.

Parameters:
    _mode -- call mode ("SET_TIME", "INIT") <STRING>
    _payload -- new respawn time <NUMBER>

Returns:
    none

Examples:
    (begin example)
        ["SET_TIME", 15] call dzn_CasualGaming_fnc_respawnManager
    (end)

Author:
    10Dozen
---------------------------------------------------------------------------- */

params ["_mode",["_payload", -1]];

switch (toUpper _mode) do {
    case "INIT": {
        GVAR(RespawnHandler) = player addEventHandler [
            "Respawn"
            , { [player, false] remoteExec ["hideObjectGlobal", 2]; }
        ];
    };
    case "SET_TIME": {
        if (isNil SVAR(RespawnHandler)) then { ["INIT"] call SELF; };

        setPlayerRespawnTime _payload;

        [format [
            "<t size='1.5' color='#FFD000' shadow='1'>Respawn Time</t><br /><br />Set to %1 seconds"
            , _payload
        ]] call FUNC(hint);

        [player, REASON_RESPAWN_TIMER_CHANGED] call FUNC(logUserAction);
    };
};
