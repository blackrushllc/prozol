'loadrun commands
GOTO EXITSELECT
PtrPREP:'      CASE "PREP"
	' prep sourcefile, destination

GOTO EXITSELECT
PtrXSAVE:    ' XSAVE
	PRXSAVEARRAY POPARG$,Program$()

GOTO EXITSELECT
PtrXLOAD:    ' XLOAD
	PRXLOADARRAY POPARG$,Program$()

GOTO EXITSELECT
PtrPRUN: '	case "PRUN"
	Pload%=%True

PtrRUN:'                    CASE "RUN"
		F$=POPARG$
		IF LEN(F$) THEN
                        IF INSTR(F$,".")=0 THEN F$=F$+PRO$
			Fi$=DIR$(F$)
                        IF Fi$="" THEN
                        	REPLACE PRO$ WITH ".TTY" IN F$
                        	Fi$=DIR$(F$)
			END IF
                        IF Fi$="" THEN
                        	REPLACE ".TTY" WITH ".BBS" IN F$
                        	Fi$=DIR$(F$)
			END IF
                        IF Fi$="" THEN
                        	REPLACE ".BBS" WITH ".PRO" IN F$
                        	Fi$=DIR$(F$)
			END IF
                        IF Fi$="" THEN
                        	REPLACE ".BBS" WITH ".PRX" IN F$
                        	Fi$=DIR$(F$)
			END IF

			IF Fi$="" THEN
                                PROZOPRINT "File Not Found."+CrLf$
                                Prog%=0
			ELSE
				Fi%=FREEFILE
				OPEN F$ FOR INPUT AS #Fi%
				x%=UBOUND(PROGRAM$)
				REDIM PROGRAM$(x%)
                                LINE INPUT #Fi%,P$
                                IF LEFT$(P$,3)="PRZ" THEN
                                	' it's a compiled program
                                        IF P$<>PRXVER$ THEN
                                        	PROZOPRINT P$+" Wrong version for tokenized program"+CrLf$+CHR$(7)
                                                Prog%=0
                                                GOTO EXITSELECT
					END IF
                                        CLOSE #Fi%
                                        PRXLOADARRAY F$,PROGRAM$()
                                        ProgLine%=0
                                        Prog%=1
                                        GOTO EXITSELECT
				END IF
                                PROGRAM$(1)=P$
				MaxLine%=2
				DO UNTIL EOF(Fi%)
                                 LINE INPUT #Fi%, PROGRAM$(MaxLine%)
                                 IF RIGHT$(PROGRAM$(MaxLine%),1)="_" THEN
                                 	DO UNTIL EOF(Fi%) OR RIGHT$(PROGRAM$(MaxLine%),1)<>"_"
                                        	LINE INPUT #Fi%,A$
                                 		PROGRAM$(MaxLine%)=PROGRAM$(MaxLine%)+A$
                                        LOOP
                                  END IF
                                 IF INSTR(PROGRAM$(MaxLine%),"{") THEN
                                 	DO UNTIL EOF(Fi%) OR INSTR(PROGRAM$(MaxLine%),"}")
                                        	LINE INPUT #Fi%,A$
                                 		PROGRAM$(MaxLine%)=PROGRAM$(MaxLine%)+CHR$(13,10)+A$
                                        LOOP
				  END IF
				 INCR MaxLine%

				LOOP
				Prog%=1
				ProgLine%=0
			END IF
		ELSE
			Prog%=1
			ProgLine%=0
		END IF
		GLOBAL$(3)=F$
                CLOSE #Fi
	IF Pload% THEN
        	Pload%=FALSE
		PREPARRAY Program$()
	END IF

GOTO EXITSELECT
PtrPLOAD:'	CASE "PLOAD"
	pload%=%true
PtrLOAD:'       CASE "LOAD"
		F$=POPARG$
		IF LEN(F$) THEN
                        IF INSTR(F$,".")=0 THEN F$=F$+PRO$
			Fi$=DIR$(F$)
                        IF Fi$="" THEN
                        	REPLACE PRO$ WITH ".TTY" IN F$
                        	Fi$=DIR$(F$)
			END IF
                        IF Fi$="" THEN
                        	REPLACE ".TTY" WITH ".BBS" IN F$
                        	Fi$=DIR$(F$)
			END IF
                        IF Fi$="" THEN
                        	REPLACE ".BBS" WITH ".PRO" IN F$
                        	Fi$=DIR$(F$)
			END IF

			IF Fi$="" THEN
                                PROZOPRINT "File Not Found." +CrLf$
			ELSE
				Fi%=FREEFILE
				OPEN F$ FOR INPUT AS #Fi%
				x%=UBOUND(PROGRAM$)
				REDIM PROGRAM$(x%)
                                LINE INPUT #Fi%,P$
                                IF LEFT$(P$,3)="PRZ" THEN
                                	' it's a compiled program
                                        IF P$<>PRXVER$ THEN
                                        	PROZOPRINT P$+" Wrong version for tokenized program"+CrLf$+CHR$(7)
                                                Prog%=0
                                                GOTO EXITSELECT
					END IF
                                        CLOSE #Fi%
                                        PRXLOADARRAY F$,PROGRAM$()
                                        ProgLine%=0
                                        Prog%=0
                                        GOTO EXITSELECT
				END IF
                                PROGRAM$(1)=P$
				MaxLine%=2
				DO UNTIL EOF(Fi%)
                                 LINE INPUT #Fi%, PROGRAM$(MaxLine%)
                                 IF RIGHT$(PROGRAM$(MaxLine%),1)="_" THEN
                                 	DO UNTIL EOF(Fi%) OR RIGHT$(PROGRAM$(MaxLine%),1)<>"_"
                                        	LINE INPUT #Fi%,A$
                                 		PROGRAM$(MaxLine%)=PROGRAM$(MaxLine%)+A$
                                        LOOP
                                  END IF

                                 IF INSTR(PROGRAM$(MaxLine%),"{") THEN
                                 	DO UNTIL EOF(Fi%) OR INSTR(PROGRAM$(MaxLine%),"}")
                                        	LINE INPUT #Fi%,A$
                                 		PROGRAM$(MaxLine%)=PROGRAM$(MaxLine%)+CHR$(13,10)+A$
                                        LOOP
                                  END IF
				 INCR MaxLine%
				LOOP

				Prog%=0
				ProgLine%=0
			END IF
		END IF
		GLOBAL$(3)=F$
		CLOSE Fi%
	IF Pload% THEN
        	Pload%=FALSE
		PREPARRAY Program$()
	END IF

GOTO EXITSELECT
PtrQUIT:'       CASE "QUIT"

        	ERROR 99

GOTO EXITSELECT
PtrLIST:'       CASE "LIST"
                for y=1 to ubound(program$)
                	if len(program$(y)) then maxline%=y
		next y
                a%=val(POPARG$)
                IF a%=0 then
                       	a%=1:b%=MaxLine%
                ELSE
                        b%=val(POPARG$)
                        IF b%=0 or b%<a% then b%=a%
                       	if b%>MaxLine% then b%=MaxLine%
		END IF

		For y%=a% TO b%
         IF LEN(PROGRAM$(y%)) THEN DM STR$(y%)+ " " +PROGRAM$(y%)+CrLf$ :_
          IF COMLINE THEN COMPRINT STR$(y%)+ " " +PROGRAM$(y%)+CrLf$
                IF PROZOINKEY$=CHR$(27) THEN EXIT FOR
                NEXT y%

GOTO EXITSELECT
PtrSAVE:'       CASE "SAVE"

                For y%=1 to 1000
                IF LEN(RTRIM$(PROGRAM$(y%))) THEN MaxLine%=y%
                NEXT y%

                a$=POPARG$
                IF INSTR(A$,".")=0 THEN a$=a$+PRO$
                Buf=FREEFILE
                OPEN a$ FOR OUTPUT AS #buf

		For y%=1 TO MaxLine%
		PRINT #Buf, PROGRAM$(y%)
                NEXT y%

                CLOSE #Buf
		GLOBAL$(3)=a$

GOTO EXITSELECT
PtrEND:'        CASE "END"
        	Prog%=0:Progline%=0:ExitFlag%=%TRUE
