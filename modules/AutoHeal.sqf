#include "..\macro.hpp"

/*
 *	Auto Healing
 *
*/

dzn_CG_fnc_setAutoHealSettings = {
	if (typename _this == "BOOL") then {
		dzn_CG_AutoHealEnabled = _this;
	} else {
		dzn_CG_AutoHealTimer = _this;
	};
	
	hint parseText format ["<t size='1.5' color='#FFD000' shadow='1'>Auto-Heal</t>
		<br /><br />%1
		<br />%2 seconds"
		, if (dzn_CG_AutoHealEnabled) then { "ON" } else { "OFF" }
		, dzn_CG_AutoHealTimer
	];
};

dzn_CG_fnc_heal = {
	params ["_showHint"];
	// --- Vanilla healing
	player setDamage 0;

	// --- ACE Healing
	if (!isNil "ace_medical_fnc_treatmentAdvanced_fullHealLocal") then {
		[player ,player] call ace_medical_fnc_treatmentAdvanced_fullHealLocal;
	};

	// --- BIS Revive
	["", 1, player] call BIS_fnc_reviveOnState;
	player setVariable ["#rev", 1];

	if (_showHint) then {
		hint parseText "<t size='1.5' color='#FFD000' shadow='1'>Healed</t>";
	};
	[player, 1] call GVAR(fnc_logUserAction);
};
	
dzn_CG_fnc_healAll = {	
	[true] call dzn_CG_fnc_heal;
	
	{
		[true] remoteExec ["dzn_CG_fnc_heal", _x];
		sleep 0.5;
	} forEach (call BIS_fnc_listPlayers);
	
	hint parseText "<t size='1.5' color='#FFD000' shadow='1'>Global Healing done</t>";
	[player, 2] call GVAR(fnc_logUserAction);
};

dzn_CG_fnc_toggleFatigue = {
	player enableFatigue _this;
	
	// If ACE stamina exists
	if (!isNil "ace_advanced_fatigue_enabled" && { ace_advanced_fatigue_enabled }) then {
		dzn_CG_ACE_Fatigue = _this;
		if !(_this) then {
			[] spawn {
				while { !dzn_CG_ACE_Fatigue } do {
					sleep 0.25;
					ace_advanced_fatigue_anReserve = 999999;
				};		
			};
		};
	};
	
	hint parseText format [
		"<t size='1.5' shadow='1'><t color='#FFD000' >Fatigue</t> %1</t>"
		, if (_this) then { "ON" } else { "OFF" }
	];

	[player, 3] call GVAR(fnc_logUserAction);
};

[] spawn {
	sleep 2;
	
	GVAR(AutoHealEnabled) = false;
	GVAR(AutoHealTimer) = 30;	

	while { true } do {
		sleep 0.5;
		
		if (dzn_CG_AutoHealEnabled) then {
			sleep GVAR(AutoHealTimer);
			[false] call GVAR(fnc_heal);
		};
	};
};

