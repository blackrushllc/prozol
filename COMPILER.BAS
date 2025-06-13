COMPILER:
prozoprint crlf$+crlf$+"^0^BThe PROZOL Compiler"+CrLf$+CrLf$
c$=ltrim$(rtrim$(mid$(commandline$,2)))
if instr(commandline$," ")=0 then goto huh
ex$=left$(c$,instr(c$," ")-1)
' PROZOL -PRX file(s)
c$=mid$(c$,instr(c$," ")+1)
getfilespec:
if instr(c$," ") then
	f$=left$(c$,instr(c$," ")-1):c$=mid$(c$,instr(c$," ")+1)
else
	f$=c$:c$=""
end if
a$=dir$(f$)
if a$="" then prozoprint chr$(7)+f$+" - not found!" + CrLf$
do until a$=""
	' clear memory
	NextVar%=1
	ERASE VAR$()
	ERASE VALUE$()
	Fi%=FREEFILE
	OPEN A$ FOR INPUT AS #Fi%
        PROZOPRINT A$ + " - "
	x%=UBOUND(PROGRAM$)
	REDIM PROGRAM$(x%)
	LINE INPUT #Fi%,P$
        IF LEFT$(P$,3)="PRZ" THEN
                ' it's a compiled program
        	PROZOPRINT P$+" This program is already compiled."+CrLf$+CHR$(7)
                close #fi%
		a$=dir$
                iterate do
	END IF
	PROGRAM$(1)=P$
	MaxLine%=2
	DO UNTIL EOF(Fi%)
        	LINE INPUT #Fi%, PROGRAM$(MaxLine%)
                IF RIGHT$(PROGRAM$(MaxLine%),1)="_" THEN
                	DO UNTIL EOF(Fi%) OR RIGHT$(PROGRAM$(MaxLine%),1)<>"_"
                        	LINE INPUT #Fi%,Aa$
                                PROGRAM$(MaxLine%)=PROGRAM$(MaxLine%)+Aa$
                        LOOP
                END IF
                IF INSTR(PROGRAM$(MaxLine%),"{") THEN
                	DO UNTIL EOF(Fi%) OR INSTR(PROGRAM$(MaxLine%),"}")
                        	LINE INPUT #Fi%,Aa$
                        	PROGRAM$(MaxLine%)=PROGRAM$(MaxLine%)+CHR$(13,10)+Aa$
                        LOOP
		END IF
		INCR MaxLine%
        LOOP
        CLOSE #Fi%
        IF instr(a$,".")=0 then
        	a$=a$+"."+ex$
	else
        	a$=left$(a$,instr(a$,"."))+ex$
	end if

        prxsavearray a$,program$()
        prozoprint a$ + CrLf$
        a$=dir$
loop

if c$="" then end
goto getfilespec

huh:

prozoprint CrLf$+CrLf$+"^0^BCompiler syntax:   PROZOL -ext filespec [filespec...]"+Crlf$+Crlf$
prozoprint "Where 'ext' is the extension you want to give your compiled programs, and"+CrLf$
prozoprint "the filespec is any file name, wild card specification, or list of files"+CrLf$
prozoprint "separated by spaces.^0"+CrLf$
end