#include "..\script_component.hpp"

/* ----------------------------------------------------------------------------
Function: dzn_CasualGaming_fnc_remoteExecAll

Description:
    Runs given function with given arguments on all clients using remoteExec.
    Function will be published before remoteExec.

Parameters:
    0: _function -- name of the function <STRING>.
    1: _functionArgs -- arguments of the function to run with <ANY>.


Returns:
    none

Examples:
    (begin example)
        [] call dzn_CasualGaming_fnc_remoteExecAll;
    (end)

Author:
    10Dozen
---------------------------------------------------------------------------- */


params ["_function", "_functionArgs", ["_delay", 0.5]];

[_function] call FUNC(publishFunction);

_functionArgs remoteExec [_function, -2];
