$link "vidram.obj"
declare sub vmprint(string,integer,integer,integer)
dim global$(10)
shared global$()
global$(3)="FILENAME.IO"
call setdoslines(23)
cls
for y=1 to 50
DPRINTLN "This is a test"
call status
next y

SUB STATUS
S$=SPACE$(80)
MID$(S$,1)=CURDIR$
MID$(S$,20)="Ý" + GLOBAL$(3)
MID$(S$,30)="Ý" + "L"+STR$(Progline%)+" P"+STR$(Prog) + _
 " F"+STR$(Fork1%)+" f"+STR$(fork2%)
'MID$(S$,42)
CALL VMPRINT(S$,25,1,&H70)
END SUB


SUB SetDosLines(Lin%)
	DEF SEG=&h0040
	POKE &H0084,Lin%
	DEF SEG
END SUB



SUB Dprint(TEST$)
   TEST$=TEST$+"$"
   REG 1,&h0900
   REG 8,STRSEG(TEST$)
   REG 4,STRPTR(TEST$)
   CALL INTERRUPT &h21
END SUB

SUB CurPos (y%, x%)
   REG 1, &h03
   REG 2, %h0100
   CALL INTERRUPT &h10
   Y%=REG(4)
   X%=REG(4) MOD 256
END SUB

SUB SetDosTop(Lin%)
	DEF SEG=&h0040
	POKEI &H004E,Lin%*160
	POKE &H0084,25-Lin%
	DEF SEG
END SUB

FUNCTION DPOS%
	REG 1,&H0300
	REG 2,&H0000
	CALL INTERRUPT &H10
	DPOS%=(REG(4) AND &H00FF)+1
END FUNCTION

FUNCTION DCSRLIN%
	REG 1,&H0300
	REG 2,&H0000
	CALL INTERRUPT &H10
	DCSRLIN%=(REG(4) AND &HFF00)/256+1
END FUNCTION

SUB DPrintLn(TEST$)
   TEST$=TEST$+CHR$(13)+CHR$(10)+"$"
   REG 1,&h0900
   REG 8,STRSEG(TEST$)
   REG 4,STRPTR(TEST$)
   CALL INTERRUPT &h21
END SUB
