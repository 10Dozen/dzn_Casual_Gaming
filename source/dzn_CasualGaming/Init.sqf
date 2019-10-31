#include "macro.hpp"

/*
    TODO:
    - Re-adding topics during the game (via CBA Settings)
    - Add rating restore (to be > 0)
    - CBA Keybind for features 

    - Player group AI manager:
        [Set Positive Rating]

        Squad:
            [BECOME LEADER] [ADD UNIT] (red)[REMOVE ALL](red) 
            
            [Heal All][Rearm All][Rally Up]
            
        Selected units:
            [Heal][Gear][Rally Up]  (red)[Remove](red)
*/

call compile preprocessFileLineNumbers format ["%1\Functions.sqf", PATH];
call compile preprocessFileLineNumbers format ["%1\Settings.sqf", PATH];

// Exit at dedicated or headless client
if !(hasInterface) exitWith {};

// --- Init variables 

// Rallypoint: Rally point object class
GVAR(RallyPointClass) = "Pole_F";

// Wallhack module
GVAR(WallhackEnabled) = false;

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
    ];
};



// --- Init

// --- Exit if not authorized
if !(call GVAR(fnc_checkUserAuthorized)) exitWith {};
[player, 0] call GVAR(fnc_logUserAction);

// --- Save default mission loadout to mission loadout 1
["SAVE",1] call GVAR(fnc_manageLoadouts);  

// --- Adds topics
[{
    if (["CHECK_EXISTS"] call GVAR(fnc_addTopic)) exitWith {};
    ["ADD_ALL"] call GVAR(fnc_addTopic);
}, [], 2] call CBA_fnc_waitAndExecute;
