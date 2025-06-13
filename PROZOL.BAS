'$DEBUG PBDEBUG ON
$INCLUDE "METAS.BAS"       ' compiler configuration options
$INCLUDE "CONSTANTS.BAS"   ' conditional compilation options
DEFINT A-Z                 ' all vars are signed short integers
$INCLUDE "DECLARES.BAS"    ' all sub/function declarations for externals
OPTION BINARY BASE 1       ' all files start at byte 1
$INCLUDE "TYPES.BAS"       ' type structures for dBASE/XModem and E-Mail
$INCLUDE "DIMS.BAS"        ' all global dimensions
$INCLUDE "SHARED.BAS"      ' all global variables
$INCLUDE "FIXUP.INC"       ' create jump table for keywords
COMPILEDATE$ = "rv 02.01.94"
' PROZO$ is displayed when the user connects

PRXVER$="PRZ0098" ' revision stamp for compiled programs
PROZO$= "^0@CLS()^B^c@DUP(@CHR(8),10)MSP:PROZOL Microframe Operating System v.98"+CHR$(13,10)+_
 "Copyright (C) 1994  Mermaid Software Products  All Rights Reserved"+CHR$(13,10,13,10)
ErrorMsg%=%True
$IF %MONOWATCH
ON TIMER(5) GOSUB MONOCOPY
TIMER ON
$ENDIF

$IF %KILLF10
ON KEY(10) GOSUB F10PRESSED
KEY(10) ON
$ENDIF

 BT.Update.Always% = -1 ' for Vest BTree indexing

' set ports
def seg=&h40
poke 0,&hf8  '03F8  sets com1 address irq 4
poke 1,&h03
poke 2,&hf8  '02F8  sets com2 address irq 3
poke 3,&h02
poke 4,&he8  '03E8  sets com3 address irq 4
poke 5,&h03
poke 6,&he8  '02E8  sets com4 address irq 3
poke 7,&h02

$IF NOT %NOTASKS
 TaskDepth%=4           ' default "depth" for background processing calls
$ENDIF
CALL DVGETVERSION	'Initialize Desqview API  (see also WINAPI.BAS)
IF ISFALSE INSTR(UCASE$(COMMAND$),"/E") THEN
        ' for debugging, this command line switch will supress the ON ERROR
        ' error checking of PowerBASIC.  Any error will crash with a pgm-ctr
        ' number, which helps us find any bugs (shame) in the source code.
        ON ERROR GOTO 10000
	ELSE
        ON KEY(10) GOSUB 10000
        KEY(10) ON
END IF
' The commandline switch /IRQ=nn will allow us to override the default IRQ
' for the com port.  This will allow many more COM ports to be used on a
' single machine running Desqview or something similar
IF INSTR(UCASE$(COMMAND$),"/IRQ=") THEN
IRQ$=MID$(COMMAND$,INSTR(UCASE$(COMMAND$),"/IRQ=")+5,1)
END IF

' The commandline switch /PORT=nn allows us to override the default port
' address, allowing us to simulate COM5+
IF INSTR(UCASE$(COMMAND$),"/PORT=") THEN
' must be 4 digit hex number
PORTADDR$=MID$(COMMAND$,INSTR(UCASE$(COMMAND$),"/PORT=")+6,4)
END IF

IF INSTR(UCASE$(COMMAND$),"/DIRECT=") THEN
' indicates direct connect and baud rate
DIRECT$=MID$(COMMAND$,INSTR(UCASE$(COMMAND$),"/DIRECT=")+8)+" "
DIRECT$=LEFT$(DIRECT$,INSTR(DIRECT$," ")-1)
DIRECT$=REMOVE$(DIRECT$,",")
END IF

CrLf$=CHR$(13,10) ' used for all carriage returns


IIFState%=%TRUE
IfState%=%True                   ' used for block CASE..END CASE
COMMANDLINE$ = UCASE$(COMMAND$)  '
LET UserTime# = 360000           ' amount of time user may be logged in
CLS:LOCATE ,,1                   ' make cursor visible
PROZOPRINT PROZO$                  ' copyright
PROZOPRINT CompileDate$+CrLf$     ' compile date fyi
AnswerThePhone:                  ' we come here from the ANSWER command
IF Comline THEN RESETMODEM       ' hang up if connected
PROZOPRINT CrLf$                  '

' ______________ CONFIGURATION VARIABLES _____________________
CLOSE
$INCLUDE "CONFIG.BAS" ' ......................Load config file

IF LEFT$(COMMANDLINE$, 1) = "-" THEN GOTO COMPILER '..........COMPILER MODE

IF LEFT$(COMMANDLINE$, 3) = "COM" THEN '........................ANSWER MODE
   PARM$ = LEFT$(COMMANDLINE$, 5)+BAUD$+"," + Proto$
   IF IRQ$<>""THEN PARM$=PARM$+",IR"+IRQ$
   Port% = VAL(MID$(PARM$, 4, 1)):
   IF PORTADDR$<>"" THEN '.......................POKE nonstandard port addr.
	DEF SEG = &H40
	poke (Port%-1)*2,val("&H"+right$(PORTADDR$,2))
	poke (Port%-1)*2+1,val("&H"+left$(PORTADDR$,2))
        Padd% = peeki (Port%-1)*2
	DEF SEG
   ELSE
   	DEF SEG = &H40
        padd% = peeki (port%-1)*2
   	DEF SEG
   END IF
   Node$ = "PORT" + STR$(Port%): GOTO HOST
END IF



DO:DUMMY$=POPARG$:LOOP WHILE ArgPtr%   ' clear argument stack
IF LEN(COMMANDLINE$) THEN              ' if PROZOL command is on command line
        PROZOL COMMANDLINE$             ' then execute it
END IF
DO:DUMMY$=POPARG$:LOOP WHILE ArgPtr%   ' clear argument stack
GOTO PROGINPUT 			       ' do not answer the phone


HOST:

WAITINGFORRING:
IF LEN(DIRECT$) THEN
	REPLACE BAUD$ WITH DIRECT$ IN PARM$
        Comline=1:e=0:Carrier%=1
        BAUD$=DIRECT$
        BAUD=VAL(DIRECT$)
        COMOPEN PARM$
ELSE
$INCLUDE "ANSWER.BAS"   ' set up the modem and wait for caller
END IF
' a call has come in at this point
SOUND 2000,2:SOUND 500,.5:DELAY .1:SOUND 500,.5
PROZOCLS
PROZOPRINT PROZO$ ' display copyright
PROZOPRINT "][ CORE " + ENVIRON$("HOSTNODE")+"  "+ Node$ + "  BPS:" + STR$(Baud) + CrLf$
PROGDELAY 2
PROZOL OnAnswer$ ' execute PROZOL command specified in config at ON ANSWER

$SEGMENT '===================================================================
' this main loop controls the execution of all PROZOL programs
' and the immediate mode interpreter command line
PROGINPUT:

  IF TerminalMode% THEN
	IF LOC(6) THEN DM INPUT$(LOC(6),6)
  END IF

IF Prog% THEN               'single-step parent program if currently running

stp:

  IF Progline% = 1000 THEN Prog% = 0: Ifstate%=%True:GOTO PROGINPUT  ' stop if run-off end
  IF RTRIM$(PROGRAM$(Progline%)) = "" THEN INCR Progline%: GOTO stp
  Prog$ = PROGRAM$(Progline%)             ' load line to process into Prog$
  IF Progline%=1 then
   	if len(Program$(0)) then prx%=%True else prx%=%False
  END IF

END IF
IF Prog% = 0 THEN  ' if no parent is running then display system prompt
Prx%=%False
PROZOPRINT PROMPT$

VALUE$=PROZOINPUT$

        IF VAL(Value$) THEN
	A = VAL(Value$): b = INSTR(Value$, " "): IF b = 0 OR A > 1000 THEN DM "ILLEGAL PROGRAM LINE" + CrLf$ + CHR$(7): GOTO PROGINPUT
        LET PROGRAM$(A) = MID$(Value$, b + 1)
	IF A>MaxLine% THEN MaxLine% = A
 	GOTO PROGINPUT
	END IF

Prog$ = Value$
END IF
ChaffLoop:
'*************************************************************************
IF IfState% THEN

IF Prx%=%False THEN PREP Prog$'........ PREPROCESS THE STATEMENT?
RepeatLabel:
RepeatFlag%=0 '................... set to true if statement is to be repeated
ExitFlag%=0 '............... set to true if statement is aborted by condition
ArgPtr%=0
IIfState%=%True
'EProg$=Prog$
$IF NOT %NOTASKS
CALL TASKMAN
$ENDIF
EXEC Prog$ '.......................... EXECUTE THE PROGRAM LINE !!!!!!!!!!!!!
	IF RepeatFlag% GOTO RepeatLabel

		ELSE

IF UCASE$(ltrim$(rtrim$(Prog$)))="ELSE"or prog$=symelse$ then IfState%=%True
IF UCASE$(ltrim$(rtrim$(Prog$)))="ENDCASE" or prog$=symendcase$ THEN IfState%=%True

		END IF

'*************************************************************************
BackFromError:
		IF AnswerFlag% THEN AnswerFlag%=0:GOTO ANSWERTHEPHONE

IF Prog% THEN INCR Progline% else IfState%=%True:IfPointer%=0:StackPointer%=0
GOTO PROGINPUT

$INCLUDE "ERROR.BAS"     ' error handler

DATA "UNK"
$INCLUDE "ERRORMSG.BAS"  ' data statements containing error messages

'' Subroutines begin here ==============================================
$IF NOT %NOTASKS
$INCLUDE "TASKMAN.BAS"  ' Task manager for background routines
$ENDIF
$INCLUDE "ANSIPRIN.BAS" ' ansi printing
$INCLUDE "CALC.BAS"     ' arithmetic calculator routine (RCD)
$INCLUDE "PREP.BAS"     ' Interpreted code pre-processor subroutine
$INCLUDE "CUSTOM.BAS"   ' SUBs and FUNCTIONs for custom commands
$INCLUDE "PROZO_IO.BAS"  ' General input output procedures
$INCLUDE "EXEC.BAS"     ' execute a prepared line of code
$INCLUDE "RIP.BAS"
$SEGMENT
$INCLUDE "DATABASE.BAS" ' database procedures
$INCLUDE "BTREE.BAS"    ' database index btree for <=64K records
$INCLUDE "COMSUBS.BAS"  ' all communications i/o subroutines
$INCLUDE "GETVAR$.BAS"  ' return the value of a PROZOL variable
$INCLUDE "VSET.BAS"     ' set the value of PROZOL variables
$SEGMENT
$INCLUDE "TRANSLAT.BAS" ' merge PROZOL variables with text
$INCLUDE "FUNCTION.BAS" ' process functions in text
$INCLUDE "SYMBOLS.BAS"  ' process terminal emulation codes in text
$INCLUDE "REPRINT.BAS"  ' print without moving cursor
$INCLUDE "WAITSTAT.BAS" ' if key is in buffer
$INCLUDE "CWAIT.BAS"    ' wait until key is pressed
$INCLUDE "PROGDELA.BAS" ' timed delay loop for all delays (may add tasks)
$INCLUDE "TIMEOUT.BAS"  ' what happens on user kb timeout
$INCLUDE "GETCOMME.BAS" ' get and display mail if any
$INCLUDE "PUTCOMME.BAS" ' write mail comment to disk
$INCLUDE "RESETMOD.BAS" ' reset the modem

$INCLUDE "EFFECT.BAS"   ' sound effects
$INCLUDE "EXIST.BAS"    ' old format of file exist function
$INCLUDE "XMODEMIN.BAS" ' rec xmodem file
$INCLUDE "XMODEMOU.BAS" ' send xmodem file
$INCLUDE "SYSRESET.BAS" ' reset system/re-run
$INCLUDE "GETACKNA.BAS" ' for xmodem
$INCLUDE "GETXCHAR.BAS" ' for xmodem
$INCLUDE "PUSHPOP.BAS"  ' stacks
$INCLUDE "COMPILER.BAS" ' compiler procedure

$LINK "STRINGA.OBJ"     ' CRC routines for xmodem
$LINK "DVCALLS.OBJ"     ' optimizing routines for DV

$SEGMENT
$INCLUDE "CONF.BAS"     ' conference subroutines
$INCLUDE "OLM.BAS"      ' "on line messages" live multiuser messages
$INCLUDE "CHAT.BAS"     ' live 6-way multi-user chat
$INCLUDE "DMMENU.BAS"   ' ansi box
$INCLUDE "DMWINDO.BAS"  ' ansi menu
$INCLUDE "DMXMENU.BAS"  ' better ansi menu

$INCLUDE "GETGO.BAS"    ' hot run other programs from menus/input
$INCLUDE "OBASE.BAS"    ' database index routines for databases > 64K recs
$INCLUDE "EDIT.BAS"     ' full screen field input routines
$INCLUDE "AUTOEDIT.BAS" ' name and address cleanup routines
$INCLUDE "QUIKSORT.BAS" ' c.a.r.hoare's quiksort implementation
$INCLUDE "DIREXIST.BAS" ' function to tell if a dir exists
$SEGMENT
$INCLUDE "PCBTYPE.BAS"  ' display a pcboard file listing
$INCLUDE "EDLIN.BAS"    ' an EDLIN clone for editing.
$INCLUDE "EDITCOMM.BAS" ' edit mail and post

SUB PROZOL (X$)
	PREP X$
        EXEC X$
END SUB

FUNCTION PRO$
IF Ext$<>"" THEN PRO$=Ext$ ELSE IF Tty THEN PRO$=".TTY" ELSE PRO$=".PRO"
END FUNCTION

MONOCOPY:
DEF SEG = &HB800
ASDFASDF$=PEEK$(0,4000)
DEF SEG = &HB000
POKE$ 0,ASDFASDF$
DEF SEG
RETURN

F10PRESSED:
END

' PowerBASIC Units
$LINK "RINSTR.PBU" ' Necessary for Reverse-Instr (do this inline later)
'$LINK "BASIC.PBU" ' BASIC compatible interpreter (to be added later)
'$LINK "ANSIPRIN.PBU" ' ANSI driver
'$LINK "EXTMATHB.PBU" ' Extended math
'$LINK "EVAL.PBU"     ' replacement for CALC
$LINK "ELIZA.PBU"
