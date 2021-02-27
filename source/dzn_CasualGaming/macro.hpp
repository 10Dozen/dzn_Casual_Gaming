#define TITLE "dzn Casual Gaming"
#define	gADDON CasualGaming
#define	gADDON_NAME dzn_##gADDON

#define gADDON_PATH gADDON_NAME
#define gFNC_PATH gADDON_PATH##\functions\##

#define QUOTE(s) #s

#define	ADDON QUOTE(gADDON)
#define ADDON_NAME QUOTE(gADDON_NAME)
#define PATH QUOTE(gADDON_PATH)
#define FNC_PATH QUOTE(gFNC_PATH)

#define GVAR(X) gADDON_NAME##_##X
#define SVAR(X) QUOTE(GVAR(X))
#define FORMAT_VAR(X) format ["%1_%2", ADDON_NAME, X]
#define FUNC(X) gADDON_NAME##_fnc_##X
#define QFUNC(X) QUOTE(FUNC(X))

#define gSTR_NAME(X) STR_##gADDON##_##X
#define STR_NAME(X) QUOTE(gSTR_NAME(X))

#define LOCALIZE_FORMAT_STR(X) localize format ["STR_%1_%2", ADDON, X]
#define LOCALIZE_FORMAT_STR_desc(X) localize format ["STR_%1_%2_desc", ADDON, X]

#define COMPILE_FUNCTION(SUBPATH,NAME) GVAR(NAME) = compile preprocessFileLineNumbers format ["%1%2\%3.sqf", FNC_PATH, QUOTE(SUBPATH), QUOTE(NAME)]