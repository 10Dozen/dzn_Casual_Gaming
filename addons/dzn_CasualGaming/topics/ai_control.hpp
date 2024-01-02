#include "script_component.hpp"

H1(AI units)
BR
BTN_ ["UNIT_ADD"] call FUNC(manageGroup) _WITH_TEXT(ADD UNIT)
BTN_ ["UNIT_REMOVE", units player] call FUNC(manageGroup) _WITH_TEXT(Delete Group)
BR
BR
BTN_ ["UNIT_HEAL", units player] call FUNC(manageGroup) _WITH_TEXT(Heal All)
BTN_ ["UNIT_REARM", units player] call FUNC(manageGroup) _WITH_TEXT(Rearm All)
BTN_ ["UNIT_RALLY", units player] call FUNC(manageGroup) _WITH_TEXT(Rally Up)
BR
BR
BTN_ ["MENU_SHOW", units player] call FUNC(manageGroup) _WITH_TEXT(MANAGE GROUP)
BR
BR
NOTE(Note: Open manage menu, select group members and then choose action to apply from manage menu)
