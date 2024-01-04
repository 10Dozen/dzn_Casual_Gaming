#include "script_component.hpp"

/* ----------------------------------------------------------------------------
Function: <ToggleHandlerCOB>.getValue

Description:
    Returns current active toggle values.

Parameters:
    none

Returns:
    <ARRAY> collection of values of all active switches

Examples:
    (begin example)
        _values = COB call ["getvalue"];
    (end)

Author:
    10Dozen
---------------------------------------------------------------------------- */


if (self_GET(AllEnabled)) exitWith { self_GET(onAllEnabledValue) };

private _currentValue = [];

{
    _y params ["_state", "_value"];
    if (_state) then { _currentValue append _value; };
} forEach (self_GET(Switches));

_currentValue
