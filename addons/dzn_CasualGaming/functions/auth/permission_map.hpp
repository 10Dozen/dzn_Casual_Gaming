#define PERM_ALL 1
#define PERM_HEAL 100
#define PERM_GHEAL 101
#define PERM_FATIGUE 102
#define PERM_WEAPON_SWAY 103
#define PERM_WEAPON_RECOIL 104
#define PERM_RESPAWN 200
#define PERM_ARSENAL 300
#define PERM_GARAGE 400
#define PERM_VEHICLE_SERVICE 501
#define PERM_VEHICLE_CONTROL 502
#define PERM_VEHICLE_DRIVER 503
#define PERM_PINNED_VEHICLES 504
#define PERM_RALLYPOINT 600
#define PERM_GROUP_CONTROL 700
#define PERM_GROUP_AI 701
#define PERM_CAMERA 800
#define PERM_CONSOLE 900
#define PERM_WALLHACK 1000

#define PERMISSION_TO_SETTING_MAP \
    [ \
        [PERM_HEAL                , "Feature_HEAL"],\
        [PERM_GHEAL               , "Feature_GLOBAL_HEAL"],\
        [PERM_FATIGUE             , "Feature_FATIGUE"],\
        [PERM_WEAPON_SWAY         , "Feature_WEAPON_SWAY"],\
        [PERM_WEAPON_RECOIL       , "Feature_WEAPON_RECOIL"],\
        [PERM_RESPAWN             , "Feature_RESPAWN"],\
        [PERM_ARSENAL             , "Feature_ARSENAL"],\
        [PERM_GARAGE              , "Feature_GARAGE"],\
        [PERM_VEHICLE_SERVICE     , "Feature_VEHICLE_SERVICE"],\
        [PERM_VEHICLE_CONTROL     , "Feature_VEHICLE_CONTROL"],\
        [PERM_VEHICLE_DRIVER      , "Feature_VEHICLE_DRIVER"],\
        [PERM_PINNED_VEHICLES     , "Feature_PINNED_VEHICLES"],\
        [PERM_RALLYPOINT          , "Feature_RALLYPOINT"],\
        [PERM_GROUP_CONTROL       , "Feature_GROUP_CONTROL"],\
        [PERM_GROUP_AI            , "Feature_GROUP_AI"],\
        [PERM_CAMERA              , "Feature_CAMERA"],\
        [PERM_CONSOLE             , "Feature_CONSOLE"],\
        [PERM_WALLHACK            , "Feature_WALLHACK"] \
    ]

/*

  - HEAL / AUTO-HEAL [Key_Heal]
  - GLOBAL HEAL
  - FATIGUE OPTIONS
  - RESPAWN OPTION
  - ARSENAL/LOADOUTS [Key_OpenArsenal_BIS, Key_OpenArsenal_ACE]
  - GARAGE OPTION [Key_OpenGarage]
  - VEHICE SERVICE [Key_VehicleService]
  - VEHICLE EXTRA CONTROLS [Key_VehicleHover, Key_VehicleLand, Key_VehicleFly, Key_VehicleChangeSeat]
  - VEHICLE DRIVER
  - PINNED VEHICLES [Key_PinnedVehicle_QuickMenu]
  - RALLYPOINTS [Key_SetRallypoint, Key_DeployToRallypoint]
  - GROUP AI - GROUP OPTIONS
  - GROUP AI - MANAGE AI UNITS [Key_GroupAIManage, Key_GroupAIHealAll, Key_GroupAIRallyAll, Key_GroupAIRearmAll]
  - SPLENDID CAMERA
  - CONSOLE [Key_Console]
  - WALLHACK
*/
