#include "script_component.hpp"

/*
    'ToggleHandler' Component Object.

    Collection of the switches with related values that handled as group.
    Allows to individually change specific switch and return values of the
    all active switches.

    On selecting/deselcting all switches - reset to 'all enabled'.

    Parameters:
        _this - constructor parameters (see #create.sqf)
*/

private _declaration = GVAR(COB_Cache) getOrDefaultCall [
    QCOB_FQNAME,
    {[
        self_TYPE,
        [cob_PAR(Name), nil],
        [cob_PAR(Switches), 0],
        [cob_PAR(Count), 0],
        [cob_PAR(AllEnabled), true],
        [cob_PAR(onAllEnabledInfo), nil],
        [cob_PAR(onAllEnabledValue), nil],

        // Private methods
        self_PRIVATE_PREP(#create),

        // Methods
        self_PREP(Toggle),
        self_PREP(Reset),
        self_PREP(GetValue),
        self_PREP(GetInfo)
    ]},
    true
];

(createHashMapObject [_declaration, _this])
