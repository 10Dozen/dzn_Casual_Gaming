#include "..\script_component.hpp"
/* ----------------------------------------------------------------------------
Function: dzn_CasualGaming_fnc_hint

Description:
    Shows pre-formatted hint.

Parameters:
    _template - template to use <NUMBER>
    _msg - message to use <STRING>
    _arg1..._arg9 -- optional, args to use in _msg <STRING>

Returns:
    none

Examples:
    (begin example)
        [0,"Range: %1 m", 500] call dzn_CasualGaming_fnc_hint;
    (end)

Author:
    10Dozen
---------------------------------------------------------------------------- */

params [
    "_template",
    "_msg",
    ["_arg1", nil], ["_arg2", nil], ["_arg3", nil], ["_arg4", nil],
    ["_arg5", nil], ["_arg6", nil], ["_arg7", nil], ["_arg8", nil],
    ["_arg9", nil]
];

hint parseText format [
    _template,
    format [_msg, _arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7, _arg8, _arg9]
];
