
class CfgPatches
{
	class dzn_CasualGaming
	{		
		units[] = {};
		weapons[] = {};
		requiredVersion = 0.1;
		requiredAddons[] = {"CBA_MAIN"};
		author[] = {"10Dozen"};
		version = "4";
	};
};

class Extended_PreInit_EventHandlers
{
	dzn_CasualGamingXEH = call compile preprocessFileLineNumbers "\dzn_CasualGaming\Init.sqf";
};

#include "baseDialogClasses.hpp"
#include "display.hpp"