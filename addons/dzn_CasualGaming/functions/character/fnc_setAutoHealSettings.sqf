#include "..\script_component.hpp"

/* ----------------------------------------------------------------------------
Function: dzn_CasualGaming_fnc_setAutoHealSettings

Description:
    Change Auto-Heal feature settings according to passed value:
        - if bool -> toggles auto-heal on/off
        - if number -> set auto-heal timer (seconds)

Parameters:
    _this - on/off starte <BOOL> or auto-heal timeout <NUMBER>

Returns:
    none

Examples:
    (begin example)
        [true] call dzn_CasualGaming_fnc_setAutoHealSettings; // Turns auto-heal on
        [15] call dzn_CasualGaming_fnc_setAutoHealSettings; // Set auto-heal timer to 15 seconds
    (end)

Author:
    10Dozen
---------------------------------------------------------------------------- */

params ["_setting"];

if (typename _setting == "BOOL") then {
    GVAR(AutoHealEnabled) = _setting;
} else {
    GVAR(AutoHealTimer) = _setting;
};

[] call FUNC(setAuthoHealHandler);

[format ["<t size='1.5' color='#FFD000' shadow='1'>Auto-Heal</t>
    <br /><br />%1
    <br />%2 seconds"
    , if (GVAR(AutoHealEnabled)) then { "ON" } else { "OFF" }
    , GVAR(AutoHealTimer)
]] call FUNC(hint);
