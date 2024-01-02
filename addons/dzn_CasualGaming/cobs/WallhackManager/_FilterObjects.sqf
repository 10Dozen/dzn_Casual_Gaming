#include "..\script_component.hpp"
#include "WallhackManager.h"

/* ----------------------------------------------------------------------------
Function: dzn_CasualGaming_fnc_filterWallhackObjects

Description:
    Applies basic and custom filters to object. Returns true if object matches
    filter.

Parameters:
    _this - object to check <object>.

Returns:
    _match - true if object matches filter <boolean>.

Examples:
    (begin example)
        _isFiltered = _object call dzn_CasualGaming_fnc_filterWallhackObjects;
    (end)

Author:
    10Dozen
---------------------------------------------------------------------------- */

!(isObjectHidden _this)
&& simulationEnabled _this
&& vehicle player != _this
&& { _this call GVAR(WallhackFilterCallable) }
