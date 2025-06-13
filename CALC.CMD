'calc commands
GOTO EXITSELECT
PtrINCR:'        CASE "INCR"
                v%=ArgPtr%
        	A!=VAL(POPARG$)
                INCR A!
		VSET2 LITERAL$(v%),STR$(A!)

GOTO EXITSELECT
PtrDECR:'        CASE "DECR"
                v%=ArgPtr%
        	A!=VAL(POPARG$)
                DECR A!
		VSET2 LITERAL$(v%),STR$(A!)


GOTO EXITSELECT
PtrCALC:'        CASE "CALC","EVAL","WHAT", "DOES"
                ' Build an expression to calculate by stringing together
                ' all pushed arguments that may constitute an arithmetic
                ' expression.  When we come to a non arithmetic symbol or
                ' bit of text, push it back and calculate what we have.
                A$=""
                DO
                	B$=POPARG$
                        IF B$="" THEN B$="0"
                        IF VERIFY(B$,"01234567890 .+-/\*^()><=") THEN
                        	PUSHARG B$
                                EXIT LOOP
                        END IF
                A$=A$+B$
                LOOP WHILE ArgPtr%>0
                PUSHARG STR$(CALC(A$))

GOTO EXITSELECT
PtrMathSym:'        CASE "+","-","/","*","(",")",">","<","=","&","0"
                INCR ArgPtr%
                ARG$(ArgPtr%)=Prg$
                'PUSHARG PRG$

