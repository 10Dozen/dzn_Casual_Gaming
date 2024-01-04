#include "script_component.hpp"

H1(Respawn Time)
BR
BTN_ ["SET_TIME", 15] call FUNC(respawnManager) _WITH_TEXT(Turn On (15)) 
BTN_ ["SET_TIME", 999999] call FUNC(respawnManager) _WITH_TEXT(Turn Off)
BR
