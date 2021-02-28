#include "macro.hpp"
#include "functions\main\reasons.hpp"

/*
F - Use addSettings function instead of initSetting
F - Make server settings global 
- Test whitelist/blacklist settings 

T - Vehicle: Change set in flight logic to actually move in flight 
T - Vehicle: Add option to set in flight at high altitude (5000 and 10000)
T - Vehicle: Land should hover over sea
T - Vehicle: Hover on should save tilt of the craft
T - Vehicle: Garage: Add UI button and spawn vehicle only when this button clicked (remove vehicle otherwise)
T - Wallhack distance options 100, 300, 500, 1000

T - Rallypoint refactoring

T - Vehicle shortcut:
  a) 5 slots for vehicles that player can access during mission
  b) Player is able to save his current vehicle to this slot 
  c) Player is able to then Disable the vehicle - it will be removed from the game (hidden/disableSimul)
  d) On disable vehicle saves current mission position & velocity (for arial)
  e) On disable vehicle - player seat is saved, player (and other players) become moved out and teleported to Rallypoint or to the ground at vehicle position
  f) On disable vehicle - AI units become disabled and hidden if needed
  g) Player is able to then Enable the vehicle: vehicle will be shown and enableSimul
  h) On enable: player will be moved in driver or whatever place he was
  j) On enable: ai in the vehicle will be enabled
  i) On enable: vehicle restore it's position, for aerial vehicles in air -- restore velocity and engine state 

T - Reason logging refactoring 

F - Keybind use of refactored features (e.g. Rallypoints):
  -- Rallypoint set 
  -- Rallypoint deploy 
  -- Open garage 

- Disable individual functions option... via cba setting?
 - 2 profiles - General and Filtered
 - Profiles are independant, if user is added to Filtered list - it can only exeute functions allowd for Filtered users 
 - Whitelist settings is overriding both filters if set: if user is not in Whitelist - it not allowed to use functions from General or Filtered sections, even if it added to Filtered list
 - For all:
 -  a) functions are grouped by categories and for each category there is an Checkbox 
 -  b) if checkbox is set - function execution is allowed, if not set -- no effect on execution
 -  c) Admin and server always can launch any function 
 - For general -- all users (or whitelisted users if whitelist exist) may only execute enabled functions 
 - For filtered:
 -  a) A field for UIDs is available (whitelist)
 -  b) User from whitelist may execute functions that are allowed for them in the Filtered section
 
- Replace PLAYER with CBA_fnc_currentUnit to support zeus (?)
*/

call compile preprocessFileLineNumbers format ["%1\Functions.sqf", PATH];
call compile preprocessFileLineNumbers format ["%1\Settings.sqf", PATH];

if (isServer) then {
    GVAR(LogReasons) = call compile preprocessFileLineNumbers format [
        "%1\functions\main\mapLogReasons.sqf",
        PATH
    ];
};

// Exit at dedicated or headless client
if !(hasInterface) exitWith {};

// --- Init
// --- Exit if not authorized
if !(call FUNC(checkUserAuthorized)) exitWith {};
[player, REASON_AUTHORIZED] call FUNC(logUserAction);

// --- Save default mission loadout to mission loadout 1
missionNamespace setVariable [format ["%1_%2", SVAR(Loadout), 1], getUnitLoadout player];

// --- Adds topics
[{
    ["INIT"] call FUNC(manageRallypoint);
    ["INIT"] call FUNC(manageWallhack);
    ["INIT"] call FUNC(managePinnedVehicle);

    if (["CHECK_EXISTS"] call FUNC(manageTopics)) exitWith {};
    ["ADD_ALL"] call FUNC(manageTopics);
}, [], 2] call CBA_fnc_waitAndExecute;
