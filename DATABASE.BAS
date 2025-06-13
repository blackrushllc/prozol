$IF NOT %NODBASE
'=========================================================================
'         dBASE III Plus file interface subroutines begin here
'=========================================================================
SUB dBSetIndexTo(IX$,Fld$,e%)
e%=0
' Make sure a database is open
IF dBASEOpen%=0 THEN e%=1:EXIT SUB

' close existing index if it is open
IF IX$="" OR Index$<>"" THEN Index$="":_
   CALL BT("","Q","","","","",r%)
IF IX$="" THEN EXIT SUB
' verify filename exists
IF DIR$(IX$)="" THEN e%=3:EXIT SUB

' verify field exists in database
Fld%=0:Fld$=UCASE$(Fld$)
	FOR y%=1 TO NumberOfFields?
        	IF INSTR(DBS(y%).FieldName,Fld$)=1 THEN Fld%=y%:EXIT FOR
	NEXT y%
IF Fld%=0 THEN e%=2:EXIT SUB
Index$=IX$:IndexField$=Fld$:IndexField?=Fld%
END SUB

SUB dBCreateIndex(IX$, Fld$, e%)
REDIM K$(1000), D$(1000)
Bt.Update.Always%=0
' Make sure a database is open
IF dBASEOpen%=0 THEN e%=1:GOTO ExitSub

' close existing index if it is open
IF IX$="" OR Index$<>"" THEN Index$="":_
   CALL BT("","Q","","","","",r%)
IF IX$="" THEN EXIT SUB

' verify field exists in database
Fld%=0:Fld$=UCASE$(Fld$)
	FOR y%=1 TO NumberOfFields?
        	IF INSTR(DBS(y%).FieldName,Fld$)=1 THEN Fld%=y%:EXIT FOR
	NEXT y%
IF Fld%=0 THEN e%=2:GOTO EXITSUB
Index$=IX$:IndexField$=Fld$:IndexField?=Fld%

' Create the index and build it.
K$=SPACE$(DBS(Fld%).FieldLength):D$=CHR$(0,0,0,0)
CALL BT(Index$,"C",K$,D$,RK$,RD$,R%)
IF NOT R% THEN E%=3:GOTO EXITSUB ' could not create index
x%=CSRLIN:y%=POS(0)
For y???=1 TO NumberOfRecords???
	dBGetRecord Y???, e%
        IF e% THEN e%=4:EXIT FOR
        IF INSTAT OR COMCHARS% THEN A$=PROZOINKEY$:IF A$=CHR$(27) THEN e%=5:EXIT FOR

        ' ====================
        ' remove the UCASE$ here if you do not want the index to be
        ' create as case insensative.
        K$=UCASE$(dBGetCField$(Indexfield$, e%))
        '  ^^^^^^____________________________ ^

        IF e% THEN e%=6:EXIT FOR
        D$=MKDWD$(Y???)  ' must know the record number!
        INCR i%
        K$(i%)=K$:D$(i%)=D$
        IF i%=1000 THEN
        	FOR ii%=1 TO 1000
		CALL BT(Index$,"A",K$(ii%),D$(ii%),RK$,RD$,r%)
        	IF NOT r% THEN e%=7:EXIT FOR
                NEXT ii%
                i%=0
                IF e%=7 THEN EXIT FOR
	END IF
        IF TTY=0 THEN PROZOPRINT "@SCP()"+STR$(Y???)+"@RCP()" ELSE PROZOPRINT "."
        NEXT y???

        	FOR ii%=1 TO i%
		CALL BT(Index$,"A",K$(ii%),D$(ii%),RK$,RD$,r%)
        	IF NOT r% THEN e%=7:EXIT FOR
                NEXT ii%

	CALL BT(Index$,"Q","","","","",r%)
ExitSub:
BT.Update.Always%=-1
END SUB

SUB dBSearchIndex(Findme$,e%)
e%=0
IF dBaseOpen%=0 THEN e%=1:EXIT SUB
IF Index$="" THEN
        PROZOPRINT CrLf$+"Index not open, scan database? (Y/N): "
        YN$=PROZOINPUT$
	IF UCASE$(YN$)="Y" THEN
		' scan the whole database for a match
		FOR y???=1 TO NumberOfRecords???
        		dBGetRecord y???, e%
	                IF e% THEN EXIT FOR
	                IF INSTR(FindMe$,RecordBlock$) THEN EXIT FOR
		NEXT y???
        IF y???=>NumberOfRecords THEN _
                PROZOPRINT "Not Found.  Press a key..."
                CWAIT
                PROZOPRINT CrLf$
        END IF
ELSE
        Findme$=UCASE$(Findme$)
	CALL BT(Index$,"S", Findme$, D$, RK$, RD$, r%)
        'IF NOT r% THEN e%=2:EXIT SUB
        FindMe$=RK$
        R???=CVDWD(RD$)
        IF R???>0 THEN CALL dBGetRecord(R???,e%)
END IF
END SUB

SUB dBSkip(NS%, e%)
e%=0
IF LEN(INDEX$) THEN
        DO
	IF NS%<0 THEN BT Index$,"P","","",K$,D$,r%:INCR NS% ELSE _
                      BT Index$,"N","","",K$,D$,r%:DECR NS%
        IF NOT r% THEN e%=-1:EXIT SUB
        IF INSTAT THEN IF A$=CHR$(27) THEN NS%=0
        LOOP WHILE NS%<>0
        dBGetRecord CVDWD(D$), e%
ELSE
	RN???=RecNum??? + NS%
        IF RN??? < 1 THEN RN???=1:e%=-1
        IF RN??? > NumberOfRecords??? THEN RN???=NumberOfRecords???:e%=-1
        dBGetRecord RN???,e%
END IF
END SUB

SUB dBGotoTop (e%)
e%=0
IF LEN(INDEX$) THEN
	BT Index$,"F","","",K$,D$,r%
        IF NOT r% THEN e%=-2:EXIT SUB
        DBGetRecord CVDWD(D$),e%
ELSE
	DBGetRecord 1, e%
END IF
END SUB

SUB dBGotoBottom (e%)
e%=0
IF LEN(INDEX$) THEN
	BT Index$,"L","","",K$,D$,r%
        IF NOT r% THEN e%=-2:EXIT SUB
        DBGetRecord CVDWD(D$),e%
ELSE
	DBGetRecord NumberOfRecords???, e%
END IF
END SUB

SUB dBEditRecord (RN???, e%)
e%=0
	dBGetRecord RN???, e%
        IF e% THEN EXIT SUB

' remove entry from index
IF LEN(INDEX$) THEN
	BT Index$,"D",UCASE$(DBGetCField$(IndexField$,e%)),MKDWD$(RN???),"","",r%
        IF NOT r% THEN PROZOPRINT "Error accessing index file"+CrLf$
END IF

        ' edit the record
        DBEditFields e%

' replace entry in index
IF LEN(INDEX$) THEN
	BT Index$,"A", UCASE$(DBGetCField$(IndexField$,e%)),MKDWD$(RN???),"","",r%
        IF NOT r% THEN PROZOPRINT "Error updating index file"+CrLf$
END IF
END SUB

SUB dBAppendRecord (e%)
	e%=0
        IF dBaseOpen%=0 THEN e%=1:EXIT SUB
	Recnum???=0
        RecordBlock$=SPACE$(LEN(RecordBlock$))
	DbEditFields e%
	IF Recnum???>0 AND LEN(INDEX$) THEN
        	BT Index$, "A", UCASE$(DBGetCField$(IndexField$,e%)),MKDWD$(RecNum???),"","",r%
                IF NOT r% THEN PROZOPRINT "Error appending index file."+CrLf$
        END IF
END SUB

SUB dBDefaultFormat
' Create a default field edit format.
IF dBaseOpen%=0 THEN EXIT SUB
ERASE DBE()
k%=1
FOR y%=1 to NumberOfFields?
        INCR j%:IF j%=20 THEN j%=1:k%=k%+40:IF K%=81 THEN EXIT FOR
	DBE(y%).FieldName = DBS(y%).FieldName
        DBE(y%).FieldType = DBS(y%).FieldType
        DBE(y%).FieldLength = DBS(y%).FieldLength
        DBE(y%).FieldRow = j%
        DBE(y%).FieldCol = k%+(11-LEN(RTRIM$(DBS(y%).FieldName,CHR$(0))))
	DBE(y%).FieldFG = 0
        DBE(y%).FieldBG = 7
NEXT y%
END SUB

SUB dBCreateFormat
IF dBaseOpen%=0 THEN PROZOPRINT "No Database is in USE."+CrLf$:EXIT SUB
DO
PROZOCLS
dbdefaultformat
DBView
PROZOLOCATE 23,1:PROZOCOLOR 7,0:PROZOPRINT "Press ENTER to Accept or Fieldname to change: "
F$=PROZOINPUT$
IF F$="" THEN
	B%=FREEFILE
        PROZOLOCATE 23,1:PROZOPRINT SPACE$(80)
        PROZOLOCATE 23,1:PROZOPRINT "Enter format filename: "
        F$=PROZOINPUT$
        IF F$="" THEN F$="NONAME.FMT"
        OPEN F$ FOR RANDOM SHARED AS #B% LEN=LEN(DBE(1))
        Fld%=1
        DO UNTIL DBE(Fld%).FieldLength=0
        	PUT #B%, Fld%, DBE(Fld%)
                INCR Fld%
        LOOP
        EXIT LOOP
ELSE
Fld%=0
F$=UCASE$(F$)
	FOR y%=1 TO NumberOfFields?
        	IF INSTR(DBS(y%).FieldName,F$)=1 THEN Fld%=y%:EXIT FOR
	NEXT y%
IF Fld%=0 THEN PROZOLOCATE 23,1:PROZOPRINT SPACE$(80):PROZOLOCATE 23,1:PROZOPRINT "BAD FIELD NAME":SOUND 50,4:DELAY 2:ITERATE LOOP
PROZOLOCATE 23,1:PROZOPRINT SPACE$(80):PROZOLOCATE 23,1:PROZOPRINT "Use arrow keys to place new field position"
X%=DBE(Fld%).FieldRow
Y%=DBE(Fld%).FieldCol
F$=RTRIM$(DBE(Fld%).FieldName,CHR$(0))+":"+STRING$(DBE(Fld%).FieldLength,176)
' edit field location
DBSCRNFIND X%, Y%, F$
IF X%=0 THEN EXIT LOOP
DBE(Fld%).FieldRow = X%
DBE(Fld%).FieldCol = Y%
END IF
LOOP
END SUB

SUB dBSetFormatTo(FormatFileName$,Ecode%)
Ecode%=0
IF FormatFileName$="" THEN ERASE DBE():EXIT SUB
IF Dir$(FormatFileName$)="" THEN Ecode%=1:EXIT SUB
B%=FREEFILE
OPEN FormatFileName$ FOR RANDOM SHARED AS #B% LEN=LEN(DBE(1))
FOR y%=1 TO LOF(B%)\LEN(DBE)
	GET #B%, y%, DBE(y%)
NEXT y%
CLOSE #B%
END SUB

SUB dBView
Fld%=1
of%=(PBVScrnTxtAttr AND &HF) ' get the original foreground and background
ob%=(PBVScrnTxtAttr \ &H10)  ' PROZOCOLORs, in case they change.
DO UNTIL DBE(Fld%).FieldLength=0
        PROZOLOCATE DBE(Fld%).FieldRow,DBE(Fld%).FieldCol
        PROZOCOLOR of%,ob%
        PROZOPRINT RTRIM$(DBE(Fld%).FieldName,chr$(0))+":"
        PROZOPRINT "@SCP()"
        PROZOCOLOR DBE(Fld%).FieldFG,DBE(Fld%).FieldBG
        PROZOPRINT SPACE$(DBE(Fld%).FieldLength)
        PROZOPRINT "@RCP()"
        IF DBE(Fld%).FieldType="N" THEN
                PROZOPRINT LTRIM$(STR$(dBGetNField!((DBE(Fld%).FieldName),E%)))
                IF E% THEN PROZOPRINT "???"
	ELSE
                PROZOPRINT dBGetCField$((DBE(Fld%).FieldName),E%)
                IF E% THEN PROZOPRINT "???"
	END IF
	INCR Fld%
LOOP
PROZOCOLOR of%, ob%
END SUB


SUB dBEditFields(Ecode%)
Ecode%=0
Fld%=1 ' start with the first field on the screen
of%=(PBVScrnTxtAttr AND &HF) ' get the original foreground and background
ob%=(PBVScrnTxtAttr \ &H10)  ' PROZOCOLORs, in case they change.
' Now make one pass and DRAW the fields on the screen with defaults
DO UNTIL DBE(Fld%).FieldLength=0
        PROZOLOCATE DBE(Fld%).FieldRow,DBE(Fld%).FieldCol
        PROZOCOLOR of%,ob%
        PROZOPRINT RTRIM$(DBE(Fld%).FieldName,chr$(0))+":"
        PROZOPRINT "@SCP()"
        PROZOCOLOR DBE(Fld%).FieldFG,DBE(Fld%).FieldBG
        PROZOPRINT SPACE$(DBE(Fld%).FieldLength)
        PROZOPRINT "@RCP()"
        IF DBE(Fld%).FieldType="N" THEN
                PROZOPRINT LTRIM$(STR$(dBGetNField!((DBE(Fld%).FieldName),E%)))
                IF E% THEN PROZOPRINT "???"
	ELSE
                PROZOPRINT dBGetCField$((DBE(Fld%).FieldName),E%)
                IF E% THEN PROZOPRINT "???"
	END IF

	INCR Fld%
LOOP


Fld%=1 ' start with the first field on the screen
' Now go back and edit the fields
DO UNTIL DBE(Fld%).FieldLength=0
        PROZOLOCATE DBE(Fld%).FieldRow,DBE(Fld%).FieldCol
        PROZOCOLOR of%,ob%
        PROZOPRINT RTRIM$(DBE(Fld%).FieldName,CHR$(0))+":"
        r%=PROZOCSRLIN:C%=PROZOPOS
        IF DBE(Fld%).FieldType="N" THEN
                num%=-1
        	ED$=LTRIM$(STR$(dBGetNField!((DBE(Fld%).FieldName),E%)))
                IF E% THEN ED$="???"
                	ELSE
                num%=0
        	ED$= dBGetCField$((DBE(Fld%).FieldName),E%)
                IF E% THEN ED$="???"
	END IF

        ED$=DBGET$(r%, c%, (DBE(Fld%).FieldLength), (DBE(Fld%).FieldFG),_
                  (DBE(Fld%).FieldBG), ED$, -1, num%,KeyFlag%)

        IF num% THEN
        	dBPutNField (DBE(Fld%).FieldName), VAL(ED$), E%
        ELSE
        	dBPutCField (DBE(Fld%).FieldName),ED$,E%
	END IF

	SELECT CASE KeyFlag%
        	CASE 10
                	DBPutRecord RecNum???, E%
                        EXIT LOOP
		CASE 5
                	EXIT LOOP
		CASE 0,2,6
                	INCR Fld%
                        IF Fld%>NumberOfFields? THEN
                        	DBPutRecord RecNum???,e%
                                EXIT LOOP
                                END IF
                                'Fld%=NumberOfFields?
                CASE 4,8
                	DECR Fld%
                        IF Fld%=0 THEN Fld%=1
		END SELECT
LOOP
PROZOCOLOR Of%, Ob%

END SUB



SUB dBPutCField(FieldName$, FieldData$, Ecode%)
Ecode% = 1
	FieldName$=UCASE$(FieldName$)
FOR nof? = 1 TO NumberOfFields?
	IF LEFT$(DBS(nof?).FieldName,LEN(FieldName$)) = FieldName$ THEN
                IF LEN(FieldData$)>DBS(nof?).FieldLength THEN FieldData$=LEFT$(FieldData$,DBS(nof?).FieldLength)
		MID$(RecordBlock$, DBS(nof?).Fieldoffset,_
		DBS(nof?).FieldLength) = FieldData$ + _
                Space$(DBS(nof?).FieldLength-LEN(FieldData$))
		Ecode% = 0
		EXIT FOR
	END IF
NEXT nof?
END SUB

SUB dBPutNField(FieldName$, FieldData!, Ecode%)
	Ecode% = 1
	FieldName$=UCASE$(FieldName$)

FOR nof? = 1 TO NumberOfFields?
	IF LEFT$(DBS(nof?).FieldName,LEN(FieldName$)) = FieldName$ THEN
	Pattern$ = STRING$(DBS(nof?).FieldLength,"#")
	IF DBS(nof?).FieldDecimals > 0 THEN
	MID$(Pattern$,LEN(Pattern$)-(DBS(nof?).FieldDecimals),1)="."
	END IF
	FieldData$ = USING$(Pattern$,FieldData!)
	MID$(RecordBlock$, DBS(nof?).Fieldoffset,_
	DBS(nof?).FieldLength) = FieldData$
		Ecode% = 0
		EXIT FOR
	END IF
NEXT nof?

END SUB


SUB dBPutRecord(RN???,Ecode%)
Ecode% = 0
IF dBaseOpen% = 0 THEN Ecode% = 1: Exit Sub
                         ' Error Code 1 = Database file not open
GET #dBaseOpen%, 1, DBH
IF RN??? > DBH.NumberOfRecords + 1 THEN RN???=0
IF RN???<1 OR RN???=DBH.NumberOfRecords+1 THEN RN???=DBH.NumberOfRecords+1 :_
 DBH.NumberOfRecords = RN???:LastRec%=1: NumberOfRecords???=RN???
R$=MID$(RecordBlock$,2)
IF LEN(R$)<DBH.Size+1 THEN R$=R$+SPACE$(DBH.Size+1-LEN(R$))
IF LastRec%=1 THEN R$=R$+CHR$(26)
PUT #dBaseOpen%, DBH.offset + ((RN??? * DBH.Size) - DBH.Size)+1 , R$
IF DBH.NumberOfRecords = RN??? THEN _
          e$ = CHR$(26) + CHR$(10): PUT #dBaseOpen%, SEEK(dBaseOpen%) + 1, e$
DBH.Day   = VAL(MID$(DATE$, 4, 2))
DBH.Month = VAL(LEFT$(DATE$, 2))
DBH.Year  = VAL(RIGHT$(DATE$, 2))

PUT #dBaseOpen%, 1, DBH
RecNum???=RN???
END SUB


SUB dBGetARRAY(DB$(),Ecode%)

IF UBOUND(DB$()) < NumberOfFields? THEN Ecode% = 1:EXIT SUB
					' Error code 1, array not big enough
FOR nof? = 1 TO NumberOfFields?
	IF INSTR("CLD",DBS(nof?).FieldType) THEN
		DB$(nof?) = MID$(RecordBlock$, DBS(nof?).Fieldoffset,_
		DBS(nof?).FieldLength)
	ELSE
		DB$(nof?) = STR$(val(MID$(RecordBlock$, DBS(nof?).Fieldoffset,_
	 DBS(nof?).FieldLength)) * (10 ^ DBS(nof?).FieldDecimals))
	END IF
NEXT nof?
END SUB



FUNCTION dBGetASCII$
A$=""
FOR nof? = 1 TO NumberOfFields?
	IF INSTR("CLD",DBS(nof?).FieldType) THEN
		A$ = A$ + CHR$(34)+MID$(RecordBlock$, DBS(nof?).Fieldoffset,_
		DBS(nof?).FieldLength)+CHR$(34)
	ELSE
		A$ = A$ + STR$(val(MID$(RecordBlock$, DBS(nof?).Fieldoffset,_
	 DBS(nof?).FieldLength)) * (10 ^ DBS(nof?).FieldDecimals))
	END IF
	IF nof? < NumberOfFields? THEN A$ = A$ + ","
NEXT nof?
dBGetASCII$ = A$
END FUNCTION




FUNCTION dBGetCField$ (FieldName$, Ecode%)
Ecode% = 1
	FieldName$=UCASE$(FieldName$)
FOR nof? = 1 TO NumberOfFields?
	IF LEFT$(DBS(nof?).FieldName,LEN(FieldName$)) = FieldName$ THEN
		dBGetCField$ = MID$(RecordBlock$, DBS(nof?).Fieldoffset,_
		DBS(nof?).FieldLength)
		Ecode% = 0
		EXIT FOR
	END IF
NEXT nof?
END FUNCTION

FUNCTION dBGetNField!(FieldName$,Ecode%)
	Ecode% = 1
	FieldName$=UCASE$(FieldName$)
FOR nof? = 1 TO NumberOfFields?
	IF LEFT$(DBS(nof?).FieldName,LEN(FieldName$)) = FieldName$ THEN
	dBGetNField! = val(MID$(RecordBlock$, DBS(nof?).Fieldoffset,_
	 DBS(nof?).FieldLength)) '* (10 ^ -DBS(nof?).FieldDecimals)
		Ecode% = 0
		EXIT FOR
	END IF
NEXT nof?

END FUNCTION


SUB DBGetRecord (Rn???, Ecode%)
Ecode% = 0
IF dBaseOpen% = 0 THEN Ecode% = 1: EXIT SUB              ' database not open
GET #dBaseOpen%, 1, DBH
IF Rn??? > DBH.NumberOfRecords THEN Ecode% = 2: EXIT SUB   ' record too high
IF Rn??? < 1 THEN Ecode% = 2: EXIT SUB                     ' record too low

SEEK #dBaseOpen%, DBH.offset + (Rn??? * DBH.Size) - DBH.Size
GET$ dBaseOpen%, DBH.Size + 2, RecordBlock$
RecNum???=RN???
END SUB  ' dBGetRecord



SUB dBUse (FileName$, Ecode%)
Ecode% = 0: Recnum??? = 0
IF dBaseOpen% THEN CLOSE #dBaseOpen%: dBaseOpen% = 0
                                  'if database file is open, then close it.
FileName$ = UCASE$(FileName$)
IF INSTR(FileName$, ".") = 0 THEN FileName$ = FileName$ + ".DBF"
IF DIR$(FileName$) = "" THEN Ecode% = 1: EXIT SUB
                                                  ' error 1=file not found

LET dBaseOpen% = 81
OPEN FileName$ FOR BINARY ACCESS READ WRITE SHARED AS #dBaseOpen%
IF LOF(dBaseOpen%) = 0 THEN CLOSE #dBaseOpen%:dBaseOpen%=0:Ecode%=2:EXIT SUB
                                                ' Error 2=file is 0 length

GET #dBaseOpen%, 1, DBH
IF DBH.Year > 99 OR DBH.Month > 12 OR DBH.Month = 0 OR_
   DBH.Day > 31 OR DBH.Day = 0 THEN CLOSE #dBaseOpen%:_
   dBaseOpen% = 0: Ecode% = 4: EXIT SUB
                                              ' Error 4 = not a dBASE file

' establish number of fields by (dbh.offset-len(dbheader))\32
NumberOfRecords??? = DBH.NumberOfRecords
NumberOfFields? = (DBH.offset - LEN(DBH)) \ 32
IF NumberOfFields?<1 THEN Ecode% = 3:CLOSE #dBaseOpen%:dBaseOpen%=0:Exit SUB
                                ' Error 3 = no fields in database structure


' Load the field definition header
DBS(1).FieldOffset = 3
FOR nof? = 1 TO NumberOfFields?
	GET #dBaseOpen%, SEEK(dBaseOpen%), DBF

		DBS(nof?).FieldName     = DBF.FieldName
		DBS(nof?).FieldType     = DBF.FieldType
		DBS(nof?).FieldLength   = DBF.FLen
		DBS(nof?+1).FieldOffset = DBS(nof?).FieldOffset + DBF.FLen
		DBS(nof?).FieldDecimals = DBF.DecC
NEXT nof?
'CALL dBDefaultFormat  ' set default screen format
RecordBlock$=SPACE$(DBH.Size+2)
END SUB 'dBUse

SUB DBSCRNFIND(X%, Y%, F$)
IF ComLine THEN PROZOPRINT "Cannot design screens while on-line"+CrLf$:EXIT SUB
'arrows around F$ on the screen. and returns the ultimate coordinates.
REG 1, 15*256
CALL INTERRUPT &H10
IF Reg(1) - (Reg(1)\256) * 256 = 7 THEN Address=&HB000 else Address=&HB800
DEF SEG = ADDRESS
O$=PEEK$(0,4000)

DO   ' a deer, a female deer
	LOCATE X%, Y%:COLOR 20,0:PRINT F$;
        COLOR 7,0
        LOCATE 23,1:PRINT SPACE$(80);
        LOCATE 23,1:PRINT "Use arrows to re-position field.  ENTER finishes, ESC aborts.";
	KB$="" : WHILE KB$=""    ' create a polling loop instead of SLEEPing
                KB$=INKEY$
		WEND
		POKE$ 0,O$
		SELECT CASE KB$

			CASE CHR$(0,71) '  home
                        	Y%=1
			CASE CHR$(0,72) '  up arrow
                        	DECR X%:IF X%=0 THEN X%=22
			CASE CHR$(0,73) '  page up
                        	X%=1
			CASE CHR$(0,75) '  left arrow
                        	DECR Y%:IF Y%=0 THEN Y%=79-LEN(F$)
			CASE CHR$(0,77) '  right arrow
                        	INCR Y%:IF Y%>79-LEN(F$) THEN Y%=1
			CASE CHR$(0,79) '  end
                        	Y%=79-LEN(F$)
			CASE CHR$(0,80) '  down arrow
                        	INCR X%:IF X%=23 THEN X%=1
			CASE CHR$(0,81) '  page down
                        	X%=22
			CASE CHR$(0,82) '  Insert
			CASE CHR$(0,83) '  Delete
			CASE CHR$(0,59) '  f1
			CASE CHR$(0,60) '  f2
			CASE CHR$(0,61) '  f3
			CASE CHR$(0,62) '  f4
			CASE CHR$(0,63) '  f5
			CASE CHR$(0,64) '  f6
			CASE CHR$(0,65) '  f7
			CASE CHR$(0,66) '  f8
			CASE CHR$(0,67) '  f9
			CASE CHR$(0,68) '  f10
                        	FINISHED=-1
			CASE CHR$(0,115) ' CTL-Left arrow
                        	Y%=Y%-8:IF Y%<1 THEN Y%=1
			CASE CHR$(0,116) ' CTL-Right arrow
                        	Y%=Y%+8:IF Y%>79-LEN(F$) THEN y%=79-LEN(F$)
			CASE CHR$(0,117) ' CTL-END
                        	FINISHED=-1
			CASE CHR$(0,118) ' CTL-PgDn
			CASE CHR$(0,119) ' CTL-HOME
                        	X%=1:Y%=1
			CASE CHR$(0,132) ' CTL-PgUp
			CASE CHR$(3)  '  CTL-C ETX
                        	X%=0:FINISHED=-1
			CASE CHR$(9)  '  CTL-I TAB
                        	Y%=Y%+8:IF Y%>79-LEN(F$) THEN y%=79-LEN(F$)
			CASE CHR$(13)  ' CTL-M CARRIAGE RETURN
                        	FINISHED=-1
			CASE CHR$(16)  ' CTL-P DLE
			CASE CHR$(21)  ' CTL-U NAK
			CASE CHR$(27)  ' Escape ESC
                        	X%=0:FINISHED=-1

			END SELECT


LOOP WHILE NOT FINISHED
POKE$ 0, O$
DEF SEG

END SUB

$ENDIF