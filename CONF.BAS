SUB CONF (ConfFile$, Last$)
$IF NOT %NOCONFERENCE
LET ConfBuffer = FREEFILE
IF VAL(Last$) = 0 THEN LET Last$ = "1"
DIM ConfLine AS STRING * 80
OPEN ConfFile$ FOR RANDOM AS #ConfBuffer LEN = 80
CALL EXIST(ConfFile$, Ecode%)
IF Ecode% = 0 THEN PROZOPRINT "Conference file not found." + CrLf$: GOTO ConfEnter
LET CNFBuffer = FREEFILE
ConfMain:
LET ConfRec = 1
Current = 1
Previous = 1
continuous = 0
IF LOF(ConfBuffer) > 80 THEN GET #ConfBuffer, ConfRec, ConfLine ELSE PROZOPRINT CrLf$ + "** new conference **" + CrLf$
PROZOPRINT "^0^B^y(^gR^y)ead Conference, (^gE^y)nter message, or (^rENTER^y) to Quit^w"
PROZOPRINT "--> "
VALUE$=PROZOINPUT$
IF LEN(value$) = 0 THEN GOTO EndConfSub ELSE IF LEN(value$) > 1 THEN LET value$ = LEFT$(value$, 2)
value$ = UCASE$(value$)
IF value$ = "E" THEN GOTO ConfEnter
IF value$ = "R" THEN
        Reader$ = GLOBAL$(1)
               IF Reader$ = "" THEN Reader$ = "LOCAL"
        CALL EXIST(CONFDIR$ + Reader$ + "." + RIGHT$(ConfFile$, 3) + CHR$(0), e%)
        IF e% THEN
                OPEN "i", #CNFBuffer, CONFDIR$ + Reader$ + "." + RIGHT$(ConfFile$, 3)
                INPUT #CNFBuffer, Llast$
                CLOSE #CNFBuffer
        ELSE
                LET Llast$ = "1"
                OPEN "o", #CNFBuffer, CONFDIR$ + Reader$ + "." + RIGHT$(ConfFile$, 3)
                PRINT #CNFBuffer, "1"
                CLOSE #CNFBuffer
        END IF
   GOTO ConfRead
   END IF
   GOTO ConfMain

ConfRead:
IF EOF(ConfBuffer) THEN PROZOPRINT CrLf$ + "** End of Conference **" + CrLf$: GOTO ConfMain
GET #ConfBuffer, ConfRec, ConfLine
IF LEFT$(ConfLine, 1) <> CHR$(1) THEN ConfRec = ConfRec + 1: GOTO ConfRead
Last$ = MID$(STR$(ConfRec), 2)
PROZOPRINT CrLf$ + "#" + MID$(ConfLine, 2, 4) + " From " + MID$(ConfLine, 24, 35) + " Time: " + MID$(ConfLine, 6, 8) + " Date: " + MID$(ConfLine, 14, 10) + CrLf$
PROZOPRINT STRING$(79, "=") + CrLf$
Previous = Current: Current = ConfRec: L = 0: StartRec = ConfRec
Frm$ = RTRIM$(MID$(ConfLine, 58, 8))
IF MID$(ConfLine, 77, 1) = "*" THEN PROZOPRINT CrLf$ + "*** This message has been deleted ***" + CrLf$: df = 1

DO WHILE NOT EOF(ConfBuffer)
     ConfRec = ConfRec + 1
       GET #ConfBuffer, ConfRec, ConfLine
       IF LEFT$(ConfLine, 1) = CHR$(1) THEN EXIT DO
       IF df = 0 THEN PROZOPRINT "^0" + RTRIM$(ConfLine): L = L + 1

        IF L > 18 AND continuous = 0 THEN
                L = 0
                PROZOPRINT "-more-"
                CWAIT
                FOR y = 1 TO 6: PROZOPRINT CHR$(8) + " " + CHR$(8): NEXT y
                END IF
        LOOP
df = 0
IF EOF(ConfBuffer) THEN PROZOPRINT "** Last message **" + CrLf$
IF continuous THEN
        VALUE$=PROZOINKEY$
        IF LEN(value$) THEN continuous = 0
        END IF


value$ = ""
IF continuous = 0 THEN
        PROZOPRINT "^0^w^B(^r^FN^0^w^B)ext (^cP^w)rev (^cS^w)ince (^cR^w)eply private (^cC^w)ont (^cF^w)irst (^cL^w)ast (^cQ^w)uit (^gG^w)bye"
        PROZOPRINT "--> "
        VALUE$=PROZOINPUT$
END IF
IF LEN(value$) > 1 THEN value$ = LEFT$(Value$, 1) ELSE IF Value$ = "" THEN Value$ = "N"
Value$ = UCASE$(Value$)
SELECT CASE Value$
        CASE "R"
                ConfRec = StartRec
                PROZOPRINT CrLf$ + "Reply to Originator.  This is private mail, not included in conference." + CrLf$
                PROZOPRINT CrLf$ + "Press a key for editor..." + CrLf$
                CWAIT
                EditComment Frm$
        CASE "D"
        LET ConfRec = StartRec
        GET #ConfBuffer, ConfRec, ConfLine
        MID$(ConfLine, 77, 1) = "*"
        PUT #ConfBuffer, StartRec, ConfLine
        CASE "U"
        LET ConfRec = StartRec
        GET #ConfBuffer, ConfRec, ConfLine
        MID$(ConfLine, 77, 1) = " "
        PUT #ConfBuffer, StartRec, ConfLine
        CASE "N"

        CASE "P"


                IF StartRec > 1 THEN
                ConfRec = StartRec
                DO
                ConfRec = ConfRec - 1
                GET #ConfBuffer, ConfRec, ConfLine
                IF LEFT$(ConfLine, 1) = CHR$(1) THEN EXIT DO
                LOOP WHILE ConfRec > 1
                ELSE
                ConfRec = 1
                END IF

        CASE "S"
        ConfRec = VAL(Llast$)
        CASE "C"
        continuous = 1
        CASE "F"
        ConfRec = 1
        GET #ConfBuffer, ConfRec, ConfLine
        CASE "L"
        ConfRec = LOF(ConfBuffer) \ 80
                DO
                ConfRec = ConfRec - 1
                GET #ConfBuffer, ConfRec, ConfLine
                IF LEFT$(ConfLine, 1) = CHR$(1) THEN EXIT DO
                LOOP WHILE ConfRec > 1

        CASE "Q"

        GOTO ConfMain

        CASE "G"
                OPEN "o", #CNFBuffer, CONFDIR$ + Reader$ + "." + RIGHT$(ConfFile$, 3)
                PRINT #CNFBuffer, Last$
                CLOSE #CNFBuffer

        SYSRESET

        CASE ELSE
        END SELECT
     GOTO ConfRead
ConfEnter:
        IF LOF(ConfBuffer) > 80 THEN
        ConfRec = LOF(ConfBuffer) \ 80

                DO
                ConfRec = ConfRec - 1
                GET #ConfBuffer, ConfRec, ConfLine
                IF LEFT$(ConfLine, 1) = CHR$(1) THEN EXIT DO
                LOOP WHILE ConfRec > 1
                L$ = MID$(STR$(VAL(MID$(ConfLine, 2, 4)) + 1), 2)
        ELSE
        L$ = "1"
        END IF
a$ = GetVar$("<USERNAME>") + SPACE$(35 - LEN(GetVar$("<USERNAME>"))) + GLOBAL$(1)
LET ConfLine = CHR$(1) + L$ + SPACE$(4 - LEN(L$)) + TIME$ + DATE$ + a$
LET StartRec = (LOF(ConfBuffer) \ 80) + 1
PUT #ConfBuffer, (LOF(ConfBuffer) \ 80) + 1, ConfLine
PROZOPRINT CrLf$ + "Enter text.  Press (ENTER) on a blank line to finish." + CrLf$
PROZOPRINT STRING$(79, "=") + CrLf$
EnterText:
DO
PROZOPRINT ">"
VALUE$=PROZOINPUT$
LET ConfLine = Value$
IF LEN(Value$) THEN PUT #ConfBuffer, (LOF(ConfBuffer) \ 80) + 1, ConfLine
LOOP WHILE LEN(Value$)
PROZOPRINT "(ENTER)=Save, (K)ill (C)ontinue --> "
VALUE$=PROZOINPUT$
IF UCASE$(Value$) = "C" THEN GOTO EnterText
IF UCASE$(Value$) = "K" THEN
        GET #ConfBuffer, StartRec, ConfLine
        MID$(ConfLine, 77, 1) = "*"
        PUT #ConfBuffer, StartRec, ConfLine
END IF
GOTO ConfMain




EndConfSub:
CLOSE #ConfBuffer
                LET Reader$ = GLOBAL$(1)
                IF Reader$ = "" THEN LET Reader$ = "LOCAL"
                OPEN "o", #CNFBuffer, CONFDIR$ + Reader$ + "." + RIGHT$(ConfFile$, 3)
                PRINT #CNFBuffer, Last$
                CLOSE #CNFBuffer

$ENDIF
END SUB

