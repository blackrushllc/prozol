' Flow commands

GOTO EXITSELECT
PtrNUL:'          CASE "NUL"
        	FOR i = 1 to 10:A$=POPARG$:NEXT i
GOTO EXITSELECT
PtrFILES:'      CASE "FILES"
        	A$=POPARG$:IF A$="" THEN A$="*.*"
                A$=DIR$(A$)
                DO
                PROZOPRINT A$+SPACE$(20-LEN(A$))
                A$=DIR$
                LOOP UNTIL A$=""


GOTO EXITSELECT
PtrGOTO:'       CASE "GOTO"
                ' try to find a label matching the name of what was pushed.
                v%=ArgPtr%:A$=POPARG$:A%=VAL(A$)
                	IF A% THEN
                        	Progline%=A%-1
			ELSE
	                 ARRAY SCAN PROGRAM$(), FROM 1 TO LEN(LITERAL$(v%)),_
        	          COLLATE UCASE, =LITERAL$(v%), TO P%
                            DECR P%,2
                         IF P%<0 OR P%>1000 THEN ERROR 100
                         ProgLine%=P%
                        END IF
                ExitFlag%=-1

GOTO EXITSELECT
PtrFROM:' "TO", "IN", "WITH", "IS", "BE", "EQUAL", "OF", "THE", "AT", "AS", "?", "THEN","RECORD","DATABASE","DISK","NUMBER"
        ' do nothing, these are spacers.

GOTO EXITSELECT
PtrGOSUB:'                    GOSUB
                INCR GosubPtr%
                GosubStack%(GosubPtr%)=ProgLine%
                v%=ArgPtr%:A$=POPARG$:A%=VAL(A$)
		IF A% THEN
                	ProgLine%=A%-1
		ELSE

	                ARRAY SCAN PROGRAM$(), FROM 1 TO LEN(LITERAL$(v%)),_
        	         COLLATE UCASE, =LITERAL$(v%), TO P%
                	DECR ProgLine%,2
                	IF P%<0 OR P%>1000 THEN ERROR 100
                        ProgLine%=P%
                END IF
                ExitFlag%=-1

GOTO EXITSELECT
PtrRETURN:'     CASE "RETURN"
                ProgLine%=GosubStack%(GosubPtr%)
                DECR GosubPtr%
                IF ProgLine%=0 OR ProgLine%>1000 THEN ERROR 100
                ExitFlag%=-1

GOTO EXITSELECT
PtrLINE:'       CASE "LINE"
                P$=LITERAL$(ArgPtr%):A%=VAL(POPARG$)
                IF A% THEN
                	P$=PROGRAM$(P%)
		ELSE
                IF LEN(P$) THEN
                	ARRAY SCAN PROGRAM$(), FROM 1 TO LEN(P$),_
        	         COLLATE UCASE, =P$, TO P%
                	DECR P%,2
                        IF P% THEN P$=MID$(PROGRAM$(P%),LEN(P$)+1)
                END IF
                END IF
                PUSHARG P$

GOTO EXITSELECT
PtrCALL:'       CASE "CALL"
                PROZOL POPARG$

GOTO EXITSELECT
PtrEXIT:'       CASE "EXIT"
        	EXITFLAG%=%TRUE
