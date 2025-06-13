'function commands
GOTO EXITSELECT
PtrLOOKUP:'                   CASE "LOOKUP"
                fi$ = poparg$
                srch$ = poparg$
                Result$ = fi$ + "?"
                Fr% = FREEFILE
                OPEN fi$ FOR INPUT SHARED AS #Fr%
                DO
                        LINE INPUT #Fr%, fi$
                        IF UCASE$(srch$)=LEFT$(UCASE$(fi$),LEN(srch$)) THEN Result$ = fi$: EXIT DO
                LOOP WHILE NOT EOF(Fr%)
                CLOSE #Fr%
                PUSHARG Result$

GOTO EXITSELECT
PtrUSING:'      CASE "USING"
                PUSHARG USING$(poparg$,VAL(poparg$))

GOTO EXITSELECT
PtrFIX:'        ' fix the length of output making it larger or smaller                CASE "FIX"     ' fix the length of output making it larger or smaller
                pusharg LEFT$(poparg$+SPACE$(255), VAL(poparg$))

GOTO EXITSELECT
PtrPARM:'       CASE "PARM"
                Pusharg Parm$

GOTO EXITSELECT
PtrPORT:'       CASE "PORT"
                pusharg MID$(STR$(Port%),2)

GOTO EXITSELECT
PtrCRC:'        CASE "CRC"
                CALL CRC16(Arg$, hi%, Lo%)
                pusharg CHR$(Hi%,Lo%)

GOTO EXITSELECT
PtrDUP:'        CASE "DUP"
                b$=poparg$
                a = val(poparg$)
                pusharg STRING$(a, b$)

GOTO EXITSELECT
PtrBAUD:'       CASE "BAUD"
                pusharg BAUD$

GOTO EXITSELECT
PtrSUBDIR:'     CASE "SUBDIR"
        	a$=poparg$
                pusharg str$(direxist%(a$))
GOTO EXITSELECT
PtrDIR:'        CASE "DIR"
        	a$=poparg$
                if a$="" then pusharg dir$ else pusharg dir$(a$)

GOTO EXITSELECT
PtrBOTH:'       CASE "BOTH"
                IF VAL(POPARG$) AND VAL(POPARG$) THEN PUSHARG "-1" ELSE PUSHARG "0"
GOTO EXITSELECT
PtrEITHER:'     CASE "EITHER"
                IF VAL(POPARG$) OR VAL(POPARG$) THEN PUSHARG "-1" ELSE PUSHARG "0"
GOTO EXITSELECT
PtrNEITHER:'    CASE "NEITHER"
                IF VAL(POPARG$) OR VAL(POPARG$) THEN PUSHARG "0" ELSE PUSHARG "-1"

GOTO EXITSELECT
PtrSIZEOF:'     CASE "SIZEOF"
                F=FREEFILE
                OPEN POPARG$ FOR BINARY AS #F
                PUSHARG STR$(LOF(F))
                CLOSE #F
GOTO EXITSELECT
PtrENVIRON:'    CASE "ENVIRON"
                PUSHARG ENVIRON$(POPARG$)

GOTO EXITSELECT
PtrFREEFILE:'   CASE "FREEFILE"
        	PUSHARG STR$(FREEFILE)

GOTO EXITSELECT
PtrFILE:'       CASE "FILE"
        	Buf%=FREEFILE
                P$=POPARG$
                IF DIR$(P$)<>"" THEN
                 OPEN P$ FOR BINARY AS #Buf%
                 GET$ #Buf%, LOF(Buf%), A$
                 PUSHARG A$
		 CLOSE #Buf%
                END IF
GOTO EXITSELECT
PtrUCASE:'      "UPPER"                CASE "UCASE","UPPER"
        	PUSHARG UCASE$(POPARG$)
GOTO EXITSELECT
PtrLCASE:'      "LOWER"                CASE "LCASE","LOWER"
        	PUSHARG LCASE$(POPARG$)
GOTO EXITSELECT
PtrLTRIM:'      CASE "LTRIM"
        	PUSHARG LTRIM$(POPARG$)
GOTO EXITSELECT
PtrRTRIM:'      CASE "RTRIM"
        	PUSHARG RTRIM$(POPARG$)
GOTO EXITSELECT
PtrLEFT:'       CASE "LEFT"
        	PUSHARG LEFT$(POPARG$,VAL(POPARG$))
GOTO EXITSELECT
PtrRIGHT:'      CASE "RIGHT"
        	PUSHARG RIGHT$(POPARG$,VAL(POPARG$))
GOTO EXITSELECT
PtrMID:'        "SUBSTR"                CASE "MID","SUBSTR"
        	A$=POPARG$
                A1%=VAL(POPARG$)
                A2%=VAL(POPARG$)
                IF A2%=0 THEN
                	PUSHARG MID$(A$,A1%)
                ELSE
                	PUSHARG MID$(A$,A1%,A2%)
                END IF
GOTO EXITSELECT
PtrASC:'        "ASCII"                CASE "ASC","ASCII"
        	PUSHARG STR$(ASCII(POPARG$))
GOTO EXITSELECT
PtrCHR:'        CASE "CHR"
        	PUSHARG CHR$(VAL(POPARG$))
GOTO EXITSELECT
PtrINKEY:'      CASE "INKEY"
                PUSHARG PROZOINKEY$
GOTO EXITSELECT
PtrLEN:'        CASE "LEN"
        	PUSHARG STR$(LEN(POPARG$))
GOTO EXITSELECT
PtrEQUALS:'     "SAME"                CASE "EQUALS","SAME"
        	IF POPARG$=POPARG$ THEN PUSHARG "-1" ELSE PUSHARG "0"
GOTO EXITSELECT
PtrNOT:'        CASE "NOT"
        	PUSHARG STR$(NOT ISTRUE VAL(POPARG$))
GOTO EXITSELECT
PtrFALSE:'       "OFF", "NO"                CASE "FALSE", "OFF", "NO"
        	PUSHARG "0"

GOTO EXITSELECT
PtrTRUE:'        "ON", "YES"                CASE "TRUE", "ON", "YES"
        	PUSHARG "-1"

GOTO EXITSELECT
PtrCWAIT:'      CASE "CWAIT"
        	DO
                a$=PROZOINKEY$
                LOOP WHILE A$=""
                PUSHARG A$
GOTO EXITSELECT
PtrEXIST:'      CASE "EXIST"
                IF LEN(DIR$(POPARG$)) THEN PUSHARG "-1" ELSE PUSHARG "0"

GOTO EXITSELECT
PtrROW:'        CASE "ROW"
                PUSHARG STR$(PROZOCSRLIN)
GOTO EXITSELECT
PtrCOL:'        CASE "COL"
                PUSHARG STR$(PROZOPOS)
GOTO EXITSELECT
PtrINSTR:'      CASE "INSTR"
        	PUSHARG STR$( INSTR(POPARG$, POPARG$) )

GOTO EXITSELECT
PtrTIME:'       CASE "TIME"
        	PUSHARG TIME$
GOTO EXITSELECT
PtrDATE:'       CASE "DATE"
        	PUSHARG DATE$

GOTO EXITSELECT
PtrVAL:'        CASE "VAL"
        	PUSHARG STR$(VAL(POPARG$))
GOTO EXITSELECT
PtrABS:'        CASE "ABS"
        	PUSHARG STR$(ABS(VAL(POPARG$)))

GOTO EXITSELECT
PtrAND:'        CASE "AND"
        	PUSHARG "&&"
GOTO EXITSELECT
PtrOR:' CASE "OR"
        	PUSHARG "||"

GOTO EXITSELECT
PtrNEG:'        "MINUS"                CASE "NEG","MINUS"
        	PUSHARG STR$(VAL(POPARG$)*-1)

