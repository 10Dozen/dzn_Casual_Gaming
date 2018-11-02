#include "..\macro.hpp"

dzn_CG_WallhackEnabled = false;

["dzn_CG_Wallhack_EH", "onEachFrame", { player call dzn_CG_fnc_handleWallhackEH; }] call BIS_fnc_addStackedEventHandler;

dzn_CG_fnc_toggleWallhack = {
	dzn_CG_WallhackEnabled = !dzn_CG_WallhackEnabled;
	
	hint parseText format [
		"<t size='1.5' color='#FFD000' shadow='1'>Wallhack toggled to %1</t>"
		, if (dzn_CG_WallhackEnabled) then { "ON" } else { "OFF" }
	];

	[player, 17] call GVAR(fnc_logUserAction);
};


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