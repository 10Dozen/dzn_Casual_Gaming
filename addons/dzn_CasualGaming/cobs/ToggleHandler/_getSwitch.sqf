#include "script_component.hpp"

/* ----------------------------------------------------------------------------
Function: <ToggleHandlerCOB>.getSwitch

Description:
    Returns switch data - state, value and name.

Parameters:
    _switchID -- switch identity <ANY HashMap key>

Returns:
    <ARRAY> switch info: [_state <BOOL>, _value <ANY>, _valueName <STRING>]

Examples:
    (begin example)
        _switchData = COB call ["getswitch", _switchID];
    (end)

Author:
    10Dozen
---------------------------------------------------------------------------- */

if (isNil "_this") exitWith {
    self_GET(Switches)
};

self_GET(Switches) get _this
