'index commands
GOTO EXITSELECT
PtrIXOPEN:'     CASE "IXOPEN"
        ' IXOPEN Filename AS Buffer
        FI$=POPARG$
        V$=LITERAL$(ArgPtr%) ' buffer
        FF=FREEFILE
        VSET2 V$, STR$(FF)
        Dummy$=POPARG$
        IxPtr&(FF,0)=0 ' Current pointer
        IxPtr&(FF,1)=0 ' RecordSize
        IxPtr&(FF,2)=0 ' Last recnum read
        IxPtr&(FF,3)=0 ' Previous pointer (for lost Ptr val in no find)
        OPEN FI$ FOR BINARY SHARED AS FF
        GET$ FF,4,A$
        IxPtr&(FF,1) = CVL(A$) ' first four bytes contains the field length+4

GOTO EXITSELECT
PtrIXCLOSE:'    CASE "IXCLOSE"
        V$=LITERAL$(ArgPtr%)
	FF=VAL(POPARG$)
        CLOSE #FF
        VCLEAR V$
        IxPtr&(FF,0)=0
        IxPtr&(FF,1)=0
        IxPtr&(FF,2)=0
        IxPtr&(FF,3)=0

GOTO EXITSELECT
PtrREST:'       CASE "REST"
	RestFlag%=%True

GOTO EXITSELECT
PtrIXSCAN:'     CASE "IXSCAN"
        FF=VAL(POPARG$)
        S$=UCASE$(POPARG$)
     temp=0
     IF LEN(S$) THEN
        SEEK FF,IxPtr&(FF,1)+1
        IF RestFlag% THEN
         R&=IXPtr&(FF,0)
         RestFlag%=0
         SEEK FF,(IxPtr&(FF,0) * IxPtr&(FF,1))+1
        ELSE
         R&=0
        END IF
       DO
        INCR R&
        GET$ FF,IxPtr&(FF,1),I$
        IF INSTR(I$,S$) THEN
                IxPtr&(FF,3)=IxPtr&(FF,0)
                IxPtr&(FF,0)=R&
                IxPtr&(FF,2)=CVL(RIGHT$(I$,4))
                PUSHARG STR$(IxPtr&(FF,2))
                Temp=1
        	EXIT LOOP
	END IF
       IF INSTAT OR COMChars% THEN IF BOZOINKEY$=CHR$(27) THEN PUSHARG "0":EXIT LOOP
       LOOP WHILE NOT EOF(FF)
       END IF
	IF TEMP=0 THEN PUSHARG "0"

GOTO EXITSELECT
PtrIXFIND:'     CASE "IXFIND"
FF=VAL(POPARG$)
S$=UCASE$(POPARG$)
IF LEN(S$) THEN
IXPtr&(FF,3)=IXPtr&(FF,0)
IxPtr&(FF,0) = (LOF(FF) \ (IxPtr&(FF,1)) \ 2): '  start in the middle of index TRG
HalfIxPtr& = IxPtr&(FF,0)
DO
HalfIxPtr& = ((HalfIxPtr& - 1) \ 2) + 1
IF IxPtr&(FF,0) < 1 THEN LET IxPtr&(FF,0) = 1
IF IxPtr&(FF,0) > (LOF(FF) \ IxPtr&(FF,1)) THEN LET IxPtr&(FF,0) = (LOF(FF) \ (IxPtr&(FF,1)))
SEEK #FF, (IxPtr&(FF,0) * (IxPtr&(FF,1))) - (IxPtr&(FF,1)) + 1
GET$ #FF, IxPtr&(FF,1), I$
IF INSTR(I$,S$) = 1 THEN EXIT DO

IF S$ > I$ THEN IxPtr&(FF,0) = IxPtr&(FF,0) + HalfIxPtr&
IF S$ < I$ THEN IxPtr&(FF,0) = IxPtr&(FF,0) - HalfIxPtr&

IF HalfIxPtr& <= 1 THEN incr Flag
LOOP WHILE Flag < 3

IF Flag => 3 THEN PUSHARG "0":IXPtr&(FF,0)=IXPtr&(FF,3):GOTO EndIXFindSub

DO
IF IxPtr&(FF,0) = 1 THEN EXIT DO
DECR IxPtr&(FF,0)

SEEK #FF, (IxPtr&(FF,0) * (IxPtr&(FF,1))) - (IxPtr&(FF,1)) + 1
GET$ #FF, IxPtr&(FF,1), I$
IF INSTR(S$,I$) <> 1 THEN INCR IxPtr&(FF,0): EXIT DO
LOOP WHILE IxPtr&(FF,0) > 0

SEEK #FF, (IxPtr&(FF,0) * (IxPtr&(FF,1)))-(IxPtr&(FF,1))+1
GET$ #FF, IxPtr&(FF,1), I$
IxPtr&(FF,2)=CVL(RIGHT$(I$,4))
DECR IxPtr&(FF,0),2 ' adjust
PUSHARG STR$(IxPtr&(FF,2))

ENDIXFINDSUB:
END IF

GOTO EXITSELECT
PtrIXSKIP:'     CASE "IXSKIP"
        FF=VAL(POPARG$)
        sk&=VAL(POPARG$)

        IxPtr&(FF,3)=IxPtr&(FF,0)
        IxPtr&(FF,0)=IxPtr&(FF,0)+Sk&
        SEEK FF,1+(IxPtr&(FF,0)*IxPtr&(FF,1))
        GET$ FF,IxPtr&(FF,1),I$
        IxPtr&(FF,2)=CVL(RIGHT$(I$,4))
        PUSHARG STR$(IxPtr&(FF,2))

GOTO EXITSELECT
PtrIXPREV:'     CASE "IXPREV"
        FF=VAL(POPARG$)
        sk&=-1

        IxPtr&(FF,3)=IxPtr&(FF,0)
        IxPtr&(FF,0)=IxPtr&(FF,0)+Sk&
        SEEK FF,1+(IxPtr&(FF,0)*IxPtr&(FF,1))
        GET$ FF,IxPtr&(FF,1),I$
        IxPtr&(FF,2)=CVL(RIGHT$(I$,4))
        PUSHARG STR$(IxPtr&(FF,2))
GOTO EXITSELECT
PtrIXNEXT:'     CASE "IXNEXT"
        FF=VAL(POPARG$)
        sk&=1

        IxPtr&(FF,3)=IxPtr&(FF,0)
        IxPtr&(FF,0)=IxPtr&(FF,0)+Sk&
        SEEK FF,1+(IxPtr&(FF,0)*IxPtr&(FF,1))
        GET$ FF,IxPtr&(FF,1),I$
        IxPtr&(FF,2)=CVL(RIGHT$(I$,4))
        PUSHARG STR$(IxPtr&(FF,2))

GOTO EXITSELECT
PtrIXTOP:'      "IXFIRST"        CASE "IXTOP","IXFIRST"
        FF=VAL(POPARG$)

        IxPtr&(FF,3)=IxPtr&(FF,0)
        IxPtr&(FF,0)=1
        SEEK FF,1+(IxPtr&(FF,0)*IxPtr&(FF,1))
        GET$ FF,IxPtr&(FF,1),I$
        IxPtr&(FF,2)=CVL(RIGHT$(I$,4))
        PUSHARG STR$(IxPtr&(FF,2))

GOTO EXITSELECT
PtrIXBOTTOM:'    "IXLAST"        CASE "IXBOTTOM", "IXLAST"
        FF=VAL(POPARG$)


        IxPtr&(FF,3)=IxPtr&(FF,0)
        IxPtr&(FF,0)=(LOF(FF)\IxPtr&(FF,1))-1
        SEEK FF,1+(IxPtr&(FF,0)*IxPtr&(FF,1))
        GET$ FF,IxPtr&(FF,1),I$
        IxPtr&(FF,2)=CVL(RIGHT$(I$,4))
        PUSHARG STR$(IxPtr&(FF,2))

GOTO EXITSELECT
PtrIXEOF:'      CASE "IXEOF"
        FF=VAL(POPARG$)
        IF IxPtr&(FF,0)=(LOF(FF)\IxPtr&(FF,1))-1 THEN PUSHARG "-1" ELSE PUSHARG "0"
GOTO EXITSELECT
PtrIXBOF:'      CASE "IXBOF"
	FF=VAL(POPARG$)
        IF IxPtr&(FF,0)=1 THEN PUSHARG "-1" ELSE PUSHARG "0"

GOTO EXITSELECT
PtrIX:' CASE "IX"
        PUSHARG STR$(IxPtr&(FF,2))

GOTO EXITSELECT
PtrIXWAS:'      CASE "IXWAS"
        IF IxPtr&(FF,3)>0 THEN
        IxPtr&(FF,0)=IxPtr&(FF,3)
        SEEK FF,1+(IxPtr&(FF,0)*IxPtr&(FF,1))
        GET$ FF,IxPtr&(FF,1),I$
        IxPtr&(FF,2)=CVL(RIGHT$(I$,4))
        PUSHARG STR$(IxPtr&(FF,2))
        ELSE
        PUSHARG "0"
        END IF

GOTO EXITSELECT
PtrIXSTITCH:'   ' IXSTITCH indexname, data, recordnumber, (length)        CASE "IXSTITCH" ' IXSTITCH indexname, data, recordnumber, (length)
        FF=FREEFILE
        Fi$=POPARG$
        D$=POPARG$
        R&=VAL(POPARG$)
        IF ArgPtr% THEN L=VAL(POPARG$)
        IF DIR$(Fi$)<>"" THEN
                OPEN Fi$ FOR BINARY SHARED AS FF
                GET$ FF,4,A$
                L=CVL(A$)
        ELSE
                OPEN Fi$ FOR BINARY SHARED AS FF
                PUT$ FF, MKL$(R&)+SPACE$(L-4)
        END IF
        SEEK FF,LOF(FF)
        IF LEN(D$)<L-4 THEN D$=D$+SPACE$((L-4)-LEN(D$))
        IF LEN(D$)>L-4 THEN D$=LEFT$(D$,L-4)
        PUT$ FF, D$+MKL$(R&)
        CLOSE FF


GOTO EXITSELECT
PtrIXCREATE:'   'IXCREATE filename, fieldname FROM filebuffer        CASE "IXCREATE" 'IXCREATE filename, fieldname FROM filebuffer
	FF=FREEFILE                     'buffer for index
        Fi$=POPARG$                     'index file name
        VM$=LITERAL$(ArgPtr%)           'literal map var name
        DUMMY$=POPARG$
        VL$=LEFT$(VM$,INSTR(VM$,".")-1) 'map field
        IF VL$="" THEN ERROR 103        'bad map variable
        VS$=MID$(VM$,INSTR(VM$,".")+1)+"$"+VL$ ' field name
	 ARRAY SCAN VAR$(1),COLLATE UCASE, =VS$, TO i% 'find field var
		IF i% THEN
        	 O%=CVI(LEFT$(VALUE$(i%),2)) ' establish field position
                 L%=CVI(RIGHT$(VALUE$(i%),2)) ' establish field length
                 ELSE
                  ERROR 103 			' bad map
                 END IF
        ARRAY SCAN VAR$(1),COLLATE UCASE,=VL$, TO i% 'find VALUE$(i%)
        IF i%=0 THEN ERROR 103 		'map var not found

        FB=VAL(POPARG$) 		'file buffer for database
        OPEN Fi$ FOR OUTPUT AS #FF  	'prepare to write to index file

        'PRINT #FF,MKL$(L%+4)+SPACE$(L%); ' create header (take this out)
        PRINT #FF, STRING$(L%+4,0); ' space header prior to quiksort
        HDR$=MKL$(L%+4)+SPACE$(L%) ' save header
        FOR R&=1 TO LOF(FB)\LEN(VALUE$(i%)) ' rec 1 through endrec
		GET #FB,R&,VALUE$(i%)	'get record
                FLD$=MID$(VALUE$(i%),O%,L%)
                PRINT #FF, FLD$+MKL$(R&);
	NEXT R&
        CLOSE #FF
        QUIKSORT Fi$,L%+4
        OPEN Fi$ FOR BINARY AS #FF
        PUT$ #FF, HDR$
        CLOSE #FF

GOTO EXITSELECT
PtrIXRESORT:'   CASE "IXRESORT"

GOTO EXITSELECT
PtrIXUPDATE:'   CASE "IXUPDATE"

GOTO EXITSELECT
PtrIXDELETE:'   CASE "IXDELETE"
