#include "macro.hpp"


call compile preprocessFileLineNumbers format ["%1\Functions.sqf", PATH];
// call compile preprocessFileLineNumbers format ["%1\Settings.sqf", PATH];

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
    ];
};







/*

[] spawn {
    waitUntil { !isNull (call BIS_fnc_displayMission) && !isNull player && local player };

    // --- Wait for 5 minutes to get authorized
    waitUntil { 
        sleep 2; 
        time > 5*60 || call GVAR(fnc_checkUserAuthorized) 
    };

    if !(call GVAR(fnc_checkUserAuthorized)) exitWith {};

    [player, 0] call GVAR(fnc_logUserAction);


    // --- Initialization
    call compile preProcessFileLineNumbers "\dzn_CasualGaming\UIFunctions.sqf";
    {
        call compile preprocessFileLineNumbers format ["%1\modules\%2.sqf", PATH, _x];
    } forEach [
        "AutoHeal"
        , "Arsenal"
        , "Respawn"
        , "Rallypoint"
        , "VehicleService"
        , "Wallhack"
    ];

    dzn_CG_Loadout_1 = getUnitLoadout player;
    dzn_CG_Loadout_2 = [] + dzn_CG_Loadout_1;
    dzn_CG_Loadout_3 = [] + dzn_CG_Loadout_1;
 
    dzn_CG_Loadout_4 = profileNamespace getVariable ["dzn_CG_Loadout_4", [] + dzn_CG_Loadout_1];
    dzn_CG_Loadout_5 = profileNamespace getVariable ["dzn_CG_Loadout_5", [] + dzn_CG_Loadout_1];
    dzn_CG_Loadout_6 = profileNamespace getVariable ["dzn_CG_Loadout_6", [] + dzn_CG_Loadout_1];


    // --- Re-adds topics if were deleted somehow (e.g. DRO/DCO when switching to new mission)
    while { true } do {
        sleep 10;

        if !(player diarySubjectExists "dzn_CG_Page") then {
            #include "Topics.sqf"
        };
    }
};

*/