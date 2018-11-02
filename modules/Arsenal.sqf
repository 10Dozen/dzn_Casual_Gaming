#include "..\macro.hpp"

/*
 *	Arsenal & Garage
 *
*/

dzn_CG_fnc_openArsenal = {
	params ["_mode"];
	closeDialog 2;

	if (_mode == "BIS") then {
		["Open", true] call BIS_fnc_Arsenal;
	} else {
		[player, player, true] spawn ace_arsenal_fnc_openBox;
	};

	[player, 6] call GVAR(fnc_logUserAction);
};

dzn_CG_fnc_loadout = {
	params ["_mode", "_slotId"];
	
	if (toLower _mode == "save") then {

		if (_slotID < 4) then {
			// --- Current game loadouts 
			call compile format ["dzn_CG_Loadout_%1 = getUnitLoadout player;", _slotId];
			hint parseText format ["<t size='1.5' color='#FFD000' shadow='1'>Loadout %1 saved</t>", _slotId];
		} else {
			// --- Persistant loadouts 
			profileNamespace setVariable [format ["dzn_CG_Loadout_%1", _slotID], getUnitLoadout player];
			hint parseText format ["<t size='1.5' color='#FFD000' shadow='1'>Persistant Loadout P%1 saved</t>", _slotId - 3];
		};

		[player, 7] call GVAR(fnc_logUserAction);
	} else {

		if (_slotID < 4) then {
			// --- Current game loadouts 
			call compile format ["player setUnitLoadout dzn_CG_Loadout_%1;", _slotId];
			hint parseText format ["<t size='1.5' color='#FFD000' shadow='1'>Loadout %1 loaded</t>", _slotId];
		} else {
			// --- Persistant loadouts 
			private _loadout = profileNamespace getVariable [format ["dzn_CG_Loadout_%1", _slotID], []];
			if (_loadout isEqualTo []) exitWith {
				hint parseText format ["<t size='1.5' color='#FFD000' shadow='1'>Persistant Loadout P%1 is not available!</t>", _slotId - 3];
			};

			player setUnitLoadout _loadout;
			hint parseText format ["<t size='1.5' color='#FFD000' shadow='1'>Persistant Loadout P%1 loaded</t>", _slotId - 3];
		};

		[player, 8] call GVAR(fnc_logUserAction);
	};
};

GVAR(fnc_copyLoadoutInit) = {
	openMap false;
	closeDialog 2;

	call GVAR(fnc_removeCopyLoadout);
	
	private _actionID = player addAction [
		"<t color='#FF0000'>COPY UNIT LOADOUT</t>"
		, {
			params ["_target", "_caller", "_actionId", "_arguments"];
			if (isNull cursorTarget) exitWith { hint "No unit under the cursor!"; };

			player setUnitLoadout (getUnitLoadout cursorTarget);
			player removeAction _actionId;

			hint parseText "<t size='1.5' color='#FFD000' shadow='1'>Loadout copied!</t>";
			[player, 10] call GVAR(fnc_logUserAction);
		}
		, ""
		, 6
		, true
		, true
	];

	hint parseText "<t size='1.5' color='#FFD000' shadow='1'>To copy loadout</t><br /><br />Point to unit and use action!";
	player setVariable [SVAR(CopyLoadoutActionID), _actionID];
};

GVAR(fnc_removeCopyLoadout) = {
	private _actionID = player getVariable [SVAR(CopyLoadoutActionID), -1];
	if (_actionID < 0) exitWith {};

	player removeAction _actionID;
	hint "Copy loadout disabled";
};

dzn_CG_fnc_openGarage = {
	closeDialog 2;

	[player, 9] call GVAR(fnc_logUserAction);

	BIS_fnc_garage_center = createVehicle ["Land_HelipadEmpty_F", player getPos [20,getDir player], [], 0, "CAN_COLLIDE" ];
	private _pos = getPosATL BIS_fnc_garage_center;
	
	["Open", true] call BIS_fnc_garage;	
	
	waitUntil { !isNull (uiNamespace getVariable "rscdisplaygarage") };	
	sleep 0.25;
	waitUntil {isNull (uiNamespace getVariable "rscdisplaygarage")};
	
	private _v = nearestObject [_pos, "AllVehicles"];
	private _vType = typeOf _v;
	private _vCustomizationStr = [_v,""] call BIS_fnc_exportVehicle;
	while { !((crew _v) isEqualTo []) } do {
		private _crewman = ((crew _v) select 0);
		moveOut _crewman;
		sleep 0.01;
		deleteVehicle _crewman;
	};
	
	deleteVehicle _v;
	
	sleep 0.25;
	private _nv = _vType createVehicle _pos;
	_nv setPosATL _pos;
	_nv call compile _vCustomizationStr;
	
	sleep 0.025;
	while { !((crew _nv) isEqualTo []) } do {
		private _crewman = ((crew _nv) select 0);
		moveOut _crewman;
		sleep 0.01;
		deleteVehicle _crewman;
	};
};
