' Scan for a variable name in the database field list.  If one is present
' then return the database field, otherwise scan for a memory variable.  If
' no memory variable is present then scan current code for a subroutine and
' execute it if found.  if nothing is found in the current code then scan
' the procedure array for a match.  If nothing is found there either then
' check the common variable file.

FUNCTION GetVar$ (BYVAL VariableName$)
GetVar$=""
IF INSTR(VARIABLENAME$,CHR$(0)) THEN VARIABLENAME$=LEFT$(VARIABLENAME$,INSTR(VARIABLENAME$,CHR$(0))-1)
VARIABLENAME$=UCASE$(LTRIM$(RTRIM$(VARIABLENAME$)))
V%=%TRUE
IF LEN(VARIABLENAME$) THEN
        IF INSTR(VARIABLENAME$,".") THEN
          N=INSTR(VARIABLENAME$,".")
          VM$=LEFT$(VARIABLENAME$,N-1)
          VS$=MID$(VARIABLENAME$,N+1)+"$"+VM$
	  ARRAY SCAN VAR$(1),COLLATE UCASE, =VS$, TO i%
		IF i% THEN
        	 O%=CVI(LEFT$(VALUE$(i%),2))
                 L%=CVI(RIGHT$(VALUE$(i%),2))
                 ARRAY SCAN VAR$(1),COLLATE UCASE,=VM$, TO i%
                 IF i% THEN
                  GETVAR$=RTRIM$(MID$(VALUE$(i%),O%,L%),CHR$(0))
                 ELSE
                  ERROR 103
                 END IF
                ELSE
                 ERROR 103
		END IF
        EXIT FUNCTION
        END IF
        IF v% THEN
$IF NOT %NODBASE
	IF dBASEOpen% THEN
		For i%=1 TO NumberOfFields?
                        IF RTRIM$(DBS(i%).FieldName,ANY CHR$(0,32))=VARIABLENAME$ THEN
	                  IF DBS(i%).FieldType="N" THEN
	                    GetVar$=STR$(DBGetNField!((DBS(i%).FieldName),e%))
		          ELSE
	                    GetVar$=rtrim$(DBGetCField$((DBS(i%).FieldName),e%))
                	  END IF
                          v%=%FALSE
                          EXIT FOR
                	END IF
                NEXT i%
	END IF
$ENDIF
        END IF

	IF v% THEN
	  ARRAY SCAN VAR$(1),COLLATE UCASE, =VARIABLENAME$, TO i%
		IF i% THEN
                 v%=%FALSE
        	 GetVar$=VALUE$(i%)
		END IF
	END IF

     '   IF V% THEN
     '           Fi%=FREEFILE
     '           OPEN COMMONVARFILE$ FOR RANDOM SHARED AS #Fi% LEN=LEN(CommonVar)
     '           FOR r% = 1 TO LOF(Fi%)\LEN(CommonVar)
     '                   GET Fi%, r%, CommonVar
     '                   IF ucase$(LEFT$(CommonVar.Variable,LEN(variablename$)+1))_
     '                = ucase$(variablename$)+"=" THEN_
     '                   GetVar$=rtrim$(ltrim$(CommonVar.Value)):v%=%False:EXIT FOR
     '          NEXT r%
     '   Close Fi%
     '   end if


END IF

END FUNCTION
