
class CfgPatches
{
	class dzn_CasualGaming
	{
		units[] = {};
		weapons[] = {};
		requiredVersion = 0.1;
		requiredAddons[] = {"CBA_MAIN"};
		author[] = {"10Dozen"};
		version = "5.3";
	};
};

class Extended_PreInit_EventHandlers
{
	class dzn_CasualGaming
	{
		init = call compile preprocessFileLineNumbers "\dzn_CasualGaming\PreInit.sqf";
	};
};

class Extended_PostInit_EventHandlers
{
	class dzn_CasualGaming
	{
		init = call compile preprocessFileLineNumbers "\dzn_CasualGaming\Init.sqf";
	};
};

#include "baseDialogClasses.hpp"
#include "display.hpp"
