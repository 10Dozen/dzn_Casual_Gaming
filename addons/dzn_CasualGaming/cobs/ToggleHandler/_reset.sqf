#include "script_component.hpp"

/* ----------------------------------------------------------------------------
Function: <ToggleHandlerCOB>.reset

Description:
    Resets all switches to desired state.

Parameters:
    _newState - desired state for switches. Optional, default True. <BOOLEAN>

Returns:
    none

Examples:
    (begin example)
        COB call ["reset"]; //  enables all switches
        // COB call ["reset", false]; // disable all switches
    (end)

Author:
    10Dozen
---------------------------------------------------------------------------- */

systemChat format ["ToggleHandler.reset(): Args: %1", _this];
private _desiredState = if (isNil "_this") then { true } else { _this };
{
    _y set [0, _desiredState]
} forEach self_GET(Switches);

self_SET(AllEnabled, _desiredState);
