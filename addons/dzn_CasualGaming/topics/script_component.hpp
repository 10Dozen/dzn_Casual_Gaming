#include "\z\dzn_CasualGaming\addons\dzn_CasualGaming\script_component.hpp"

#define H1_COLOR QUOTE(#12C4FF)
#define BTN_COLOR QUOTE(#A0DB65)
#define NOTE_COLOR QUOTE(#888888)
#define H1_SIZE '14'

#define H1(title) <font color=H1_COLOR size=H1_SIZE>##title##</font>
#define NOTE(text) <font color=NOTE_COLOR>##text##</font>
#define BTN_ [<font color=BTN_COLOR><execute expression='
#define _WITH_TEXT(title) '>##title##</execute></font>]
#define BR <br/>
