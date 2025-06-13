FUNCTION OFIND??? (newf$, DAT$, FLEN, Ecode%)
Ecode% = 0
DAT$ = UCASE$(DAT$)
IF INSTR(newf$, ".") = 0 THEN newf$ = newf$ + ".IX"

LET IXBuffer = FREEFILE

IF DIR$(NEWF$)="" THEN Ecode% = 1: OFIND???=0:GOTO EndOFindSub

OPEN newf$ FOR BINARY ACCESS READ WRITE SHARED AS #IXBuffer
IF LOF(IXBuffer) < FLEN + 4 THEN Ecode% = 2: GOTO EndOFindSub

PNTR??? = INT((LOF(IXBuffer) \ (FLEN + 4) \ 2)): '  start in the middle of index TRG
HALFPNTR??? = PNTR???
DO
HALFPNTR??? = INT((HALFPNTR??? - 1) \ 2) + 1
IF PNTR??? < 1 THEN LET PNTR??? = 1
IF PNTR??? > (LOF(IXBuffer) \ (FLEN + 4)) THEN LET PNTR??? = (LOF(IXBuffer) \ (FLEN + 4))
SEEK #IXBuffer, (PNTR??? * (FLEN + 4)) - (FLEN + 4) + 1
GET$ #IXBuffer, FLEN, RECORD.DATA$
RECORD.DATA$=UCASE$(RECORD.DATA$)
GET #IXBuffer, SEEK(IXBuffer), R???
IF INSTR(RECORD.DATA$, DAT$) = 1 THEN EXIT DO

IF DAT$ > RTRIM$(RECORD.DATA$) THEN PNTR??? = PNTR??? + HALFPNTR???
IF DAT$ < RTRIM$(RECORD.DATA$) THEN PNTR??? = PNTR??? - HALFPNTR???
IF DAT$ = RTRIM$(RECORD.DATA$) THEN EXIT DO

IF HALFPNTR??? <= 1 THEN incr Flag
LOOP WHILE Flag < 3

IF Flag => 3 THEN R??? = 0: Ecode% = 3: GOTO EndOFindSub

DO
IF PNTR??? = 1 THEN EXIT DO
DECR PNTR???

SEEK #IXBuffer, (PNTR??? * (FLEN + 4)) - (FLEN + 4) + 1
GET$ #IXBuffer, FLEN, RECORD.DATA$
RECORD.DATA$=UCASE$(RECORD.DATA$)
GET #IXBuffer, SEEK(IXBuffer), R???
IF DAT$ <> LEFT$(RECORD.DATA$ + SPACE$(40), LEN(DAT$)) THEN INCR PNTR???: EXIT DO
IF R??? = 0 THEN EXIT DO  ' this might indicate a bad index
LOOP WHILE PNTR??? > 0

SEEK #IXBuffer, (PNTR??? * (FLEN+4))-(FLEN+4)+1
GET$ #IXBuffer, FLEN, RECORD.DATA$
GET #IXBuffer,SEEK(IXBuffer),R???
IF R??? = 0 THEN Ecode% = 3
EndOFindSub:
CLOSE #IXBuffer
IF Ecode% = 0 THEN OFIND???=R??? ELSE OFIND???=0
END FUNCTION

FUNCTION OSKIP??? (fi$, n, FLEN, Ecode%)
Ecode% = 0
PNTR??? = PNTR??? + n
fi$ = UCASE$(fi$)

IF INSTR(fi$, ".") = 0 THEN fi$ = fi$ + ".IX"
LET IXBuffer = FREEFILE

OPEN fi$ FOR BINARY AS #IXBuffer
IF LOF(IXBuffer) < FLEN + 4 THEN Ecode% = 2: GOTO EndOSkipSub

SEEK #IXBuffer, (PNTR??? * (FLEN + 4)) - (FLEN + 4) + 1
Get$ IXBuffer, FLEN, RECORD.DATA$
GET #IXBuffer, SEEK(IXBuffer), R???

IF R??? = 0 THEN Ecode% = 3:OSKIP???=0 ELSE OSKIP???=R???
EndOSkipSub:
CLOSE #IXBuffer
END FUNCTION

