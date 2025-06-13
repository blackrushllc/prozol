SUB PROZOCLS PUBLIC
IF TTY THEN
        PROZOPRINT CHR$(27)+"+"
ELSE
        CALL PROZOPRINT(CHR$(27) + "[2J" + CHR$(27) + "[;f")
END IF
END SUB

SUB PROZOLOCATE (byval row%, byval col%) PUBLIC
IF TTY THEN
        PROZOPRINT CrLf$
ELSE
        CALL PROZOPRINT(CHR$(27) + "[" + MID$(STR$(row%), 2) + ";" + MID$(STR$(col%), 2) + "f")
END IF
END SUB

SUB PROZOCOLOR (byval fg%, byval bg%) PUBLIC
IF TTY THEN
ELSE
CALL PROZOPRINT(CHR$(27) + "[" + MID$(STR$(fg%+30), 2) + ";" + MID$(STR$(bg%+40), 2) + "m")
END IF
END SUB

SUB PROZOPrint(byval Oput$) PUBLIC
IF Echo% THEN EXIT SUB
IF LEN(Oput$)=1 THEN
        ANSIPRINT Oput$
        $IF %MONOWATCH
        GOSUB MONOCOPY
        $ENDIF
        IF Comline THEN COMPRINT Oput$
ELSE
IF INSTR(Oput$,"^") THEN SYMBOLS OPUT$
IF INSTR(Oput$,"<") AND INSTR(Oput$,">") THEN TRANSLATE Oput$ ' find merged variables
IF INSTR(Oput$, "@") THEN FUNCTIONS OPUT$
ANSIPRINT Oput$
IF Comline THEN COMPrint Oput$
        $IF %MONOWATCH
        GOSUB MONOCOPY
        $ENDIF
END IF
END SUB

FUNCTION PROZOINPUT$ STATIC PUBLIC
IF OLM% THEN GETOLM
V$=""
DO
  CALL DVPAUSE
  LET dropout# = TIMER + 300
  LET Ten# = TIMER + 10
  LET Prick# = TIMER + 50
DO

  A$=PROZOINKEY$
$IF NOT %NOTASKS
  CALL TASKMAN
  CALL DVPAUSE
$ENDIF
  IF Timer > Ten# THEN LET Ten# = TIMER + 10:_
    IF OLM% AND V$="" THEN CALL GETOLM:_
      LET Prick# = TIMER + 50:LET DropOut#=Timer+300

IF Comline and Direct$="" THEN
  IF Timer > Prick# THEN LET Prick#=Timer + 50:PROZOPRINT CHR$(7)
  IF TIMER > dropout# OR TIMER > UserTime# THEN _
    PROZOPRINT CHR$(7): CALL TIMEOUT
END IF
LOOP WHILE A$=""

IF A$=" " AND LEN(V$) > 65 THEN LET A$=CHR$(13)

SELECT CASE ASCII(A$)
	CASE 12
                CALL PROZOL("PROMPT '^P@chr(12)^p'")
	CASE 9
                IF LEN(V$) < LEN(OldV$) THEN A$ = MID$(OldV$, LEN(V$) + 1, 1): V$ = V$ + A$: PROZOPRINT A$
	CASE 13
                IF ps = 0 THEN PROZOPRINT CrLf$: EXIT DO ELSE ps = 0
	CASE 16
                PROZOPRINT CHR$(27) + "P": ps = 1
	CASE 8
                IF LEN(V$) THEN V$ = LEFT$(V$, LEN(V$) - 1): PROZOPRINT CHR$(8) + CHR$(32) + CHR$(8)
	CASE 3
                FOR backs = 1 TO LEN(V$): PROZOPRINT CHR$(8) + "!" + CHR$(8): NEXT backs: V$ = ""
		EXIT DO
	CASE 27, 21
                FOR backs = 1 TO LEN(V$): PROZOPRINT CHR$(8) + CHR$(32) + CHR$(8): NEXT backs: V$ = ""

	CASE 7
                'PROZOPRINT "*Page!*" + STRING$(7,8):EFFECT "PAGE"
                GoFlag%=-1
                CALL GETGO

        CASE 4
        	IF TTY THEN TTY=0 ELSE TTY=-1
	CASE ELSE
                IF ASCII(A$) > 31 THEN V$ = V$ + A$: PROZOPRINT A$
	END SELECT
IF GoFlag% THEN GoFlag%=0:ExitFlag%=%True:EXIT LOOP
IF INSTR(V$, "++") THEN ERROR 1
IF INSTR(V$, "NO CARRIER") THEN ERROR 1
LOOP
IF A$=CHR$(3) THEN IF COMLINE THEN ERROR 1 ELSE ERROR 199
IF LEN(V$) > 3 THEN OldV$ = V$
IF LEFT$(V$, 1) = "/" AND GOD THEN Prog$ = V$: V$ = "": CALL PROZOL(MID$(Prog$, 2))
IF LEFT$(UCASE$(V$), 3) = "GO " THEN V$=MID$(V$,4): CALL PROZOL(GETVAR$("$$"+V$+"$$")):V$=""
PROZOINPUT$=V$
END FUNCTION


FUNCTION PROZOINKEY$ PUBLIC
$IF NOT %NOTASKS
        CALL TASKMAN
$ENDIF
        IF COMChars% THEN B$=COMINKEY$ ELSE B$=DOSINKEY$
	CALL DVPAUSE
	' Correct for odd parity
	IF ASCII(B$)>128 THEN B$=CHR$(ASCII(B$)-128)
        IF B$=CHR$(3) THEN ERROR 1
        PROZOINKEY$=B$
END FUNCTION

SUB DM(byval Oput$) PUBLIC
ANSIPRINT Oput$
END SUB

FUNCTION PROZOCSRLIN PUBLIC
	REG 1,&H0300
        REG 2, 0
        CALL INTERRUPT &H10
        PROZOCSRLIN=(REG(4)\&H100)+1
END FUNCTION

FUNCTION PROZOPOS   PUBLIC
	REG 1, &H0300
        REG 2, 0
        CALL INTERRUPT &H10
        PROZOPOS=(REG(4) AND &HFF)+1
END FUNCTION



' DOSINKEY$ returns a character just like INKEY$, or "" if no characters
' are waiting.  The difference between DOSINKEY$ and INKEY$ is that DOSINKEY$
' is redirectable.  So what, you say?  Why not just open KYBD: for input?
' Well, You can't POLL KYBD.  You can only use INPUT$, which will wait
' forever until a character is there.  EOF and LOF do not work, so INPUT$
' us useless for DOS redirection of input.



FUNCTION DOSINKEY$  PUBLIC
	i?=0
        !MOV AX,&H600
        !MOV DL,&HFF
        !INT &H21
        !JZ  NOCHAR
        !MOV i?,AL
NOCHAR:
IF i?=0 THEN DOSINKEY$="" ELSE DOSINKEY$=CHR$(i?)
END FUNCTION

