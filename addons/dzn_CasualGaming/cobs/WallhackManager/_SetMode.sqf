#include "..\script_component.hpp"
#include "WallhackManager.h"

/* ----------------------------------------------------------------------------
Function: setMode

Description:
    Changes mode of the filters or HUD settings. Each mode is handled by
    ToggleHandler COB.
    Enables Wallhack if it is not enabled yet.
    Shows hint with current state of the Wallhack feature settings.

Parameters:
    0: _modeHandlerID - toggleHandler enum value from WallhackManager.h <ENUM>
    1: _modeKey - identifier of the switch to change in ToggleHandler <ENUM>

Returns:
    none

Examples:
    (begin example)
        dzn_CasualGaming_cob_WallhackManager call ["setmode", [_modeHandlerID, _modeKey]];
    (end)

Author:
    10Dozen
---------------------------------------------------------------------------- */

params ["_modeHandlerID", "_modeKey"];

if (!self_GET(Enabled)) then {
    self_CALL(Enable);
};

private _modeHandler = switch _modeHandlerID do {
    case MODE_DETAILS: { self_GET(DetailLevel) };
    case MODE_SIDE: {    self_GET(SideFilter)  };
    case MODE_TYPES: {   self_GET(TypeFilter)  };
    case MODE_LOOT: {    self_GET(LootFilter)  };
};

if (isNil "_modeKey") exitWith {
    cob_CALL(_modeHandler, Reset);

    [[
        HINT_WALLHACK,
        format ["%1 reset!", cob_GET(_modeHandler, Name)],
        HINT_WALLHACK_SETTINGS_INFO
    ], 5] call FUNC(hint);
};

cob_CALL_WITH(_modeHandler, Toggle) _modeKey VARSET;
[[
    HINT_WALLHACK,
    format ["%1 changed!", cob_GET(_modeHandler, Name)],
    HINT_WALLHACK_SETTINGS_INFO
], 15] call FUNC(hint);
