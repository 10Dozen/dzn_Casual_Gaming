#include "script_component.hpp"

// --- Auth
COMPILE_FUNCTION(auth,fnc_manageAuth);

// --- Main
COMPILE_FUNCTION(main,fnc_init);
COMPILE_FUNCTION(main,fnc_logUserAction);
COMPILE_FUNCTION(main,fnc_logActionRemote);
COMPILE_FUNCTION(main,fnc_publishFunction);
COMPILE_FUNCTION(main,fnc_remoteExecAll);
COMPILE_FUNCTION(main,fnc_manageTopics);
COMPILE_FUNCTION(main,fnc_handleHotkey);
COMPILE_FUNCTION(main,fnc_hint);

// --- Character component
COMPILE_FUNCTION(character,fnc_heal);
COMPILE_FUNCTION(character,fnc_healAll);
COMPILE_FUNCTION(character,fnc_setAutoHealSettings);
COMPILE_FUNCTION(character,fnc_setAuthoHealHandler);
COMPILE_FUNCTION(character,fnc_toggleFatigue);
COMPILE_FUNCTION(character,fnc_setWeaponSway);
COMPILE_FUNCTION(character,fnc_setWeaponRecoil);

// --- Rallypoint component
COMPILE_FUNCTION(rallypoint,fnc_manageRallypoint);
COMPILE_FUNCTION(rallypoint,fnc_addRallypointActionsToACE);
COMPILE_FUNCTION(rallypoint,fnc_safeMove);

// --- Arsenal & Garage component
COMPILE_FUNCTION(arsenal,fnc_openArsenal);
COMPILE_FUNCTION(arsenal,fnc_manageLoadouts);
COMPILE_FUNCTION(arsenal,fnc_applyLoadoutToUnit);

// --- Respawn component
COMPILE_FUNCTION(respawn,fnc_respawnManager);

// --- Vehicle
COMPILE_FUNCTION(vehicle,fnc_manageVehicle);
COMPILE_FUNCTION(vehicle,fnc_openGarage);
COMPILE_FUNCTION(vehicle,fnc_managePinnedVehicle);

COMPILE_FUNCTION(vehicle,fnc_vehicle_changeSeat);
COMPILE_FUNCTION(vehicle,fnc_vehicle_getEmptySeats);
COMPILE_FUNCTION(vehicle,fnc_vehicle_toggleCache);
COMPILE_FUNCTION(vehicle,fnc_vehicle_showMenu);
COMPILE_FUNCTION(vehicle,fnc_vehicle_addHoverPFH);
COMPILE_FUNCTION(vehicle,fnc_vehicle_releaseHover);

// --- Group AI
COMPILE_FUNCTION(group_ai,fnc_ratingFix);
COMPILE_FUNCTION(group_ai,fnc_ratingFixAll);
COMPILE_FUNCTION(group_ai,fnc_manageGroup);

// --- Misc component
COMPILE_FUNCTION(misc,fnc_handleConsole);

// Component Objects
COMPILE_COB(ToggleHandler);
COMPILE_COB(WallhackManager);
