#include "..\..\macro.hpp"
#define SELF GVAR(fnc_manageGroup)
#define QSELF SVAR(fnc_manageGroup)

/* ----------------------------------------------------------------------------
Function: dzn_CasualGaming_fnc_manageGroup

Description:
	Apply action to player's group and individual units:
		- take leadership "BECOME_LEADER"
		- add new AI to group "UNIT_ADD"
		- clear group from AI units "UNIT_REMOVE_ALL"
		- heal all AI units "UNIT_HEAL_ALL"
		- rearm all AI units "UNIT_REARM_ALL"
		- teleport all AI units to player position "UNIT_RALLY_ALL"
		- individual actions "UNIT_HEAL", "UNIT_REARM", "UNIT_RALLY"
		- manage group menu action "MENU_SHOW"

Parameters:
	_mode -- management modes <STRING>
	_args -- (optional) call arguments <ARRAY>

Returns:
	none

Examples:
    (begin example)
		["HEAL_ALL"] call dzn_CasualGaming_fnc_manageGroup; // refuels vehicle
    (end)

Author:
	10Dozen
---------------------------------------------------------------------------- */

/*
	TODO:
		- Become Leader 
		- Remove all AI 
		- Remove specific unit 
*/

params ["_mode", ["_args",[]], ["_args2",[]]];

// --- Filter only AI units 
private _units = [];
if (typename _args == typename []) then {
	_units = _args select { !isPlayer _x };
};

switch (toUpper _mode) do {


	case "MENU_SHOW": {

		_title = "Auto-hover is OFF";
		if (isNil SVAR(GroupMenu)) then {
			GVAR(GroupMenu) = [
				["APPLY TO SELECTED", true]
				,["Heal", [2],"",-5,[["expression",format["['UNIT_HEAL', groupSelectedUnits player] call %1", QSELF]]], "1","1"]
				,["Rally up", [3],"",-5,[["expression",format["['UNIT_RALLY', groupSelectedUnits player] call %1", QSELF]]], "1","1"]
				,["Re-arm", [4],"",-5,[["expression",format["['UNIT_REARM', groupSelectedUnits player] call %1", QSELF]]], "1","1"]			
				,["Apply Loadout", [5], format ["#USER:%1", SVAR(LoadoutMenu)], -5, [],"1","1"]
				,["-------------", [7],"",-1,[],"1","0"]
				,["Remove unit", [10],"",-5,[["expression",format["['HOVER_RELEASE', groupSelectedUnits player] call %1", QSELF]]], "1","1"]
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

	// --- Envelope 
	case "UNIT_HEAL": {
		{ ["UNIT_HEAL_EXECUTE", _x] call SELF; } forEach _units;
	};
	case "UNIT_RALLY": {
		{ ["UNIT_RALLY_EXECUTE", _x] call SELF; } forEach _units;
	};
	case "UNIT_APPLY_LOADOUT": {
		{ ["UNIT_APPLY_LOADOUT_EXECUTE", _x, _args2] call SELF; } forEach _units;
	};
	case "UNIT_REARM": {
		{ ["UNIT_REARM_EXECUTE", _x] call SELF; } forEach _units;
	};
	case "UNIT_ARSENAL": {
		if (count _units > 1) then {
			GVAR(UnitArsenalTarget) = +_units;
			GVAR(UnitArsenalEH) = [missionNamespace, "arsenalClosed", {
				// --- Apply loadout of first unit to other
				private _loadout = getUnitLoadout (GVAR(UnitArsenalTarget) # 0);
				for "_i" from 0 to (count GVAR(UnitArsenalTarget) - 1) do {
					private _unit = GVAR(UnitArsenalTarget) # _i;

					_unit setVariable [SVAR(UnitLoadout), _loadout];
					if (_i > 0) then { _unit setUnitLoadout _loadout; };
				};

				// --- Nulify vars
				[missionNamespace, "arsenalClosed", GVAR(UnitArsenalEH)] call BIS_fnc_removeScriptedEventHandler;
				GVAR(UnitArsenalTarget) = nil;
				GVAR(UnitArsenalEH) = nil;			
			}] call BIS_fnc_addScriptedEventHandler;
		};

		["Open", [true, objNull, _units # 0]] spawn BIS_fnc_arsenal;
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
		if (_loadout isEqualTo []) exitWith {};

		_u setVariable [SVAR(UnitLoadout), _loadout];
		_u setUnitLoadout _loadout;
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

};