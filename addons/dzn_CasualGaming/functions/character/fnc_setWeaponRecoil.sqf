#include "..\script_component.hpp"
#include "..\main\reasons.hpp"

/* ----------------------------------------------------------------------------
Function: dzn_CasualGaming_fnc_setWeaponRecoil

Description:
    Changes weapon recoil coefficient

Parameters:
    _coefChange -- recoil coefficient in % (e.g. -75 means -75%) <NUMBER>

Returns:
    none

Examples:
    (begin example)
        [-75] call dzn_CasualGaming_fnc_setWeaponRecoil; // Sets recoil to 25% of initial value
    (end)

Author:
    10Dozen
---------------------------------------------------------------------------- */

params ["_coefChange"];

// --- Save default recoil coef
private _coef = player getVariable [SVAR(DefaultRecoilCoef), -99];
if (_coef < 0) then {
    _coef = unitRecoilCoefficient player;
    player setVariable [SVAR(DefaultRecoilCoef), _coef];
};

if (_coefChange != 0) then {
    _coef = _coef * (100 + _coefChange)/100;
};

// --- Update recoil coef
player setUnitRecoilCoefficient _coef;

hint parseText format ["<t size='1.5' color='#FFD000' shadow='1'>Recoil changed</t><br />%1%2", _coefChange, "%"];
[player, REASON_WEAPON_RECOIL_CHANGED] call FUNC(logUserAction);
