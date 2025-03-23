#include "..\script_component.hpp"
#include "..\main\reasons.hpp"
#define SELF FUNC(manageLoadouts)

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
        [format ["<t size='1.5' color='#FFD000' shadow='1'>%1</t>", _msg]] call FUNC(hint);
        [player, REASON_LOADOUT_SAVED] call FUNC(logUserAction);
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
            [format ["<t size='1.5' color='#FFD000' shadow='1'>%1</t>", _msg]] call FUNC(hint);
            player setUnitLoadout _loadout;
            [player, REASON_LOADOUT_APPLIED] call FUNC(logUserAction);
        } else {
            ["<t size='1.5' color='#FFFFFF' shadow='1'>Loadout is empty</t>"] call FUNC(hint);
        };
    };

    case "COPY_LOADOUT_FROM": {
        private _u = cursorObject;
        if (isNull _u || {!(_u isKindOf "CAManBase")}) exitWith { hint "No unit under the cursor!"; };

        player setUnitLoadout (getUnitLoadout _u);
        ["REMOVE_COPY_ACTION"] call SELF;

        ["<t size='1.5' color='#FFD000' shadow='1'>Loadout copied from unit!</t>"] call FUNC(hint);
        [player, REASON_LOADOUT_COPIED] call FUNC(logUserAction);
    };
    case "COPY_LOADOUT_TO": {
        private _u = cursorObject;
        if (isNull _u || {!(_u isKindOf "CAManBase")}) exitWith { hint "No unit under the cursor!"; };

        [_u, getUnitLoadout player] call FUNC(applyLoadoutToUnit);
        ["REMOVE_COPY_ACTION"] call SELF;

        ["<t size='1.5' color='#FFD000' shadow='1'>Loadout copied to unit!</t>"] call FUNC(hint);
        [player, REASON_LOADOUT_COPIED] call FUNC(logUserAction);
    };
    case "ADD_COPY_ACTION": {
        openMap false;
        closeDialog 2;
        ["REMOVE_COPY_ACTION"] call SELF;

        private _copyFromID = player addAction [
            "<t color='#FF0000'>Copy LOADOUT FROM unit</t>"
            , {    ["COPY_LOADOUT_FROM"] call SELF; }
            , "", 6, true, true
        ];
        private _copyToID = player addAction [
            "<t color='#FF0000'>Copy MY LOADOUT TO unit</t>"
            , {    ["COPY_LOADOUT_TO"] call SELF; }
            , "", 6, true, true
        ];
        private _removeID = player addAction [
            "<t color='#FF3333'># remove actions #</t>"
            , {    ["REMOVE_COPY_ACTION"] call SELF; }
            , "", 6, true, true
        ];

        player setVariable [SVAR(CopyLoadoutActionsID), [_copyFromID,_copyToID,_removeID]];

        ["<t size='1.5' color='#FFD000' shadow='1'>To copy loadout</t><br /><br />Point to unit and use action!"] call FUNC(hint);
    };
    case "REMOVE_COPY_ACTION": {
        private _actionIDs = player getVariable [SVAR(CopyLoadoutActionsID), []];
        if (_actionIDs isEqualTo []) exitWith {};

        { player removeAction _x; } forEach _actionIDs;
        ["Copy loadout disabled"] call FUNC(hint);
    };
};
