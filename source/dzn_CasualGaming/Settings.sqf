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
		if (["CHECK_EXISTS"] call GVAR(fnc_addTopic)) exitWith {};
        ["ADD_ALL"] call GVAR(fnc_addTopic);
	}
	, 2
] call _add;


/*
 *	 Keybindings
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
	, { [true] call GVAR(fnc_heal); true }
] call _addKey;

// --- Set rallypoint
// --- Deploy to rallypoint 
[
	"Key_SetRallypoint"
	, "Set My rallypoint"
	, { [0] call GVAR(fnc_setRallypoint); true }
] call _addKey;
[
	"Key_DeployToRallypoint"
	, "Deploy To My rallypoint"
	, { [0] spawn GVAR(fnc_moveToRallypoint); true }
] call _addKey;

// --- Arsenal 
// --- Garage 
[
	"Key_OpenArsenal_BIS"
	, "Open BIS Arsenal"
	, { ["BIS"] call GVAR(fnc_openArsenal); true }
] call _addKey;
[
	"Key_OpenArsenal_ACE"
	, "Open ACE Arsenal"
	, { ["ACE"] call GVAR(fnc_openArsenal); true }
] call _addKey;
[
	"Key_OpenGarage"
	, "Open Garage"
	, { [] call GVAR(fnc_openGarage); true }
] call _addKey;

// --- Repair/refuel/rearm vehicle 
// --- Land vehicle
// --- Move in flight 
// --- Toggle hover 
[
	"Key_VehicleService"
	, "Vehicle: Refuel/Rearm/Repair"
	, { 
		["REPAIR"] call GVAR(fnc_manageVehicle);
		["REFUEL"] call GVAR(fnc_manageVehicle);
		["REARM"] call GVAR(fnc_manageVehicle);
		true 
	}
] call _addKey;
[
	"Key_VehicleHover"
	, "Vehicle: Toggle hover"
	, { ["HOVER_TOGGLE"] call GVAR(fnc_manageVehicle); true }
] call _addKey;
[
	"Key_VehicleLand"
	, "Vehicle: Land"
	, { ["LAND"] call GVAR(fnc_manageVehicle); true }
] call _addKey;
[
	"Key_VehicleFly"
	, "Vehicle: Set in flight"
	, { ["SET_IN_FLIGHT"] call GVAR(fnc_manageVehicle); true }
] call _addKey;
[
	"Key_VehicleChangeSeat"
	, "Vehicle: Change seat"
	, { ["CHANGE_SEAT_MENU"] call GVAR(fnc_manageVehicle); true }
] call _addKey;



// --- Manage group 
// --- Heal All 
// --- Rally All 
// --- Rearm All
[
	"Key_GroupAIManage"
	, "Group AI: Manage group"
	, { ["MENU_SHOW"] call GVAR(fnc_manageGroup); true }
] call _addKey;
[
	"Key_GroupAIHealAll"
	, "Group AI: Heal group"
	, { ["UNIT_HEAL", units player] call GVAR(fnc_manageGroup); true }
] call _addKey;
[
	"Key_GroupAIRallyAll"
	, "Group AI: Rally group"
	, { ["UNIT_RALLY", units player] call GVAR(fnc_manageGroup); true }
] call _addKey;
[
	"Key_GroupAIRearmAll"
	, "Group AI: Rearm group"
	, { ["UNIT_REARM", units player] call GVAR(fnc_manageGroup); true }
] call _addKey;

// --- Console 
[
	"Key_Console"
	, "Open Console"
	, { 
		openMap false; 
		closeDialog 2; 
		[] spawn { createDialog SVAR(Console_Group) };
		[player, 19] call GVAR(fnc_logUserAction);
		true 
	}
] call _addKey;







