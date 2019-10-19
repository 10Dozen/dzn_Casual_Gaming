#include "macro.hpp"

// --- Main
COMPILE_FUNCTION(main,fnc_checkUserAuthorized);
COMPILE_FUNCTION(main,fnc_logUserAction);
COMPILE_FUNCTION(main,fnc_publishFunction);

// --- UI functions

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
COMPILE_FUNCTION(rallypoint,fnc_addRallypointActionsToACE);

// --- Arsenal & Garage component 
COMPILE_FUNCTION(arsenal_garage,fnc_openArsenal);
COMPILE_FUNCTION(arsenal_garage,fnc_openGarage);
COMPILE_FUNCTION(arsenal_garage,fnc_manageLoadouts);

// --- Respawn component 
COMPILE_FUNCTION(respawn,fnc_respawn_addHandler);
COMPILE_FUNCTION(respawn,fnc_respawn_setRespawnTime);

// --- Vehicle service 
COMPILE_FUNCTION(vehicleService,fnc_serviceVehicle);

// --- Misc component



