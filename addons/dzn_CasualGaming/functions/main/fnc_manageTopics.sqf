#include "..\script_component.hpp"
#include "..\auth\permission_map.hpp"
#include "..\rallypoint\defines.hpp"
#include "reasons.hpp"

#define SELF FUNC(manageTopics)
#define QSELF QFUNC(manageTopics)

/* ----------------------------------------------------------------------------
Function: dzn_CasualGaming_fnc_manageTopics

Description:
    Adds briefing topics.

Parameters:
    _mode -- call mode ("ADD", "CHECK_EXISTS") <STRING>
    _args -- (optional) arguments for call mode (e.g. topic name) <ANY>

Returns:
    <ANY>:
        <BOOL> -- execution result for "CHECK_EXISTS" call
        <STRING> -- topic text for "GET" call


Examples:
    (begin example)
        ["AUTOHEAL"] call dzn_CasualGaming_fnc_manageTopics
    (end)

Author:
    10Dozen
---------------------------------------------------------------------------- */
#define IS_PERMITTED(FEATURE) ["CHECK_PERMISSION", FEATURE] call FUNC(manageAuth)

params ["_mode",["_args", ""]];

// ["Invoked. Mode: %1, Params: -", _mode, _args] call MT_Log;

private _result = false;

switch (toUpper _mode) do {
    case "CHECK_EXISTS": {
        _result = player diarySubjectExists SVAR(Page);
    };
    case "ADD_ALL": {
        {
            ["ADD", _x] call SELF;
        } forEach [
            /* Reversed order, as last added displayed first in the list */
            "MISC"
            ,"GROUP_AI"
            ,"RALLYPOINT"
            ,"VEHICLE"
            ,"ARSENAL"
            ,"RESPAWN"
            ,"CHARACTER"
        ];
    };
    case "ADD": {
        if !(["CHECK_EXISTS"] call SELF) then {
            player createDiarySubject [SVAR(Page), "dzn Casual Gaming"];
        };

        // --- Get topic text and remove all whitespaces and carriage return symbols
        private _topicData = ["GET", _args] call SELF;
        if (_topicData isEqualTo []) exitWith {};
        player createDiaryRecord [
            SVAR(Page)
            , [_topicData # 0, (_topicData # 1) splitString toString[9, 13, 10] joinString ""]
        ];
    };
    case "COMPOSE": {
        _result = _args select { IS_PERMITTED(_x # 0) } apply { _x # 1 };
    };
    case "GET": {
        _result = [];
        private _lines = "";
        private _name = "";

        switch (toUpper _args) do {
            case "CHARACTER": {
                _name = "Character";
                _lines = [
                    [
                        PERM_HEAL,
                        preprocessFile "\z\dzn_CasualGaming\addons\dzn_CasualGaming\topics\heal.hpp"
                    ],
                    [
                        PERM_GHEAL,
                        preprocessFile "\z\dzn_CasualGaming\addons\dzn_CasualGaming\topics\global_heal.hpp"
                    ],
                    [
                        PERM_FATIGUE,
                        preprocessFile "\z\dzn_CasualGaming\addons\dzn_CasualGaming\topics\fatigue.hpp"
                    ],
                    [
                        PERM_WEAPON_SWAY,
                        preprocessFile "\z\dzn_CasualGaming\addons\dzn_CasualGaming\topics\weapon_sway.hpp"
                    ],
                    [
                        PERM_WEAPON_RECOIL,
                        preprocessFile "\z\dzn_CasualGaming\addons\dzn_CasualGaming\topics\weapon_recoil.hpp"
                    ]
                ];
            };
            case "RESPAWN": {
                _name = "Respawn Time";
                _lines = [
                    [
                        PERM_RESPAWN,
                        preprocessFile "\z\dzn_CasualGaming\addons\dzn_CasualGaming\topics\respawn.hpp"
                    ]
                ];
            };
            case "ARSENAL": {
                _name = "Arsenal";
                _lines = [
                    [
                        PERM_ARSENAL,
                        preprocessFile "\z\dzn_CasualGaming\addons\dzn_CasualGaming\topics\arsenal.hpp"
                    ]
                ];
            };
            case "VEHICLE": {
                _name = "Vehicle";
                _lines = [
                    [
                        PERM_GARAGE,
                        preprocessFile "\z\dzn_CasualGaming\addons\dzn_CasualGaming\topics\vehicle_garage.hpp"
                    ],
                    [
                        PERM_VEHICLE_SERVICE,
                        preprocessFile "\z\dzn_CasualGaming\addons\dzn_CasualGaming\topics\vehicle_service.hpp"
                    ],
                    [
                        PERM_VEHICLE_CONTROL,
                        preprocessFile "\z\dzn_CasualGaming\addons\dzn_CasualGaming\topics\vehicle_control.hpp"
                    ],
                    [
                        PERM_VEHICLE_DRIVER,
                        preprocessFile "\z\dzn_CasualGaming\addons\dzn_CasualGaming\topics\vehicle_driver.hpp"
                    ],
                    [
                        PERM_PINNED_VEHICLES,
                        preprocessFile "\z\dzn_CasualGaming\addons\dzn_CasualGaming\topics\vehicle_pin.hpp"
                    ]
                ];
            };
            case "RALLYPOINT": {
                _name = "Rallypoint";
                _lines = [
                    [
                        PERM_RALLYPOINT,
                        preprocessFile "\z\dzn_CasualGaming\addons\dzn_CasualGaming\topics\rallypoint.hpp"
                    ]
                ];
            };
            case "MISC": {
                _name = "Misc";
                _lines = [
                    [
                        PERM_CAMERA,
                        preprocessFile "\z\dzn_CasualGaming\addons\dzn_CasualGaming\topics\misc_camera.hpp"
                    ],
                    [
                        PERM_CONSOLE,
                        preprocessFile "\z\dzn_CasualGaming\addons\dzn_CasualGaming\topics\misc_console.hpp"
                    ],
                    [
                        PERM_WALLHACK,
                        preprocessFile "\z\dzn_CasualGaming\addons\dzn_CasualGaming\topics\misc_wallhack.hpp"
                    ]
                ];
            };
            case "GROUP_AI": {
                _name = "Group AI";
                _lines = [
                    [
                        PERM_GROUP_CONTROL,
                        preprocessFile "\z\dzn_CasualGaming\addons\dzn_CasualGaming\topics\group_control.hpp"
                    ],
                    [
                        PERM_GROUP_AI,
                        preprocessFile "\z\dzn_CasualGaming\addons\dzn_CasualGaming\topics\ai_control.hpp"
                    ]
                ];
            };
        };

        private _composedLines = ["COMPOSE", _lines] call SELF;
        if (_composedLines isEqualTo []) exitWith {};
        _result = [_name, _composedLines joinString "<br />"];
    };
};

// ["Finished. Mode: %1, Params: %2, Result: -", _mode, _args, [_result, "Success"] select (_result isEqualTo -1)] call MT_Log;

_result
