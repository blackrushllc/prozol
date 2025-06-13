SUB EditComment (TAX$)
$IF NOT %NOCOMMENTS
SHARED MailPath$
DIM Comline$(9)
CALL PROZOL("Print '^0@CLS()^yLINE EDITOR: ^c9 Lines maximum.  Press ^rENTER^c on a new line to finish.'")
CALL PROZOL("PRINT '^0'")
FOR x = 1 TO 9
CALL PROZOL("Prompt '^0^B^g" + MID$(STR$(x), 2) + ": ^r'")

DO
  LET dropout# = TIMER + 300
  DO
  IF NOT VIDFLAG% THEN Value$=PROZOINKEY$
$IF NOT %NOTASKS
CALL TASKMAN
$ENDIF
REM FORK WENT HERE
  IF TIMER > dropout# OR TIMER > UserTime# THEN CALL PROZOL("PRINT '@CHR(7)'"): CALL TIMEOUT
  LOOP WHILE VALUE$=""
CharCode%=ASCII(Value$)
A$ = CHR$(CharCode%)

IF CharCode% < 128 AND CharCode% > 31 THEN

        Comline$(x) = Comline$(x) + A$: PROZOPRINT A$
ELSE
        IF CharCode% = 13 THEN PROZOPRINT CrLf$: EXIT DO
        IF CharCode% = 8 THEN IF LEN(Comline$(x)) THEN Comline$(x) = LEFT$(Comline$(x), LEN(Comline$(x)) - 1): PROZOPRINT CHR$(8) + CHR$(32) + CHR$(8)
	IF CharCode% = 3 OR CharCode% = 27 THEN EXIT DO
END IF
IF LEN(Comline$(x)) > 60 AND CharCode% = 32 THEN PROZOPRINT CrLf$: EXIT DO
IF INSTR(Comline$(x), "++") THEN ERROR 1
LOOP
	IF LEN(Comline$(x)) = 0 THEN EXIT FOR
	IF CharCode% = 3 OR CharCode% = 27 THEN EXIT FOR
NEXT x
	IF CharCode% = 3 THEN CALL SYSRESET

sopt:
CALL PROZOL("Print '^0'")
CALL PROZOL("Prompt '^B^c(^bS^c)ave (^bA^c)bort or enter line number (^b1-9^c) to ^redit^c --> ^g'")
Value$ = UCASE$(PROZOINPUT$)
IF VAL(Value$) AND VAL(Value$) < 10 THEN
x = VAL(Value$)
CALL PROZOL("Print '^0^B^g" + MID$(STR$(x), 2) + ": ^r" + Comline$(x) +"'")
Comline$ = Comline$(x): Comline$(x) = ""
CALL PROZOL("Prompt '^0^B^g" + MID$(STR$(x), 2) + ": ^r'")
DO
  LET dropout# = TIMER + 500
  DO
IF NOT VidFlag% THEN VALUE$=PROZOINKEY$
$IF NOT %NOTASKS
CALL TASKMAN
$ENDIF
REM FORK WENT HERE
  IF TIMER > dropout# OR TIMER > UserTime# THEN CALL PROZOL("PRINT '@CHR(7)'"): CALL TIMEOUT
  LOOP WHILE VALUE$=""
CharCode%=ASCII(VALUE$)
A$ = CHR$(CharCode%)
IF CharCode% < 128 AND CharCode% > 31 THEN

        Comline$(x) = Comline$(x) + A$: PROZOPRINT A$
ELSE
        IF CharCode% = 13 THEN PROZOPRINT CrLf$: EXIT DO
        IF CharCode% = 8 THEN IF LEN(Comline$(x)) THEN Comline$(x) = LEFT$(Comline$(x), LEN(Comline$(x)) - 1): PROZOPRINT CHR$(8) + CHR$(32) + CHR$(8)
	IF CharCode% = 3 OR CharCode% = 27 THEN EXIT DO
END IF

IF LEN(Comline$(x)) > 75 AND CharCode% = 32 THEN EXIT DO
IF INSTR(Comline$(x), "++") THEN ERROR 1
LOOP
IF Comline$(x) = "" THEN Comline$(x) = Comline$
IF CharCode% = 3 THEN CALL SYSRESET
CALL PROZOL("CLS")
FOR x = 1 TO 9
CALL PROZOL("Print '^0^B^g" + MID$(STR$(x), 2) + ": ^r" + Comline$(x) +"'")
NEXT x
GOTO sopt
ELSEIF Value$ = "S" THEN
LET Comment.ComUser = Global$(1)
LET Comment.ComTime = TIME$
LET Comment.ComDate = DATE$
LET Comment.TaxID$ = TAX$
LET Comment.Line1 = Comline$(1)
LET Comment.Line2 = Comline$(2)
LET Comment.Line3 = Comline$(3)
LET Comment.Line4 = Comline$(4)
LET Comment.Line5 = Comline$(5)
LET Comment.Line6 = Comline$(6)
LET Comment.Line7 = Comline$(7)
LET Comment.Line8 = Comline$(8)
LET Comment.Line9 = Comline$(9)
LET CommentIndex.TaxID$ = TAX$
LET BUF = FREEFILE
OPEN MailPath$ + "COMMENT.RAF" FOR RANDOM aCCESS READ WRITE SHARED as #BUF LEN = LEN(Comment)
x = LOF(BUF) / LEN(Comment)
CommentIndex.RecordNumber = x + 1
PUT #BUF, CommentIndex.RecordNumber, Comment
CLOSE #BUF
OPEN MailPath$ + "COMMENT.IX" FOR RANDOM ACCESS READ WRITE SHARED AS #BUF LEN = LEN(CommentIndex)
x = LOF(BUF) / LEN(CommentIndex) + 1
PUT #BUF, x, CommentIndex
CLOSE #BUF

CALL PROZOL("Print")
CALL PROZOL("Print '^0^B^r** COMMENT SAVED **^0'")
ELSEIF Value$ = "A" THEN
CALL PROZOL("Print")
CALL PROZOL("Print '^B^r** ABORTED **^0'")
ELSE
GOTO sopt
END IF
$ENDIF
END SUB

