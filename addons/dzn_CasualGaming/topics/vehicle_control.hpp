#include "script_component.hpp"

H1(Quick controls)
BR  BTN_ ["SET_IN_FLIGHT"] call FUNC(manageVehicle) _WITH_TEXT(SET IN FLIGHT) 
BTN_ ["SET_IN_FLIGHT", 500] call FUNC(manageVehicle) _WITH_TEXT(At 500m) 
BTN_ ["SET_IN_FLIGHT", 1000] call FUNC(manageVehicle) _WITH_TEXT(At 1000m) 
BTN_ ["SET_IN_FLIGHT", 3000] call FUNC(manageVehicle) _WITH_TEXT(At 3000m) 
BTN_ ["SET_IN_FLIGHT", 5000] call FUNC(manageVehicle) _WITH_TEXT(At 5000m) 
BTN_ ["SET_IN_FLIGHT", 10000] call FUNC(manageVehicle) _WITH_TEXT(At 10000m)
BR  BTN_ ["LAND"] call FUNC(manageVehicle) _WITH_TEXT(LAND) 
BTN_ ["HOVER_TOGGLE"] call FUNC(manageVehicle) _WITH_TEXT(HOVER ON/OFF)
BR
BR
Move to seat:
BR  BTN_ ["CHANGE_SEAT_MENU"] call FUNC(manageVehicle) _WITH_TEXT(CHANGE SEAT) 
BTN_ ["LEAVE_VEHICLE"] call FUNC(manageVehicle) _WITH_TEXT(LEAVE VEHICLE)
BR
