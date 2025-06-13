SUB PRXLOADARRAY(Fi$,P$())
        MaxLine%=0
        FF=FREEFILE
	OPEN Fi$ FOR INPUT AS #FF
        LINE INPUT #ff, P$(0) ' version
        input #ff, N% ' number of variables
        FOR y=1 to N%
        	INPUT #ff, A$,B$
                REPLACE CHR$(254) WITH " " IN B$
                VSET2 A$,B$
        NEXT y
        DO until eof(ff)
        	incr MaxLine%
                line input #FF, p$(MaxLine%)
        loop
        close #ff
END SUB

SUB PRXSAVEARRAY(Fi$,P$())
	' All variables defined at this point are incorporated into the
        ' compiled program.  This can be very dangerous if done at the
        ' wrong time (like when lots of variables are in memory)
        Fi$=UCASE$(Fi$)
        IF INSTR(Fi$,".LIB") or INSTR(Fi$,".SUB") or INSTR(Fi$,".PLB") THEN Subbing=%True
        ' Setting Subbing to %True causes string constants to be set with
        ' a higher ascii value, so they won't be overwritten by ordinary
        ' pre-processing of string constants.  Only one procedure file
        ' is allowed at a time.

        PROZOPRINT "["+Fi$+"]"
        PREPARRAY P$()
	FF=FREEFILE
        OPEN Fi$ FOR OUTPUT AS #FF
        PRINT #FF, P$(0) ' version
        PRINT #FF, NextVar% ' number of variables defined
        FOR i = 1 to NextVar%
                V$=VALUE$(i)
                'REPLACE " " WITH CHR$(254) IN V$
        	Write #FF,VAR$(i),V$
	NEXT i
        ' program starts here
        i=0
        DO
            INCR i
            IF P$(i)="" THEN EXIT LOOP
            PRINT #FF, P$(i)
	LOOP
        CLOSE #FF
END SUB

SUB PREPARRAY (P$())
	' This routine preps an entire array and leaves variables in
        ' memory (which can be extracted for prep-save format)
        Prepping% = %True
	VarTableX%=176:VarTableZ%=176
        dim temp$(ubound(p$))  ' storage for compiled array
	dim l$(256):dim l(256) ' storage for labels and line numbers
' PASS 1
        for y=1 to ubound(p$)  ' preprocess each line
	        p$=p$(y)
                prep p$
                if len(p$) then
                        incr x
                           if right$(p$,4)="PROC" then
                                decr x
                                p$=left$(p$,len(p$)-5) 'take off the "proc"
                                if instr(p$," ") then ' there's something to it
                                   rinstr p$," ",s
                                   v$=mid$(p$,s+1)
                                   p$=left$(p$,s-1)
                                   vset2 v$,p$
                                end if
                           	iterate for
                           end if

                        if left$(p$,1)<>chr$(2) then
                           ' it's a label or procedure
                           incr l
                             if instr(p$," ") then
                                l$(l)=left$(p$,instr(p$," ")-1)
                                p$=mid$(p$,instr(p$," ")+1)
                                l(l)=x
                                temp$(x)=ltrim$(rtrim$(p$))
                             else
	                           l$(l)=p$
                                   l(l)=x
                                   decr x
                             end if
                        else
                        	reprint str$(x)
                        	temp$(x)=p$
                        end if
		end if
	next y
' now replace all label references with a literal line number

' PASS 2
	for y=1 to ubound(p$)
            if len(temp$(y)) then
                for x=1 to l
                	replace l$(x) with ltrim$(str$(l(x))) in temp$(y)
                next x
	    end if
            p$(y)=temp$(y)
        next y
	Prepping%=%False:Subbing=%False
        p$(0)=PrxVer$
END SUB

SUB PREP (Prg$)
IF LEFT$(Prg$,1)=CHR$(2) THEN EXIT SUB 'already prepped
' Remove all REMARKS
if instr(prg$,any "/*'" + chr$(34)) then
DO
a%=INSTR(PRG$,"/*")
IF a% THEN
        VALUE$=MID$(PRG$, a%)
        b%=INSTR(2,VALUE$, "*/")
        IF b% THEN VALUE$=LEFT$(VALUE$,b%+1)
        PRG$=REMOVE$(PRG$,VALUE$)
END IF
LOOP WHILE a%

' Remove all quoted strings and make temporary variables out of them.
if not Prepping% then VarTableX%=176:VarTableZ%=176
if subbing then VarTableZ%=219
DO
a%=INSTR(PRG$,CHR$(34))
IF a% THEN
        VALUE$=MID$(PRG$, a%)
        b%=INSTR(2,VALUE$, CHR$(34))
        IF b% THEN VALUE$=LEFT$(VALUE$,b%)
        REPLACE VALUE$ WITH " "+CHR$(1,VarTableZ%,VarTableX%)+" " IN PRG$
        ARRAY SCAN VAR$(1), COLLATE UCASE, =CHR$(1,VarTableZ%,VarTableX%), TO i%
        IF i% THEN
        	VALUE$(i%)=REMOVE$(VALUE$,CHR$(34))
	ELSE
        	INCR NextVar%
                VALUE$(NextVar%)=REMOVE$(VALUE$,CHR$(34))
                VAR$(NextVar%)=CHR$(1,VarTableZ%,VarTableX%)
        END IF
ELSE
	EXIT LOOP
END IF
INCR VarTableX%:IF VarTableX%=254 THEN VarTableX%=176:INCR VarTableZ%
LOOP

' Remove any strings quoted with ' character that are not inside ""

DO
a%=INSTR(PRG$,CHR$(39))
IF a% THEN
        VALUE$=MID$(PRG$, a%)
        b%=INSTR(2,VALUE$,CHR$(39))
        IF b% THEN VALUE$=LEFT$(VALUE$,b%)
        REPLACE VALUE$ WITH " "+CHR$(1,VarTableZ%,VarTableX%)+" " IN PRG$
        ARRAY SCAN VAR$(1), COLLATE UCASE, =CHR$(1,VarTableZ%,VarTableX%), TO i%
        IF i% THEN
        	VALUE$(i%)=REMOVE$(VALUE$,CHR$(39))
	ELSE
        	INCR NextVar%
                VALUE$(NextVar%)=REMOVE$(VALUE$,CHR$(39))
                VAR$(NextVar%)=CHR$(1,VarTableZ%,VarTableX%)
        END IF
ELSE
	EXIT LOOP
END IF
INCR VarTableX%:IF VarTableX%=254 THEN VarTableX%=176:INCR VarTableZ%
LOOP
end if ' if quote or rem chars are in prg$


' Secondly, we have to deal with the harsh realities of NUMERIC EXPRESSIONS.
' We could certainly work that into EXEC as well, using a technique called
' RECURSIVE DESCENT PARSING, but that, too would start making things a bit
' hideous.
' Being able to handle an line like ...
'  					PRINT B*20/C+(INT(D/100))
' ... where a statement is followed by an expression which includes
' literal numbers and variables and functions (like INT) would require a
' much more complex parsing algorithm than we are introducing here.
' Another way to deal with expressions is to force any arithmetic to
' be performed in special arithmetic functions, like ...
'
'	PRINT ADD(DIV(MUL(B,20),C),INT(DIV(D,100))
'
' with the stack-parsing technique we are using for language processing
' this type of expression would be much much much easier to implement, BUT
' it starts to make our language seem pretty silly, so what we are going to
' do is this:  By pushing arithmetic symbols onto the argument stack along
' with the rest of the arguments, a variable-free, statement-free expression
' can be built whenever the stack is popped clean by the CALC function.
' in other words, the above expression would wind up looking like this:
'
' 	PRINT CALC B*20/C+(INT(CALC D/100))
'
' ... which I would consider more of a fair compromise, and for the burden
' of forcing you to use the CALC command before every arithmetic expression
' you can still use natural arithmetic without having to make your language
' look like FrameWork Fred. (ick!)  To accomplish this, we have to make
' sure that arithmetic symbols get parsed and pushed as individuals.  In
' order for that to happen, we must ensure that they are separated by a
' parsing character, such as a SPACE.

if instr(prg$,any "+-*/<>()=&_?") then
REPLACE "+" WITH " + " IN PRG$
REPLACE "-" WITH " - " IN PRG$
REPLACE "*" WITH " * " IN PRG$
'REPLACE "\" WITH " \ " IN PRG$
REPLACE "/" WITH " / " IN PRG$
'REPLACE "^" WITH " ^ " IN PRG$
REPLACE "<" WITH " < " IN PRG$
REPLACE ">" WITH " > " IN PRG$
REPLACE "(" WITH " ( " IN PRG$
REPLACE ")" WITH " ) " IN PRG$
REPLACE "=" WITH " = " IN PRG$
REPLACE "&" WITH " & " IN PRG$
REPLACE "?" WITH "" IN PRG$
REPLACE "_"+CHR$(13,10) WITH " " IN PRG$
end if

' Now, finally, we will be dealing in a free-form program structure where
' the single string being processed here may contain carriage returns and
' line feeds.  In the case of multiple lines, we don't want the whole
' module executed in REV (which is what stack-parsing does) so we will
' remove all carriage returns and line feeds, and we'll be flipping the
' lines, so the last lines come first and the first come last.  To fully
' understand why we are doing this, you must fully understand stack-parsing.
' In stack parsing, we push every item in a single statement onto a stack,
' processing it as it goes, from last to first.  If you have a line which
' read like this:
'
'               print      mid$      (A$,     Y%,      1)
'               ^^^^^      ^^^^      ^^^^     ^^^      ^^
'		STATEMENT  FUNCTION  VARIABLE VARIABLE ARGUMENT
' ... the stack-parser start out by pushing the argument 1 as a literal
' number.  Then it would evaluate Y% and push it's value as a literal
' number.  Then it would evaluate A$ and push it's contents as a literal
' string.  Then it would get to the function MID$.  It would POP the three
' arguments in order to see what it needs to MID$ with, and then push the
' result as a literal string.  Finally, PRINT would see that one single
' item on the stack (the result of MID$) and print it.  For more information
' about stack parsing, go back 20 lines and read this again until you get it.

IF INSTR(PRG$,ANY CHR$(13,58,123,125)) THEN
        ' remove all line feeds (PBWrite and other text editors produce them)
        ' Add a closing carriage return, just in case, and then REV
        ' the order of every line of text.
	PRG$=REV$(REMOVE$(PRG$,ANY CHR$(10)+"{}"))
        ' and remove blank lines
END IF

REPLACE ANY ",;" WITH "  " IN PRG$ ' make all parsers into spaces
REPLACE "_ " with " " in prg$
DO
REPLACE "  " WITH " " IN PRG$   ' elimate double spaces
LOOP UNTIL INSTR(PRG$,"  ")=0

PRG$=" " + UCASE$(PRG$)+" "
' replace all keywords with tokens
x=1
DO UNTIL Fixup(x).offset=0 or instr(prg$,any "BCDFGHKLMNPRSTVWX")=0
fk$=rtrim$(fixup(x).keyword)+" "
if instr(prg$,fk$) then
	n$=chr$(32,2)+ltrim$(str$(x))+" "
	replace fk$ with n$ in Prg$
	if instr(Prg$,fk$) then replace fk$ with n$ in Prg$
' We had to do that a second time incase of two back to back same keywords
end if
incr x
LOOP
PRG$=LTRIM$(RTRIM$(PRG$))
END SUB

FUNCTION REV$(byval X$)
IF X$="" THEN EXIT FUNCTION
IF INSTR(X$,ANY CHR$(13,58)) = 0 THEN
	REV$=X$
        EXIT FUNCTION
ELSE
	Y$=LEFT$(X$,INSTR(X$,ANY CHR$(13,58))-1)
        Z$=MID$(X$,INSTR(X$,ANY CHR$(13,58))+1)
        REV$=REV$(Z$)+" " + Y$
END IF

END FUNCTION
