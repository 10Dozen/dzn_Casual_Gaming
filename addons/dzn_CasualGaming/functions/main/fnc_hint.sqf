#include "..\script_component.hpp"
/* ----------------------------------------------------------------------------
Function: dzn_CasualGaming_fnc_hint

Description:
    Shows pre-formatted hint.

Parameters:
    _this -- array of lines

Returns:
    none

Examples:
    (begin example)
        [0,"Range: %1 m", 500] call dzn_CasualGaming_fnc_hint;
    (end)

Author:
    10Dozen
---------------------------------------------------------------------------- */

private _msg = _this;

if (typename _msg != typename []) exitWith {
    hint parseText _msg;
};

// ComposeText case
_msg = composeText (_msg apply {
    if (typename _x == typename "") then {
        parseText _x
    } else {
        _x
    };
});

hint _msg;
