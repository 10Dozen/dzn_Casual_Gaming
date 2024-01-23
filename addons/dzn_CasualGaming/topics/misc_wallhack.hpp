#include "script_component.hpp"
#include "..\cobs\WallhackManager\WallhackManager.h"

H1(Wallhack)
BR
BTN_ openMap false; COB(WallhackManager) call [cob_QPAR(Toggle)] _WITH_TEXT(Toggle Wallhack)
BR
Range:     WS
BTN_ COB(WallhackManager) call [cob_QPAR(SetRange), [50]] _WITH_TEXT(50m) WS
BTN_ COB(WallhackManager) call [cob_QPAR(SetRange), [100]] _WITH_TEXT(100m) WS
BTN_ COB(WallhackManager) call [cob_QPAR(SetRange), [300]] _WITH_TEXT(300m) WS
BTN_ COB(WallhackManager) call [cob_QPAR(SetRange), [500]] _WITH_TEXT(500m) WS
BTN_ COB(WallhackManager) call [cob_QPAR(SetRange), [1000]] _WITH_TEXT(1000m) WS
BTN_ COB(WallhackManager) call [cob_QPAR(SetRange), [3000]] _WITH_TEXT(3000m) WS
BTN_ COB(WallhackManager) call [cob_QPAR(SetRange), [6000]] _WITH_TEXT(6000m)
BR
Details:    WS
BTN_ COB(WallhackManager) call [cob_QPAR(SetMode), [MODE_DETAILS]] _WITH_TEXT(All) WS
BTN_ COB(WallhackManager) call [cob_QPAR(SetMode), [MODE_DETAILS, HUD_MARK]] _WITH_TEXT(Mark) WS
BTN_ COB(WallhackManager) call [cob_QPAR(SetMode), [MODE_DETAILS, HUD_RANGE]] _WITH_TEXT(Range) WS
BTN_ COB(WallhackManager) call [cob_QPAR(SetMode), [MODE_DETAILS, HUD_ICON]] _WITH_TEXT(Icon) WS
BR
By side:    WS
BTN_ COB(WallhackManager) call [cob_QPAR(SetMode), [MODE_SIDE]] _WITH_TEXT(All) WS
BTN_ COB(WallhackManager) call [cob_QPAR(SetMode), [MODE_SIDE, F_SIDE_BLUFOR]] _WITH_TEXT(BLUFOR) WS
BTN_ COB(WallhackManager) call [cob_QPAR(SetMode), [MODE_SIDE, F_SIDE_OPFOR]] _WITH_TEXT(OPFOR) WS
BTN_ COB(WallhackManager) call [cob_QPAR(SetMode), [MODE_SIDE, F_SIDE_GUER]] _WITH_TEXT(RESIST) WS
BTN_ COB(WallhackManager) call [cob_QPAR(SetMode), [MODE_SIDE, F_SIDE_CIV]] _WITH_TEXT(CIVIL)
BR
By type:   WS
BTN_ COB(WallhackManager) call [cob_QPAR(SetMode), [MODE_TYPES]] _WITH_TEXT(All) WS
BTN_ COB(WallhackManager) call [cob_QPAR(SetMode), [MODE_TYPES, F_TYPE_INF]] _WITH_TEXT(Infantry) WS
BTN_ COB(WallhackManager) call [cob_QPAR(SetMode), [MODE_TYPES, F_TYPE_WHEELED]] _WITH_TEXT(Wheeled) WS
BTN_ COB(WallhackManager) call [cob_QPAR(SetMode), [MODE_TYPES, F_TYPE_ARMORED]] _WITH_TEXT(Armored) WS
BTN_ COB(WallhackManager) call [cob_QPAR(SetMode), [MODE_TYPES, F_TYPE_AERIAL]] _WITH_TEXT(Aerial) WS
BTN_ COB(WallhackManager) call [cob_QPAR(SetMode), [MODE_TYPES, F_TYPE_STATICS]] _WITH_TEXT(Statics) WS
BTN_ COB(WallhackManager) call [cob_QPAR(SetMode), [MODE_TYPES, F_TYPE_SHIP]] _WITH_TEXT(Ships)WS
BTN_ COB(WallhackManager) call [cob_QPAR(SetMode), [MODE_TYPES, F_TYPE_NONE]] _WITH_TEXT(None)
BR
Track loot:       WS
BTN_ COB(WallhackManager) call [cob_QPAR(ToggleLootTrack)] _WITH_TEXT(Toggle)
BR
Track at map: WS
BTN_ COB(WallhackManager) call [cob_QPAR(ToggleMapTrack)] _WITH_TEXT(Toggle)
BR
NOTE_
Note: Selecting large ranges causes FPS to drop! Use filters to exclude unwanted sides and categories - that may improve performance. _EOL
BR
BR
BTN_ [] spawn FUNC(revealMines); _WITH_TEXT(Reveal mines)
BR
NOTE_
Note: Mines become known to units of your side too, but only be visible depending of Difficulty level of the game. _EOL
