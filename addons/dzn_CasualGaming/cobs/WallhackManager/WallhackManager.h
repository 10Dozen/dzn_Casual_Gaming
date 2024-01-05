
#define COB_SELF_NAME WallhackManager

#define MODE_DETAILS 1
#define MODE_SIDE 2
#define MODE_TYPES 3
#define MODE_LOOT 4

#define HUD_RANGE 1
#define HUD_MARK  2
#define HUD_ICON  3

#define F_SIDE_BLUFOR 1
#define F_SIDE_OPFOR  2
#define F_SIDE_GUER   3
#define F_SIDE_CIV    4

#define F_TYPE_INF       1
#define F_TYPE_WHEELED   2
#define F_TYPE_ARMORED   3
#define F_TYPE_AERIAL    4
#define F_TYPE_STATICS   5
#define F_TYPE_SHIP      6
#define F_TYPE_NONE      7

#define HINT_WALLHACK '<t size="1.5" color=COLOR_HINT_TITLE shadow="1">Wallhack</t><br/><br/>'
#define HINT_WALLHACK_SETTINGS_INFO \
    lineBreak, \
    '<t color=COLOR_GRAY>-------</t>', \
    lineBreak, \
    '<t align="left" color=COLOR_GRAY>Range:</t>', \
    format ["<t align='right'>%1 m</t>", self_GET(Range)], \
    lineBreak, \
    '<t align="left" color=COLOR_GRAY>HUD:</t>', \
    format ["<t align='right'>%1</t>", cob_CALL(self_GET(DetailLevel), GetInfo)], \
    lineBreak, \
    '<t align="left" color=COLOR_GRAY>Sides:</t>', \
    format ["<t align='right'>%1</t>", cob_CALL(self_GET(SideFilter), GetInfo)], \
    lineBreak, \
    '<t align="left" color=COLOR_GRAY>Types:</t>', \
    format ["<t align='right'>%1</t>", cob_CALL(self_GET(TypeFilter), GetInfo)], \
    lineBreak, \
    '<t align="left" color=COLOR_GRAY>Loot:</t>', \
    format ["<t align='right'>%1</t>", ["No", "Yes"] select self_GET(LootTrackEnabled)]
