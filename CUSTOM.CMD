'custom commands
GOTO EXITSELECT
PtrELIZA: ' Eliza
	CALL ELIZA

GOTO EXITSELECT
PtrERRORMSG:'   CASE "ERRORMSG"
	ErrorMsg%=val(poparg$)
GOTO EXITSELECT
PtrEDLIN:'      CASE "EDLIN"
	CALL Edlin(POPARG$)
GOTO EXITSELECT
PtrTASK:'       CASE "TASK"
        ' set a task to a prozol program on disk
GOTO EXITSELECT
PtrSUSPEND:'    CASE "SUSPEND"
        ' suspend a certain task or ALL
GOTO EXITSELECT
PtrRESUME:'     CASE "RESUME"
        ' resume a certain task or ALL
GOTO EXITSELECT
PtrFINISHED:'   CASE "FINISHED"
        ' returns true if a certain task is finished
GOTO EXITSELECT
PtrSTATUS:'     CASE "STATUS"
        ' returns a status flag of a certain task
GOTO EXITSELECT
PtrFREETASK:'   CASE "FREETASK"
        ' returns the next free task number
GOTO EXITSELECT
PtrKILLTASK:'   CASE "KILLTASK"
        ' kills a certain task, or ALL
GOTO EXITSELECT
PtrSIGNAL:'     CASE "SIGNAL"
        ' returns true if a certain signal has been set by a certain task
GOTO EXITSELECT
PtrDEVOTE:'     CASE "DEVOTE"
        ' devotes all time to a certain task or ALL until it's finished
GOTO EXITSELECT
PtrDEPTH:'      CASE "DEPTH"
        ' sets the depth of background processing for tasks

GOTO EXITSELECT
PtrSETENV:'     CASE "SETENV"
        ENVIRON POPARG$

GOTO EXITSELECT
PtrAUTOEDIT:'   CASE "AUTOEDIT"
	CALL AUTOEDIT


GOTO EXITSELECT
PtrINSIDE:'     CASE "INSIDE"
	A$=POPARG$
        DO
        B$=POPARG$
        IF B$="" THEN PUSHARG "0":EXIT LOOP
        IF INSTR(UCASE$(A$),UCASE$(B$)) THEN
                DO:DUMMY$=POPARG$:LOOP UNTIL DUMMY$=""
                PUSHARG "-1"
                EXIT LOOP
        END IF
        LOOP


GOTO EXITSELECT
PtrFLIP:'       CASE "FLIP"

	A$=RTRIM$(LTRIM$(POPARG$))
        A%=INSTR(A$," ")
        IF A% THEN A$=MID$(A$,A%+1)+" "+LEFT$(A$,A%-1)
        PUSHARG A$


GOTO EXITSELECT
PtrCAPS:'       CASE "CAPS"
	A$=LCASE$(RTRIM$(LTRIM$(POPARG$)))
        IF LEN(A$) THEN
        DO : REPLACE "  " WITH " " IN A$ : LOOP WHILE INSTR("  ",A$)
        REPLACE " " WITH CHR$(1) IN A$
        A$=UCASE$(LEFT$(A$,1))+MID$(A$,2)
        DO
	 A%=INSTR(A$,CHR$(1)):IF A%=0 THEN EXIT LOOP
         MID$(A$,A%) = " " + UCASE$(MID$(A$,A%+1,1))
        LOOP
        PUSHARG A$
        END IF
GOTO EXITSELECT
PtrRAW:'        CASE "RAW"



GOTO EXITSELECT
PtrASK:'        CASE "ASK"
        i%=0
	FOR y%=1 TO UBOUND(VAR$)
                IF LEN(VAR$(y%)) THEN
                INCR i%:IF i%=20 THEN CWAIT:I%=0
                PROZOPRINT "{"+VAR$(y%)+"}"+CHR$(9)+"["+VALUE$(y%)+"]"+CrLf$
                END IF
        NEXT y%

GOTO EXITSELECT
PtrDELAY:'      CASE "DELAY"
        PROGDELAY VAL(POPARG$)

GOTO EXITSELECT
PtrITEM:'       CASE "ITEM"
i%=VAL(POPARG$):ITEM$(i%)=POPARG$

GOTO EXITSELECT
PtrWINDOW:'     CASE "WINDOW"
CALL DMMENU(VAL(POPARG$),VAL(POPARG$),VAL(POPARG$),VAL(POPARG$), POPARG$, item$())

GOTO EXITSELECT
PtrMENU:'       CASE "MENU"
CALL DMWINDO(VAL(POPARG$),VAL(POPARG$),VAL(POPARG$),VAL(POPARG$), POPARG$, item$())

GOTO EXITSELECT
PtrXMENU:'      CASE "XMENU"
CALL DMXMENU(VAL(POPARG$),VAL(POPARG$),VAL(POPARG$),VAL(POPARG$), POPARG$, item$())

GOTO EXITSELECT
PtrEDITCOMMENT:'        CASE "EDITCOMMENT"
CALL EditComment(Poparg$)

GOTO EXITSELECT
PtrGETCOMMENT:' CASE "GETCOMMENT"
CALL GetComment(Poparg$)


GOTO EXITSELECT
PtrCOMMON:'     CASE "COMMON"

  v$ = Poparg$
  Value$  = Poparg$
  Fi%=FREEFILE
  OPEN CommonVarFile$ FOR RANDOM SHARED AS #Fi% LEN=LEN(CommonVar)
	' check to see if the var is in the commonvar file
	Flag% = 0
	FOR r% = 1 TO LOF(Fi%)\LEN(CommonVar)
		GET Fi%, r%, CommonVar

	IF ucase$(LEFT$(CommonVar.Variable,LEN(v$))) = ucase$(v$) THEN
	  CommonVar.Variable = v$
	  CommonVar.Value    = value$
	  CommonVar.CrLf     = CrLf$
	PUT #Fi%, r%, CommonVar:Flag%=1:EXIT FOR
	END IF
	NEXT r%

  IF Flag% = 0 THEN
	  CommonVar.Variable = v$
	  CommonVar.Value    = value$
	  CommonVar.CrLf     = CrLf$
  PUT #Fi%, (LOF(Fi%)\LEN(CommonVar))+1,CommonVar
  END IF
  Flag% = 0:CLOSE #Fi%


GOTO EXITSELECT
PtrSETPROMPT:'  CASE "SETPROMPT"
	PROMPT$=POPARG$

GOTO EXITSELECT
PtrECHO:'       CASE "ECHO"
echo% = NOT VAL(POPARG$)

GOTO EXITSELECT
PtrTIMEOUT:'    CASE "TIMEOUT"
IF ArgPtr%>0 THEN
UserTime# = (VAL(Poparg$) * 60) + TIMER
ELSE
PUSHARG STR$(INT((UserTime# - TIMER) / 60))
END IF

GOTO EXITSELECT
PtrLOGOUT:'     CASE "LOGOUT"
	ERROR 1
GOTO EXITSELECT
PtrRESET:'      CASE "RESET"
CALL SYSRESET

GOTO EXITSELECT
PtrGOD:'        CASE "GOD"
        GOD = VAL(POPARG$)
GOTO EXITSELECT
PtrEFFECT:'     CASE "EFFECT"
	EFFECT POPARG$

GOTO EXITSELECT
PtrTTY:'        CASE "TTY"
tty = 1
GOTO EXITSELECT
PtrANSI:'       CASE "ANSI"
tty = 0

GOTO EXITSELECT
PtrGLOBAL:'     CASE "GLOBAL"
	i%=VAL(POPARG$)
        IF ArgPtr% THEN A$=POPARG$:GLOBAL$(i%)=A$ ELSE PUSHARG GLOBAL$(i%)

GOTO EXITSELECT
PtrDOOR:'       CASE "DOOR"
	COMCLOSE
        SHELL POPARG$ + POPARG$ + POPARG$ + POPARG$ + POPARG$ + POPARG$
        COMOPEN PARM$

GOTO EXITSELECT
PtrGO:' CASE "GO"
        A$=LITERAL$(ArgPtr%)
        PROZOL GETVAR("$$"+A$+"$$")
GOTO EXITSELECT
PtrCD:' "CHDIR"        CASE "CD","CHDIR"
	CHDIR POPARG$
GOTO EXITSELECT
PtrMD:' "MKDIR"        CASE "MD","MKDIR"
	MKDIR POPARG$
GOTO EXITSELECT
PtrRD:' CASE "RD"
	A$=POPARG$
        IF LEN(DIR$(A$,16)) THEN KILL A$
GOTO EXITSELECT
PtrHOME:'       CASE "HOME"
        PROZOPRINT "^0@CLS()"

GOTO EXITSELECT
PtrTAG:'        CASE "TAG"
fi$ = PopArg$: R??? = VAL(PopArg$)
LET TagBuffer = FREEFILE
IF INSTR(Fi$,".")=0 THEN Fi$=Fi$+".TAG"
OPEN  fi$ FOR RANDOM AS #TagBuffer LEN = 4
IF LOF(TagBuffer) > 3 THEN
        PUT #TagBuffer, (LOF(TagBuffer) \ 4) + 1, R???
ELSE
        PUT #TagBuffer, 1, R???
END IF
CLOSE #TagBuffer

GOTO EXITSELECT
PtrTAGGED:'     CASE "TAGGED"
Fi$=POPARG$
IF INSTR(Fi$,".")=0 THEN Fi$=Fi$+".TAG"
TagBuffer=FREEFILE
OPEN Fi$ FOR RANDOM AS #TagBuffer LEN=4
IF LOF(1)=0 THEN PUSHARG "0" ELSE PUSHARG STR$(LOF(1)/4)
CLOSE #TagBuffer

GOTO EXITSELECT
PtrGETTAG:'     CASE "GETTAG"
Fi$=POPARG$
IF INSTR(Fi$,".")=0 THEN Fi$=Fi$+".TAG"
R???=VAL(POPARG$)
TagBuffer=FREEFILE
OPEN Fi$ FOR RANDOM AS #TagBuffer LEN=4
GET #TagBuffer,R???,T???
CLOSE #TagBuffer
PUSHARG STR$(T???)

GOTO EXITSELECT
PtrXMODEM:'     CASE "XMODEM"
IF UCASE$(LITERAL$(ArgPtr%))="IN" THEN
	X$=POPARG$:X$=POPARG$
        XMODEMIN X$,e%
        IF e% THEN PROZOPRINT "Transfer successful"+CrLf$ ELSE PROZOPRINT "Transfer unsuccessful"+CrLf$
ELSE
IF UCASE$(LITERAL$(ArgPtr%))="OUT" THEN
	X$=POPARG$:X$=POPARG$
        XMODEMOUT X$,e%
        IF e% THEN PROZOPRINT "Transfer successful"+CrLf$ ELSE PROZOPRINT "Transfer unsuccessful"+CrLf$
END IF
END IF
GOTO EXITSELECT
PtrCONFERENCE:' CASE "CONFERENCE"
	CALL CONF(POPARG$,POPARG$)
GOTO EXITSELECT
PtrINT:'        CASE "INT"
	REG VAL(POPARG$), VAL(POPARG$)
GOTO EXITSELECT
PtrREG:'        CASE "REG"
	PUSHARG STR$(REG(VAL(POPARG$)))
GOTO EXITSELECT
PtrRESTART:'    CASE "RESTART"
RUN
GOTO EXITSELECT
PtrTRON:'       CASE "TRON"
	Tracer%=-1
GOTO EXITSELECT
PtrTROFF:'      CASE "TROFF"
	Tracer%=0

GOTO EXITSELECT
PtrRANDOM:'     CASE "RANDOM"
GOTO EXITSELECT
PtrEXECUTE:'    CASE "EXECUTE"
	EXECUTE POPARG$
GOTO EXITSELECT
PtrUNLOCK:'     CASE "UNLOCK"
CLOSE #22

GOTO EXITSELECT
PtrLOCK:'       CASE "LOCK"
CLOSE #22
OPEN PopArg$ FOR OUTPUT AS #22:PRINT #22, TIME$, DATE$
' we open the file for output and write to it, then leave it open
' so any other user attempting lock the same file gets a big fat error

GOTO EXITSELECT
PtrCHAT:'       CASE "CHAT"
CALL CHAT(PopArg$)

GOTO EXITSELECT
PtrOLM:'        CASE "OLM"
A$=POPARG$:B$=POPARG$
        IF A$="-1" THEN OLM%=-1:GOTO EXITSELECT
        IF A$="0" THEN OLM%=0:GOTO EXITSELECT

        Fi%=FREEFILE
        OPEN OLMPath$+a$+".OLM" FOR APPEND AS #Fi%
        PRINT #Fi%,"FROM "+Global$(1)+":"+b$
        CLOSE #Fi%

GOTO EXITSELECT
PtrONLOGOUT:'   CASE "ONLOGOUT"
	LET ONLOGOUT$ = PopArg$
	OnLogout% = %True

GOTO EXITSELECT
PtrONERROR:'    CASE "ONERROR"

IF UCASE$(LITERAL$(ArgPtr%)) ="OFF" THEN
       ONError$=""
       OnError% = 0
       X$=POPARG$
ELSE
       ONError$ = PopArg$
       OnError% = %True
END IF

GOTO EXITSELECT
PtrANSWER:'     CASE "ANSWER"
Commandline$=UCASE$(PopArg$)
IF INSTR("COM1: COM2: COM3: COM4:",CommandLine$) THEN AnswerFlag%=-1 ELSE ERROR 57

GOTO EXITSELECT
PtrCONFIG:'     CASE "CONFIG"
CLOSE
OPEN"PROZOL.CFG" FOR BINARY AS #1:CLOSE
KILL"PROZOL.CFG"
RUN

GOTO EXITSELECT
PtrCONNECT:'    CASE "CONNECT"
CLOSE #6:OPEN PopArg$ FOR RANDOM AS #6:TerminalMode%=-1

GOTO EXITSELECT
PtrDISCONNECT:' CASE "DISCONNECT"
CLOSE #6:TerminalMode%=0

GOTO EXITSELECT
PtrSEND:'       CASE "SEND"
Prg$=PopArg$+Poparg$+Poparg$+Poparg$+Poparg$
IF LEN(Prg$) THEN REPLACE";" WITH CHR$(13) IN Prg$
IF TerminalMode% THEN PRINT #6,Prg$;

GOTO EXITSELECT
PtrMENUCOLOR:'  CASE "MENUCOLOR"
GLOBAL$(4)=POPARG$

GOTO EXITSELECT
PtrEXTENSION:'  CASE "EXTENSION"
	EXT$=POPARG$
        IF LEFT$(EXT$,1)<>"." THEN EXT$="."+EXT$
