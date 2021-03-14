/* ----------------------------------------------------------------------------
Function: dzn_CasualGaming_fnc_vehicle_toggleCache

Description:
	Caches given object. If object is typeOf "Man" -- toggles AI.

Parameters:
	_obj -- vehicle to check <OBJECT>
	_doCache -- flag to cache (true) or uncache (false) <BOOLEAN>

Returns:
	none

Examples:
    (begin example)
		[vehicle player, _mode] call dzn_CasualGaming_fnc_vehicle_toggleCache;
    (end)

Author:
	10Dozen
---------------------------------------------------------------------------- */

params ["_obj", "_doCache"];

[_obj, !_doCache] remoteExec ["enableSimulationGlobal", 2];
[_obj, _doCache] remoteExec ["hideObjectGlobal", 2];

if (_obj isKindOf "Man") then {
	if (_doCache) then {
		_obj disableAI "ALL";
	} else {
		_obj enableAI "ALL";
	};
};
