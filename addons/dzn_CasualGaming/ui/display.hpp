#include "\z\dzn_CasualGaming\addons\dzn_CasualGaming\script_component.hpp"

class GVAR(Console_Group): RscControlsGroup
{
	idd = 192001;
	idc = 3100;
	x = 0.316307 * safezoneW + safezoneX;
	y = 0.149948 * safezoneH + safezoneY;
	w = 0.354265 * safezoneW;
	h = 0.532079 * safezoneH;
	colorBackground[] = {0,0,0,.75};
	onLoad = "[] spawn { uiSleep 0.01; ['OPEN'] call dzn_CasualGaming_fnc_handleConsole; };";

	class controls
	{
		class GVAR(Console_DisplayMain): RscFrame
		{
			idc = 3101;
			x = 0.316307 * safezoneW + safezoneX;
			y = 0.149948 * safezoneH + safezoneY;
			w = 0.354265 * safezoneW;
			h = 0.532079 * safezoneH;
			colorBackground[] = {0,0,0,.5};
			style=80;
		};
		class GVAR(Console_InputMain): RscEdit
		{
			idc = 1400;
			x = 0.322867 * safezoneW + safezoneX;
			y = 0.16395 * safezoneH + safezoneY;
			w = 0.341144 * safezoneW;
			h = 0.280042 * safezoneH;
			style= 16;

			font = "PuristaMedium";
			colorBackground[] = {0,0,0,0.75};
		};
		class GVAR(Console_ServerExecBtn): RscButtonMenu
		{
			idc = 1600;
			text = "SERVER EXEC"; //--- ToDo: Localize;
			x = 0.322867 * safezoneW + safezoneX;
			y = 0.457994 * safezoneH + safezoneY;
			w = 0.111528 * safezoneW;
			h = 0.0280042 * safezoneH;
			colorBackground[] = {0,0,0,1};

			onButtonClick = "['HANDLE','SERVER'] call dzn_CasualGaming_fnc_handleConsole";
		};
		class GVAR(Console_GlobalExecBtn): RscButtonMenu
		{
			idc = 1601;
			text = "GLOBAL EXEC"; //--- ToDo: Localize;
			x = 0.440956 * safezoneW + safezoneX;
			y = 0.457994 * safezoneH + safezoneY;
			w = 0.111528 * safezoneW;
			h = 0.0280042 * safezoneH;
			colorBackground[] = {0,0,0,1};

			onButtonClick = "['HANDLE','GLOBAL'] call dzn_CasualGaming_fnc_handleConsole";
		};
		class GVAR(Console_LocalExecBtn): RscButtonMenu
		{
			idc = 1602;
			text = "LOCAL EXEC"; //--- ToDo: Localize;
			x = 0.559044 * safezoneW + safezoneX;
			y = 0.457994 * safezoneH + safezoneY;
			w = 0.104967 * safezoneW;
			h = 0.0280042 * safezoneH;
			colorBackground[] = {0,0,0,1};
			onButtonClick = "['HANDLE','LOCAL'] call dzn_CasualGaming_fnc_handleConsole";
		};
		class GVAR(Console_PlayerExecCombo): RscCombo
		{
			idc = 2100;
			x = 0.322867 * safezoneW + safezoneX;
			y = 0.5 * safezoneH + safezoneY;
			w = 0.229616 * safezoneW;
			h = 0.0280042 * safezoneH;
			colorBackground[] = {0,0,0,1};
			onSetFocus = "['UPDATE_PLAYER_LIST'] call dzn_CasualGaming_fnc_handleConsole";
		};
		class GVAR(Console_PlayerExecBtn): RscButtonMenu
		{
			idc = 1603;
			text = "EXEC ON PLAYER"; //--- ToDo: Localize;
			x = 0.559044 * safezoneW + safezoneX;
			y = 0.5 * safezoneH + safezoneY;
			w = 0.104967 * safezoneW;
			h = 0.0280042 * safezoneH;
			colorBackground[] = {0,0,0,1};
			onButtonClick = "['HANDLE','PLAYER'] call dzn_CasualGaming_fnc_handleConsole";
		};
		class GVAR(Console_WatchInput): RscEdit
		{
			idc = 1401;
			x = 0.322867 * safezoneW + safezoneX;
			y = 0.598015 * safezoneH + safezoneY;
			w = 0.341144 * safezoneW;
			h = 0.0280042 * safezoneH;
			font = "PuristaMedium";
			onKeyDown = "if ((_this select 1) in [28,156]) then { ['WATCH'] call dzn_CasualGaming_fnc_handleConsole; }";
		};
		class GVAR(Console_WatchOutput): RscEdit
		{
			idc = 1402;
			x = 0.322867 * safezoneW + safezoneX;
			y = 0.626019 * safezoneH + safezoneY;
			w = 0.341144 * safezoneW;
			h = 0.0280042 * safezoneH;
			colorBackground[] = {0,0,0,1};
			font = "PuristaMedium";
			onSetFocus = "['WATCH'] call dzn_CasualGaming_fnc_handleConsole";
		};
		class RscStructuredText_1101: RscStructuredText
		{
			idc = 1101;
			text = "Watch"; //--- ToDo: Localize;
			x = 0.322867 * safezoneW + safezoneX;
			y = 0.57001 * safezoneH + safezoneY;
			w = 0.334584 * safezoneW;
			h = 0.0280042 * safezoneH;
			colorBackground[] = {0,0,0,0};
		};
	};
};
