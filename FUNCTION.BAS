SUB Functions (g$) ' for merged functions embedded within text
aa = INSTR(g$, "@")
IF INSTR(aa + 1, g$, "@") THEN temp$ = MID$(g$, aa + 1): CALL Functions(temp$): g$ = LEFT$(g$, aa) + temp$

bb = INSTR(aa, g$, "(")
IF bb = 0 THEN g$ = LEFT$(g$, aa - 1) + " " + MID$(g$, aa + 1): GOTO functionloop
cc = INSTR(bb, g$, ")")
a$ = LEFT$(g$, aa - 1): b$ = MID$(g$, cc + 1): fun$ = UCASE$(MID$(g$, aa + 1, bb - (aa + 1)))
arg$ = MID$(g$, bb + 1, cc - (bb + 1))

SELECT CASE fun$
CASE "OR"
aa% = VAL(LEFT$(arg$, INSTR(arg$, ",") - 1))
bb% = VAL(MID$(arg$, INSTR(arg$, ",") + 1))
IF (aa% OR bb%) THEN RESULT$="1" ELSE RESULT$="0"

CASE "AND"
aa% = VAL(LEFT$(arg$, INSTR(arg$, ",") - 1))
bb% = VAL(MID$(arg$, INSTR(arg$, ",") + 1))
IF (aa% AND bb%) THEN RESULT$="1" ELSE RESULT$="0"

CASE "NOT"
IF VAL(Arg$)>0 THEN Result$="0" ELSE Result$="1"

CASE "LOOKUP"
Result$ = arg$ + "?"
fi$ = LEFT$(arg$, INSTR(arg$, ",") - 1)' lookup file
srch$ = MID$(arg$, INSTR(arg$, ",") + 1)' lookup string
Fr% = FREEFILE
OPEN fi$ FOR INPUT SHARED AS #Fr%
DO
LINE INPUT #Fr%, fi$
IF UCASE$(srch$) = LEFT$(UCASE$(fi$), LEN(srch$)) THEN Result$ = fi$: EXIT DO
LOOP WHILE NOT EOF(Fr%)
CLOSE #Fr%

CASE "CWAIT"
CWAIT

CASE "USING"
A = INSTR(Arg$, ",")
Result$ = USING$(  LEFT$(Arg$, A - 1)   ,    VAL(MID$(Arg$, A + 1)) )

CASE "FIX"     ' fix the length of output making it larger or smaller
A = INSTR(Arg$, ",")
Result$ = LEFT$(LEFT$(Arg$, A - 1)+SPACE$(255), VAL(MID$(Arg$, A + 1)))

CASE "LOGOUT"
CALL PROZOL("LOGOUT")

CASE "INPUT"
VALUE$=PROZOINPUT$
IF VAL(Arg$)=0 THEN Result$=Value$ ELSE Result$=LEFT$(Value$,VAL(Arg$))

CASE "FOUND"
Result$ = MID$(STR$(Found), 2)

CASE "PARM"
Result$=Parm$

CASE "PORT"
Result$=MID$(STR$(Port%),2)

CASE "CRC"
CALL CRC16(Arg$, hi%, Lo%)
Result$=CHR$(Hi%,Lo%)

CASE "EXIST"
CALL EXIST(Arg$ + CHR$(0), e%)
Result$ = MID$(STR$(e%), 2)

CASE "INKEY"
Result$ = PROZOINKEY$

CASE "LEN"
Result$ = MID$(STR$(LEN(Arg$)), 2)

CASE "MID"
A = INSTR(Arg$, ",")
Result$ = LEFT$(Arg$, A - 1)
Result$ = MID$(Result$, VAL(MID$(Arg$, A + 1)))

CASE "UPPER", "UCASE"
Result$ = UCASE$(Arg$)

CASE "LOWER", "LCASE"
Result$ = LCASE$(Arg$)

CASE "INSTR","SUBSTR"
A = INSTR(Arg$, ",")
Result$ = LEFT$(Arg$, A - 1)
Result = INSTR(Result$, MID$(Arg$, A + 1))
Result$ = MID$(STR$(Result), 2)

CASE "LEFT"
A = INSTR(Arg$, ",")
Result$ = LEFT$(LEFT$(Arg$, A - 1), VAL(MID$(Arg$, A + 1)))

CASE "RIGHT"
A = INSTR(Arg$, ",")
Result$ = RIGHT$(LEFT$(Arg$, A - 1), VAL(MID$(Arg$, A + 1)))

CASE "CHR"
Result$ = CHR$(VAL(Arg$))

CASE "ASC"
Result$ = STR$(ASCII(LTRIM$(Arg$) + CHR$(0)))

CASE "ENVIRON"
Result$ = ENVIRON$(Arg$)

CASE "DUP"
A = INSTR(Arg$, ",")
Result$ = STRING$(VAL(MID$(Arg$, A + 1)), LEFT$(Arg$, 1))

CASE "RTRIM"
Result$ = RTRIM$(Arg$)

CASE "LTRIM"
Result$ = LTRIM$(Arg$)

CASE "CALC"
Result$ = mid$(str$(calc(Arg$)),2)

CASE "GETFILE"
LET getBuffer = FREEFILE
OPEN Arg$ FOR BINARY SHARED AS #getBuffer
Result$ = INPUT$(LOF(getbuffer), #getBuffer)
CLOSE #getBuffer

CASE "VAL"
Result# = VAL(Arg$)
Result$ = MID$(STR$(Result#), 2)

CASE "EOF"
Result$ = MID$(STR$(EOF(VAL(Arg$))), 2)

CASE "COUNT"
Result$ = MID$(STR$(DBH.NumberOfRecords), 2)

CASE "RECNUM","RECNO"
Result$ = MID$(STR$(Recnum), 2)

CASE "LOCATE"
aa = INSTR(Arg$, ",")
aa$ = CHR$(27) + "[" + LEFT$(Arg$, aa - 1) + ";" + MID$(Arg$, aa + 1) + "f"
IF tty THEN Result$ = CrLf$ ELSE Result$ = aa$

CASE "SGR"
IF tty THEN Result$ = "" ELSE Result$ = CHR$(27) + "[" + Arg$ + "m"

CASE "CLS"
IF tty THEN Result$ = CrLf$ ELSE Result$ = CHR$(27) + "[2J" + CHR$(27) + "[;f"

CASE "TIMEOUT"
Result$ = MID$(STR$(INT((UserTime# - TIMER) / 60)), 2)

CASE "GLOBAL"
LET Result$ = Global$(VAL(Arg$))

CASE "CUU"
	IF tty THEN Result$ = CrLf$ ELSE Result$ = CHR$(27) + "[" + Arg$ + "A"
CASE "CUD"
	IF tty THEN Result$ = CrLf$ ELSE Result$ = CHR$(27) + "[" + Arg$ + "B"
CASE "CUF"
	IF tty THEN Result$ = CrLf$ ELSE Result$ = CHR$(27) + "[" + Arg$ + "C"
CASE "CUB"
	IF tty THEN Result$ = CrLf$ ELSE Result$ = CHR$(27) + "[" + Arg$ + "D"
CASE "SCP"
	IF tty THEN Result$ = CrLf$ ELSE Result$ = CHR$(27) + "[s"
CASE "RCP"
	IF tty THEN Result$ = CrLf$ ELSE Result$ = CHR$(27) + "[u"
CASE "EOL"
	IF tty THEN Result$ = CrLf$ ELSE Result$ = CHR$(27) + "[OK"


CASE "TIME"
	Result$ = TIME$
CASE "DATE"
	Result$ = DATE$
CASE "GOD"
Result$=mid$(str$(GOD),2)

CASE "RND","RANDOM"
RANDOMIZE TIMER
aa=val(arg$):decr aa:Result$=MID$(STR$(INT(RND(1)*aa)+1) ,2)

CASE "BAUD"
Result$=BAUD$

CASE "DOS"
Result$=CurDir$:IF Right$(Result$,1)<>"\" THEN Result$=Result$+"\"

CASE ELSE
	' Be able to call a user defined function with parameters
END SELECT


g$ = A$ + Result$ + b$

functionloop:


END SUB

