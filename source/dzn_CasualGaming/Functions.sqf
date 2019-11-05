#include "macro.hpp"

// --- Main
COMPILE_FUNCTION(main,fnc_checkUserAuthorized);
COMPILE_FUNCTION(main,fnc_logUserAction);
COMPILE_FUNCTION(main,fnc_publishFunction);
COMPILE_FUNCTION(main,fnc_addTopic);
COMPILE_FUNCTION(main,fnc_applyLoadoutToUnit);

// --- AutoHeal component
COMPILE_FUNCTION(autoheal,fnc_heal);
COMPILE_FUNCTION(autoheal,fnc_healAll);
COMPILE_FUNCTION(autoheal,fnc_setAutoHealSettings);
COMPILE_FUNCTION(autoheal,fnc_setAuthoHealHandler);
COMPILE_FUNCTION(autoheal,fnc_toggleFatigue);

// --- Rallypoint component 
COMPILE_FUNCTION(rallypoint,fnc_checkRallypointExists);
COMPILE_FUNCTION(rallypoint,fnc_setRallypoint);
COMPILE_FUNCTION(rallypoint,fnc_moveToRallypoint);
COMPILE_FUNCTION(rallypoint,fnc_removeRallypoint);
COMPILE_FUNCTION(rallypoint,fnc_addRallypointActionsToACE);

// --- Arsenal & Garage component 
COMPILE_FUNCTION(arsenal,fnc_openArsenal);
COMPILE_FUNCTION(arsenal,fnc_manageLoadouts);

// --- Respawn component 
COMPILE_FUNCTION(respawn,fnc_respawnManager);

// --- Vehicle  
COMPILE_FUNCTION(vehicle,fnc_manageVehicle);
COMPILE_FUNCTION(vehicle,fnc_openGarage);

// --- Group AI
COMPILE_FUNCTION(group_ai,fnc_ratingFix);
COMPILE_FUNCTION(group_ai,fnc_ratingFixAll);
COMPILE_FUNCTION(group_ai,fnc_manageGroup);

// --- Misc component
COMPILE_FUNCTION(misc,fnc_toggleWallhack);
COMPILE_FUNCTION(misc,fnc_handleWallhackEH);
COMPILE_FUNCTION(misc,fnc_handleConsole);
