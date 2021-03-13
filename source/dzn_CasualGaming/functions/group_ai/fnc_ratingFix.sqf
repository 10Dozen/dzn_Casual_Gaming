#include "..\..\macro.hpp"
#include "..\main\reasons.hpp"

/* ----------------------------------------------------------------------------
Function: dzn_CasualGaming_fnc_ratingFix

Description:
	Fix rating of player (prevents allied AI to attack player, allows to embark other's player vehicles)

Parameters:
	_showHint -- flag to show hint with action result <BOOL>

Returns:
	none

Examples:
    (begin example)
		[true] call dzn_CasualGaming_fnc_ratingFix; // Fix rating with hing displayed
    (end)

Author:
	10Dozen
---------------------------------------------------------------------------- */

params ["_showHint"];

private _ratingToAdd = 2000 - (rating player);
if (_ratingToAdd > 0) exitWith {
	player addRating _ratingToAdd;
};

if (_showHint) then {
	hint parseText "<t size='1.5' color='#FFD000' shadow='1'>Rating fixed</t>";
};
[player, REASON_RATING_FIXED] call FUNC(logUserAction);
