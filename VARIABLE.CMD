'variable commands

GOTO EXITSELECT
PtrLET:'        CASE "LET", "SET"
                v%=ArgPtr%
                V$=LITERAL$(ArgPtr%)
		DUMMY$=POPARG$
                VALUE$=POPARG$
                'IF Value$="[" THEN
                ' AS%=VAL(POPARG$)
                ' DUMMY$=POPARG$ ' closing "]"
  		'V$=V$+LTRIM$(STR$(AS%))
                'VALUE$=POPARG$
                CALL VSET2(LITERAL$(v%),VALUE$)

GOTO EXITSELECT
PtrCLEAR:'      CASE "CLEAR"
                IF ArgPtr%=0 THEN
                	NextVar%=1
                        ERASE VAR$()
                        ERASE VALUE$()
                ELSE
                        IF LITERAL$(1)="ANY" THEN
                        	VCLEARALL LITERAL$(2)
                        ELSE
                	VCLEAR LITERAL$(1)
                        END IF
                END IF
