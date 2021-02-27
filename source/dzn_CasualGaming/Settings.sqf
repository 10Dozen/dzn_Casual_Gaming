#include "macro.hpp"

/*
 *	 Addon Settings
 */
private _add = {
	params [
		"_varName",
		"_desc",
		"_tooltip",
		"_type",
		"_val",
		["_script", nil],
		["_isGlobal", false],
		["_needRestart", false]
	];

	[
		FORMAT_VAR(_varName),
		_type,
		[_desc, _tooltip],
		TITLE,
		_val,
		_isGlobal,
		if (isNil "_script") then { nil } else { _script },
		_needRestart
	] call CBA_fnc_addSetting;
};

[
	"AuthorizedUsernamesSetting"
	, "Authorized users (names)"
	, "List of authorized users by player name (admin is always authorized). In format: ""Nickname1"",""Nickname2"". Empty 'Authorized Users' (both settings) means authorized for everyone."
	, "EDITBOX"
	, ""
	, {
		GVAR(AuthorizedUsers) = call compile ("[" + _this + "]");
	}
	, true
	, true
] call _add;

[
	"AuthorizedUIDsSetting"
	, "Authorized users (UIDs)"
	, "List of authorized users by player UID (admin is always authorized). In format: ""UID1"",""UID2"".  Empty 'Authorized Users' (both settings) means authorized for everyone."
	, "EDITBOX"
	, ""
	, {
		GVAR(AuthorizedUIDs) = call compile ("[" + _this + "]");
	}
	, true
	, true
] call _add;

[
	"Log"
	, "Log usage"
	, "Logs usage of CG to server .rpt file as [dzn_CG][Username UID]<Action>"
	, "CHECKBOX"
	, false
	, nil
	, true
] call _add;

[
	"ReaddTopicsToggle"
	, "Re-add diary topics"
	, "Re-adds CasualGaming topics if not exist or removed"
	, "CHECKBOX"
	, false
	, {
		if (["CHECK_EXISTS"] call FUNC(manageTopics)) exitWith {};
        ["ADD_ALL"] call FUNC(manageTopics);
	}
	, 2
] call _add;




/*
 *   Keybindings
 *
 */
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
	, { [true] call FUNC(heal); true }
] call _addKey;

// --- Set rallypoint
// --- Deploy to rallypoint 
[
	"Key_SetRallypoint"
	, "Set My rallypoint"
	, { [0] call FUNC(setRallypoint); true }
] call _addKey;
[
	"Key_DeployToRallypoint"
	, "Deploy To My rallypoint"
	, { [0] spawn FUNC(moveToRallypoint); true }
] call _addKey;

// --- Arsenal 
// --- Garage 
[
	"Key_OpenArsenal_BIS"
	, "Open BIS Arsenal"
	, { ["BIS"] call FUNC(openArsenal); true }
] call _addKey;
[
	"Key_OpenArsenal_ACE"
	, "Open ACE Arsenal"
	, { ["ACE"] call FUNC(openArsenal); true }
] call _addKey;
[
	"Key_OpenGarage"
	, "Open Garage"
	, { [] call FUNC(openGarage); true }
] call _addKey;

// --- Repair/refuel/rearm vehicle 
// --- Land vehicle
// --- Move in flight 
// --- Toggle hover 
[
	"Key_VehicleService"
	, "Vehicle: Refuel/Rearm/Repair"
	, { 
		["REPAIR"] call FUNC(manageVehicle);
		["REFUEL"] call FUNC(manageVehicle);
		["REARM"] call FUNC(manageVehicle);
		true 
	}
] call _addKey;
[
	"Key_VehicleHover"
	, "Vehicle: Toggle hover"
	, { ["HOVER_TOGGLE"] call FUNC(manageVehicle); true }
] call _addKey;
[
	"Key_VehicleLand"
	, "Vehicle: Land"
	, { ["LAND"] call FUNC(manageVehicle); true }
] call _addKey;
[
	"Key_VehicleFly"
	, "Vehicle: Set in flight"
	, { ["SET_IN_FLIGHT"] call FUNC(manageVehicle); true }
] call _addKey;
[
	"Key_VehicleChangeSeat"
	, "Vehicle: Change seat"
	, { ["CHANGE_SEAT_MENU"] call FUNC(manageVehicle); true }
] call _addKey;

// --- Pinned vehicle quick menu 
[
	"Key_PinnedVehicle_QuickMenu"
	, "Pinned Vehicle: Quick Menu"
	, { ["QUICK_MENU"] call FUNC(managePinnedVehicle); true }
] call _addKey;


// --- Manage group 
// --- Heal All 
// --- Rally All 
// --- Rearm All
[
	"Key_GroupAIManage"
	, "Group AI: Manage group"
	, { ["MENU_SHOW"] call FUNC(manageGroup); true }
] call _addKey;
[
	"Key_GroupAIHealAll"
	, "Group AI: Heal group"
	, { ["UNIT_HEAL", units player] call FUNC(manageGroup); true }
] call _addKey;
[
	"Key_GroupAIRallyAll"
	, "Group AI: Rally group"
	, { ["UNIT_RALLY", units player] call FUNC(manageGroup); true }
] call _addKey;
[
	"Key_GroupAIRearmAll"
	, "Group AI: Rearm group"
	, { ["UNIT_REARM", units player] call FUNC(manageGroup); true }
] call _addKey;

// --- Console 
[
	"Key_Console"
	, "Open Console"
	, { 
		openMap false; 
		closeDialog 2; 
		[] spawn { createDialog SVAR(Console_Group) };
		[player, 19] call FUNC(logUserAction);
		true 
	}
] call _addKey;

