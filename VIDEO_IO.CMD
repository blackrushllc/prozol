'video_io commands
GOTO EXITSELECT
PtrCLS :'       CASE "CLS"
        PROZOCLS

GOTO EXITSELECT
PtrCOLOR:'      CASE "COLOR"
        PROZOCOLOR VAL(POPARG$), VAL(POPARG$)

GOTO EXITSELECT
PtrLOCATE:'     CASE "LOCATE"
        PROZOLOCATE VAL(POPARG$), VAL(POPARG$)

GOTO EXITSELECT
PtrTAB:'        CASE "TAB"
        PUSHARG CHR$(9)

GOTO EXITSELECT
PtrCR:' CASE "CR"
        PUSHARG CRLF$

GOTO EXITSELECT
PtrPROMPT:'     CASE "PROMPT"
        DO:PROZOPRINT POPARG$:LOOP WHILE ArgPtr%>0

GOTO EXITSELECT
PtrPRINT:'      CASE "PRINT"
        DO:PROZOPRINT POPARG$:LOOP WHILE ArgPtr%>0
        PROZOPRINT CrLf$

GOTO EXITSELECT
PtrINPUT:'      CASE "INPUT"
        A%=ArgPtr%
        IF ArgPtr%>1 THEN FOR y%=A% TO 2 STEP -1:PROZOPRINT POPARG$:NEXT y%
        VAR$=LITERAL$(ArgPtr%)
                IF UCASE$(VAR$)="FIELDS" THEN
                	VarEditFields e%
                ELSE
                VALUE$=PROZOINPUT$
                VSET2 VAR$,VALUE$
                END IF
'TYPE DBaseEditFormat
'        FieldName AS STRING * 11
'        FieldType AS STRING * 1
'        FieldLength AS BYTE
'        FieldRow AS INTEGER
'        FieldCol AS INTEGER
'        FieldFG AS INTEGER
'        FieldBG AS INTEGER
'END TYPE

GOTO EXITSELECT
PtrFIELD:'      CASE "FIELD"
IF ArgPtr%=0 THEN
	ERASE DBE()
ELSE
	'field number, "VARNAME","N",length, Row, Col, [Foreground, Background]
	Fld%=VAL(POPARG$)
        DBE(Fld%).FieldName = POPARG$
        DBE(Fld%).FieldType = POPARG$
        DBE(Fld%).FieldLength = VAL(POPARG$)
        DBE(Fld%).FieldRow = VAL(POPARG$)
        DBE(Fld%).FieldCol = VAL(POPARG$)
        DBE(Fld%).FieldFG = VAL(POPARG$)
        DBE(Fld%).FieldBG = VAL(POPARG$)
        IF DBE(Fld%).FieldFG=0 AND DBE(Fld%).FieldBG=0 THEN DBE(Fld%).FieldBG=7
END IF
