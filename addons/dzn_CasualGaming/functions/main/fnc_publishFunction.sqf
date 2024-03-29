#include "..\script_component.hpp"

/* ----------------------------------------------------------------------------
Function: dzn_CasualGaming_fnc_publishFunction

Description:
    Publish function over the network, allowing to remote call it later.

Parameters:
    _functionName -- name of the function to publish <STRING>

Returns:
    <BOOL> - is function published (return false if function name is incorrect)

Examples:
    (begin example)
        ["dzn_CasualGaming_fnc_heal"] call dzn_CasualGaming_fnc_publishFunction; // Turns auto-heal on
    (end)

Author:
    10Dozen
---------------------------------------------------------------------------- */

params ["_functionName"];

// --- Check that _functionName will not be published again from same source
if (isNil SVAR(PublishedList)) then {
    GVAR(PublishedList) = [];
};

// --- Exit if already published
if (GVAR(PublishedList) findIf {_x == _functionName} > -1) exitWith { true };

// --- Exit if _functionName not exists
if (isNil compile _functionName) exitWith { false };

// --- Publish list to avoid repeated publishing of functions
GVAR(PublishedList) pushBack _functionName;
publicVariable SVAR(PublishedList);

// --- Publish function
publicVariable _functionName;

true
