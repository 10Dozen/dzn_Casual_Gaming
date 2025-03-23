#include "..\script_component.hpp"
/* ----------------------------------------------------------------------------
Function: dzn_CasualGaming_fnc_hint

Description:
    Draws formatted hint for .75 second, then draws empty hint.

Parameters:
    0: _message -- message to be parsed and shown <STRING> or array of lines to be composed <ARRAY>.
    1: _timeout -- optional timeout before hidding. Defaults to 0.75 <NUMBER>.

Returns:
    none

Examples:
    (begin example)
        [0,"Range: %1 m", 500] call dzn_CasualGaming_fnc_hint;
    (end)

Author:
    10Dozen
---------------------------------------------------------------------------- */

params ["_msg", ["_timeout", 0.75]];

// -- Prepare message
if (_msg isEqualType []) then {
    _msg = composeText (_msg apply {
        if (typename _x == typename "") then {
            parseText _x
        } else {
            _x
        };
    });
} else {
    _msg = parseText _msg;
};

// -- Show message
hint _msg;
GVAR(HintID) = diag_frameNo;

[
    {
        if (GVAR(HintID) isNotEqualTo _this) exitWith {}; // Skip if new hint was invoked
        hintSilent "";
    },
    GVAR(HintID),
    _timeout
] call CBA_fnc_waitAndExecute;
