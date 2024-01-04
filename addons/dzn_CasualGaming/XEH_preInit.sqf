#include "script_component.hpp"

#include "XEH_PREP.hpp"
#include "initSettings.sqf"

GVAR(COB_Cache) = createHashMap;
GVAR(WallhackFilterCallable) = {true};

["CBA_settingsInitialized", {
    [] call FUNC(init);
}] call CBA_fnc_addEventHandler;
