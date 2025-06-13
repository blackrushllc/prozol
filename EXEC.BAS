SUB EXEC (BYVAL Prg$)
shared AnswerFlag%, CommonVarFile$, Commandline$, OLMPath$

RPRG$=PRG$

DO UNTIL RPRG$=""
RINSTR RPrg$," ",Split% ' find last parser
IF Split%=0 THEN
	PRG$=RPRG$
        RPRG$=""
ELSE
	PRG$=MID$(RPRG$,Split%+1) ' get last item
	Rprg$=LEFT$(RPRG$,Split%-1) ' remove last item
END IF

IF IIfState% THEN
IF Tracer% THEN PROZOPRINT "{"+Prg$+"}"
'SELECT CASE Prg$
if left$(Prg$,1)=chr$(2) then
	i=val(mid$(Prg$,2))
else
	i=0
end if
x??=fixup(i).offset
!       mov	ax,x??
!	push	ax
!	retn
        $INCLUDE "VIDEO_IO.CMD"  ' Print, Input, TAB, CR, etc.
        $INCLUDE "VARIABLE.CMD"  ' LET, SET, etc.
        $INCLUDE "LOGIC.CMD"     ' IF, WHILE, UNTIL, etc.
        $INCLUDE "FUNCTION.CMD"  ' functions (ucase, lcase, chr, etc)
        $INCLUDE "FLOW.CMD"      ' GOTO, GOSUB, other flow control commands
        $INCLUDE "FILE.CMD"      ' file i/o commands and functions
        $INCLUDE "CALC.CMD"      ' CALC, arithmetic processing commands.
        $INCLUDE "CUSTOM.CMD"    ' custom commands and functions
	$INCLUDE "DATABASE.CMD"  ' database interface commands and functions
        $INCLUDE "OBASE.CMD"     ' fixed length index file functions
        $INCLUDE "INDEX.CMD"     ' high performance index file functions
        $INCLUDE "LOADRUN.CMD"   ' Run, Load, Quit, List, etc.
        $INCLUDE "RIP.CMD"	 ' RIPScript commands
PtrNotKey:

                IF VERIFY(Prg$," 0123456789()<>?+-*/&=")=0 THEN
                        INCR ArgPtr%
                        ARG$(ArgPtr%)=Prg$
                	'PUSHARG Prg$
                ELSE
                        INCR ArgPtr%
                        ARG$(ArgPtr%)=GETVAR$(PRG$)
                        'PUSHARG GETVAR$(PRG$)
                LITERAL$(ArgPtr%)=Prg$ '....... save the literal name
	        '.......We may need to remember the name of the var for later
                END IF
EXITSELECT:
ELSE ' if IifState% is false
IF UCASE$(Prg$)="ELSE" or Prg$=SymElse$ THEN IIfState%=%True
IF UCASE$(Prg$)="ENDIF" or Prg$=SymEndIf$ THEN IIfState%=%True
END IF

LOOP ' This LOOP is for the new method

END SUB


SUB PUSHARG(BYVAL X$)
	INCR ArgPtr%
	ARG$(ArgPtr%)=X$
END SUB

FUNCTION POPARG$
	IF ArgPtr%>0 THEN
	P$=ARG$(ArgPtr%)
	DECR ArgPtr%
Concate:
	IF ArgPtr%>0 AND ARG$(ArgPtr%)="&" THEN
        	DECR ArgPtr%
	        P$=P$+Arg$(ArgPtr%)
                IF ArgPtr%>0 THEN DECR ArgPtr%
        	GOTO Concate
        END IF
'AndOr:
'	IF ArgPtr%>0 AND ARG$(ArgPtr%)="&&" THEN
'        	DECR ArgPtr%
'                P$=STR$(ISTRUE(VAL(P$)) AND ISTRUE(VAL(Arg$(ArgPtr%))) )
'		IF ArgPtr%>0 THEN DECR ArgPtr%
'        	GOTO AndOr:
'        END IF

'	IF ArgPtr%>0 AND ARG$(ArgPtr%)="||" THEN
'        	DECR ArgPtr%
'                P$=STR$(ISTRUE(VAL(P$)) OR ISTRUE(VAL(Arg$(ArgPtr%))))
'		IF ArgPtr%>0 THEN DECR ArgPtr%
'                GOTO AndOr:
'        END IF

	END IF
        IF LEFT$(P$,1)=CHR$(2) THEN
        	PROZOL P$
        ELSE
	        POPARG$=P$
	END IF
END FUNCTION


SUB PUSHON (which%,P$)
	incr genpointer%(which%)
        if genpointer%(which%)>32 then error 105
        genstack$(which%,genpointer%(which%)) = P$
END SUB

FUNCTION POPOFF$ (which%)
	popoff$=genstack$(which%,genpointer%(which%))
        if genpointer%(which%)>0 then decr genpointer(which%)
END FUNCTION

