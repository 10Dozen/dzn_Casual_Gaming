# dzn Casual Gaming
##### Version: 5

Small cheat-mod to make any mission playable and fun if it isn't (e.g. not enough assets to complete the mission, absence of ACE Medical items, broken vehicles or scripts and so on). 

#### Features:
- ACE / Vanilla / BIS Revive player and global healing; infinite fatigue switch
- Respawn timer change
- Arsenal + ACE Arsenal
- Fast loadout save/load, persistant loadouts (saved between games), loadout copycat
- Garage (MP-compatible)
- Vehicle service (Repair, Rearm, Refuel) and various features: Add/Remove AI driver, Set In Flight, Instant land, Switch seats, Forced hover for helis/planes
- Individual, Squad and Global Rallypoint for fast move
- Group AI features: Adding/deleting AI, manage equipment (Arsenal or copy loadouts, re-arm), heal/teleport, ability to leave and join groups, join specific unit to your group
- Splendid camera
- Scripting console
- Wallhack (300m units markup)
- Server authorization settinga and logging
- CBA Keybind compatibility: various features may be binded to hotkeys

### Usage:
All functions are available from map menu (diary topic 'dzn Casual Gaming').

#### CBA Keybind
Mod allows to bind most of the functions to hotkeys (like heal, set/deplot to rallypoint, vehicle land/hover, group AI features). Check (Options - Controls - Addon Controls - dzn Casual Gaming). 

#### Hover On/Off feature
Forces vehicle to hover mid-air (even planes). You won't be able to control vehicle, but at least it won't fall while you away.

#### Change seat feature
Allows to switch between seats of vehicle. Can be used to swtich between helicopter pilot/gunner/door gunner while in flight/hovered.

#### Group AI - Manage group - Arsenal
When Arsenal is opened with several units selected - each unit will get selected gear once arsenal become closed.

### Settings
#### Authorized users (names/UIDs)
You can configure authorization settings on your server to prevent anyone except admins to use this mod. 
Authorization options are available at (Options - Addon Options - dzn Casual Gaming at Server or Mission tab) that may be forced from server-side or as mission settings and define list of usernames/UIDs that authorized to use Casual Gaming. Empty lists means mod allowed for everyone.

#### Log usage
Logs usage of mod's functions in server RPT log in format `[dzn_CG][PlayerName UID] ActionPerformed`

#### Re-add diary topics
Adds diary topics if where deleted for some reason (e.g. DRO/DCO missions clears diary records on mission start). Just change state of the checkboxs (either check or uncheck) and click OK - topics will be added.

