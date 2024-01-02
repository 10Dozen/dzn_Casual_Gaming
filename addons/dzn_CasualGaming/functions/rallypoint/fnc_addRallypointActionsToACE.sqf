#include "..\script_component.hpp"
#include "defines.hpp"

/* ----------------------------------------------------------------------------
Function: dzn_CasualGaming_fnc_addRallypointActionsToACE

Description:
    Creats ACE Intercation menu actions to use rallypoint system.

Parameters:
    none

Returns:
    <BOOL> - is added

Examples:
    (begin example)
        _added = [] call dzn_CasualGaming_fnc_addRallypointActionsToACE; // true
    (end)

Author:
    10Dozen
---------------------------------------------------------------------------- */

if (isNil "ace_interact_menu_fnc_addActionToClass") exitWith { false };

private _player = typeof player;
private _actionFormat = [_player, 1, ["ACE_SelfActions",SVAR(RallypointNode)]];

// --- Root node
[
    _player,1,["ACE_SelfActions"]
    , [SVAR(RallypointNode), "Rallypoint", "", {}, {}] call ace_interact_menu_fnc_createAction
] call ace_interact_menu_fnc_addActionToClass;

// --- Actions
{
    private _action = _x call ace_interact_menu_fnc_createAction;
    (+_actionFormat + [_action]) call ace_interact_menu_fnc_addActionToClass;
} forEach [
    [SVAR(SetRallypointNode), "Set Rallypoint", "", { ["SET", RP_CUSTOM] call FUNC(manageRallypoint) }, {true}]
    , [SVAR(GoToMyRallypointNode), "Deploy to My Rallypoint", "", { ["DEPLOY_TO", RP_CUSTOM] call FUNC(manageRallypoint); }, { ["CHECK_EXISTS", RP_CUSTOM] call FUNC(manageRallypoint) }]
    , [SVAR(GoToSquadRallypointNode), "Deploy to Squad Rallypoint", "", { ["DEPLOY_TO", RP_SQUAD] call FUNC(manageRallypoint); }, { ["CHECK_EXISTS", RP_SQUAD] call FUNC(manageRallypoint) }]
];

true
