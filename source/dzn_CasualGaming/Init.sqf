#include "macro.hpp"

/*
    TODO:
    - Move to seat --> need to check is palce free before moveout 
    - Hover --> If Plane -> add velocity

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
    ];
};



// --- Init
[] spawn {
    // --- Exit if not authorized
    if !(call GVAR(fnc_checkUserAuthorized)) exitWith {};
    [player, 0] call GVAR(fnc_logUserAction);

    // --- Save default mission loadout to mission loadout 1
    ["SAVE",1] call GVAR(fnc_manageLoadouts);  

    // --- Re-adds topics if were deleted somehow (e.g. DRO/DCO when switching to new mission)
    GVAR(Topics_PFH) = [{
        if (["CHECK_EXISTS"] call GVAR(fnc_addTopic)) exitWith {};
        hint "Re-add topic";
        ["ADD_ALL"] call GVAR(fnc_addTopic);
    }, 60] call CBA_fnc_addPerFrameHandler;
};

/*

[] spawn {
    [player, 0] call GVAR(fnc_logUserAction);

    dzn_CG_Loadout_1 = getUnitLoadout player;
    dzn_CG_Loadout_2 = [] + dzn_CG_Loadout_1;
    dzn_CG_Loadout_3 = [] + dzn_CG_Loadout_1;
 
    dzn_CG_Loadout_4 = profileNamespace getVariable ["dzn_CG_Loadout_4", [] + dzn_CG_Loadout_1];
    dzn_CG_Loadout_5 = profileNamespace getVariable ["dzn_CG_Loadout_5", [] + dzn_CG_Loadout_1];
    dzn_CG_Loadout_6 = profileNamespace getVariable ["dzn_CG_Loadout_6", [] + dzn_CG_Loadout_1];


};

*/