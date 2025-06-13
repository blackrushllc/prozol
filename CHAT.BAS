SUB CHAT(Id$)
$IF NOT %NOCHAT
SHARED ChatFile$
PROZOPRINT CrLf$+CrLf$+"You are now in CHAT mode.  Type /? for help."+CrLf$+CrLf$
'HEY: Chat file name needs to be in CONFIG
ChatFile%=FREEFILE
OPEN ChatFile$ FOR RANDOM SHARED AS #ChatFile% LEN=LEN(Comment)
'HEY: make chat file in config
IF LOF(ChatFile%)=0 THEN GOSUB MakeChatFile
' find a free chat line
FOR TEMP=1 to 7
GET #ChatFile%, TEMP, Comment
IF left$(Comment.ComUser,4) = "NONE" THEN User% = TEMP : Exit For
Next TEMP
if TEMP=7 THEN CLOSE #ChatFile%: PROZOPRINT CrLf$+"Too many CHATs in session..."+CrLf$:Exit SUB
LET Comment.ComUser = Id$
Let Comment.ComDate = Date$
Let Comment.ComTime = Time$
Let Comment.Line1 = Id$+" has entered CHAT"
Comment.Line2 = "."
Comment.Line3 = "."
Comment.Line4 = "."
Comment.Line5 = "."
Comment.Line6 = "."
Comment.Line7 = "."
Comment.Line8 = "."
Comment.Line9 = "."
Let Comment.TaxID = "123456"
LET User$ = mid$(Str$(User%),2)
        LET TaxID$=Comment.TaxID '.............mask out your own intro
        REPLACE User$ WITH " " IN TaxID$
        Let Comment.TaxID = TaxID$
Put #ChatFile%, User%, Comment
GOSUB BFLUSH
PROZOPRINT CrLf$+"You are in chat slot #"+mid$(str$(user%),2)+CrLf$

For TEMP=1 TO 6 '........................... mask out unread comments
	GET #ChatFile%, TEMP, Comment
		LET TaxID$=Comment.TaxID
		REPLACE User$ WITH " " IN TaxID$
		Let Comment.TaxID = TaxID$
	PUT #ChatFile%, TEMP, Comment
Next TEMP
GOSUB BFLUSH
''' ON TIMER(2) GOSUB Check
''' TIMER ON
timestart:
ts#=TIMER+2
idle:
CALL DVPAUSE
$IF NOT %NOTASKS
CALL TASKMAN
$ENDIF
REM FORK WENT HERE
IF TIMER > TS# THEN GOSUB Check:GETOLM:GOTO TimeStart
IF WaitStat% THEN
	''' TIMER STOP
		Ln%=0
		for i%=1 to 9:c$(i%)=".":next i%
		fin%=0
		DO
		Incr Ln%
                PROZOPRINT " --> "
			Value$ = ""
			DO
			  DO
				CALL DVPAUSE
				A$=INKEY$
				IF Comline THEN IF ComChars% THEN A$ = COMINKEY$
				IF LEN(A$) THEN CharType% = 1:_
				CharCode% = ASCII(A$) else CharType%=0:CharCode%=0
$IF NOT %NOTASKS
CALL TASKMAN
$ENDIF
REM FORK WENT HERE
			  LOOP WHILE CharType% = 0
			IF CharCode% = 13 THEN LET fin%=1
			IF CharCode% = 32 AND LEN(Value$) > 65 THEN_
			 LET CharCode% = 13

			SELECT CASE CharCode%
				CASE 9
                                        IF LEN(Value$) < LEN(OldValue$) THEN A$ = MID$(OldValue$, LEN(Value$) + 1, 1): Value$ = Value$ + A$: PROZOPRINT A$
				CASE 13
                                        PROZOPRINT CrLf$: EXIT DO
				CASE 8
                                        IF LEN(Value$) THEN Value$ = LEFT$(Value$, LEN(Value$) - 1): PROZOPRINT CHR$(8) + CHR$(32) + CHR$(8)
				CASE 3
                                        FOR backs = 1 TO LEN(Value$): PROZOPRINT CHR$(8) + "!" + CHR$(8): NEXT backs: Value$ = ""
				EXIT DO
					CASE 27, 21
                                        FOR backs = 1 TO LEN(Value$): PROZOPRINT CHR$(8) + CHR$(32) + CHR$(8): NEXT backs: Value$ = ""

				CASE 7
                                        PROZOPRINT "*Page!*" + STRING$(7,8):EFFECT "PAGE"

				CASE ELSE
                        IF CharCode% > 31 THEN Value$ = Value$ + A$: PROZOPRINT A$
			END SELECT

		IF INSTR(Value$, "++") THEN Die%=1:Goto ExitChat

		LOOP
		IF CharCode% = 3 THEN Die%=1:Goto ExitChat
		IF CharCode% = 27 THEN Goto ExitChat
		IF LEN(Value$) > 3 THEN OldValue$ = Value$

                IF Left$(Value$,1)="/" and Len(Value$)>1 THEN
			P$=MID$(Value$,2)
			Select Case Mid$(UCASE$(Value$),2,1)
                                CASE "H", "?"
                                 PROZOPRINT "Slash (/) commands:"+CrLf$
                                 PROZOPRINT "/? or /H = Help"+CrLf$
                                 PROZOPRINT "      /Q = Quit Chat"+CrLf$
                                 PROZOPRINT "      /W = Who's online"+CrLf$
                                 PROZOPRINT "      /N = Nothing"+CrLf$
                                CASE "W"
                                For i%=1 to 6
                                        GET #ChatFile%, i%, Comment
PROZOPRINT "^B^" + MID$("rgywcm",i%,1) + Str$(i%)+":"+Comment.ComUser+CrLf$
                                Next i%

                                CASE "K"
				GOSUB MakeChatFile
				CASE "Q"
                                LET Comment.ComUser = Global$(1)
                                Let Comment.ComDate = Date$
                                Let Comment.ComTime = Time$
                                Let Comment.Line1 = global$(1)+" has exited CHAT"
                                Comment.Line2 = "."
                                Comment.Line3 = "."
                                Comment.Line4 = "."
                                Comment.Line5 = "."
                                Comment.Line6 = "."
                                Comment.Line7 = "."
                                Comment.Line8 = "."
                                Comment.Line9 = "."
                                Let Comment.TaxID = "123456"
                                LET User$ = mid$(Str$(User%),2)
                                LET TaxID$=Comment.TaxID '.............mask out your own intro
                                REPLACE User$ WITH " " IN TaxID$
                                Let Comment.TaxID = TaxID$
                                Put #ChatFile%, User%, Comment
                                GOSUB BFLUSH

                                ExF%=1
				CASE ELSE
			END SELECT

		EXIT DO
		END IF

		C$(Ln%) = Value$

		IF fin% or Ln% = 9 THEN EXIT DO
		LOOP
		fin%=0
		IF Left$(Value$,1)<>"/" THEN

			Comment.Line1 = c$(1)
			Comment.Line2 = c$(2)
			Comment.Line3 = c$(3)
			Comment.Line4 = c$(4)
			Comment.Line5 = c$(5)
			Comment.Line6 = c$(6)
			Comment.Line7 = c$(7)
			Comment.Line8 = c$(8)
			Comment.Line9 = c$(9)
		     Let Comment.ComUser=Id$
		     Let Comment.ComTime=Time$
		     Let Comment.ComDate=Date$
		     Let Comment.TaxID="123456"
                        LET TaxID$=Comment.TaxID
                        REPLACE User$ WITH " " IN TaxID$
                        Let Comment.TaxID = TaxID$
		     PUT #ChatFile%, User%, Comment
		     GOSUB BFLUSH
		END IF

	''' TIMER ON

END IF
  IF TIMER > UserTime# THEN PROZOPRINT CHR$(7): CALL TIMEOUT
  IF ExF%=1 THEN GOTO ExitChat

goto Idle


Check:
GOSUB BFLUSH
For TEMP=1 to 6
	Get #ChatFile%, TEMP, Comment
	IF Mid$(Comment.TaxID,User%,1)=User$ THEN
		C$(1) = Comment.Line1
		C$(2) = Comment.Line2
		C$(3) = Comment.Line3
		C$(4) = Comment.Line4
		C$(5) = Comment.Line5
		C$(6) = Comment.Line6
		C$(7) = Comment.Line7
		C$(8) = Comment.Line8
		C$(9) = Comment.Line9
		TaxID$=Comment.TaxID
		REPLACE User$ WITH " " IN TaxID$
		Let Comment.TaxID = TaxID$
		Put #ChatFile%, TEMP, Comment
		GOSUB BFLUSH
		FOR i%= 1 TO 9
		IF Len(rtrim$(C$(i%))) > 1 THEN_
                   PROZOPRINT "^B^" + MID$("rgywcm",TEMP,1) + Comment.ComUser+"->"+rtrim$(C$(i%))+"^0"+ CrLf$
		NEXT i%
	END IF
Next TEMP
RETURN

ExitChat:
	''' TIMER OFF
	LET Comment.ComUser="NONE"
	PUT #ChatFile%, User%, Comment
	close #ChatFile%
	IF Die%=1 THEN ERROR 1
	EXIT SUB

MakeChatFile:
        PROZOPRINT "Making Chat file..."+CrLf$
	FOR TEMP=1 TO 7
	LET Comment.ComUser="NONE"
	PUT #ChatFile%, TEMP, Comment
	Next TEMP
	CLOSE #ChatFile%
        PROZOPRINT "Done..."+CrLf$
	OPEN ChatFile$ FOR RANDOM SHARED_
				AS #ChatFile% LEN=LEN(Comment)
        RETURN

BFLUSH:
	CLOSE #ChatFile%
	OPEN ChatFile$ FOR RANDOM SHARED_
				AS #ChatFile% LEN=LEN(Comment)
	RETURN
$ENDIF
END SUB
