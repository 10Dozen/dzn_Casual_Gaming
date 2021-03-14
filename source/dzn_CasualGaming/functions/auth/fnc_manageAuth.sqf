#include "..\..\macro.hpp"
#include "auth_enum.hpp"
#include "permission_map.hpp"

#define SELF FUNC(manageAuth)
#define QSELF QFUNC(manageAuth)

/* ----------------------------------------------------------------------------
Function: dzn_CasualGaming_fnc_manageAuth

Description:
	Class for authentication checks 

Parameters:
	_mode -- modes <STRING>
	_args -- (optional) call arguments <ARRAY>

Returns:
	none

Examples:
    (begin example)
		[""] call dzn_CasualGaming_fnc_manageAuth; 
    (end)

Author:
	10Dozen
---------------------------------------------------------------------------- */

params ["_mode", ["_args",[]]];

private _title = "";
private _result = -1;

switch (toUpper _mode) do {
	case "INIT": {
		// --- Generates permission map 
		if (isNil SVAR(PermissionMap)) then {
			GVAR(PermissionMap) = ["GET_PERMISSION_MAP"] call SELF;
		};
	};

	case "CHECK_AUTHORIZED": {
		// Returns True if user authorized with any level of access (full or limited)
		private _authLevel = ["GET_AUTH_LEVEL"] call SELF;
		_result = _authLevel isNotEqualTo AUTH_NONE;
	};
	case "CHECK_PERMISSION": {
		// Returns True if feature permitted for user (or all features are permitted)
		private _feature = _args;
		_result = GVAR(PermissionMap) getOrDefault [PERM_ALL, false] || { GVAR(PermissionMap) getOrDefault [_feature, false] };
	};

	case "GET_PERMISSION_MAP": {
		// Returns permission hashmap according to current user auth level
		private _authLevel = ["GET_AUTH_LEVEL"] call SELF;
		_result = createHashMap;

		#define MAP_PERMISSION(ID, VALUE) _result set [ID, VALUE]
		if (_authLevel isEqualTo AUTH_NONE) exitWith {
			MAP_PERMISSION(PERM_ALL, false);
		};

		if (_authLevel isEqualTo AUTH_FULL) exitWith {
			MAP_PERMISSION(PERM_ALL, true);
		};

		if (_authLevel isEqualTo AUTH_LIMITED) exitWith {
			MAP_PERMISSION(PERM_ALL, false);
			MAP_PERMISSION(PERM_HEAL                , GVAR(AuthProfile1_Feature_HEAL));
			MAP_PERMISSION(PERM_GHEAL               , GVAR(AuthProfile1_Feature_GLOBAL_HEAL));
			MAP_PERMISSION(PERM_FATIGUE             , GVAR(AuthProfile1_Feature_FATIGUE));
			MAP_PERMISSION(PERM_WEAPON_SWAY         , GVAR(AuthProfile1_Feature_WEAPON_SWAY));
			MAP_PERMISSION(PERM_WEAPON_RECOIL       , GVAR(AuthProfile1_Feature_WEAPON_RECOIL));
			MAP_PERMISSION(PERM_RESPAWN             , GVAR(AuthProfile1_Feature_RESPAWN));
			MAP_PERMISSION(PERM_ARSENAL             , GVAR(AuthProfile1_Feature_ARSENAL));
			MAP_PERMISSION(PERM_GARAGE              , GVAR(AuthProfile1_Feature_GARAGE));
			MAP_PERMISSION(PERM_VEHICLE_SERVICE     , GVAR(AuthProfile1_Feature_VEHICLE_SERVICE));
			MAP_PERMISSION(PERM_VEHICLE_CONTROL     , GVAR(AuthProfile1_Feature_VEHICLE_CONTROL));
			MAP_PERMISSION(PERM_VEHICLE_DRIVER      , GVAR(AuthProfile1_Feature_VEHICLE_DRIVER));
			MAP_PERMISSION(PERM_PINNED_VEHICLES     , GVAR(AuthProfile1_Feature_PINNED_VEHICLES));
			MAP_PERMISSION(PERM_RALLYPOINT          , GVAR(AuthProfile1_Feature_RALLYPOINT));
			MAP_PERMISSION(PERM_GROUP_CONTROL       , GVAR(AuthProfile1_Feature_GROUP_CONTROL));
			MAP_PERMISSION(PERM_GROUP_AI            , GVAR(AuthProfile1_Feature_GROUP_AI));
			MAP_PERMISSION(PERM_CAMERA              , GVAR(AuthProfile1_Feature_CAMERA));
			MAP_PERMISSION(PERM_CONSOLE             , GVAR(AuthProfile1_Feature_CONSOLE));
			MAP_PERMISSION(PERM_WALLHACK            , GVAR(AuthProfile1_Feature_WALLHACK));
		};
	};
	case "GET_AUTH_LEVEL": {
		// --- Returns user's auth level 
		// --- Player is admin -> full access
		if ((serverCommandAvailable "#logout") || !(isMultiplayer) || isServer) exitWith { _result = AUTH_FULL; };

		// --- Return full access if all names and UIDs lists are empty -> full access
		private _isProfileListEmpty = GVAR(AuthProfile1_UIDs) isEqualTo [];
		if (
			GVAR(AuthorizedUsers) isEqualTo [] 
			&& GVAR(AuthorizedUIDs) isEqualTo []
			&& _isProfileListEmpty
		) exitWith { 
			_result = AUTH_FULL; 
		};

		private _name = toLower name player;
		private _uid = toLower getPlayerUID player;

		// --- Player is in authorized user names -> full access
		if (_name in GVAR(AuthorizedUsers)) exitWith { _result = AUTH_FULL; };

		// --- Player is in authorized UIDs -> full access
		if (_uid in GVAR(AuthorizedUIDs)) exitWith { _result = AUTH_FULL; };

		// --- Player is not in main list and auth profile is not set -> no access
		if (_isProfileListEmpty) exitWith { _result = AUTH_NONE; };

		// --- Auth Profile is set to "all" -> limited access 
		if ("all" in GVAR(AuthProfile1_UIDs)) exitWith { _result = AUTH_LIMITED; };

		// --- Player's UID is listed in Auth Profile -> limited access 
		if (_uid in GVAR(AuthProfile1_UIDs)) exitWith { _result = AUTH_LIMITED; };

		_result = AUTH_NONE;
	};
};

_result
