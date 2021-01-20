#include "macro.hpp"

/*
F - Use addSettings function instead of initSetting
F - Make server settings global 

F - Vehicle: Change set in flight logic to actually move in flight 
F - Vehicle: Add option to set in flight at high altitude (5000 and 10000)
F - Vehicle: Land should hover over sea
F - Vehicle: Hover on should save tilt of the craft

F - Vehicle: Garage: Add UI button and spawn vehicle only when this button clicked (remove vehicle otherwise)

- Wallhack distance options 100, 300, 500, 1000
- Test whitelist/blacklist settings 

- Disable individual functions option... via cba setting?

- Vehicle shortcut:
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

*/

call compile preprocessFileLineNumbers format ["%1\Functions.sqf", PATH];
call compile preprocessFileLineNumbers format ["%1\Settings.sqf", PATH];

if (isServer) then {
    GVAR(LogReasons) = [
        /* 0 */ "Authorized"
        , /* 1 */ "Healing"
        , /* 2 */ "Global Healing"
        , /* 3 */ "Fatigue toggled"

        , /* 4 */ "Deployed to rallypoint"
        , /* 5 */ "Rallypoint set"

        , /* 6 */ "Accessing Arsenal"
        , /* 7 */ "Loadout saved"
        , /* 8 */ "Loadout applied"
        , /* 9 */ "Accessing Garage"
        , /* 10 */ "Loadout copied"

        , /* 11 */ "Respawn timer changed"

        , /* 12 */ "Vehicle repaired"
        , /* 13 */ "Vehicle refueled"
        , /* 14 */ "Vehicle rearmed"
        , /* 15 */ "Vehicle Driver added"
        , /* 16 */ "Vehicle moved in air"

        , /* 17 */ "Wallhack toggled"
        , /* 18 */ "Splendid Camera opened"
        , /* 19 */ "Console opened"

        , /* 20 */ "Vehicle Driver removed"
        , /* 21 */ "Vehicle landed"
        , /* 22 */ "Vehicle hover toggled"
        , /* 23 */ "Rallypoint removed"

        , /* 24 */ "Rating fixed"
        , /* 25 */ "Global Rating fixed"
        , /* 26 */ "Leadership taken"
        , /* 27 */ "Units added to group"
        , /* 28 */ "Group AI Units healed"
        , /* 29 */ "Group AI Units rallied up"
        , /* 30 */ "Group AI Loadouts applied"
        , /* 31 */ "Group AI Loadouts restored / rearmed"
        , /* 32 */ "Group AI Units removed"
        , /* 33 */ "Group leaved"
        , /* 34 */ "Joined to group"
        , /* 35 */ "Unit joined to player's group"
        , /* 36 */ "Group AI Arsenal applied"
    ];
};

// Exit at dedicated or headless client
if !(hasInterface) exitWith {};

// --- Init variables 
// Rallypoint: Rally point object class
GVAR(RallyPointClass) = "Pole_F";

// Wallhack module
GVAR(WallhackEnabled) = false;


// --- Init
// --- Exit if not authorized
if !(call GVAR(fnc_checkUserAuthorized)) exitWith {};
[player, 0] call GVAR(fnc_logUserAction);

// --- Save default mission loadout to mission loadout 1
missionNamespace setVariable [format ["%1_%2", SVAR(Loadout), 1], getUnitLoadout player];

// --- Adds topics
[{
    if (["CHECK_EXISTS"] call GVAR(fnc_addTopic)) exitWith {};
    ["ADD_ALL"] call GVAR(fnc_addTopic);
}, [], 2] call CBA_fnc_waitAndExecute;
