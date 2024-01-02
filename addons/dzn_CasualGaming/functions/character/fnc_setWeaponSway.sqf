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

// --- Save default sway coef
private _coef = player getVariable [SVAR(DefaultSwayCoef), -99];
if (_coef < 0) then {
    _coef = getCustomAimCoef player;
    player setVariable [SVAR(DefaultSwayCoef), _coef];
};

if (_coefChange != 0) then {
    _coef = _coef * (100 + _coefChange)/100;
};

// --- Update sway coef
player setCustomAimCoef _coef;

hint parseText format ["<t size='1.5' color='#FFD000' shadow='1'>Sway changed</t><br />%1%2", _coefChange, "%"];
[player, REASON_WEAPON_SWAY_CHANGED] call FUNC(logUserAction);
