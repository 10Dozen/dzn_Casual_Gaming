#include "..\..\macro.hpp"
#define SELF GVAR(fnc_manageLoadouts)

/* ----------------------------------------------------------------------------
Function: dzn_CasualGaming_fnc_manageLoadouts

Description:
	Manages loadout slots and related actions.

Parameters:
	_mode -- call mode (SAVE, LOAD, ADD_COPY_ACTION, REMOVE_COPY_ACTION and some internal params) <STRING>
	_slotID -- ID of loadout slot <NUMBER>

Returns:
	none

Examples:
    (begin example)
		["SAVE",1] call dzn_CasualGaming_fnc_manageLoadouts;  // Saves current loadout to Loadout #1 slot
    (end)

Author:
	10Dozen
---------------------------------------------------------------------------- */

params ["_mode","_slotID"];


switch (toUpper _mode) do {
	case "SAVE": {
		private ["_namespace","_msg"];
		if (_slotID < 100) then {
			// --- Current game loadouts 
			_namespace = missionNamespace;
			_msg = format ["Loadout %1 saved", _slotID];
		} else {
			_namespace = profileNamespace;
			_msg = format ["Persistant Loadout P%1 saved", _slotID - 100];
		};

		_namespace setVariable [format ["%1_%2", SVAR(Loadout), _slotID], getUnitLoadout player];
		hint parseText format ["<t size='1.5' color='#FFD000' shadow='1'>%1</t>", _msg];

		[player, 7] call GVAR(fnc_logUserAction);
	};
	case "LOAD": {
		private ["_namespace","_msg"];
		if (_slotID < 100) then {
			_namespace = missionNamespace;
			_msg = format ["Loadout %1 loaded", _slotID]; 
		} else {
			_namespace = profileNamespace;
			_msg = format ["Persistant Loadout P%1 loaded", _slotID - 100];
		};

		private _loadout = _namespace getVariable [format ["%1_%2", SVAR(Loadout), _slotID], []];

		if !(_loadout isEqualTo []) then {
			hint parseText format ["<t size='1.5' color='#FFD000' shadow='1'>%1</t>", _msg];
			player setUnitLoadout _loadout;
			[player, 8] call GVAR(fnc_logUserAction);
		} else {
			hint parseText "<t size='1.5' color='#FFFFFF' shadow='1'>Loadout is empty</t>";
		};
	};

	case "COPY_LOADOUT_FROM": {
		if (isNull cursorTarget) exitWith { hint "No unit under the cursor!"; };

		player setUnitLoadout (getUnitLoadout cursorTarget);
		["REMOVE_COPY_ACTION"] call SELF;

		hint parseText "<t size='1.5' color='#FFD000' shadow='1'>Loadout copied from unit!</t>";
		[player, 10] call GVAR(fnc_logUserAction);
	};
	case "COPY_LOADOUT_TO": {
		if (isNull cursorTarget) exitWith { hint "No unit under the cursor!"; };
		if !(cursorTarget isKindOf "CAManBase") exitWith {};

		[cursorTarget, getUnitLoadout player] call GVAR(fnc_applyLoadoutToUnit);
		["REMOVE_COPY_ACTION"] call SELF;

		hint parseText "<t size='1.5' color='#FFD000' shadow='1'>Loadout copied to unit!</t>";
		[player, 10] call GVAR(fnc_logUserAction);
	};
	case "ADD_COPY_ACTION": {
		openMap false;
		closeDialog 2;
		["REMOVE_COPY_ACTION"] call SELF;
		
		private _copyFromID = player addAction [
			"<t color='#FF0000'>Copy LOADOUT FROM unit</t>"
			, {	["COPY_LOADOUT_FROM"] call SELF; }
			, "", 6, true, true
		];
		private _copyToID = player addAction [
			"<t color='#FF0000'>Copy MY LOADOUT TO unit</t>"
			, {	["COPY_LOADOUT_TO"] call SELF; }
			, "", 6, true, true
		];

		player setVariable [SVAR(CopyLoadoutActionsID), [_copyFromID,_copyToID]];

		hint parseText "<t size='1.5' color='#FFD000' shadow='1'>To copy loadout</t><br /><br />Point to unit and use action!";
	};
	case "REMOVE_COPY_ACTION": {
		private _actionIDs = player getVariable [SVAR(CopyLoadoutActionsID), []];
		if (_actionIDs isEqualTo []) exitWith {};

		{ player removeAction _x; } forEach _actionIDs;
		hint "Copy loadout disabled";
	};
};