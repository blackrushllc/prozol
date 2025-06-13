' This routine reads the config file
' This routine creates the config file if it does not exist

IF DIR$("PROZOL.CFG")="" THEN
        PROZOPRINT "^0@CHR(7)PROZOL.CFG not found.  You must create it now."+CrLf$
GetBaud:
        PROZOL "PRINT '1200 2400 4800 9600'"
        PROZOL "PROMPT 'Enter opening baud rate (default 2400) --> '"
        VALUE$=PROZOINPUT$
	BAUD$=VALUE$:IF BAUD$="" THEN BAUD$="2400"
	IF INSTR("1200 2400 4800 9600",BAUD$)=0 THEN GOTO GetBaud

        PROZOL "PROMPT 'Enter modem parameters (N,8,1,ME,FE,DT) --> '"
        VALUE$=PROZOINPUT$
	PROTO$=VALUE$:IF PROTO$="" THEN PROTO$="N,8,1,ME,FE,DT"

        PROZOL "PROMPT 'Chat file path\name (default is \CHAT.RAF) --> '"
        VALUE$=PROZOINPUT$
	CHATFILE$=VALUE$:IF CHATFILE$="" THEN CHATFILE$ = "\CHAT.RAF"

        PROZOL "PROMPT 'OLM Directory (i.e. F:\OLM\   default is root) --> '"
        VALUE$=PROZOINPUT$
	OLMPath$=Value$:IF OLMPath$="" THEN OLMPath$ = "\"
	IF RIGHT$(OLMPath$,1)<>"\" THEN OLMPath$=OLMPath$+"\"

        PROZOL "PROMPT 'CONFERENCE Directory (default is root) --> '"
        VALUE$=PROZOINPUT$
        CONFDIR$=VALUE$:IF CONFDIR$="" THEN CONFDIR$="\"
        IF RIGHT$(CONFDIR$,1)<>"\" THEN CONFDIR$=CONFDIR$+"\"

        PROZOL "PROMPT 'COMMON variable file (default is COMMON.VAR) --> '"
        VALUE$=PROZOINPUT$
	CommonVarFile$=VALUE$:IF CommonVarFile$="" THEN CommonVarFile$ = "COMMON.VAR"

        PROZOL "PROMPT 'MAIL Directory (default is root) --> '"
        VALUE$=PROZOINPUT$
	MailPath$=VALUE$:IF MailPath$="" THEN MailPath$ ="\"
	IF RIGHT$(MailPath$,1)<>"\" THEN MailPath$=MailPath$+"\"
GetPrompt:
        PROZOL "PRINT 'Default system prompt:'"
        PROZOL "PRINT '1) OK (like gwbasic)'"
        PROZOL "PRINT '2)^0^B^m{^rHOST^m}> ^0'"
        PROZOL "PRINT '3) Command:'"
        PROZOL "PRINT '4) C:\> (like dos)'"
        PROZOL "PRINT '5) No prompt - automatically log out user if prompt is displayed.'"
        PROZOL "PROMPT 'Select --> '"
        VALUE$=PROZOINPUT$
	Select Case VALUE$
	CASE "1"
	Prompt$ = "@CHR(13)@CHR(10)OK@CHR(13)@CHR(10)"
	CASE "2"
	Prompt$ = "^0^B^m^rHOST^m> ^w"
	CASE "3"
	Prompt$ = "@CHR(13)@CHR(10)Command:"
	CASE "4"
	Prompt$ = "@CHR(13)@CHR(10)@DOS()>"
	CASE "5"
	Prompt$ = "@LOGOUT()"
	End Select
	IF Prompt$="" THEN GOTO GetPrompt

        PROZOL "PROMPT 'Execute on CONNECT (END=cmd mode) (default=GO MAIN) --> '"
        VALUE$=PROZOINPUT$
	OnAnswer$ = Value$
	IF OnAnswer$="" THEN OnAnswer$="RUN 'MAIN'"


OPEN "PROZOL.CFG" FOR OUTPUT AS #1
PRINT #1, BAUD$
PRINT #1, PROTO$
PRINT #1, CHATFILE$
PRINT #1, OLMPath$
PRINT #1, CONFDIR$
PRINT #1, CommonVarFile$
PRINT #1, MailPath$
PRINT #1, Prompt$
PRINT #1, OnAnswer$
CLOSE #1

ELSE

OPEN "PROZOL.CFG" FOR INPUT AS #1
LINE INPUT #1, BAUD$
LINE INPUT #1, PROTO$
LINE INPUT #1, CHATFILE$
LINE INPUT #1, OLMPath$
LINE INPUT #1, CONFDIR$
LINE INPUT #1, CommonVarFile$
LINE INPUT #1, MailPath$
LINE INPUT #1, Prompt$
LINE INPUT #1, OnAnswer$
CLOSE #1

END IF
