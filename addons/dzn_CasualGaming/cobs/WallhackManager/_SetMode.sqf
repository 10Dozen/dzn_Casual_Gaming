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
    case MODE_SIDE: {    self_GET(SideFilter) };
    case MODE_TYPES: {   self_GET(TypeFilter)  };
};

if (isNil "_modeKey") exitWith {
    // _modeHandler call ["reset", true];
    cob_CALL(_modeHandler, Reset);

    [
        HINT_WALLHACK,
        format ["%1 reset!", cob_GET(_modeHandler, Name) /* get "name"*/],
        HINT_WALLHACK_SETTINGS_INFO
    ] call FUNC(hint);
};

//_modeHandler call ["toggle", _modeKey];
cob_CALL_WITH(_modeHandler, Toggle) _modeKey VARSET;
[
    HINT_WALLHACK,
    format ["%1 changed!", cob_GET(_modeHandler, Name) ], //_modeHandler get "name"],
    HINT_WALLHACK_SETTINGS_INFO
] call FUNC(hint);
