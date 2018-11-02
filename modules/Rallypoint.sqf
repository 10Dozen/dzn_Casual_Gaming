#include "..\macro.hpp"

/*
 *	Individual & Squad Rallypoint
 *
 *	Player will be able to place rallypoint and then teleport to it position.
 *	If player's squad leader set rallypoint - player can also teleport to group leader's rallypoint
*/

dzn_CG_RallyPointClass = "Pole_F";

dzn_CG_fnc_moveToRallypoint = {
	params["_modeID"];

	private _pos = [0,0,0];
	private _msgWord = "";
	
	switch (_modeID) do {
		case 0: {
			_msgWord = "My";
			_pos = player getVariable ["dzn_CG_RallypointPosition", [0,0,0]];
		};
		case 1: {
			_msgWord = "Squad";
			_pos = (leader group player) getVariable ["dzn_CG_RallypointPosition", [0,0,0]];
		};
		case 2: {
			_msgWord = "Global";
			_pos = if (!isNil SVAR(GlobalRallypoint)) then { getPos GVAR(GlobalRallypoint) } else { [0,0,0] };
		};
	};
	
	if (_pos isEqualTo [0,0,0]) exitWith {
		hint parseText format ["<t size='1.5' color='#FFD000' shadow='1'>Rallypoint</t>
			<br /><br />%1 rallypoint is NOT AVAILABLE"
			, _msgWord
		];
	};
	
	1000 cutText ["Re-deploying","BLACK OUT",1];
	player allowDamage false;
	sleep 2; 
	openMap false;
	moveOut player;
	player setVelocity [0,0,0];
	player setPos _pos;
	player allowDamage true; 
	1000 cutText ["Re-deploying","BLACK IN",1];

	[player, 4] call GVAR(fnc_logUserAction);
};

GVAR(fnc_setRallypoint) = {
	params["_modeID"];

	private _pos = getPos player;
	private _namespace = "";
	private _rpMrkName = "";
	private _rpName = "";
	private _rpDisplayName = "";
	private _publish = false;

	switch (_modeID) do {
		case 0;
		case 1: {
			player setVariable ["dzn_CG_RallypointPosition", _pos, true];
			
			_namespace = player;
			_rpMrkName = SVAR(RallypointMrk);
			_rpName = SVAR(Rallypoint);
			_rpDisplayName = "Rallypoint";		
		};
		case 2: {
			_namespace = missionNamespace;
			_rpMrkName = SVAR(globalRallypointMrk);
			_rpName = SVAR(GlobalRallypoint);
			_rpDisplayName = "Global Rallypoint";
			_publish = true;
		};
	};

	if (isNull (_namespace getVariable [_rpName, objNull])) then {		
		_namespace setVariable [_rpName, dzn_CG_RallyPointClass createVehicle _pos, _publish];
		
		call compile format [
			'createMarker%1 ["%2", _pos];
			"%2" setMarkerShape "ICON";
			"%2" setMarkerType%1 "mil_pickup";
			"%2" setMarkerAlpha%1 0.5;
			"%2" setMarkerColor%1 "ColorUNKNOWN";
			"%2" setMarkerText%1 "%3";'
			, if (_publish) then { "" } else { "Local" }
			, _rpMrkName
			, _rpDisplayName
		];		
	} else {
		(_namespace getVariable _rpName) setPos _pos;
		_rpMrkName setMarkerPos _pos;
	};

	hint parseText format ["<t size='1.5' color='#FFD000' shadow='1'>%1</t>
		<br /><br />Set at grid %2"
		, _rpDisplayName
		, mapGridPosition _pos
	];

	[player, 5] call GVAR(fnc_logUserAction);
};

/*

dzn_CG_fnc_setRallypoint = {
	private _pos = getPos player;
	player setVariable ["dzn_CG_RallypointPosition", _pos, true];
	
	if ( isNull (player getVariable ["dzn_CG_Rallypoint", objNull]) ) then {
		player setVariable ["dzn_CG_Rallypoint", dzn_CG_RallyPointClass createVehicle _pos];
		
		createMarkerLocal ["dzn_CG_RallypointMrk", _pos];
		"dzn_CG_RallypointMrk" setMarkerShape "ICON";
		"dzn_CG_RallypointMrk" setMarkerTypeLocal "mil_pickup";
		"dzn_CG_RallypointMrk" setMarkerAlphaLocal 0.5;
		"dzn_CG_RallypointMrk" setMarkerColorLocal "ColorUNKNOWN";
		"dzn_CG_RallypointMrk" setMarkerTextLocal "Rallypoint";
	} else {
		(player getVariable "dzn_CG_Rallypoint") setPos _pos;
		"dzn_CG_RallypointMrk" setMarkerPos _pos;
	};
	
	hint parseText format ["<t size='1.5' color='#FFD000' shadow='1'>Rallypoint</t>
		<br /><br />Set at grid %1"
		, mapGridPosition _pos
	];

	[player, 5] call GVAR(fnc_logUserAction);
};
*/


dzn_CG_fnc_isRallypointExist = {
	[
		!(player getVariable ["dzn_CG_RallypointPosition", []] isEqualTo [])
		,!((leader group player) getVariable ["dzn_CG_RallypointPosition", []] isEqualTo [])
	]
};

[] spawn {
	waitUntil { time > 5 };
	
	// Adding ACE actions if ACE running
	if (!isNil "ace_interact_menu_fnc_addActionToClass") then {
		[typeof player,1,["ACE_SelfActions"], [
			"dzn_CG_RallypointNode"
			, "Rallypoint", "", {}, {}
		] call ace_interact_menu_fnc_createAction] call ace_interact_menu_fnc_addActionToClass;
		
		[typeof player,1,["ACE_SelfActions","dzn_CG_RallypointNode"], [
			"dzn_CG_SetRallypointNode"
			, "Set Rallypoint", ""
			, { [0] spawn dzn_CG_fnc_setRallypoint }
			, { true }
		] call ace_interact_menu_fnc_createAction] call ace_interact_menu_fnc_addActionToClass;
		
		[typeof player,1,["ACE_SelfActions","dzn_CG_RallypointNode"], [
			"dzn_CG_GoToMyRallypointNode"
			, "Deploy to My Rallypoint", ""
			, { [0] spawn dzn_CG_fnc_moveToRallypoint }
			, { (call dzn_CG_fnc_isRallypointExist) select 0 }
		] call ace_interact_menu_fnc_createAction] call ace_interact_menu_fnc_addActionToClass;
		
		[typeof player,1,["ACE_SelfActions","dzn_CG_RallypointNode"], [
			"dzn_CG_GoToSquadRallypointNode"
			, "Deploy to Squad Rallypoint", ""
			, { [1] spawn dzn_CG_fnc_moveToRallypoint }
			, { (call dzn_CG_fnc_isRallypointExist) select 1 }
		] call ace_interact_menu_fnc_createAction] call ace_interact_menu_fnc_addActionToClass;
	};	
};

