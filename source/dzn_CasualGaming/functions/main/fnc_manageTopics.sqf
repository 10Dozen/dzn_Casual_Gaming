#include "..\..\macro.hpp"
#define SELF FUNC(manageTopics)

/* ----------------------------------------------------------------------------
Function: dzn_CasualGaming_fnc_manageTopics

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
		["AUTOHEAL"] call dzn_CasualGaming_fnc_manageTopics
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
			player createDiarySubject [SVAR(Page), "dzn Casual Gaming"];
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
			,"GROUP_AI"
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
						<br />  [<font color='#A0DB65'><execute expression='[""ADD_COPY_ACTION""] call %2;'>Copy loadout</execute></font>]
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
						<br />  [<font color='#A0DB65'><execute expression='[""SET_IN_FLIGHT""] call %1;'>SET IN FLIGHT</execute></font>] 
						[<font color='#A0DB65'><execute expression='[""SET_IN_FLIGHT"",500] call %1;'>500m</execute></font>] 
						[<font color='#A0DB65'><execute expression='[""SET_IN_FLIGHT"",1000] call %1;'>1000m</execute></font>] 
						[<font color='#A0DB65'><execute expression='[""SET_IN_FLIGHT"",3000] call %1;'>3000m</execute></font>] 
						[<font color='#A0DB65'><execute expression='[""SET_IN_FLIGHT"",5000] call %1;'>5000m</execute></font>] 
						[<font color='#A0DB65'><execute expression='[""SET_IN_FLIGHT"",10000] call %1;'>10000m</execute></font>] 
						<br />  [<font color='#A0DB65'><execute expression='[""LAND""] call %1;'>LAND</execute></font>]           
						[<font color='#A0DB65'><execute expression='[""HOVER_TOGGLE""] call %1;'>HOVER ON/OFF</execute></font>] 
						<br />
						<br />Move to seat:
						<br />  [<font color='#A0DB65'><execute expression='[""CHANGE_SEAT_MENU""] call %1;'>CHANGE SEAT</execute></font>] 
						[<font color='#A0DB65'><execute expression='[""LEAVE_VEHICLE""] call %1;'>LEAVE VEHICLE</execute></font>]
						<br />
						<br />AI driver:
						<br />  [<font color='#A0DB65'><execute expression='[""DRIVER_ADD""] call %1;'>ADD DRIVER</execute></font>] 
						[<font color='#A0DB65'><execute expression='[""DRIVER_REMOVE""] call %1;'>REMOVE DRIVER</execute></font>]
						<br />
						<br /><font color='#12C4FF' size='14'>Garage</font>
						<br />[<font color='#A0DB65'><execute expression='[] spawn %2;'>Open Garage</execute></font>]
						<br />
						<br />Pinned vehicles -------------------
						<br />  Vehicle 1 [<font color='#A0DB65'><execute 
						                                expression='[""PIN"",     1] call %3;'>PIN</execute></font>] 
						[<font color='#A0DB65'><execute expression='[""UNPIN"",   1] call %3;'>UNPIN</execute></font>]    
						[<font color='#A0DB65'><execute expression='[""USE"",     1] call %3;'>USE</execute></font>] 
						[<font color='#A0DB65'><execute expression='[""DISABLE"", 1] call %3;'>OFF</execute></font>] 
						[<font color='#A0DB65'><execute expression='[""INFO"",    1] call %3;'>INFO</execute></font>] 
						<br />  Vehicle 2 [<font color='#A0DB65'><execute 
						                                expression='[""PIN"",     2] call %3;'>PIN</execute></font>] 
						[<font color='#A0DB65'><execute expression='[""UNPIN"",   2] call %3;'>UNPIN</execute></font>]    
						[<font color='#A0DB65'><execute expression='[""USE"",     2] call %3;'>USE</execute></font>] 
						[<font color='#A0DB65'><execute expression='[""DISABLE"", 2] call %3;'>OFF</execute></font>] 
						[<font color='#A0DB65'><execute expression='[""INFO"",    2] call %3;'>INFO</execute></font>] 
						<br />  Vehicle 3 [<font color='#A0DB65'><execute 
						                                expression='[""PIN"",     3] call %3;'>PIN</execute></font>] 
						[<font color='#A0DB65'><execute expression='[""UNPIN"",   3] call %3;'>UNPIN</execute></font>]    
						[<font color='#A0DB65'><execute expression='[""USE"",     3] call %3;'>USE</execute></font>] 
						[<font color='#A0DB65'><execute expression='[""DISABLE"", 3] call %3;'>OFF</execute></font>] 
						[<font color='#A0DB65'><execute expression='[""INFO"",    3] call %3;'>INFO</execute></font>] 
						<br />  Vehicle 4 [<font color='#A0DB65'><execute 
						                                expression='[""PIN"",     4] call %3;'>PIN</execute></font>] 
						[<font color='#A0DB65'><execute expression='[""UNPIN"",   4] call %3;'>UNPIN</execute></font>]    
						[<font color='#A0DB65'><execute expression='[""USE"",     4] call %3;'>USE</execute></font>] 
						[<font color='#A0DB65'><execute expression='[""DISABLE"", 4] call %3;'>OFF</execute></font>] 
						[<font color='#A0DB65'><execute expression='[""INFO"",    4] call %3;'>INFO</execute></font>] 
						<br />  Vehicle 5 [<font color='#A0DB65'><execute 
						                                expression='[""PIN"",     5] call %3;'>PIN</execute></font>] 
						[<font color='#A0DB65'><execute expression='[""UNPIN"",   5] call %3;'>UNPIN</execute></font>]    
						[<font color='#A0DB65'><execute expression='[""USE"",     5] call %3;'>USE</execute></font>] 
						[<font color='#A0DB65'><execute expression='[""DISABLE"", 5] call %3;'>OFF</execute></font>] 
						[<font color='#A0DB65'><execute expression='[""INFO"",    5] call %3;'>INFO</execute></font>] 
						<br /><br /><font color='#888888'>Note: UNPIN and USE enables vehicle that was turned off, you can not turn OFF vehicles with other players inside</font>
						"
						, QFUNC(manageVehicle)
						, QFUNC(openGarage)
						, QFUNC(managePinnedVehicle)
					]
				];
			};

			#include "..\rallypoint\defines.hpp"
			case "RALLYPOINT": {
				_result = [
					"Rallypoint"
					, format [
						"<font color='#12C4FF' size='14'>Rallypoint</font>
						<br />[<font color='#A0DB65'><execute expression='[""SET"", ""%2""] call %1;'>Set Rallypoint</execute></font>]
						<br />
						<br />[<font color='#A0DB65'><execute expression='[""DEPLOY_TO"", ""%2""] call %1;'>Deploy to My Rallypoint</execute></font>]
						<br />[<font color='#A0DB65'><execute expression='[""DEPLOY_TO"", ""%4""] call %1;'>Deploy to Squad Rallypoint</execute></font>]
						<br />
						<br />[<font color='#A0DB65'><execute expression='[""SET"", ""%3""] call %1;'>Set Global Rallypoint</execute></font>]
						<br />[<font color='#A0DB65'><execute expression='[""DEPLOY_TO"", ""%3""] call %1;'>Deploy to Global Rallypoint</execute></font>]
						<br />
						<br /> ----------
						<br />[<font color='#ab483e'><execute expression='[""REMOVE"", ""%2""] call %1;'>Delete My Rallypoint</execute></font>]
						<br />[<font color='#ab483e'><execute expression='[""REMOVE"", ""%3""] call %1;'>Delete Global Rallypoint</execute></font>]
						"
						, QFUNC(manageRallypoint)
						, RP_CUSTOM
						, RP_GLOBAL
						, RP_SQUAD
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
						<br />[<font color='#A0DB65'><execute expression='openMap false; [""TOGGLE""] spawn %2;'>Toggle Wallhack</execute></font>]
						[<font color='#A0DB65'><execute expression='openMap false; [""SET_RANGE"", 100] spawn %2;'>100m</execute></font>]
						[<font color='#A0DB65'><execute expression='openMap false; [""SET_RANGE"", 300] spawn %2;'>300m</execute></font>]
						[<font color='#A0DB65'><execute expression='openMap false; [""SET_RANGE"", 500] spawn %2;'>500m</execute></font>]
						[<font color='#A0DB65'><execute expression='openMap false; [""SET_RANGE"", 1000] spawn %2;'>1000m</execute></font>]
						[<font color='#A0DB65'><execute expression='openMap false; [""SET_RANGE"", 3000] spawn %2;'>3000m</execute></font>]
						"
						, SVAR(fnc_logUserAction)
						, SVAR(fnc_manageWallhack)
						, SVAR(Console_Group)
					]
				];
			};
			case "GROUP_AI": {
				_result = [
					"Group AI"
					, format [
						"<font color='#12C4FF' size='14'>Rating</font>
						<br />[<font color='#A0DB65'><execute expression='[true] spawn %1;'>Set Positive Rating</execute></font>]
						<br />[<font color='#A0DB65'><execute expression='[false] spawn %2;'>Set Positive Rating for All</execute></font>]
						<br />
						<br /><font color='#12C4FF' size='14'>SQUAD</font>
						<br />[<font color='#A0DB65'><execute expression='[""BECOME_LEADER""] spawn %3;'>BECOME LEADER</execute></font>] 
						[<font color='#A0DB65'><execute expression='[""JOIN_TO_ACTION_ADD""] spawn %3;'>JOIN TO</execute></font>]        
						[<font color='#A0DB65'><execute expression='[""LEAVE_GROUP""] spawn %3;'>LEAVE GROUP</execute></font>]  
						<br />
						<br />[<font color='#A0DB65'><execute expression='[""UNIT_ADD""] spawn %3;'>ADD UNIT</execute></font>]                                          
						[<font color='#AB483E'><execute expression='[""UNIT_REMOVE"", units player] spawn %3;'>Delete Group</execute></font>]
						<br />
						<br />[<font color='#A0DB65'><execute expression='[""UNIT_HEAL"", units player] spawn %3;'>Heal All</execute></font>] 
						[<font color='#A0DB65'><execute expression='[""UNIT_REARM"", units player] spawn %3;'>Rearm All</execute></font>] 
						[<font color='#A0DB65'><execute expression='[""UNIT_RALLY"", units player] spawn %3;'>Rally Up</execute></font>]
						<br />
						<br />[<font color='#A0DB65'><execute expression='[""MENU_SHOW""] spawn %3;'>MANAGE GROUP</execute></font>] 
						<br />
						<br /><font color='#888888'>Note: Open manage menu, select group members and then choose action to apply from manage menu</font>
						
						"
						, SVAR(fnc_ratingFix)
						, SVAR(fnc_ratingFixAll)
						, SVAR(fnc_manageGroup)

					]
				];
			};
		};
	};
};

_result