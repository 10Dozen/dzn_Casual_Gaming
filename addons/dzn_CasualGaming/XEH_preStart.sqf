#include "script_component.hpp"
#include "XEH_PREP.hpp"

if (isServer) then {
    GVAR(LogReasons) = call compile preprocessFileLineNumbers format [
        "%1\functions\main\mapLogReasons.sqf",
        PATH
    ];
};
