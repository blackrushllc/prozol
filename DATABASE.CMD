'database commands
$IF NOT %NODBASE
GOTO EXITSELECT
PtrUSE:'        CASE "USE"
	F$=POPARG$
        IF F$="" THEN DBUSE "",e%:GOTO EXITSELECT
        IF INSTR(F$,".")=0 THEN F$=F$+".DBF"
        DBUSE F$,e%
        SELECT CASE e%
                CASE 1:PROZOPRINT "Database file not found"+CrLf$
                CASE 2:PROZOPRINT "Zero byte file"+CrLf$
                CASE 3:PROZOPRINT "File has no fields"+CrLf$
                CASE 4:PROZOPRINT "Not a dBASE database file"+CrLf$
        END SELECT
        IF Prog%=0 THEN
        PROZOPRINT STR$(Numberoffields?) + " fields in " + STR$(NumberOfRecords???)+ " records."+CrLf$
	END IF
$ENDIF
GOTO EXITSELECT
PtrMAPPED:'     CASE "MAPPED"
	MapFlag%=%True

GOTO EXITSELECT
PtrGET:'        ' GET MAPPED variable IN database RECORD n        CASE "GET" ' GET MAPPED variable IN database RECORD n
        ' mapped variable reads directly into the var array.  Very fast.
        IF MapFlag% THEN
        	MapFlag%=%False
                 ARRAY SCAN VAR$(1),COLLATE UCASE,=LITERAL$(ArgPtr%), TO i%
                 IF i% THEN
                  DUMMY$=POPARG$ ' replace with DECR ArgPtr%
                  Buf=VAL(POPARG$)
                  R&=VAL(POPARG$)
                  GET #Buf,R&,VALUE$(i%)
                 ELSE
                  DUMMY$=POPARG$:DUMMY$=POPARG$:DUMMY$=POPARG$
                  ERROR 103
                 END IF

        ELSE
$IF NOT %NODBASE
	R???=VAL(POPARG$)
        dBGetRecord R???,e%
        SELECT CASE e%
                CASE 0 ' success
                                CASE 1:PROZOPRINT "Database not open"+CrLf$
                CASE 2,3:PROZOPRINT "Invalid record number"+CrLf$
	END SELECT
$ENDIF
	END IF
GOTO EXITSELECT
PtrPUT:'        CASE "PUT"
        IF MapFlag% THEN
        	MapFlag%=%False
                  DAT$=POPARG$
                  Buf=VAL(POPARG$)
                  R&=VAL(POPARG$)
                  PUT #Buf,R&,DAT$
        ELSE
$IF NOT %NODBASE
	R???=VAL(POPARG$)
	DBPutRecord R???,e%
        SELECT CASE e%
                CASE 1:PROZOPRINT "Database not open"+CrLf$
                CASE 2:PROZOPRINT "Invalid Record Number"+CrLf$
	END SELECT
IF LEN(INDEX$) THEN
	BT Index$,"A", UCASE$(DBGetCField$(IndexField$,e%)),MKDWD$(RecNum???),"","",r%
        IF NOT r% THEN PROZOPRINT "Error updating index file"+CrLf$
END IF
$ENDIF
	END IF

$IF NOT %NODBASE
GOTO EXITSELECT
PtrCREATEFORMAT:'       CASE "CREATEFORMAT"
	IF Comline=0 AND dBASEOpen% THEN
	DBCreateFormat
        ELSE
        PROZOPRINT "Cannot create a format now."+CrLf$
        END IF

GOTO EXITSELECT
PtrCREATEINDEX:'        CASE "CREATEINDEX"
	I$=POPARG$:IF INSTR(I$,".")=0 THEN I$=I$+".BTX"
        F$=POPARG$:IF F$="" THEN F$=LEFT$(I$,INSTR(I$,".")-1)
        DBCreateIndex I$, F$, e%
        SELECT CASE e%
        CASE 1:PROZOPRINT "Database not open"
        CASE 2:PROZOPRINT "Invalid Field name"
        CASE 3:PROZOPRINT "Cannot create file"
        CASE 4:PROZOPRINT "Error reading database"
        CASE 5:PROZOPRINT CrLf$+"*ABORTED*"
        CASE 6:PROZOPRINT "Internal error"
        CASE 7:PROZOPRINT "Disk Write Error"
        END SELECT
        PROZOPRINT CrLf$
GOTO EXITSELECT
PtrFORMAT:'     CASE "FORMAT"
        ARG$=POPARG$
        IF ARG$="" THEN
        dBDefaultFormat
        ELSE
	dBSetFormatTo ARG$,e%
        IF e% THEN PROZOPRINT "Format file not found"+CrLf$
	END IF
GOTO EXITSELECT
PtrVIEW:'       CASE "VIEW"
	DBView

GOTO EXITSELECT
PtrEDIT:'       CASE "EDIT"
        e%=0
        R???=VAL(POPARG$)
        IF R???=0 THEN CALL dBEditFields (e%) ELSE dBEditRecord R???,e%
         IF e% THEN PROZOPRINT "Invalid Record Number"+CrLf$
GOTO EXITSELECT
PtrAPPEND:'     CASE "APPEND"
	dBAppendRecord e%
        IF e% THEN PROZOPRINT "APPEND error"+CrLf$

GOTO EXITSELECT
PtrDELIMITED:'  CASE "DELIMITED"
	PUSHARG DBGetASCII$

GOTO EXITSELECT
PtrINDEX:'      CASE "INDEX"
	I$=POPARG$
        IF I$="" THEN DBSetIndexTo "","",e%:GOTO EXITSELECT
        IF INSTR(I$,".")=0 THEN I$=I$+".BTX"
        F$=POPARG$:IF F$="" THEN F$=LEFT$(I$,INSTR(I$,".")-1)
        DBSetIndexTo I$, F$, e%
        	SELECT CASE e%
                        CASE 1:PROZOPRINT "Database not open"+CrLf$
                        CASE 2:PROZOPRINT "Invalid Field Name"+CrLf$
                        CASE 3:PROZOPRINT "Index file not found"+CrLf$
		END SELECT

GOTO EXITSELECT
PtrFIND:'       CASE "FIND"
	Findme$=POPARG$
        F$=FINDME$
        DBSearchIndex Findme$,e%
        IF e% THEN PROZOPRINT "FIND error"+CrLf$:GOTO EXITSELECT
        IF UCASE$(F$)<>UCASE$(LEFT$(FINDME$,LEN(F$))) THEN _
         PROZOPRINT "Not found"+CrLf$:Found=%False ELSE Found=%True
GOTO EXITSELECT
PtrNEXT:'       CASE "NEXT"
        DBSkip 1, E%
                IF e% THEN PROZOPRINT "Can't SKIP"+CrLf$:DBEND%=-1
GOTO EXITSELECT
PtrPREV:'       "PREVIOUS"        CASE "PREV","PREVIOUS"
        DBSkip -1, E%
                IF e% THEN PROZOPRINT "Can't SKIP"+CrLf$:DBEND%=-1
GOTO EXITSELECT
PtrSKIP:'       CASE "SKIP"
	R&=VAL(POPARG$):IF R&>32767 OR R&<-32767 THEN _
                PROZOPRINT "SKIP out of range"+CrLf$:GOTO EXITSELECT
	R%=R&
        DBSkip R%, E%
        IF e% THEN PROZOPRINT "Can't SKIP"+CrLf$
	DBEND%=e%
GOTO EXITSELECT
PtrTOP:'        "FIRST"        CASE "TOP","FIRST"
	DBGOTOTOP e%
        IF e%=1 THEN PROZOPRINT "Database error"+CrLf$
        IF e%=2 THEN PROZOPRINT "Index error"+CrLf$
GOTO EXITSELECT
PtrBOTTOM:'     "LAST"        CASE "BOTTOM","LAST"
	DBEND%=-1
	DBGOTOBOTTOM e%
        IF e%=1 THEN PROZOPRINT "Database error"+CrLf$
        IF e%=2 THEN PROZOPRINT "Index error"+CrLf$
GOTO EXITSELECT
PtrISOPEN:'     CASE "ISOPEN"
PUSHARG STR$(ISTRUE dBaseOpen%)
GOTO EXITSELECT
PtrRECNUM:'     "RECNO"        CASE "RECNUM","RECNO"
PUSHARG STR$(RecNum???)
GOTO EXITSELECT
PtrNUMFIELDS:'  CASE "NUMFIELDS"
PUSHARG STR$(NumberOfFields?)
GOTO EXITSELECT
PtrCOUNT:'      CASE "COUNT"
PUSHARG STR$(NumberOfRecords???)
GOTO EXITSELECT
PtrINDEXFILE:'  CASE "INDEXFILE"
PUSHARG INDEX$
GOTO EXITSELECT
PtrINDEXFIELD:' CASE "INDEXFIELD"
PUSHARG INDEXFIELD$
GOTO EXITSELECT
PtrDBEND:'      CASE "DBEND"
PUSHARG STR$(DBEND%)
$ENDIF
