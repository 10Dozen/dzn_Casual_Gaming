#include "script_component.hpp"

H1(Rating)
BR
BTN_ [true] call FUNC(ratingFix) _WITH_TEXT(Set Positive Rating) BR
BTN_ [] call FUNC(ratingFixAll) _WITH_TEXT(Set Positive Rating for All) BR
BR
H1(Squad control)
BR
BTN_ ["BECOME_LEADER"] call FUNC(manageGroup); _WITH_TEXT(BECOME LEADER) BR
BTN_ ["JOIN_TO_ACTION_ADD"] call FUNC(manageGroup); _WITH_TEXT(JOIN TO) BR
BTN_ ["LEAVE_GROUP"] call FUNC(manageGroup); _WITH_TEXT(LEAVE GROUP) BR
