' if database is open then scan for variable name in field list and replace
' database field content.  If variable name does not match a field name then
' replace or create a memory variable.

SUB VSET2 (byval VAR$, byval Value$)
        VAR$=LTRIM$(RTRIM$(UCASE$(VAR$),ANY CHR$(32,0)),ANY CHR$(32,0))
        'VALUE$=LTRIM$(RTRIM$(VALUE$))
        IF INSTR(VAR$,".") THEN
          N=INSTR(VAR$,".")
          VM$=LEFT$(VAR$,N-1)
          VS$=MID$(VAR$,N+1)+"$"+VM$
	  ARRAY SCAN VAR$(1),COLLATE UCASE, =VS$, TO i%
		IF i% THEN
        	 O%=CVI(LEFT$(VALUE$(i%),2))
                 L%=CVI(RIGHT$(VALUE$(i%),2))
                 ARRAY SCAN VAR$(1),COLLATE UCASE,=VM$, TO i%
                 IF i% THEN

                  IF LEN(VALUE$)>L% THEN
                   VALUE$=LEFT$(VALUE$,L%)
                  ELSE
                   VALUE$=VALUE$+SPACE$(L%-LEN(VALUE$))
                  END IF

                  MID$(VALUE$(i%),O%,L%)=VALUE$
                 ELSE
                  ERROR 013
                 END IF
                ELSE
                 ERROR 103
		END IF
        EXIT SUB
        END IF



                IF LEN(VAR$) THEN
                	' Scan for name in database field
			V%=%TRUE
$IF NOT %NODBASE
			IF dBASEOpen% THEN
				For i%=1 TO NumberOfFields?
                                  IF RTRIM$(DBS(i%).FieldName,ANY CHR$(0,32))=VAR$ THEN
	                              IF DBS(i%).FieldType="N" THEN
	                	        DBPutNField (DBS(i%).FieldName),VAL(VALUE$),e%
		 	              ELSE
		                        DBPutCField (DBS(i%).FieldName),VALUE$,e%
                		      END IF
                        	  v%=%FALSE
	                          EXIT FOR
        	        	END IF
		                NEXT i%
			END IF
$ENDIF
			IF v% THEN
	                      	ARRAY SCAN VAR$(1),COLLATE UCASE, =VAR$, TO i%
	                        IF i% THEN
	                        	VALUE$(i%)=VALUE$
	                        ELSE
	                        	INCR NextVar%
	                                VALUE$(NextVar%)=VALUE$
	                                VAR$(NextVar%)=VAR$
	                        END IF
	                END IF
        	END IF
END SUB


' Clear the content of a memory variable
SUB VCLEAR (byval VAR$)
                IF LEN(VAR$) THEN
                      	ARRAY SCAN VAR$(1),COLLATE UCASE, =VAR$, TO i%
                        IF i% THEN
                                ARRAY DELETE VAR$(i%)
                                ARRAY DELETE VALUE$(i%)
                        	DECR NextVar%
                        END IF
                END IF
END SUB

SUB VCLEARALL (byval VAR$)
                IF LEN(VAR$) THEN
                        DO
                      	ARRAY SCAN VAR$(1),FROM 1 TO LEN(VAR$), COLLATE UCASE, =VAR$, TO i%
                        IF i% THEN
                                ARRAY DELETE VAR$(i%)
                                ARRAY DELETE VALUE$(i%)
                        	DECR NextVar%
                        END IF
                        LOOP WHILE i%
                END IF
END SUB

