#include "script_component.hpp"

H1(Weapon Recoil)
BR
BTN_ [-100] call FUNC(setWeaponRecoil) _WITH_TEXT(-100%)
BTN_ [-75] call FUNC(setWeaponRecoil) _WITH_TEXT(-75%)
BTN_ [-66] call FUNC(setWeaponRecoil) _WITH_TEXT(-66%)
BTN_ [-50] call FUNC(setWeaponRecoil) _WITH_TEXT(-50%)
BTN_ [-33] call FUNC(setWeaponRecoil) _WITH_TEXT(-33%)
BTN_ [-25] call FUNC(setWeaponRecoil) _WITH_TEXT(-25%) 
BTN_ [0] call FUNC(setWeaponRecoil) _WITH_TEXT(Default) 
BTN_ [+50] call FUNC(setWeaponRecoil) _WITH_TEXT(+50%)
BTN_ [+100] call FUNC(setWeaponRecoil) _WITH_TEXT(+100%)
BTN_ [+200] call FUNC(setWeaponRecoil) _WITH_TEXT(+200%)
BR
