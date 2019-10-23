#include "..\..\macro.hpp"
#define SELF GVAR(fnc_addTopic)

/* ----------------------------------------------------------------------------
Function: dzn_CasualGaming_fnc_addTopic

Description:
	Adds briefing topics.

Parameters:
	_mode -- call mode ("ADD", "CHECK_EXISTS") <STRING>
	_payload -- (optional) arguments for call mode (e.g. topic name) <ANY>

Returns:
	<ANY>:
		<BOOL> -- execution result for "CHECK_EXISTS" call
		<STRING> -- topic text for "GET" call


Examples:
    (begin example)
		["AUTOHEAL"] call dzn_CasualGaming_fnc_addTopic
    (end)

Author:
	10Dozen
---------------------------------------------------------------------------- */

params ["_mode",["_payload", ""]];

private _result = false;

switch (toUpper _mode) do {
	case "CHECK_EXISTS": {
		_result = player diarySubjectExists SVAR(Page);
	};
	case "ADD": {
		if !(["CHECK_EXISTS"] call SELF) then { 
			player createDiarySubject [SVAR(Page),"dzn Casual Gaming"];
		};

		// --- Get topic text and remove all whitespaces and carriage return symbols
		private _topicData = ["GET", _payload] call SELF;
		player createDiaryRecord [
			SVAR(Page)
			, [_topicData # 0, (_topicData # 1) splitString toString[9, 13, 10] joinString ""]
		];
	};
	case "ADD_ALL": {
		{
			["ADD", _x] call SELF;
		} forEach [
			/* Reversed order, as last added displayed first in the list */
			"MISC"
			,"RALLYPOINT"
			,"VEHICLE"
			,"ARSENAL"
			,"RESPAWN"
			,"AUTOHEAL"
		];
	};
	case "GET": {
		switch (toUpper _payload) do {
			case "AUTOHEAL": {
				_result = [
					"Auto-Heal"
					,format [
						"<font color='#12C4FF' size='14'>Auto-Heal</font>
						<br />[<font color='#A0DB65'><execute expression='[true] call %1'>Turn On</execute></font>] 
						[<font color='#A0DB65'><execute expression='[false] call %1;'>Turn Off</execute></font>]
						<br />
						<br />Timeout: [<font color='#A0DB65'><execute expression='[10] call %1'>10 sec</execute></font>] 
						[<font color='#A0DB65'><execute expression='[20] call %1'>20 sec</execute></font>] 
						[<font color='#A0DB65'><execute expression='[30] call %1'>30 sec</execute></font>] 
						[<font color='#A0DB65'><execute expression='[40] call %1'>40 sec</execute></font>] 
						[<font color='#A0DB65'><execute expression='[60] call %1'>60 sec</execute></font>] 
						[<font color='#A0DB65'><execute expression='[300] call %1'>5 min</execute></font>] 
						[<font color='#A0DB65'><execute expression='[600] call %1'>10 min</execute></font>] 
						<br />
						<br /><font color='#12C4FF' size='14'>Instant Healing</font>
						<br /> [<font color='#A0DB65'><execute expression='[true] spawn %2;'>Heal Myself</execute></font>]
						<br /> [<font color='#A0DB65'><execute expression='[] spawn %3'>Heal All Players</execute></font>]
						<br /> 
						<br /> <font color='#12C4FF' size='14'>Fatigue</font>
						<br /> [<font color='#A0DB65'><execute expression='true call %4'>Turn On</execute></font>] 
						[<font color='#A0DB65'><execute expression='false call %4'>Turn Off</execute></font>]
						"
						, SVAR(fnc_setAutoHealSettings)
						, SVAR(fnc_heal)
						, SVAR(fnc_healAll)
						, SVAR(fnc_toggleFatigue)
					]
				];
			};
			case "RESPAWN": {
				_result = [
					"Respawn Time"
					, format [
						"<font color='#12C4FF' size='14'>Respawn Time</font>
						<br />[<font color='#A0DB65'><execute expression='[""SET_TIME"",15] call %1;'>Turn On (15)</execute></font>]  [
						<font color='#A0DB65'><execute expression='[""SET_TIME"",999999] call %1;'>Turn Off</execute></font>]
						"
						, SVAR(fnc_respawnManager)
					]
				];
			};
			case "ARSENAL": {
				_result = [
					"Arsenal"
					, format [
						"<font color='#12C4FF' size='14'>Arsenal</font>
						<br />[<font color='#A0DB65'><execute expression='[""BIS""] spawn %1;'>Open Arsenal</execute></font>]  |  [<font color='#A0DB65'><execute expression='[""ACE""] spawn %1;'>Open ACE Arsenal</execute></font>]
						<br />  Loadout #1  (<font color='#A0DB65'><execute expression='[""SAVE"", 1] call %2;'>Save</execute></font>) (<font color='#A0DB65'><execute expression='[""LOAD"", 1] call %2;'>Load</execute></font>)
						<br />  Loadout #2  (<font color='#A0DB65'><execute expression='[""SAVE"", 2] call %2;'>Save</execute></font>) (<font color='#A0DB65'><execute expression='[""LOAD"", 2] call %2;'>Load</execute></font>)
						<br />  Loadout #3  (<font color='#A0DB65'><execute expression='[""SAVE"", 3] call %2;'>Save</execute></font>) (<font color='#A0DB65'><execute expression='[""LOAD"", 3] call %2;'>Load</execute></font>)
						<br />  Loadout #4  (<font color='#A0DB65'><execute expression='[""SAVE"", 4] call %2;'>Save</execute></font>) (<font color='#A0DB65'><execute expression='[""LOAD"", 4] call %2;'>Load</execute></font>)
						<br />  Loadout #5  (<font color='#A0DB65'><execute expression='[""SAVE"", 5] call %2;'>Save</execute></font>) (<font color='#A0DB65'><execute expression='[""LOAD"", 5] call %2;'>Load</execute></font>)
						<br />
						<br />Persistant loadouts:
						<br />  Loadout P1   (<font color='#A0DB65'><execute expression='[""SAVE"", 101] call %2;'>Save</execute></font>) (<font color='#A0DB65'><execute expression='[""LOAD"", 101] call %2;'>Load</execute></font>)
						<br />  Loadout P2   (<font color='#A0DB65'><execute expression='[""SAVE"", 102] call %2;'>Save</execute></font>) (<font color='#A0DB65'><execute expression='[""LOAD"", 102] call %2;'>Load</execute></font>)
						<br />  Loadout P3   (<font color='#A0DB65'><execute expression='[""SAVE"", 103] call %2;'>Save</execute></font>) (<font color='#A0DB65'><execute expression='[""LOAD"", 103] call %2;'>Load</execute></font>)
						<br />  Loadout P4   (<font color='#A0DB65'><execute expression='[""SAVE"", 104] call %2;'>Save</execute></font>) (<font color='#A0DB65'><execute expression='[""LOAD"", 104] call %2;'>Load</execute></font>)
						<br />  Loadout P5   (<font color='#A0DB65'><execute expression='[""SAVE"", 105] call %2;'>Save</execute></font>) (<font color='#A0DB65'><execute expression='[""LOAD"", 105] call %2;'>Load</execute></font>)
						<br />
						<br />Get unit loadout:
						<br />  [<font color='#A0DB65'><execute expression='[""ADD_COPY_ACTION""] call %2;'>Copy loadout</execute></font>] | 
						[<font color='#A0DB65'><execute expression='[""REMOVE_COPY_ACTION""] call %2;'>Disable copy loadout</execute></font>]
						"
						, SVAR(fnc_openArsenal)
						, SVAR(fnc_manageLoadouts)
					]
				];
			};
			case "VEHICLE": {
				_result = [
					"Vehicle"
					, format [
						"<font color='#12C4FF' size='14'>Vehicle Service</font>
						<br />Apply for player's vehicle:
						<br />  [<font color='#A0DB65'><execute expression='[""REPAIR""] call %1;'>REPAIR</execute></font>] 
						[<font color='#A0DB65'><execute expression='[""REFUEL""] call %1;'>REFUEL</execute></font>] 
						[<font color='#A0DB65'><execute expression='[""REARM""] call %1;'>REARM</execute></font>]
						<br />
						<br />  [<font color='#A0DB65'><execute expression='[""DRIVER_ADD""] call %1;'>ADD DRIVER</execute></font>] 
						[<font color='#A0DB65'><execute expression='[""DRIVER_REMOVE""] call %1;'>REMOVE DRIVER</execute></font>]
						<br />
						<br />  [<font color='#A0DB65'><execute expression='[""SET_IN_FLIGHT""] call %1;'>SET IN FLIGHT</execute></font>] 
						[<font color='#A0DB65'><execute expression='[""LAND""] call %1;'>LAND</execute></font>]           
						[<font color='#A0DB65'><execute expression='[""HOVER_TOGGLE""] call %1;'>HOVER ON/OFF</execute></font>] 
						<br />
						<br />Move to seat:
						<br />  [<font color='#A0DB65'><execute expression='[""CHANGE_SEAT_MENU""] call %1;'>CHANGE SEAT</execute></font>]
						<br />
						<br /><font color='#12C4FF' size='14'>Garage</font>
						<br />[<font color='#A0DB65'><execute expression='[] spawn %2;'>Open Garage</execute></font>]
						"
						, SVAR(fnc_manageVehicle)
						, SVAR(fnc_openGarage)
					]
				];
			};
			case "RALLYPOINT": {
				_result = [
					"Rallypoint"
					, format [
						"<font color='#12C4FF' size='14'>Rallypoint</font>
						<br />[<font color='#A0DB65'><execute expression='[0] spawn %1;'>Set Rallypoint</execute></font>]
						<br />
						<br />[<font color='#A0DB65'><execute expression='[0] spawn %2;'>Deploy to My Rallypoint</execute></font>]
						<br />[<font color='#A0DB65'><execute expression='[1] spawn %2;'>Deploy to Squad Rallypoint</execute></font>]
						<br />
						<br />[<font color='#A0DB65'><execute expression='[2] spawn %1;'>Set Global Rallypoint</execute></font>]
						<br />[<font color='#A0DB65'><execute expression='[2] spawn %2;'>Deploy to Global Rallypoint</execute></font>]
						<br />
						<br /> ----------
						<br />[<font color='#ab483e'><execute expression='[0] spawn %3;'>Delete My Rallypoint</execute></font>]
						<br />[<font color='#ab483e'><execute expression='[2] spawn %3;'>Delete Global Rallypoint</execute></font>]
						"
						, SVAR(fnc_setRallypoint)
						, SVAR(fnc_moveToRallypoint)
						, SVAR(fnc_removeRallypoint)
					]
				];
			};
			case "MISC": {
				_result = [
					"Misc"
					, format [
						"<font color='#12C4FF' size='14'>Camera</font>
						<br />[<font color='#A0DB65'><execute expression='openMap false; [] spawn BIS_fnc_camera; [player, 18] call %1;'>Open Splendid Camera</execute></font>]
						<br />[<font color='#A0DB65'><execute expression='openMap false; closeDialog 2; [] spawn { createDialog ""%3"" }; [player, 19] call %1;'>Open Console</execute></font>]
						<br />
						<br />[<font color='#A0DB65'><execute expression='openMap false; [] spawn %2;'>Toggle Wallhack (300m)</execute></font>]
						"
						, SVAR(fnc_logUserAction)
						, SVAR(fnc_toggleWallhack)
						, SVAR(Console_Group)
					]
				];
			};
		};
	};
};

_result