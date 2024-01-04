#include "script_component.hpp"

AI driver:
BR  BTN_ ["DRIVER_ADD"] call FUNC(manageVehicle) _WITH_TEXT(ADD DRIVER) 
BTN_ ["DRIVER_REMOVE"] call FUNC(manageVehicle) _WITH_TEXT(REMOVE DRIVER)
BR
