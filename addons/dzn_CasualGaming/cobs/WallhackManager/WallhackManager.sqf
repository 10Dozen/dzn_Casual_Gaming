#include "..\script_component.hpp"
#include "WallhackManager.h"

/*
    WallhackManager COB

    Manager object that handles Wallhack feature state and settings.
    Is singleton.

    No parameters.
*/
if (!isNil QCOB_FQNAME) exitWith { COB_FQNAME };

private _declaration = [
    self_TYPE,
    [cob_PAR(Enabled), false],
    [cob_PAR(Range), 300],
    [cob_PAR(PFH), nil],
    [cob_PAR(DetailLevel),
        ["HUD Mode",[
            [HUD_MARK, "Mark"],
            [HUD_RANGE, "Range"],
            [HUD_ICON, "Icon"]
        ],
        "Full HUD"] call COB_CONSTRUCTOR(ToggleHandler)
    ],
    [cob_PAR(SideFilter),
        ["Side filter",[
            [F_SIDE_BLUFOR, "BLUFOR", [west]],
            [F_SIDE_OPFOR, "OPFOR", [east]],
            [F_SIDE_GUER, "RESISTANCE", [resistance]],
            [F_SIDE_CIV, "CIVILIAN", [civilian]]
        ],
        "Disabled"] call COB_CONSTRUCTOR(ToggleHandler)
    ],
    [cob_PAR(TypeFilter),
        ["Type filter",[
            [F_TYPE_INF, "Infantry", ["CAManBase"]],
            [F_TYPE_WHEELED, "Wheeled", ["Car", "Motorcycle"]],
            [F_TYPE_ARMORED, "Armored", ["Tank"]],
            [F_TYPE_AERIAL, "Aerial", ["Air"]],
            [F_TYPE_STATICS, "Statics", ["StaticWeapon"]],
            [F_TYPE_SHIP, "Ships", ["Ship"]]
        ],
        "Disabled"] call COB_CONSTRUCTOR(ToggleHandler)
    ],

    // Methods
    self_PREP(Toggle),
    self_PREP(Enable),
    self_PREP(Disable),
    self_PREP(SetRange),
    self_PREP(SetMode),
    self_PREP(TrackObjects),
    self_PREP(FilterObjects)
];

COB_FQNAME = createHashMapObject [_declaration];

COB_FQNAME
