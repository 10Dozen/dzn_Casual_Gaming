#include "..\script_component.hpp"
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

        diag_log parseText format ["dzn_CasualGaming :: CHECK_AUTHORIZED: %1; AUTH_LEVEL: %2", _result, _authLevel];
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

        private ["_settingPrefix", "_settingValue"];
        for "_i" from 1 to 4 do {
            private _flags = [0,0,0,0,0];
            _flags set [_i, 1];
            if !([_authLevel, _flags call BIS_fnc_encodeFlags2] call BIS_fnc_bitflagsCheck) then { continue; };

            MAP_PERMISSION(PERM_ALL, false);
            _settingPrefix = format ["%1%2", SVAR(AuthProfile), _i];
            {
                _x params ["_permission", "_settingName"];

                // -- Update permission map: only grant new permissions, but do not revoke already granted
                _settingValue = [
                    missionNamespace getVariable format ["%1_%2", _settingPrefix, _settingName],
                    _result getOrDefault [_permission, false]
                ] select (_result getOrDefault [_permission, false]);

                MAP_PERMISSION(_permission, _settingValue);
            } forEach PERMISSION_TO_SETTING_MAP;
        };
    };
    case "GET_AUTH_LEVEL": {
        // --- Returns user's auth level
        _result = AUTH_NONE;

        // --- Player is admin -> full access
        if ((serverCommandAvailable "#logout") || !(isMultiplayer) || isServer) exitWith { _result = AUTH_FULL; };

        // --- Return full access if all names and UIDs lists are empty -> full access
        private _isProfile1ListEmpty = GVAR(AuthProfile1_UIDs) isEqualTo [];
        private _isProfile2ListEmpty = GVAR(AuthProfile2_UIDs) isEqualTo [];
        private _isProfile3ListEmpty = GVAR(AuthProfile3_UIDs) isEqualTo [];
        private _isProfile4ListEmpty = GVAR(AuthProfile4_UIDs) isEqualTo [];
        if (
            GVAR(AuthorizedUsers) isEqualTo []
            && GVAR(AuthorizedUIDs) isEqualTo []
            && _isProfile1ListEmpty
            && _isProfile2ListEmpty
            && _isProfile3ListEmpty
            && _isProfile4ListEmpty
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
        if (
            _isProfile1ListEmpty && _isProfile2ListEmpty
            && _isProfile3ListEmpty && _isProfile4ListEmpty
        ) exitWith { _result = AUTH_NONE; };


        // -- Flags are: FULL, Profile1...Profile4
        private _groupsFlags = [0, 0, 0, 0, 0];

        // --- Player's UID is listed in some Auth Profile or "all" is used -> limited access
        {
            _x params ["_profileUIDs", "_authLevel"];
            if (_uid in _profileUIDs || "all" in _profileUIDs) then {
                _groupsFlags set [_forEachIndex + 1, 1];
            };
        } forEach [
            GVAR(AuthProfile1_UIDs),
            GVAR(AuthProfile2_UIDs),
            GVAR(AuthProfile3_UIDs),
            GVAR(AuthProfile4_UIDs)
        ];

        _result = _groupsFlags call BIS_fnc_encodeFlags2;
    };
};

_result
