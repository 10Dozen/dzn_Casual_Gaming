#define COB(NAME) gADDON_NAME##_cob_##NAME

#define COB_CONSTRUCTOR(NAME) COB(NAME)_fnc_create
#define COMPILE_COB(NAME) COB_CONSTRUCTOR(NAME) = compileScript ['gADDON_PATH\cobs\NAME\NAME.sqf']

#define COB_SELF_NAME // Should be re-defined for each COB
#define QCOB_NAME QUOTE(COB_SELF_NAME)
#define COB_SUPBATH COB_SELF_NAME
#define COB_FULL_PATH gADDON_PATH\cobs\COB_SUPBATH

#define COB_FQNAME COB(COB_SELF_NAME)
#define QCOB_FQNAME QUOTE(COB_FQNAME)
#define cob_PAR(MEMBER) (trim toLower 'MEMBER')
#define cob_QPAR(MEMBER) (trim toLower QUOTE(MEMBER))

// For use outside of COB methods to access specific singleton-COB by it's name
#define cob_GET(VARNAME,MEMBER) (VARNAME get cob_PAR(MEMBER))
#define cob_SET(VARNAME,MEMBER,VALUE) (VARNAME set [cob_PAR(MEMBER), VALUE])
#define cob_SET_WITH(VARNAME,MEMBER) (VARNAME set [cob_PAR(MEMBER),
#define cob_CALL(VARNAME,FUNC) (VARNAME call [cob_PAR(FUNC), nil])
#define cob_CALL_WITH(VARNAME,FUNC) (VARNAME call [cob_PAR(FUNC),
#define VARSET ])

// For use inside COB methods and during COB initilization
#define self_TYPE ["#type", QCOB_FQNAME]
#define self_PREP(FUNCNAME) [cob_PAR(FUNCNAME), compileScript ['COB_FULL_PATH\_##FUNCNAME.sqf']]
#define self_PRIVATE_PREP(FUNCNAME) [QUOTE(FUNCNAME), compileScript ['COB_FULL_PATH\FUNCNAME.sqf']]

#define self_GET(MEMBER) (_self get cob_PAR(MEMBER))
#define self_SET(MEMBER,VALUE) (_self set [cob_PAR(MEMBER),VALUE])
#define self_SET_WITH(MEMBER) (_self set [cob_PAR(MEMBER),
#define self_CALL(FUNC) (_self call [cob_PAR(FUNC), nil])
#define self_CALL_WITH(FUNC) (_self call [cob_PAR(FUNC),
