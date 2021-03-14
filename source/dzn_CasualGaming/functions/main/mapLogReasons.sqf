#include "reasons.hpp"
#define MAP_REASON(ID, MSG) _logReasons set [ID, MSG]

private _logReasons = [];

MAP_REASON(REASON_AUTHORIZED,               "Authorized");
MAP_REASON(REASON_HEALING,                  "Healing used");
MAP_REASON(REASON_HEALING_GLOBAL,           "Global Healing used");
MAP_REASON(REASON_FATIGUE_TOGGLED,          "Fatigue toggled");
MAP_REASON(REASON_WEAPON_SWAY_CHANGED,      "Weapon Sway changed");
MAP_REASON(REASON_WEAPON_RECOIL_CHANGED,    "Weapon Recoil changed");

MAP_REASON(REASON_RESPAWN_TIMER_CHANGED,    "Respawn timer changed");

MAP_REASON(REASON_ARSENAL_OPENED,            "Accessing Arsenal");
MAP_REASON(REASON_LOADOUT_SAVED,             "Loadout saved");
MAP_REASON(REASON_LOADOUT_APPLIED,           "Loadout applied");
MAP_REASON(REASON_LOADOUT_COPIED,            "Loadout copied");

MAP_REASON(REASON_RALLYPOINT_DEPLOYED,       "[Rallypoint] Deployed to rallypoint");
MAP_REASON(REASON_RALLYPOINT_SET,            "[Rallypoint] Rallypoint set");
MAP_REASON(REASON_RALLYPOINT_REMOVED,        "[Rallypoint] Rallypoint removed");

MAP_REASON(REASON_GARAGE_OPENED,             "Accessing Garage");
MAP_REASON(REASON_VEHICLE_REPAIR,            "[Vehicle] Vehicle repaired");
MAP_REASON(REASON_VEHICLE_REFUEL,            "[Vehicle] Vehicle refueled");
MAP_REASON(REASON_VEHICLE_REARM,             "[Vehicle] Vehicle rearmed");
MAP_REASON(REASON_VEHICLE_SET_IN_AIR,        "[Vehicle] Vehicle moved in air");
MAP_REASON(REASON_VEHICLE_LANDED,            "[Vehicle] Landed");
MAP_REASON(REASON_VEHICLE_HOVER_TOGGLED,     "[Vehicle] Hover toggled");
MAP_REASON(REASON_VEHICLE_LEAVED,            "[Vehicle] Leaved vehicle");
MAP_REASON(REASON_VEHICLE_DRIVER_ADDED,      "[Vehicle] Vehicle Driver added");
MAP_REASON(REASON_VEHICLE_DRIVER_REMOVED,    "[Vehicle] Driver removed");

MAP_REASON(REASON_PINNED_VEHICLE_PINNED,     "[Pinned Vehicle] Vehicle pinned");
MAP_REASON(REASON_PINNED_VEHICLE_USED,       "[Pinned Vehicle] Vehicle used");
MAP_REASON(REASON_PINNED_VEHICLE_DISABLED,   "[Pinned Vehicle] Vehicle disabled");
MAP_REASON(REASON_PINNED_VEHICLE_ENABLED,    "[Pinned Vehicle] Vehicle enabled");

MAP_REASON(REASON_WALLHACK_TOGGLED,          "[Wallhack] Wallhack toggled");
MAP_REASON(REASON_WALLHACK_RANGE_CHANGED,    "[Wallhack] Range changed");

MAP_REASON(REASON_CAMERA_OPENED,             "Splendid Camera opened");
MAP_REASON(REASON_CONSOLE_OPENED,            "Console opened");

MAP_REASON(REASON_RATING_FIXED,               "Rating fixed");
MAP_REASON(REASON_RATING_FIXED_GLOBAL,        "Global Rating fixed");
MAP_REASON(REASON_GROUP_JOINED,               "Joined to group");
MAP_REASON(REASON_GROUP_LEADERSHIP_TAKEN,     "Leadership taken");
MAP_REASON(REASON_GROUP_LEAVED,               "Group leaved");
MAP_REASON(REASON_GROUP_UNIT_JOINED,          "Unit joined to player's group");
MAP_REASON(REASON_GROUP_UNIT_ADDED,           "[Group AI] Units added to group");
MAP_REASON(REASON_GROUP_UNIT_HEALED,          "[Group AI] Units healed");
MAP_REASON(REASON_GROUP_UNIT_RALLIED,         "[Group AI] Units rallied up");
MAP_REASON(REASON_GROUP_UNIT_LOADOUT_APPLIED, "[Group AI] Loadouts applied");
MAP_REASON(REASON_GROUP_UNIT_REARMED,         "[Group AI] Loadouts restored / rearmed");
MAP_REASON(REASON_GROUP_UNIT_REMOVED,         "[Group AI] Units removed");
MAP_REASON(REASON_GROUP_UNIT_ARSENAL_APPLIED, "[Group AI] Arsenal applied");

// --- Return ID to message map
_logReasons
