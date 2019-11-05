#include "..\..\macro.hpp"
#define SELF GVAR(fnc_manageGroup)
#define QSELF SVAR(fnc_manageGroup)

/* ----------------------------------------------------------------------------
Function: dzn_CasualGaming_fnc_manageGroup

Description:
	Apply action to player's group and individual units:
		- take leadership "BECOME_LEADER"
		- add new AI to group "UNIT_ADD"
		- clear group from AI units "UNIT_REMOVE"
		- heal all AI units "UNIT_HEAL"
		- rearm all AI units "UNIT_REARM"
		- teleport all AI units to player position "UNIT_RALLY"
		- individual actions "UNIT_HEAL_EXECUTE", "UNIT_REARM_EXECUTE", "UNIT_RALLY_EXECUTE"
		- manage group menu action "MENU_SHOW"
		- leave group "LEAVE_GROUP"
		- add join to group/join unit to group actions "JOIN_TO_ACTION_ADD", "JOIN_TO_ACTION_REMOVE", "JOIN_UNIT", "JOINT_UNIT_EXECUTE" 

Parameters:
	_mode -- management modes <STRING>
	_args -- (optional) call arguments, mostly unit object or array of units <ANY>
	_args2 -- (optional) extra arguments, e.g. loadout info <ANY>

Returns:
	none

Examples:
    (begin example)
		["UNIT_HEAL", groupSelectedUnits player] call dzn_CasualGaming_fnc_manageGroup; // heals selected units
    (end)

Author:
	10Dozen
---------------------------------------------------------------------------- */

params ["_mode", ["_args",[]], ["_args2",[]]];

private _title = "";

// --- Filter only AI units 
private _units = [];
if (typename _args == typename []) then {
	_units = _args select { !isPlayer _x };
};

switch (toUpper _mode) do {

	case "MENU_SHOW": {
		if (isNil SVAR(GroupMenu)) then {
			GVAR(GroupMenu) = [
				["APPLY TO SELECTED", true]
				,["Heal", [2],"",-5,[["expression",format["['UNIT_HEAL', groupSelectedUnits player] call %1", QSELF]]], "1","1"]
				,["Rally up", [3],"",-5,[["expression",format["['UNIT_RALLY', groupSelectedUnits player] call %1", QSELF]]], "1","1"]
				,["Re-arm", [4],"",-5,[["expression",format["['UNIT_REARM', groupSelectedUnits player] call %1", QSELF]]], "1","1"]			
				,["Apply Loadout", [5], format ["#USER:%1", SVAR(LoadoutMenu)], -5, [],"1","1"]
				,["-------------", [7],"",-1,[],"1","0"]
				,["Remove unit", [10],"",-5,[["expression",format["['UNIT_REMOVE', groupSelectedUnits player] call %1", QSELF]]], "1","1"]
			];
		};

		GVAR(LoadoutMenu) = [
			["APPLY LOADOUT", true]
			,["Arsenal", [2],"",-5,[["expression",format["['UNIT_ARSENAL', groupSelectedUnits player] call %1", QSELF]]], "1","1"]
		];
		{
			_x params ["_namespace","_from","_to"];

			private _name = "";
			private _namespaceName = ""; 
			
			if (_namespace isEqualTo missionNamespace) then { 
				_name = "Loadout #";
				_namespaceName = "missionNamespace";
			} else { 
				_name = "P.Loadout #";
				_namespaceName = "profileNamespace";
			};
			private _idx = 3;
		
			for "_i" from _from to _to do {
				private _loadoutName = format ["%1_%2", SVAR(Loadout), _i];
				private _loadout = _namespace getVariable [_loadoutName, []];

				if !(_loadout isEqualTo []) then {
					GVAR(LoadoutMenu) pushBack [
						format ["%1%2", _name, _i - _from], [_idx], "", -5
						, [[
							"expression"
							, format ["['UNIT_APPLY_LOADOUT', groupSelectedUnits player, %2] call %1", QSELF, [_loadoutName, _namespaceName]]
						]]
						, "1", "1"
					];
					_idx = _idx + 1;
				};
			};
		} forEach [
			[missionNamespace, 0, 100],
			[profileNamespace, 100,200]
		];
		
		showCommandingMenu format ["#USER:%1", SVAR(GroupMenu)];
	};
	case "BECOME_LEADER": {
		_title = "Became leader";

		private _grp = group player;
		if (local _grp) then {
			_grp selectLeader player;
		} else {
			[_grp, player] remoteExec ["selectLeader", groupOwner _grp];
		};

		[player, 26] call GVAR(fnc_logUserAction);
	};
	case "LEAVE_GROUP": {
		_title = "Group leaved";

		private _grp = createGroup (side player);
		if (count units _grp == 1) exitWith {};

		[player] joinSilent _grp;

		[player, 33] call GVAR(fnc_logUserAction);
	};
	case "UNIT_ADD": {
		_title = "Unit added";
		private _grp = group player;
		private _u = _grp createUnit [typeof player, getPos player, [], 0, "FORM"];
		
		private _loadout = getUnitLoadout player;
		_u setUnitLoadout _loadout;
		_u setVariable [SVAR(UnitLoadout), _loadout];

		[player, 27] call GVAR(fnc_logUserAction);
	};
	case "JOIN_TO_ACTION_ADD": {
		openMap false;
		closeDialog 2;
		["JOIN_TO_ACTION_REMOVE"] call SELF;
		
		private _joinToID = player addAction [
			"<t color='#FF0000'>Join to UNIT'S GROUP</t>"
			, {	["JOIN_TO_UNIT"] call SELF; }
			, "", 6, true, true
		];
		private _joinUnitID = player addAction [
			"<t color='#FF0000'>Join unit to MY GROUP</t>"
			, {	["JOIN_UNIT_TO"] call SELF; }
			, "", 6, true, true
		];
		private _removeID = player addAction [
			"<t color='#FF3333'># remove actions #</t>"
			, {	["JOIN_TO_ACTION_REMOVE"] call SELF; }
			, "", 6, true, true
		];

		player setVariable [SVAR(JoinToActionsID), [_joinToID,_joinUnitID, _removeID]];

		hint parseText "<t size='1.5' color='#FFD000' shadow='1'>To join unit/to group</t><br /><br />Point to unit and use action!";
	};
	case "JOIN_TO_ACTION_REMOVE": {
		private _actionIDs = player getVariable [SVAR(JoinToActionsID), []];
		if (_actionIDs isEqualTo []) exitWith {};

		{ player removeAction _x; } forEach _actionIDs;
		hint "Join actions disabled";
	};
	case "JOIN_TO_UNIT": {
		private _u = cursorObject;
		if (isNull _u || {!(_u isKindOf "CAManBase")}) exitWith { hint "No unit under the cursor!"; };

		[player] join (group _u);

		["JOIN_TO_ACTION_REMOVE"] call SELF;

		_title = "Joined to unit's group!";
		[player, 34] call GVAR(fnc_logUserAction);
	};
	case "JOIN_UNIT_TO": {
		private _u = cursorObject;
		if (isNull _u || {!(_u isKindOf "CAManBase")}) exitWith { hint "No unit under the cursor!"; };

		private _grp = group player;

		if (local _u) then {
			[_u] join _grp;
		} else {
			[[_u], _grp] remoteExec ["join", cursorTarget];
		};
		["JOIN_TO_ACTION_REMOVE"] call SELF;

		_title = "Unit joined to my group!";
		[player, 35] call GVAR(fnc_logUserAction);
	};

	// --- Envelope 
	case "UNIT_HEAL": {
		_title = "Units healed";
		{ ["UNIT_HEAL_EXECUTE", _x] call SELF; } forEach _units;
		[player, 28] call GVAR(fnc_logUserAction);
	};
	case "UNIT_RALLY": {
		_title = "Units rallied up";
		{ ["UNIT_RALLY_EXECUTE", _x] call SELF; } forEach _units;
		[player, 29] call GVAR(fnc_logUserAction);
	};
	case "UNIT_APPLY_LOADOUT": {
		_title = "Units loadout applied";
		{ ["UNIT_APPLY_LOADOUT_EXECUTE", _x, _args2] call SELF; } forEach _units;
		[player, 30] call GVAR(fnc_logUserAction);
	};
	case "UNIT_REARM": {
		_title = "Units loadout restored";
		{ ["UNIT_REARM_EXECUTE", _x] call SELF; } forEach _units;
		[player, 31] call GVAR(fnc_logUserAction);
	};
	case "UNIT_ARSENAL": {
		if (count _units > 1) then {
			GVAR(UnitArsenalTarget) = +_units;
			GVAR(UnitArsenalEH) = [missionNamespace, "arsenalClosed", {
				// --- Apply loadout of first unit to other
				private _loadout = getUnitLoadout (GVAR(UnitArsenalTarget) # 0);
				{
					[_x, _loadout] call GVAR(fnc_applyLoadoutToUnit);
				} forEach GVAR(UnitArsenalTarget);

				// --- Nulify vars
				[missionNamespace, "arsenalClosed", GVAR(UnitArsenalEH)] call BIS_fnc_removeScriptedEventHandler;
				GVAR(UnitArsenalTarget) = nil;
				GVAR(UnitArsenalEH) = nil;
			}] call BIS_fnc_addScriptedEventHandler;
		};

		["Open", [true, objNull, _units # 0]] spawn BIS_fnc_arsenal;
		[player, 36] call GVAR(fnc_logUserAction);
	};
	case "UNIT_REMOVE": {
		_title = "Units removed";
		{ ["UNIT_REMOVE_EXECUTE", _x] call SELF; } forEach _units;
		[player, 32] call GVAR(fnc_logUserAction);
	};

	// --- Per each unit execution
	case "UNIT_HEAL_EXECUTE": {
		private _u = _args;

		_u setDamage 0;
		if (!isNil "ace_medical_fnc_treatmentAdvanced_fullHealLocal") then {
			[_u ,_u] call ace_medical_fnc_treatmentAdvanced_fullHealLocal;
		};
		["", 1, _u] call BIS_fnc_reviveOnState;
		_u setVariable ["#rev", 1, true];
	};
	case "UNIT_RALLY_EXECUTE": {
		private _u = _args;

		_u allowDamage false;
		moveOut _u;
		doStop _u;

		[{ 
			private _pos = getPos player;
			_this setPos _pos;
			_this moveTo _pos;

			[{ 
				_this allowDamage true;
				_this doMove (getPos player); 
			}, _this] call CBA_fnc_execNextFrame;
		}, _u] call CBA_fnc_execNextFrame;
	};
	case "UNIT_APPLY_LOADOUT_EXECUTE": {
		private _u = _args;
		_args2 params ["_loadoutName","_namespace"];

		private _loadout = call compile format ["%1 getVariable ['%2',[]]", _namespace, _loadoutName];

		[_u, _loadout] call GVAR(fnc_applyLoadoutToUnit);
	};
	case "UNIT_REARM_EXECUTE": {
		private _u = _args;

		private _loadout = _u getVariable [SVAR(UnitLoadout), []];
		if (_loadout isEqualTo []) then {
			_u setUnitLoadout (typeof _u);
		} else {
			_u setUnitLoadout _loadout;
		};
	};
	case "UNIT_REMOVE_EXECUTE": {
		private _u = _args;

		if (vehicle _u == _u) then {
			deleteVehicle _u;
		} else {
			(vehicle _u) deleteVehicleCrew _u;
		};
	};
};


if !(_title isEqualTo "") then {
	hint parseText format ["<t size='1.5' color='#FFD000' shadow='1'>Group AI</t><br /><br />%1", _title];
};