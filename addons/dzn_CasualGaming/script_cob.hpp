#define COB(NAME) gADDON_NAME##_cob_##NAME


#define PREP_COB(NAME) call compileScript ['gADDON_PATH\cobs\NAME\NAME.sqf']
#define PREP_COB_AT(NAME,SUBPATH) call compileScript ['gADDON_PATH\cobs\SUBPATH\NAME.sqf']

#define COB_SELF_NAME // Should be re-defined for each COB
#define QCOB_NAME QUOTE(COB_SELF_NAME)
#define COB_SUPBATH COB_SELF_NAME
#define COB_FULL_PATH gADDON_PATH\cobs\COB_SUPBATH

#define COB_FQNAME COB(COB_SELF_NAME)
#define QCOB_FQNAME QUOTE(COB_FQNAME)
#define cob_PAR(MEMBER) (trim toLower 'MEMBER')
#define cob_QPAR(MEMBER) (trim toLower QUOTE(MEMBER))

// For use outside of COB methods to access specific singleton-COB by it's name
#define cob_GET(NAME,MEMBER) (COB(NAME) get cob_PAR(MEMBER))
#define cob_SET(NAME,MEMBER,VALUE) (COB(NAME) set [cob_PAR(MEMBER), VALUE])
#define cob_SET_WITH(NAME,MEMBER) (COB(NAME) set [cob_PAR(MEMBER),
#define cob_CALL(NAME,FUNC) (COB(NAME) call [cob_PAR(FUNC)])
#define cob_CALL_WITH(NAME,FUNC) (COB(NAME) call [cob_PAR(FUNC),
#define VARSET ])

// For use inside COB methods and during COB initilization
#define self_TYPE ["#type", QCOB_FQNAME]
#define self_PREP(FUNCNAME) [cob_PAR(FUNCNAME), compileScript ['COB_FULL_PATH\_##FUNCNAME.sqf']]
#define self_GET(MEMBER) cob_GET(COB_SELF_NAME,MEMBER)
#define self_SET(MEMBER,VALUE) cob_SET(COB_SELF_NAME,MEMBER,VALUE)
#define self_SET_TO(MEMBER) cob_SET_WITH(COB_SELF_NAME,MEMBER)
#define self_CALL(FUNC) cob_CALL(COB_SELF_NAME,FUNC)
#define self_CALL_WITH(FUNC) cob_CALL_WITH(COB_SELF_NAME,FUNC)
