#include "..\script_component.hpp"
#include "WallhackManager.h"

/*
    Initialize Component Object
*/

if (!isNil QCOB_FQNAME) exitWith { COB_FQNAME };

private _declaration = [
    self_TYPE,
    [cob_PAR(Enabled), false],
    [cob_PAR(Range), 300],
    [cob_PAR(PFH), nil],

    // Methods
    self_PREP(Toggle),
    self_PREP(Enable),
    self_PREP(Disable),
    self_PREP(SetRange),
    self_PREP(TrackObjects),
    self_PREP(FilterObjects)
];

COB_FQNAME = createHashMapObject [_declaration];

COB_FQNAME

/*
TODO:
- Select Level of details (Full, Mark-only, Mark+Range,)
- Filter by Side: B,O,R,I
- Filter by Type: INF, VEH, CAR/SHIP, APC/IFV/TANK, AERIAL, STATIC
*/
