#include "script_component.hpp"
#include "..\functions\main\reasons.hpp"

H1(Camera)
BR
BTN_ openMap false; [] spawn BIS_fnc_camera; [player, REASON_CAMERA_OPENED] call FUNC(logUserAction); _WITH_TEXT(Open Splendid Camera)
BR
