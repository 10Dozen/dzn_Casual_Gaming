#include "script_component.hpp"
#include "..\functions\rallypoint\defines.hpp"

H1(Rallypoint)
BR
BTN_ ["SET", RP_CUSTOM] call FUNC(manageRallypoint) _WITH_TEXT(Set My Rallypoint) BR
BR
BTN_ ["DEPLOY_TO", RP_CUSTOM] call FUNC(manageRallypoint) _WITH_TEXT(Deploy to My Rallypoint) BR
BTN_ ["DEPLOY_TO", RP_SQUAD] call FUNC(manageRallypoint) _WITH_TEXT(Deploy to Squad Rallypoint) BR
BR
BTN_ ["SET", RP_GLOBAL] call FUNC(manageRallypoint) _WITH_TEXT(Set Global Rallypoint) BR
BTN_ ["DEPLOY_TO", RP_GLOBAL] call FUNC(manageRallypoint) _WITH_TEXT(Deploy to Global Rallypoint) BR
BR ----------
BTN_ ["REMOVE", RP_CUSTOM] call FUNC(manageRallypoint) _WITH_TEXT(Delete My Rallypoint) BR
BTN_ ["REMOVE", RP_GLOBAL] call FUNC(manageRallypoint) _WITH_TEXT(Delete Global Rallypoint) BR
