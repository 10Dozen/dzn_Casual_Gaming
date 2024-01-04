#include "script_component.hpp"

H1(Auto-Heal)
BR
BTN_ [true] call FUNC(setAutoHealSettings) _WITH_TEXT(Turn On) 
BTN_ [false] call FUNC(setAutoHealSettings) _WITH_TEXT(Turn Off)
BR
Timeout: 
BTN_ [10] call FUNC(setAutoHealSettings) _WITH_TEXT(10 sec)
BTN_ [20] call FUNC(setAutoHealSettings) _WITH_TEXT(20 sec)
BTN_ [30] call FUNC(setAutoHealSettings) _WITH_TEXT(30 sec)
BTN_ [40] call FUNC(setAutoHealSettings) _WITH_TEXT(40 sec)
BTN_ [60] call FUNC(setAutoHealSettings) _WITH_TEXT(60 sec)
BTN_ [300] call FUNC(setAutoHealSettings) _WITH_TEXT(5 min)
BTN_ [600] call FUNC(setAutoHealSettings) _WITH_TEXT(10 min)
BR
BR
H1(Instant Healing)
BR
BTN_ [true] call FUNC(heal); _WITH_TEXT(Heal Myself)
BR
