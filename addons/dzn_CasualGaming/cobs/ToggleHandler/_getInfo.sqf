#include "script_component.hpp"

/* ----------------------------------------------------------------------------
Function: <ToggleHandlerCOB>.getInfo

Description:
    Returns text information about toggle handler state.

Parameters:
    none

Returns:
    <STRING>

Examples:
    (begin example)
        _info = COB call ["getinfo"];
    (end)

Author:
    10Dozen
---------------------------------------------------------------------------- */

private _values = self_GET(onAllEnabledInfo);

if !(self_GET(AllEnabled)) then {
    _values = (values self_GET(Switches)) select {_x # 0} apply {_x # 2};
};

if (typename _values == typename "") exitWith { _values };
_values joinString ", "
