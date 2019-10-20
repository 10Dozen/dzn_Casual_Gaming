#include "..\..\macro.hpp"

/* ----------------------------------------------------------------------------
Function: dzn_CasualGaming_fnc_handleWallhackEH

Description:
	Draw icon for each unit on screen, on each frame.

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

{
	private _d = player distance _x;
	private _posV = _x modelToWorld (_x selectionPosition "head");
	private _textPos = [_posV # 0, _posV # 1, (_posV # 2) + 0.025 * _d];
	private _text = format ["%1 m", str(round _d)];
	private _color = switch (side _x) do {
		case west:   		{ [0,0.5,0.9,1] };
		case east:   		{ [0.8,0,0,1] };
		case resistance:  	{ [0,0.8,0,1] };
		case civilian:  	{ [0.6,0,0.8,1] };	
	};

	drawIcon3D ['', _color, _posV, 0, 0, 0, "+", 2, 0.035, 'puristaMedium'];
	drawIcon3D ['', _color, _textPos, 0, 0, 0, _text , 2, 0.035, 'puristaMedium'];
} forEach (player nearEntities [["CAManBase"], 300]);