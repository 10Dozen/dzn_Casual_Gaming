# dzn Casual Gaming
##### Version: 5.6

Small cheat-mod to make any mission playable and fun if it isn't (e.g. not enough assets to complete the mission, absence of ACE Medical items, broken vehicles or scripts and so on). 

#### Features:
- ACE / Vanilla / BIS Revive player and global healing; infinite fatigue switch
- Weapons Sway and Recoil tweaker
- Respawn timer change
- Arsenal + ACE Arsenal
- Fast loadout save/load, persistant loadouts (saved between games), loadout copycat
- Garage (MP-compatible)
- Vehicle service (Repair, Rearm, Refuel) and various features: Add/Remove AI driver, Set In Flight, Instant land, Switch seats, Forced hover for helis/planes
- Pinned vehicles
- Individual, Squad and Global Rallypoint for fast move
- Group AI features: Adding/deleting AI, manage equipment (Arsenal or copy loadouts, re-arm), heal/teleport, ability to leave and join groups, join specific unit to your group
- Splendid camera
- Scripting console
- Wallhack (300m units markup)
- Server authorization settings and logging, permission profile to allow only specific features for players
- CBA Keybind compatibility: various features may be binded to hotkeys

### Usage:
All functions are available from map menu (diary topic 'dzn Casual Gaming').

#### CBA Keybind
Mod allows to bind most of the functions to hotkeys (like heal, set/deplot to rallypoint, vehicle land/hover, group AI features). Check (Options - Controls - Addon Controls - dzn Casual Gaming). 

#### Hover On/Off feature
Forces vehicle to hover mid-air (even planes). You won't be able to control vehicle, but at least it won't fall while you away. Vehicle pitch-yaw-roll saved, so you can use gunships like Blackfish without need of other players/AI.

#### Change seat / Leave vehicle feature
Allows to switch between seats of vehicle. Can be used to swtich between helicopter pilot/gunner/door gunner while in flight/hovered. 
It's also possible to safely leave vehicle in any circumstances and teleport to position on ground or to rallypoint if set.

#### Pinned Vehicles
Ability to 'pin' up to 5 vehicles and be able to get in at any time, vehicles can also be disabled and hidden when not needed. Basically you can pin and use several vehicles during mission without accessing Zeus - switch to artillery, fire few rounds, switch to A-10 and make some brrrrrrttt and then return to rallypoint and continue to play as infantry.

#### Group AI - Manage group - Arsenal
When Arsenal is opened with several units selected - each unit will get selected gear once arsenal become closed.

### Settings
Set up server settings using (Options - Addon Options - dzn Casual Gaming -> SERVER) and restart the mission to apply.

#### Authorized users (names/UIDs)
You can configure authorization settings on your server to prevent anyone except admins to use this mod. 
Authorization options are available at (Options - Addon Options - dzn Casual Gaming at Server or Mission tab) that may be forced from server-side or as mission settings and define list of usernames/UIDs that authorized to use Casual Gaming. Empty lists means mod allowed for everyone.

#### Log usage
Logs usage of mod's functions in server RPT log in format `[dzn_CG][%PlayerName %UID] %ActionPerformed`

#### Re-add diary topics
Adds diary topics if where deleted for some reason (e.g. DRO/DCO missions clears diary records on mission start). Just change state of the checkboxs (either check or uncheck) and click OK - topics will be added.

#### Authorization Profiles
It's possible to set up availability of the specific features for specific players. Pass through list of features and uncheck features you don't want to be available. Once mission restarted - new settings will be applied and players will be able to use only permitted features via diary and hotkeys.

There are 4 profiles that players may be assigned to (using `Users (UIDs)` field), each containing separated list of allowed features. If player is listed in several profiles - it will have access to combined list of features of all related profiles! 

If `"all"` is used in the `Users (UIDs)` field - all players will be able to use features of this profile (combining with other profiles player assigned to).



