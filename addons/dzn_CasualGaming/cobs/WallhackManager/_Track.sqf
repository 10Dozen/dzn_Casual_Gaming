#include "..\script_component.hpp"
#include "WallhackManager.h"

/* ----------------------------------------------------------------------------
Function: trackObjects

Description:
    Tracks objects around the player according to selected filters.
    Then collected objects will be used by Draw3d PFH (see _RenderObjects.sqf)

Parameters:
    none

Returns:
    none

Examples:
    (begin example)
        dzn_CasualGaming_cob_WallhackManager call ["trackobjects"];
    (end)

Author:
    10Dozen
---------------------------------------------------------------------------- */

#define RANGE_MODIFIER 1.1

if (!self_GET(Enabled)) exitWith {};
if (isGamePaused) exitWith {};
if (!isNull curatorCamera) exitWith {};

private _range = self_GET(Range) * RANGE_MODIFIER;

private _typeFilter = cob_CALL(self_GET(TypeFilter), GetValue);
private _sideFilter = cob_CALL(self_GET(SideFilter), GetValue);
private _objects = (player nearEntities [_typeFilter, _range]) select {
    self_CALL_WITH(FilterObjects) [_x, _sideFilter] VARSET
};

private _pickableFilter = cob_CALL_WITH(self_GET(TypeFilter), GetSwitch) F_TYPE_CONTAINER VARSET;
private _pickableSources = [];
if (_pickableFilter # 0) then {
    _pickableSources append (player nearObjects ["ReammoBox", _range]); // weapon holders
    _pickableSources append (player nearObjects ["ReammoBox_F", _range]); // boxes
    _pickableSources append (allDeadMen select { _x distance player <= _range }); // corpses
};

_objects append _pickableSources;

self_SET_WITH(TrackedObjects) [_objects, _pickableSources] VARSET;
