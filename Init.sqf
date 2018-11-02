#include "macro.hpp"

call compile preprocessFileLineNumbers format ["%1\Settings.sqf", PATH];
call compile preprocessFileLineNumbers format ["%1\Functions.sqf", PATH];

if !(hasInterface) exitWith {};

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
    /*
    dzn_CG_Loadout_4 = profileNamespace getVariable ["dzn_CG_Loadout_4", [] + dzn_CG_Loadout_1];
    dzn_CG_Loadout_5 = profileNamespace getVariable ["dzn_CG_Loadout_5", [] + dzn_CG_Loadout_1];
    dzn_CG_Loadout_6 = profileNamespace getVariable ["dzn_CG_Loadout_6", [] + dzn_CG_Loadout_1];
    */

    // --- Re-adds topics if were deleted somehow (e.g. DRO/DCO when switching to new mission)
    while { true } do {
        sleep 10;

        if !(player diarySubjectExists "dzn_CG_Page") then {
            #include "Topics.sqf"
        };
    }
};