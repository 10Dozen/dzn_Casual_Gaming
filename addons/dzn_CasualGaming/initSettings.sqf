#include "script_component.hpp"

#define SETTING_EDITBOX "EDITBOX"
#define SETTING_CHECKBOX "CHECKBOX"
#define SETTING_NO_SCRIPT nil
#define SETTING_GLOBAL 1
#define SETTING_LOCAL 2
#define SETTING_RESTART_NEEDED true

#define SETTING_MAIN_CATEGORY TITLE

//
//     Addon Settings
//
private _add = {
    params [
        "_settingName",
        "_type",
        "_title",
        "_tooltip",
        "_category",
        "_value",
        ["_isGlobal", false],
        ["_script", nil],
        ["_needRestart", false]
    ];

    [
        FORMAT_VAR(_settingName),
        _type,
        [_title, _tooltip],
        _category,
        _value,
        _isGlobal,
        if (isNil "_script") then { nil } else { _script },
        _needRestart
    ] call CBA_fnc_addSetting;
};

// Main settings
[
    "AuthorizedUsernamesSetting"
    , SETTING_EDITBOX
    , "Authorized users (names)"
    , "List of authorized users by player name (admin is always authorized). In format: ""Nickname1"",""Nickname2"". Empty 'Authorized Users' (both settings) means authorized for everyone."
    , SETTING_MAIN_CATEGORY
    , ""
    , SETTING_GLOBAL
    , {
        GVAR(AuthorizedUsers) = call compile ("[" + toLower _this + "]"); }
    , SETTING_RESTART_NEEDED
] call _add;

[
    "AuthorizedUIDsSetting"
    , SETTING_EDITBOX
    , "Authorized users (UIDs)"
    , "List of authorized users by player UID (admin is always authorized). In format: ""UID1"",""UID2"".  Empty 'Authorized Users' (both settings) means authorized for everyone."
    , SETTING_MAIN_CATEGORY
    , ""
    , SETTING_GLOBAL
    , { GVAR(AuthorizedUIDs) = call compile ("[" + toLower _this + "]"); }
    , SETTING_RESTART_NEEDED
] call _add;

[
    "Log"
    , SETTING_CHECKBOX
    , "Log usage"
    , "Logs usage of CG to server .rpt file as [dzn_CG][Username UID]<Action>"
    , SETTING_MAIN_CATEGORY
    , false
    , SETTING_GLOBAL
    , SETTING_NO_SCRIPT
    , SETTING_RESTART_NEEDED
] call _add;

[
    "ReaddTopicsToggle"
    , SETTING_CHECKBOX
    , "Re-add diary topics"
    , "Changing this setting will re-add CasualGaming topics if not exist or removed"
    , SETTING_MAIN_CATEGORY
    , false
    , SETTING_LOCAL
    , {
        [SVAR(AddTopicsEvent),[]] call CBA_fnc_localEvent;
    }
] call _add;

[
    "WallhackFilter"
    , SETTING_EDITBOX
    , "Wallhack Filter"
    , "Custom SQF code to filter units for wallhack, _this is unit/vehicle object, must return boolean - false to exclude."
    , SETTING_MAIN_CATEGORY
    , ""
    , SETTING_GLOBAL
    , {
        if (_this == "") exitWith {
            GVAR(WallhackFilterCallable) = { true };
        };
        GVAR(WallhackFilterCallable) = compile _this;
    }
] call _add;

// Profile settings
#include "profile_settings.hpp"
private _addProfileFeatureSettings = {
    params ["_profileId"];
    private _category = [TITLE, format ["Authorization Profile %1", _profileId]];
    private _callback = [
        { GVAR(AuthProfile1_UIDs) = call compile ("[" + toLower _this + "]"); },
        { GVAR(AuthProfile2_UIDs) = call compile ("[" + toLower _this + "]"); },
        { GVAR(AuthProfile3_UIDs) = call compile ("[" + toLower _this + "]"); }
    ] select (_profileId - 1);

    [
        format ["AuthProfile%1_UIDsSetting", _profileId],
        SETTING_EDITBOX,
        "Users (UIDs)",
        "List of users to apply authorization profile settings by player UID (admin is always authorized). In format: ""UID1"",""UID2"". Use ""All"" to apply profile options to all users except listed in Authorized users lists.",
        _category,
        "",
        SETTING_GLOBAL,
        _callback,
        SETTING_RESTART_NEEDED
    ] call _add;

    {
        _x params ["_name", "_title", "_tooltip"];
        [
            format ["AuthProfile%1_%2", _profileId, _name],
            SETTING_CHECKBOX,
            _title,
            _tooltip,
            _category,
            true,
            SETTING_GLOBAL,
            SETTING_NO_SCRIPT,
            SETTING_RESTART_NEEDED
        ] call _add;
    } forEach PROFILE_SETTINGS;
};

[1] call _addProfileFeatureSettings;
[2] call _addProfileFeatureSettings;
[3] call _addProfileFeatureSettings;
[4] call _addProfileFeatureSettings;

//
//   Keybindings
//
private _addKey = {
    params["_var","_str","_downCode",["_defaultKey", nil],["_upCode", { true }]];

    private _settings = [
        TITLE
        , FORMAT_VAR(_var)
        , _str
        , _downCode
        , _upCode
    ];

    if (!isNil "_defaultKey") then { _settings pushBack _defaultKey; };
    _settings call CBA_fnc_addKeybind;
};

// --- Healing
[
    "Key_Heal"
    , "Heal player"
    , { ["KEY_HEAL"] call FUNC(handleHotkey) }
] call _addKey;

// --- Set rallypoint
// --- Deploy to rallypoint
#include "functions\rallypoint\defines.hpp"
[
    "Key_SetRallypoint"
    , "Set My rallypoint"
    , { ["KEY_RALLYPOINT", ["SET", RP_CUSTOM]] call FUNC(handleHotkey) }
] call _addKey;
[
    "Key_DeployToRallypoint"
    , "Deploy To My rallypoint"
    , { ["KEY_RALLYPOINT", ["DEPLOY_TO", RP_CUSTOM]] call FUNC(handleHotkey) }
] call _addKey;

// --- Arsenal
// --- Garage
[
    "Key_OpenArsenal_BIS"
    , "Open BIS Arsenal"
    , { ["KEY_ARSENAL", "BIS"] call FUNC(handleHotkey) }
] call _addKey;
[
    "Key_OpenArsenal_ACE"
    , "Open ACE Arsenal"
    , { ["KEY_ARSENAL", "ACE"] call FUNC(handleHotkey) }
] call _addKey;
[
    "Key_OpenGarage"
    , "Open Garage"
    , { ["KEY_GARAGE"] call FUNC(handleHotkey) }
] call _addKey;

// --- Repair/refuel/rearm vehicle
// --- Land vehicle
// --- Move in flight
// --- Toggle hover
[
    "Key_VehicleService"
    , "Vehicle: Refuel/Rearm/Repair"
    , { ["KEY_VEHICLE_SERVICE"] call FUNC(handleHotkey) }
] call _addKey;
[
    "Key_VehicleHover"
    , "Vehicle: Toggle hover"
    , { ["KEY_VEHICLE_CONTROL", "HOVER_TOGGLE"] call FUNC(handleHotkey) }
] call _addKey;
[
    "Key_VehicleLand"
    , "Vehicle: Land"
    , { ["KEY_VEHICLE_CONTROL", "LAND"] call FUNC(handleHotkey) }
] call _addKey;
[
    "Key_VehicleFly"
    , "Vehicle: Set in flight"
    , { ["KEY_VEHICLE_CONTROL", "SET_IN_FLIGHT"] call FUNC(handleHotkey) }
] call _addKey;
[
    "Key_VehicleChangeSeat"
    , "Vehicle: Change seat"
    , { ["KEY_VEHICLE_CONTROL", "CHANGE_SEAT_MENU"] call FUNC(handleHotkey) }
] call _addKey;

// --- Pinned vehicle quick menu
[
    "Key_PinnedVehicle_QuickMenu"
    , "Pinned Vehicle: Quick Menu"
    , { ["KEY_PINNED_VEHICLE_QUICK_MENU"] call FUNC(handleHotkey) }
] call _addKey;


// --- Manage group
// --- Heal All
// --- Rally All
// --- Rearm All
[
    "Key_GroupAIManage"
    , "Group AI: Manage group"
    , { ["KEY_GROUP_AI", "MENU_SHOW"] call FUNC(handleHotkey) }
] call _addKey;
[
    "Key_GroupAIHealAll"
    , "Group AI: Heal group"
    , { ["KEY_GROUP_AI", "UNIT_HEAL"] call FUNC(handleHotkey) }
] call _addKey;
[
    "Key_GroupAIRallyAll"
    , "Group AI: Rally group"
    , { ["KEY_GROUP_AI", "UNIT_RALLY"] call FUNC(handleHotkey) }
] call _addKey;
[
    "Key_GroupAIRearmAll"
    , "Group AI: Rearm group"
    , { ["KEY_GROUP_AI", "UNIT_REARM"] call FUNC(handleHotkey) }
] call _addKey;

// --- Console
[
    "Key_Console"
    , "Open Console"
    , { ["KEY_CONSOLE"] call FUNC(handleHotkey) }
] call _addKey;

[
    "Key_Wallhack"
    , "Enable Wallhack"
    , { ["KEY_WALLHACK"] call FUNC(handleHotkey) }
] call _addKey;
