#include "script_component.hpp"

/* ----------------------------------------------------------------------------
Function: <ToggleHandlerCOB>.toggle

Description:
    Toggles speicif toggle switch. If as result all switches are in the same
    state (all enabled or all disabled) - handler automatically resets.

Parameters:
    _switchName - desired toggle switch to toggle. <ANY (see HashMap keys)>

Returns:
    none

Examples:
    (begin example)
        COB call ["toggle", _switchName]; // toggles specific toggle
    (end)

Author:
    10Dozen
---------------------------------------------------------------------------- */

// First time toggle - disable all and mark filter on
if (self_GET(AllEnabled)) then {
    self_CALL_WITH(Reset) false VARSET;
};
// Toggle switch
private _switches = self_GET(Switches);
private _switch = _switches get _this;
_switch set [0, !(_switch # 0)];

// Reset when all fields are in the same state
private _enabledSwitches = {_x # 0} count values _switches;
if (_enabledSwitches == 0 || _enabledSwitches == self_GET(Count)) exitWith {
    self_CALL(Reset);
};
