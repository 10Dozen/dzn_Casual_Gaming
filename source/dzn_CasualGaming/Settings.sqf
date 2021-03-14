#include "macro.hpp"

#define SETTING_EDITBOX "EDITBOX"
#define SETTING_CHECKBOX "CHECKBOX"
#define SETTING_NO_SCRIPT nil
#define SETTING_GLOBAL 1
#define SETTING_LOCAL 2
#define SETTING_RESTART_NEEDED true

#define SETTING_MAIN_CATEGORY TITLE
#define SETTING_PROFILE_CATEGORY [TITLE, "Authorization Profile"]

//
//	 Addon Settings
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

private _addProfileFeatureSetting = {
	params [
		"_settingName",
		"_title",
		"_tooltip"
	];

	[
		_settingName,
		SETTING_CHECKBOX,
		_title,
		_tooltip,
		SETTING_PROFILE_CATEGORY,
		true,
		SETTING_GLOBAL,
		SETTING_NO_SCRIPT,
		SETTING_RESTART_NEEDED
	] call _add;
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
	, "Re-adds CasualGaming topics if not exist or removed"
	, SETTING_MAIN_CATEGORY
	, false
	, SETTING_LOCAL
	, {
		[SVAR(AddTopicsEvent),[]] call CBA_fnc_localEvent;
	}
] call _add;

// Profile settings
[
	"AuthProfile1_UIDsSetting"
	, SETTING_EDITBOX
	, "Users (UIDs)"
	, "List of users to apply authorization profile settings by player UID (admin is always authorized). In format: ""UID1"",""UID2"". Use ""All"" to apply profile options to all users except listed in Authorized users lists."
	, SETTING_PROFILE_CATEGORY
	, ""
	, SETTING_GLOBAL
	, { GVAR(AuthProfile1_UIDs) = call compile ("[" + toLower _this + "]"); }
	, SETTING_RESTART_NEEDED
] call _add;

[
	"AuthProfile1_Feature_HEAL",
	"- Healing",
	"Healing (local) and auto-healing feature"
] call _addProfileFeatureSetting;

[
	"AuthProfile1_Feature_GLOBAL_HEAL",
	"- Healing (Global)",
	"Global Healing feature"
] call _addProfileFeatureSetting;

[
	"AuthProfile1_Feature_FATIGUE",
	"- Fatigue",
	"Fatigue toggle feature"
] call _addProfileFeatureSetting;

[
	"AuthProfile1_Feature_WEAPON_SWAY",
	"- Weapon sway",
	"Weapon sway coefficient adjustment feature"
] call _addProfileFeatureSetting;

[
	"AuthProfile1_Feature_WEAPON_RECOIL",
	"- Weapon recoil",
	"Weapon recoil coefficient adjustmente feature"
] call _addProfileFeatureSetting;

[
	"AuthProfile1_Feature_RESPAWN",
	"- Respawn",
	"Respawn timer toggle feature"
] call _addProfileFeatureSetting;

[
	"AuthProfile1_Feature_ARSENAL",
	"- Arsenal",
	"Arsenal and Loadouts feature"
] call _addProfileFeatureSetting;

[
	"AuthProfile1_Feature_GARAGE",
	"- Garage",
	"Garage feature"
] call _addProfileFeatureSetting;

[
	"AuthProfile1_Feature_VEHICLE_SERVICE",
	"- Vehicle service",
	"Vehicle refuel, repair and rearm feature"
] call _addProfileFeatureSetting;

[
	"AuthProfile1_Feature_VEHICLE_CONTROL",
	"- Vehicle controls",
	"Vehicle flight controls (fly/land/hover) feature"
] call _addProfileFeatureSetting;

[
	"AuthProfile1_Feature_VEHICLE_DRIVER",
	"- Vehicle driver",
	"Vehicle AI driver add/remove feature"
] call _addProfileFeatureSetting;

[
	"AuthProfile1_Feature_PINNED_VEHICLES",
	"- Pinned Vehicles",
	"Pinned vehicles feature"
] call _addProfileFeatureSetting;

[
	"AuthProfile1_Feature_RALLYPOINT",
	"- Rallypoints",
	"Rallypoint set and deploy features"
] call _addProfileFeatureSetting;

[
	"AuthProfile1_Feature_GROUP_CONTROL",
	"- Group controls",
	"Group controls (Join/Leave/Become a leader) feature"
] call _addProfileFeatureSetting;

[
	"AuthProfile1_Feature_GROUP_AI",
	"- Group AI controls",
	"Group AI controls (create/remove/manage AIs) feature"
] call _addProfileFeatureSetting;

[
	"AuthProfile1_Feature_CAMERA",
	"- Camera",
	"Splendid camera feature"
] call _addProfileFeatureSetting;

[
	"AuthProfile1_Feature_CONSOLE",
	"- Console",
	"Script console feature"
] call _addProfileFeatureSetting;

[
	"AuthProfile1_Feature_WALLHACK",
	"- Wallhack",
	"Walhack feature"
] call _addProfileFeatureSetting;


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
