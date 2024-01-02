#include "script_component.hpp"

H1(Arsenal)
BR
BTN_ ["BIS"] spawn FUNC(openArsenal) _WITH_TEXT(Open Arsenal) | BTN_ ["ACE"] spawn FUNC(openArsenal) _WITH_TEXT(Open ACE Arsenal)
BR  Loadout #1  BTN_ ["SAVE", 1] call FUNC(manageLoadouts) _WITH_TEXT(Save) BTN_ ["LOAD", 1] call FUNC(manageLoadouts) _WITH_TEXT(Load)
BR  Loadout #2  BTN_ ["SAVE", 2] call FUNC(manageLoadouts) _WITH_TEXT(Save) BTN_ ["LOAD", 2] call FUNC(manageLoadouts) _WITH_TEXT(Load)
BR  Loadout #3  BTN_ ["SAVE", 3] call FUNC(manageLoadouts) _WITH_TEXT(Save) BTN_ ["LOAD", 3] call FUNC(manageLoadouts) _WITH_TEXT(Load)
BR  Loadout #4  BTN_ ["SAVE", 4] call FUNC(manageLoadouts) _WITH_TEXT(Save) BTN_ ["LOAD", 4] call FUNC(manageLoadouts) _WITH_TEXT(Load)
BR  Loadout #5  BTN_ ["SAVE", 5] call FUNC(manageLoadouts) _WITH_TEXT(Save) BTN_ ["LOAD", 5] call FUNC(manageLoadouts) _WITH_TEXT(Load)
BR
BR
Persistant loadouts:
BR  Loadout P1  BTN_ ["SAVE", 101] call FUNC(manageLoadouts) _WITH_TEXT(Save) BTN_ ["LOAD", 101] call FUNC(manageLoadouts) _WITH_TEXT(Load)
BR  Loadout P2  BTN_ ["SAVE", 102] call FUNC(manageLoadouts) _WITH_TEXT(Save) BTN_ ["LOAD", 102] call FUNC(manageLoadouts) _WITH_TEXT(Load)
BR  Loadout P3  BTN_ ["SAVE", 103] call FUNC(manageLoadouts) _WITH_TEXT(Save) BTN_ ["LOAD", 103] call FUNC(manageLoadouts) _WITH_TEXT(Load)
BR  Loadout P4  BTN_ ["SAVE", 104] call FUNC(manageLoadouts) _WITH_TEXT(Save) BTN_ ["LOAD", 104] call FUNC(manageLoadouts) _WITH_TEXT(Load)
BR  Loadout P5  BTN_ ["SAVE", 105] call FUNC(manageLoadouts) _WITH_TEXT(Save) BTN_ ["LOAD", 105] call FUNC(manageLoadouts) _WITH_TEXT(Load)
BR
BR Get unit loadout:
BR  BTN_ ["ADD_COPY_ACTION"] call FUNC(manageLoadouts) _WITH_TEXT(Copy loadout)
