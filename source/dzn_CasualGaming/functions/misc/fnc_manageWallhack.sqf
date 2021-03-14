#include "..\..\macro.hpp"
#include "..\main\reasons.hpp"
#define SELF FUNC(manageWallhack)
#define QSELF QFUNC(manageWallhack)

/* ----------------------------------------------------------------------------
Function: dzn_CasualGaming_fnc_manageWallhack

Description:
	Manages wallhack settings:
		- toggle on/off
		- change wallhack radius

Parameters:
	_mode -- modes <STRING>
	_args -- (optional) call arguments <ARRAY>

Returns:
	none

Examples:
    (begin example)
		["TOGGLE"] call dzn_CasualGaming_fnc_manageWallhack; // enables wallhack
    (end)

Author:
	10Dozen
---------------------------------------------------------------------------- */

params ["_mode", ["_args",[]]];

private _title = "";

switch toUpper(_mode) do {
	case "INIT": {
		GVAR(WallhackEnabled) = false;
		GVAR(WallhackRange) = 300;
	};
	case "TOGGLE": {
		if (GVAR(WallhackEnabled)) then {
			["DISABLE"] call SELF;			
		} else {
			["ENABLE"] call SELF;
		};

		[player, REASON_WALLHACK_TOGGLED] call FUNC(logUserAction);
	};
	case "SET_RANGE": {
		GVAR(WallhackRange) = _args;

		if (GVAR(WallhackEnabled)) then {
			_title = format ["Range %1 m", GVAR(WallhackRange)];
			[player, REASON_WALLHACK_RANGE_CHANGED] call FUNC(logUserAction);
		} else {
			["ENABLE"] call SELF;
		};
	};
	case "ENABLE": {
		GVAR(Wallhack_PFH) = [FUNC(handleWallhackEH)] call CBA_fnc_addPerFrameHandler;
		GVAR(WallhackEnabled) = true;

		_title = format ["Enabled [%1 m]", GVAR(WallhackRange)];
	};
	case "DISABLE": {
		if (isNil SVAR(Wallhack_PFH)) exitWith {};
		GVAR(Wallhack_PFH) call CBA_fnc_removePerFrameHandler;
		GVAR(WallhackEnabled) = false;

		_title ="Disabled";
	};
};

if !(_title isEqualTo "") then {
	hint parseText format ["<t size='1.5' color='#FFD000' shadow='1'>Wallhack</t><br /><br />%1", _title];
};
