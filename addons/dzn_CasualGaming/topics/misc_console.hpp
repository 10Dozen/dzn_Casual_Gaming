#include "script_component.hpp"
#include "..\functions\main\reasons.hpp"

H1(Console)
BR
BTN_ openMap false; closeDialog 2; [{createDialog SVAR(Console_Group)}] call CBA_fnc_execNextFrame; _WITH_TEXT(Open Console)
BR
