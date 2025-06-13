'logic commands
GOTO EXITSELECT
PtrCASE :'                    CASE "CASE"
	IF VAL(POPARG$) THEN IfState%=%True ELSE Ifstate%=%False

GOTO EXITSELECT
PtrELSE:'       CASE "ELSE"
        	IIfState%=0
                IfState%=0

GOTO EXITSELECT
PtrENDIF:'      CASE "ENDIF"
                IIfState%=-1
GOTO EXITSELECT
PtrIF:' CASE "IF"
        	A#=VAL(POPARG$)
                IF A#=0 THEN IIfState%=0:'ExitFlag%=-1

GOTO EXITSELECT

PtrDO:
        PUSHON %DoStack,RPRG$
GOTO EXITSELECT

'PtrFOR:
'
'GOTO EXITSELECT
'
'PtrNEXT:
'

GOTO EXITSELECT
PtrWHILE:'      CASE "WHILE"
        	A#=VAL(POPARG$)
                IF A# THEN
                	RPRG$=POPOFF$(%DoStack)
                        PUSHON %DoStack,RPRG$
                ELSE
                	DUMMY$=POPOFF$(%DoStack)
                END IF

GOTO EXITSELECT
PtrUNTIL:'      CASE "UNTIL"
        	a#=VAL(POPARG$)
                IF A#=0 THEN
                	RPRG$=POPOFF$(%DoStack)
                        PUSHON %DoStack,RPRG$
                ELSE
                	DUMMY$=POPOFF$(%DoStack)
                END IF

GOTO EXITSELECT
PtrON:' CASE "ON"
        	PUSHARG "-1"
GOTO EXITSELECT
PtrOFF:'        CASE "OFF"
        	PUSHARG "0"
