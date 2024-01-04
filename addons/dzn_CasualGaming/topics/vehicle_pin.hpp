#include "script_component.hpp"

H1(Pinned vehicles)
BR  Vehicle 1  BTN_ ["PIN",    1] call FUNC(managePinnedVehicle) _WITH_TEXT(PIN) WS
               BTN_ ["UNPIN",  1] call FUNC(managePinnedVehicle) _WITH_TEXT(UNPIN) WS
               BTN_ ["USE",    1] call FUNC(managePinnedVehicle) _WITH_TEXT(USE) WS
               BTN_ ["DISABLE",1] call FUNC(managePinnedVehicle) _WITH_TEXT(OFF) WS
               BTN_ ["INFO",   1] call FUNC(managePinnedVehicle) _WITH_TEXT(INFO)
BR  Vehicle 2  BTN_ ["PIN",    2] call FUNC(managePinnedVehicle) _WITH_TEXT(PIN) WS
               BTN_ ["UNPIN",  2] call FUNC(managePinnedVehicle) _WITH_TEXT(UNPIN) WS
               BTN_ ["USE",    2] call FUNC(managePinnedVehicle) _WITH_TEXT(USE) WS
               BTN_ ["DISABLE",2] call FUNC(managePinnedVehicle) _WITH_TEXT(OFF) WS
               BTN_ ["INFO",   2] call FUNC(managePinnedVehicle) _WITH_TEXT(INFO)
BR  Vehicle 3  BTN_ ["PIN",    3] call FUNC(managePinnedVehicle) _WITH_TEXT(PIN) WS
               BTN_ ["UNPIN",  3] call FUNC(managePinnedVehicle) _WITH_TEXT(UNPIN) WS
               BTN_ ["USE",    3] call FUNC(managePinnedVehicle) _WITH_TEXT(USE) WS
               BTN_ ["DISABLE",3] call FUNC(managePinnedVehicle) _WITH_TEXT(OFF) WS
               BTN_ ["INFO",   3] call FUNC(managePinnedVehicle) _WITH_TEXT(INFO)
BR  Vehicle 4  BTN_ ["PIN",    4] call FUNC(managePinnedVehicle) _WITH_TEXT(PIN) WS
               BTN_ ["UNPIN",  4] call FUNC(managePinnedVehicle) _WITH_TEXT(UNPIN) WS
               BTN_ ["USE",    4] call FUNC(managePinnedVehicle) _WITH_TEXT(USE) WS
               BTN_ ["DISABLE",4] call FUNC(managePinnedVehicle) _WITH_TEXT(OFF) WS
               BTN_ ["INFO",   4] call FUNC(managePinnedVehicle) _WITH_TEXT(INFO)
BR  Vehicle 5  BTN_ ["PIN",    5] call FUNC(managePinnedVehicle) _WITH_TEXT(PIN) WS
               BTN_ ["UNPIN",  5] call FUNC(managePinnedVehicle) _WITH_TEXT(UNPIN) WS
               BTN_ ["USE",    5] call FUNC(managePinnedVehicle) _WITH_TEXT(USE) WS
               BTN_ ["DISABLE",5] call FUNC(managePinnedVehicle) _WITH_TEXT(OFF) WS
               BTN_ ["INFO",   5] call FUNC(managePinnedVehicle) _WITH_TEXT(INFO)
BR
BR
NOTE_
Note: UNPIN and USE enables vehicle that was turned off, you can not turn OFF vehicles with other players inside _EOL
