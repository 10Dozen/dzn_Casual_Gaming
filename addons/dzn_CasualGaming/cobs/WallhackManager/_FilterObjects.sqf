#include "..\script_component.hpp"
#include "WallhackManager.h"

/* ----------------------------------------------------------------------------
Function: filterObjects

Description:
    Applies basic and custom filters to object. Returns true if object matches
    filter.

Parameters:
    0: _obj - object to check against filters <OBJECT>
    1: _sideFilter - allowed sides <ARRAY of Side>

Returns:
    <BOOLEAN> True if object passes all filters, False otherwise.

Examples:
    (begin example)
        dzn_CasualGaming_cob_WallhackManager call ["filterobjects", [_obj, _sideFilter]];
    (end)

Author:
    10Dozen
---------------------------------------------------------------------------- */

params ["_obj", "_sideFilter"];

!(isObjectHidden _obj)
&& simulationEnabled _obj
&& vehicle player != _obj
&& {
    side _obj in _sideFilter
    && { _obj call GVAR(WallhackFilterCallable) }
}
