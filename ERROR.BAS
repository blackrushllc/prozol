10000 ee = ERR



IF INSTR(UCASE$(Command$),"/E") THEN END
IF ee = 2 THEN
	COMCLOSE
	REPLACE "2400" WITH "1200" IN PARM$
	COMOPEN PARM$
	Comline = 1
	RESETMODEM
END IF

RESTORE

DO
READ A$
LOOP WHILE A$ <> "UNK"

DO
	READ er: READ e$
	IF er = ee or er=999 THEN EXIT LOOP
LOOP
CLOSE
IF ComLine THEN COMCLOSE:COMOPEN PARM$
TE$="!ERROR"
IF Ee=1 THEN TE$="END RUN"
IF Ee=99 THEN TE$="END RUN"
IF Ee=199 THEN TE$="ABORT"
IF Global$(3)="" THEN Global$(3)="(immediate)"
PROZOPRINT CrLf$ + CrLf$ + TE$ + ": (" + MID$(STR$(ee),2) + ") " + e$
if errormsg% then
	prozoprint " in line" + str$(ProgLine%) + " of " + global$(3)+" -pgm-ctr"+STR$(ERADR)+CrLf$
else
	prozoprint crlf$
end if
'IF TE$="!ERROR" THEN PROGDELAY 2

IF OnError% THEN           ' run an optional error handling program
    IF Ee<>1 AND Ee<>99 AND Ee<>199 THEN
	VSET2 "ERROR", STR$(ee)+ " " + E$
	OnError% = 0
	Prog$=OnError$
	RESUME ChaffLoop
    END IF
END IF

IF Ee<>1 AND Ee<>2 AND Ee<>57 AND Ee<>69 AND Ee<>99 AND Ee<>199 THEN
        PROZOPRINT "(R)etry, (C)ancel, (S)kip --> "
        T!=TIMER+10
        DO
        DVPAUSE
        A$=PROZOINKEY$
	LOOP WHILE A$="" AND T!>TIMER
        IF LEN(A$) THEN PROZOPRINT A$+CrLf$
        A$=UCASE$(A$)
        IF A$="R" THEN RESUME
        IF A$="S" THEN RESUME NEXT
	IF A$="C" THEN Prog%=0:Progline%=0:RESUME PROGINPUT
END IF

IF OnLogout% THEN
	OnLogout%=%False
        Prog$=OnLogout$
        RESUME ChaffLoop
END IF


IF ComLine and TE$="!ERROR" THEN EFFECT "CRASH"
IF ComLine THEN
	RESETMODEM
ELSEIF ee=99 or ee=199 THEN
	LOCATE 24,1,1
	END
'ELSE
'DM "(R)estart, (I)gnore? --> "
'INSTREAM
'IF UCASE$(Value$)="R" THEN CLOSE:RUN
'IF UCASE$(Value$)="I" THEN RESTORE:RESUME BackFromError
END IF
CLOSE:RUN
