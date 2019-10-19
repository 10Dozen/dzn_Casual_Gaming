#include "..\..\macro.hpp"

/* ----------------------------------------------------------------------------
Function: dzn_CasualGaming_fnc_handleWallhackEH

Description:
	Per frame draw of units icons on screen.

Parameters:
	none

Returns:
	none

Examples:
    (begin example)
		[dzn_CasualGaming_fnc_handleWallhackEH] call CBA_fnc_addPerFrameHandler;
    (end)

Author:
	10Dozen
---------------------------------------------------------------------------- */

if (!GVAR(WallhackEnabled)) exitWith {};







dzn_CG_fnc_handleWallhackEH = {
	if (!dzn_CG_WallhackEnabled) exitWith {};
	if (isNull _this) exitWith {};
	
	private _tgts = _this nearEntities [["CAManBase"], 300];
	
	{
		private _posV = _x modelToWorld (_x selectionPosition "head");
		private _textPos = [
			_posV select 0
			, _posV select 1
			, (_posV select 2) + 0.025*(player distance _x)
		];
		private _text = str(round(player distance _x)) + "m";
		private _color = switch (side _x) do {
			case west:   		{ [0,0.5,0.9,1] };
			case east:   		{ [0.8,0,0,1] };
			case resistance:  	{ [0,0.8,0,1] };
			case civilian:  	{ [0.6,0,0.8,1] };	
		};
		
		drawIcon3D ['', _color, _posV, 0, 0, 0, "+", 2, 0.035, 'puristaMedium'];
		drawIcon3D ['', _color, _textPos, 0, 0, 0, _text , 2, 0.035, 'puristaMedium'];
	} forEach _tgts;	
};