#include "..\script_component.hpp"
#include "WallhackManager.h"

/* ----------------------------------------------------------------------------
Function: disable

Description:
    Disables Wallhack feature.

Parameters:
    none

Returns:
    none

Examples:
    (begin example)
        dzn_CasualGaming_cob_WallhackManager call ["disable"];
    (end)

Author:
    10Dozen
---------------------------------------------------------------------------- */

private _pfhEntityTracker = self_GET(EntityTrackerPFH);
private _pfhLootTracker = self_GET(LootTrackerPFH);
private _pfhRenderer = self_GET(RendererPFH);

if (isNil "_pfhEntityTracker") exitWith {};

[_pfhEntityTracker] call CBA_fnc_removePerFrameHandler;
[_pfhLootTracker] call CBA_fnc_removePerFrameHandler;
[_pfhRenderer] call CBA_fnc_removePerFrameHandler;

self_SET(EntityTrackerPFH, nil);
self_SET(LootTrackerPFH, nil);
self_SET(RendererPFH, nil);

self_SET(LootTrackerHandler, scriptNull);
self_SET(Enabled, false);

[[
    HINT_WALLHACK, 
    "Disabled"
]] call FUNC(hint);
