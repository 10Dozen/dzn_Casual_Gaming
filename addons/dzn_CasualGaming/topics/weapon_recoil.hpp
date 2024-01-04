#include "script_component.hpp"

H1(Weapon Recoil)
BR
BTN_ [-100] call FUNC(setWeaponRecoil) _WITH_TEXT(-100%) WS
BTN_ [-75] call FUNC(setWeaponRecoil) _WITH_TEXT(-75%) WS
BTN_ [-66] call FUNC(setWeaponRecoil) _WITH_TEXT(-66%) WS
BTN_ [-50] call FUNC(setWeaponRecoil) _WITH_TEXT(-50%) WS
BTN_ [-33] call FUNC(setWeaponRecoil) _WITH_TEXT(-33%) WS
BTN_ [-25] call FUNC(setWeaponRecoil) _WITH_TEXT(-25%)  WS
BTN_ [0] call FUNC(setWeaponRecoil) _WITH_TEXT(Default)  WS
BTN_ [+50] call FUNC(setWeaponRecoil) _WITH_TEXT(+50%) WS
BTN_ [+100] call FUNC(setWeaponRecoil) _WITH_TEXT(+100%) WS
BTN_ [+200] call FUNC(setWeaponRecoil) _WITH_TEXT(+200%) WS
