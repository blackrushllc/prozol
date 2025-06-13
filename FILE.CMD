'file commands
'MAP RM TO 100, 10 AS ALF, 10 AS BET, 10 AS FOO
GOTO EXITSELECT
PtrMAP:'        CASE "MAP"
        VM$=LITERAL$(ArgPtr%):X$=POPARG$ ' map var name
        L%=VAL(POPARG$) ' length
        VSET2 VM$,STRING$(L%,0)
        O%=1 ' offset from start
        ' assign values to variables which are four byte descriptors,
        ' an offset from the map var start plus the length of the
        ' field.
        DO UNTIL ArgPtr%=0
        	L%=VAL(POPARG$) 'substr len
                V$=LITERAL$(ArgPtr%):X$=POPARG$ ' substr var name
                VSET2 V$+"$"+VM$,MKI$(O%)+MKI$(L%)
                O%=O%+L%
        LOOP

' OPEN mode,buffer,filename
GOTO EXITSELECT
PtrOPEN:'       CASE "OPEN"
        M$=UCASE$(POPARG$) 'mode
        V$=LITERAL$(ArgPtr%) ' buffer
        FF=FREEFILE
        VSET2 V$, STR$(FF)
        Dummy$=POPARG$
        FI$=POPARG$
        IF M$="R" THEN
             L=VAL(POPARG$)
             OPEN FI$ FOR RANDOM SHARED AS FF LEN=L
        ELSE
             OPEN M$,FF,FI$
        END IF

GOTO EXITSELECT
PtrCLOSE:'      CASE "CLOSE"
        VAR$=LITERAL$(ArgPtr%)
	CLOSE VAL(POPARG$)
        VCLEAR VAR$

GOTO EXITSELECT
PtrEOF:'        CASE "EOF"
	PUSHARG STR$(EOF(VAL(POPARG$)))

GOTO EXITSELECT
PtrLOF:'        CASE "LOF"
	PUSHARG STR$(LOF(VAL(POPARG$)))

GOTO EXITSELECT
PtrREAD:'       CASE "READ"
	IF Allness% THEN
         Buf=VAL(POPARG$)
         LINE INPUT #Buf, A$
         VSET2 LITERAL$(ArgPtr%),A$
         Allness%=0
        ELSE
         Buf=VAL(POPARG$)
         DO
          INPUT #Buf, A$
          VSET2 LITERAL$(ArgPtr%),A$
          DUMMY$=POPARG$
         LOOP UNTIL ArgPtr%<1
        END IF
GOTO EXITSELECT
PtrALL:'        CASE "ALL"
	Allness%=%TRUE
GOTO EXITSELECT
PtrWRITE:'      CASE "WRITE"
        P=VAL(POPARG$)
        DO
        P$=POPARG$
        IF INSTR(P$,"<") AND INSTR(P$,">") THEN TRANSLATE P$
        IF INSTR(P$,"@") AND INSTR(P$,"(") AND INSTR(P$,")") THEN FUNCTIONS P$
        IF INSTR(P$,"^") THEN SYMBOLS P$
        PRINT #P, P$;
        LOOP UNTIL ArgPtr%<1
GOTO EXITSELECT
PtrDEL:'        CASE "DEL"
	F$=POPARG$
        IF DIR$(F$)<>"" THEN
                DO
        	KILL F$
                F$=DIR$
                LOOP WHILE LEN(F$)
        END IF
GOTO EXITSELECT
PtrREN:'        "RENAME"        CASE "REN","RENAME"
	F$=POPARG$
        IF DIR$(F$)<>"" THEN NAME F$ AS POPARG$

GOTO EXITSELECT
PtrPUTFILE:'    CASE "PUTFILE"
        Buf=FREEFILE
	OPEN POPARG$ FOR APPEND AS #buf
        WHILE ArgPtr%>0
        	PRINT #buf, POPARG$;
        WEND
        CLOSE Buf
GOTO EXITSELECT
PtrMORE:'       CASE "MORE"
	more=val(poparg$)

GOTO EXITSELECT
PtrTYPE:'       CASE "TYPE"
LET TypeBuffer = FREEFILE: LET lns = 0
Prg$=POPARG$
IF INSTR(Prg$,".") = 0 THEN Prg$ = Prg$ +".TYP"

CALL EXIST(Prg$ + CHR$(0), x%)
IF x% THEN
OPEN Prg$ FOR INPUT SHARED AS #TypeBuffer
typing% = 0
DO WHILE NOT EOF(TypeBuffer)
LINE INPUT #TypeBuffer, A$
IF LEFT$(LTRIM$(A$), 1) <>"$" THEN PROZOPRINT A$+CrLf$: lns = lns + 1:  ELSE CALL PROZOL(MID$(LTRIM$(A$), 2))
''CALL GetaKey
'IF Value$ = CHR$(3) THEN EXIT DO

IF more THEN
	IF lns >= more THEN
	lns = 0
        PROZOPRINT"- more -"
	CWAIT
        PROZOPRINT STRING$(8, 8)
	END IF
END IF


IF typing% THEN EXIT DO
LOOP
CLOSE #TypeBuffer
ELSE
CALL PROZOPRINT(CrLf$ + CHR$(7) + Prg$ +" not found." + CrLf$)
END IF

GOTO EXITSELECT
PtrDISPLAY:'    CASE "DISPLAY"
LET TypeBuffer = FREEFILE: LET lns = 0
Prg$=POPARG$
IF INSTR(Prg$,".") = 0 THEN Prg$ = Prg$ +".TXT"

x%=LEN(DIR$(Prg$))
IF x% THEN
OPEN Prg$ FOR INPUT SHARED AS #TypeBuffer
typing% = 0
DO WHILE NOT EOF(TypeBuffer)
LINE INPUT #TypeBuffer, A$
PROZOPRINT A$+CrLf$
incr lns
A$=PROZOINKEY$
IF A$=CHR$(27) THEN EXIT DO

IF more THEN
	IF lns >= more THEN
	lns = 0
        PROZOPRINT "[S]top, [N]on-stop, or [ENTER] for more..."
        A$=UCASE$(PROZOINPUT$)
        IF A$="S" THEN EXIT DO
        IF A$="N" THEN more=0
        IF GoFlag% THEN GoFlag%=0: EXIT DO
        PROZOPRINT STRING$(42, 8)+SPACE$(42)+STRING$(42,8)
	END IF
END IF

LOOP
CLOSE #TypeBuffer
ELSE
CALL PROZOPRINT(CrLf$ + CHR$(7) + Prg$ +" not found." + CrLf$)
END IF

GOTO EXITSELECT
PtrENDTYPE:'    CASE "ENDTYPE"
LET typing% = 1

GOTO EXITSELECT
PtrPCBTYPE:'    CASE "PCBTYPE"
	PCBTYPE POPARG$,POPARG$,RESPONSE$
        PUSHARG RESPONSE$
