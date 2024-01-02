#include "script_component.hpp"

H1(Wallhack)
BR
BTN_ openMap false; COB(WallhackManager) call [cob_QPAR(Toggle)] _WITH_TEXT(Toggle Wallhack)
BTN_ openMap false; COB(WallhackManager) call [cob_QPAR(SetRange), [100]] _WITH_TEXT(100m)
BTN_ openMap false; COB(WallhackManager) call [cob_QPAR(SetRange), [200]] _WITH_TEXT(200m)
BTN_ openMap false; COB(WallhackManager) call [cob_QPAR(SetRange), [300]] _WITH_TEXT(300m)
BTN_ openMap false; COB(WallhackManager) call [cob_QPAR(SetRange), [500]] _WITH_TEXT(500m)
BTN_ openMap false; COB(WallhackManager) call [cob_QPAR(SetRange), [1000]] _WITH_TEXT(1000m)
BTN_ openMap false; COB(WallhackManager) call [cob_QPAR(SetRange), [3000]] _WITH_TEXT(3000m)
BTN_ openMap false; COB(WallhackManager) call [cob_QPAR(SetRange), [5000]] _WITH_TEXT(5000m)
BR

/*
["TOGGLE"] spawn FUNC(manageWallhack); _WITH_TEXT(Toggle Wallhack)
BTN_ openMap false; ["SET_RANGE", 100] spawn FUNC(manageWallhack); _WITH_TEXT(100m)
BTN_ openMap false; ["SET_RANGE", 200] spawn FUNC(manageWallhack); _WITH_TEXT(200m)
BTN_ openMap false; ["SET_RANGE", 300] spawn FUNC(manageWallhack); _WITH_TEXT(300m)
BTN_ openMap false; ["SET_RANGE", 500] spawn FUNC(manageWallhack); _WITH_TEXT(500m)
BTN_ openMap false; ["SET_RANGE", 1000] spawn FUNC(manageWallhack); _WITH_TEXT(1000m)
BTN_ openMap false; ["SET_RANGE", 3000] spawn FUNC(manageWallhack); _WITH_TEXT(3000m)
BTN_ openMap false; ["SET_RANGE", 5000] spawn FUNC(manageWallhack); _WITH_TEXT(5000m)
BR
*/
