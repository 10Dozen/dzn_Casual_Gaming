#include "..\script_component.hpp"
#include "..\main\reasons.hpp"

/* ----------------------------------------------------------------------------
Function: dzn_CasualGaming_fnc_toggleFatigue

Description:
    Turn fatigue on/off. Applied to both vanilla and ACE stamina.

Parameters:
    _this - turn on/off flag <BOOL>

Returns:
    none

Examples:
    (begin example)
        false call dzn_CasualGaming_fnc_toggleFatigue; // Disables fatigue
    (end)

Author:
    10Dozen
---------------------------------------------------------------------------- */

private _enable = _this;

([] call CBA_fnc_currentUnit) enableFatigue _enable;

// If ACE stamina exists
if (!isNil "ace_advanced_fatigue_enabled") then {
    if (!_enable) then {
        if (ace_advanced_fatigue_enabled) then {
            // If ACE enabled - override it's params
            GVAR(ACE_Fatigue_Handler) = [{
                ace_advanced_fatigue_anReserve = 2300;
                ace_advanced_fatigue_ae1Reserve = 4000000;
                ace_advanced_fatigue_ae2Reserve = 84000;
            }, 0.25] call CBA_fnc_addPerFrameHandler;
        };
    } else {
        // Remove fatigue params handler
        if (!isNil SVAR(ACE_Fatigue_Handler)) then {
            [GVAR(ACE_Fatigue_Handler)] call CBA_fnc_removePerFrameHandler;
            GVAR(ACE_Fatigue_Handler) = nil;
        };
    };
};

hint parseText format [
    "<t size='1.5' shadow='1'><t color='#FFD000' >Fatigue</t> %1</t>"
    , if (_enable) then { "ON" } else { "OFF" }
];

[player, REASON_FATIGUE_TOGGLED] call FUNC(logUserAction);
