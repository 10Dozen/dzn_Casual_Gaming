#include "macro.hpp"

// Addon Settings

private _add = {
	params ["_var","_desc","_tooltip","_type","_val",["_exp", "No Expression"],["_subcat", ""],["_isGlobal", false]];	
	 
	private _arr = [
		FORMAT_VAR(_var)
		, _type
		, [_desc, _tooltip]
		, if (_subcat == "") then { TITLE } else { [TITLE, _subcat] }
		, _val
		, _isGlobal
	];
	
	if !(typename _exp == "STRING" && { _exp == "No Expression" }) then { _arr pushBack _exp; };
	_arr call CBA_Settings_fnc_init;
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
] call _add;

[
	"Log"
	, "Log usage"
	, "Logs usage of CG to server .rpt file as [dzn_CG][Username UID]<Action>"
	, "CHECKBOX"
	, false
] call _add;