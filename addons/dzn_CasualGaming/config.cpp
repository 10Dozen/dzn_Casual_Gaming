#include "script_component.hpp"

class CfgPatches
{
    class dzn_CasualGaming
    {
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"CBA_MAIN"};
        author[] = {"10Dozen"};
        version = VERSION_STR;
    };
};

#include "CfgEventHandlers.hpp"

#include "ui\baseDialogClasses.hpp"
#include "ui\display.hpp"
