#include "script_component.hpp"

/* ----------------------------------------------------------------------------
Function: <ToggleHandlerCOB>.#create

Description:
    Constructor for ToggleHandler.
    Default value will be calculated as all values from given _switchesData.

Parameters:
    0: _name - name of the toggle switches group. <STRING>
    1: _switchesData - collection of switches descriptors. Descriptors are arrays
    in format [_switchName, _valueName, _returnValue], where:
        0: _switchName - name of the switch <ANY HashMap Key>
        1: _valueName - disaply name of the value of the switch <STRING>
        2: _returnValue - array that appends to result from 'getValue' method <ARRAY>.
        Optional, by default switch '_name' will be used.
    2: _onAllEnabledInfo - name to display when all switches are enabled (meaning )

Returns:
    none

Examples:
    (begin example)
        _cob = createHashMapObject [_toggleHandlerCOB, [
            "Test Handler",
            [
                [1, "Switch 1"],
                [2, "Switch 2"],
                [3, "Switch 3", "CustomValue"]
            ],
            "All enabled"
        ]];
    (end)

Author:
    10Dozen
---------------------------------------------------------------------------- */

params ["_name", "_switchesData", "_onAllEnabledInfo"];

private _switches = createHashMap;
private _defaultValue = [];
{
    _x params ["_switchName", "_valueName", "_returnValue"];
    if (isNil "_returnValue") then { _returnValue = [_switchName]; };
    _switches set [_switchName, [true, _returnValue, _valueName]];
    _defaultValue append _returnValue;
} forEach _switchesData;

self_SET(Name, _name);
self_SET(AllEnabled, true);
self_SET(onAllEnabledInfo, _onAllEnabledInfo);
self_SET(onAllEnabledValue, _defaultValue);
self_SET(Switches, _switches);
self_SET(Count, count _switchesData);
