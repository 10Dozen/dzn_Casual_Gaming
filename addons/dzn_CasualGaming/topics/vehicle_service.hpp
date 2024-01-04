#include "script_component.hpp"

H1(Vehicle Service)
BR
Apply for player's vehicle:
BR  BTN_ ["REPAIR"] call FUNC(manageVehicle) _WITH_TEXT(REPAIR) WS
BTN_ ["REFUEL"] call FUNC(manageVehicle) _WITH_TEXT(REFUEL) WS
BTN_ ["REARM"] call FUNC(manageVehicle) _WITH_TEXT(REARM)
BR
