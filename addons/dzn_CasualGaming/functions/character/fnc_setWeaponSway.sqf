#include "..\script_component.hpp"
#include "..\main\reasons.hpp"

/* ----------------------------------------------------------------------------
Function: dzn_CasualGaming_fnc_setWeaponSway

Description:
    Changes weapon sway coefficient

Parameters:
    _coefChange -- sway coefficient in % (e.g. -75 means -75%) <NUMBER>

Returns:
    none

Examples:
    (begin example)
        [-75] call dzn_CasualGaming_fnc_setWeaponSway;  // Sets sway to 25% of initial value
    (end)

Author:
    10Dozen
---------------------------------------------------------------------------- */

params ["_coefChange"];

private _player = [] call CBA_fnc_currentUnit;

private _coef = (100 + _coefChange)/100; // If 0 passed - _coef = 1
_player setCustomAimCoef _coef;

if (!isNil "ACE_setCustomAimCoef_baseline") then {
    // In case of ACE - need to add to ACE sway handler
    private _coefCallback = compile format ["%1", _coef];

    if (_coefChange < 0) then {
        // Save ACE sway subscribers
        private _baseline_copy = +ACE_setCustomAimCoef_baseline;
        private _multiplier_copy = +ACE_setCustomAimCoef_multiplier;
        GVAR(ACE_Sway) = [
            _baseline_copy,
            _multiplier_copy
        ];

        // Clear sway subscribers.
        // This will disable Fatigue/Medical sway effects
        ACE_setCustomAimCoef_baseline = createHashMap;
        ACE_setCustomAimCoef_multiplier = createHashMap;

        ACE_setCustomAimCoef_baseline set [SVAR(Sway), _coefCallback];
        ACE_setCustomAimCoef_multiplier set [SVAR(Sway), _coefCallback];
    } else {
        // Restore ACE sway sources if was removed previously
        if (!isNil SVAR(ACE_Sway)) then {
            ACE_setCustomAimCoef_baseline = GVAR(ACE_Sway) # 0;
            ACE_setCustomAimCoef_multiplier = GVAR(ACE_Sway) # 1;
            GVAR(ACE_Sway) = nil;
        };

        // Add custom sway source
        ACE_setCustomAimCoef_baseline set [SVAR(Sway), _coefCallback];
        ACE_setCustomAimCoef_multiplier set [SVAR(Sway), _coefCallback];
    };
};

[format ["<t size='1.5' color='#FFD000' shadow='1'>Sway changed</t><br />%1%2", _coefChange, "%"]] call FUNC(hint);
[player, REASON_WEAPON_SWAY_CHANGED] call FUNC(logUserAction);
