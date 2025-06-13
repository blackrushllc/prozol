$IF NOT %NODBASE
SHARED DBH, DBF, DBS(), dBaseOpen%, RecNum???, NumberOfFields?, RecordBlock$
SHARED NumberOfRecords???, Index$, IndexField$, IndexField?
SHARED Bt.Update.Always%, Act.Keys$
PUBLIC Act.Keys$, BT.Update.Always%

SHARED Bt.Update.Always%,Act.Keys$,Bt.File.Num%
SHARED Keys$(),Ptr$(),Stk&(),Itm$(),Dta$()
$ENDIF

SHARED DBE()

SHARED Row%, Col%, Cur% 	' Store original cursor position and state
PUBLIC ProgLine%, Prog%         ' Current line number and running status
SHARED MaxLine%			' How many lines in the program
PUBLIC CrLf$                    ' Contains carriage return character
SHARED ARG$(), ArgPtr%          ' Argument stack for parsing statements
SHARED VAR$(), VALUE$()         ' Storage arrays for variables
PUBLIC Literal$(), NextVar%     ' Literal variable name and Next free var #
PUBLIC PROGRAM$(), ORG$         ' Source code array and saved screen image
SHARED Token$,TokenType#,P#,Arg$  ' Used by the CALC function.
SHARED GosubStack%(), GosubPtr% ' Used for GOSUB..RETURN
SHARED ExitFlag%                ' Used by IF and other logic commands
SHARED RepeatFlag%              ' Used by WHILE and UNTIL

PUBLIC CommonVar
PUBLIC Rec, Code, Comment, CommentIndex ',CFG
PUBLIC Global$()
PUBLIC item$(), C$()
'PUBLIC CallStack%()
'PUBLIC IfStack%()
PUBLIC Erro$
PUBLIC formula$
PUBLIC GP
PUBLIC CharType%, CharCode%, Comline, NextVar%
PUBLIC CrLf$, COMMAND%, Pntr???, UserTime#, Num, PARM$,IXLen%,IXFI$
PUBLIC v, Prompt$, Chaff$, GOD, Port%, Node$, tty, NumberOfFields, dBUFFER
PUBLIC SeqBuffer, CAPSLOCK, BUF, FLEN, Found, more
PUBLIC OldValue$, Typing%, Stepval
PUBLIC upperval, fvar$, subbing, subline%, forpointer%
PUBLIC repeat, loopline%, repeatline, ChatFile%, User%, User$
PUBLIC OLM%, OnLogout%, OnLogout$, StackPointer%, OnError%, OnError$
SHARED csc?, LastPrompt$, IfPointer%, IfState%, Baud$
SHARED VidSave$,Vidx%,Vidy%,VidFlag%,VideoRAM&
PUBLIC PROTO$,Ee,TerminalMode%
'PUBLIC Query$(),QueryMax%
SHARED ForPointer%
SHARED CONFDIR$
PUBLIC Echo%, IIfState%
SHARED Tracer%
SHARED Allness%,MapFlag%,RestFlag%
SHARED IxPtr&()
$IF NOT %NOTASKS
PUBLIC Task() , TaskProg$(), Taskline(), TaskDepth%, CurrentDepth%
$ENDIF
PUBLIC BUFFY%
PUBLIC Ext$
PUBLIC ErrorMsg%
SHARED Prepping%,VarTableX%,VarTableZ%,Prx%,PrxVer$
PUBLIC GoFlag%
SHARED GenStack$(), GenPointer%()
SHARED Carrier%,Padd%,DIRECT$
