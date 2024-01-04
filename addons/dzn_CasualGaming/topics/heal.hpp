#include "script_component.hpp"

H1(Auto-Heal)
BR
BTN_ [true] call FUNC(setAutoHealSettings) _WITH_TEXT(Turn On) WS
BTN_ [false] call FUNC(setAutoHealSettings) _WITH_TEXT(Turn Off)
BR
Timeout: WS
BTN_ [10] call FUNC(setAutoHealSettings) _WITH_TEXT(10 sec) WS
BTN_ [20] call FUNC(setAutoHealSettings) _WITH_TEXT(20 sec) WS
BTN_ [30] call FUNC(setAutoHealSettings) _WITH_TEXT(30 sec) WS
BTN_ [40] call FUNC(setAutoHealSettings) _WITH_TEXT(40 sec) WS
BTN_ [60] call FUNC(setAutoHealSettings) _WITH_TEXT(60 sec) WS
BTN_ [300] call FUNC(setAutoHealSettings) _WITH_TEXT(5 min) WS
BTN_ [600] call FUNC(setAutoHealSettings) _WITH_TEXT(10 min)
BR
BR
H1(Instant Healing)
BR
BTN_ [true] call FUNC(heal); _WITH_TEXT(Heal Myself)
