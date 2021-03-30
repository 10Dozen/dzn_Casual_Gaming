
#include "macro.hpp"

if (isServer) then {
	GVAR(LogReasons) = call compile preprocessFileLineNumbers format [
		"%1\functions\main\mapLogReasons.sqf",
		PATH
	];
};

// --- Init for mission script
// call compile preprocessFileLineNumbers format ["%1\PreInit.sqf", PATH];
// [{ [] call FUNC(init); }, [], 3] call cba_fnc_waitAndExecute;
