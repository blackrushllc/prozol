SUB XmodemOut (fi$, Ecode%)
$IF NOT %NOXMODEM
IF Comline = 0 THEN PROZOPRINT "Not connected" + CrLf$: GOTO endXmodemOutSub
DIM XPacket AS XPacketType

NAK$ = CHR$(&H15)
SOH$ = CHR$(&H1)
EOT$ = CHR$(&H4)
ACK$ = CHR$(&H6)
CAN$ = CHR$(&H18)
C$ = CHR$(&H43)
XPacket.SOH = SOH$
CALL EXIST(fi$ + CHR$(0), e%)
IF NOT e% THEN Ecode% = 1: GOTO endXmodemOutSub

' Abort initial NAK after 6 tries, 10 seconds each
LET XBuffer = FREEFILE
OPEN fi$ FOR BINARY ACCESS READ WRITE SHARED AS #XBuffer
LET tb = (LOF(XBuffer) \ 128) + 1
PROZOPRINT CrLf$ + "             File: " + fi$ + CrLf$
PROZOPRINT "       Total Size:" + STR$(LOF(XBuffer)) + CrLf$
PROZOPRINT " Number of Blocks:" + STR$(tb) + CrLf$
mins = (tb * .75) \ 60
secs = INT((tb * .75) - (mins * 60))
PROZOPRINT "   Estimated time:" + STR$(mins) + " minutes and" + STR$(secs) + " seconds." + CrLf$
PROZOPRINT CrLf$ + "Begin transfer..." + CrLf$
Ecode% = 0
FOR y = 1 TO 6
	LOCALPRINT "NAK..."
	A$ = GetAckNak$
	IF A$ = NAK$ OR A$ = C$ THEN EXIT FOR
	IF A$ = CAN$ OR A$ = CHR$(27) OR A$ = CHR$(3) THEN Ecode% = 2: EXIT FOR
	LOCALPRINT "(retry)"
NEXT y
IF y >= 6 THEN Ecode% = 2: PRINT #5, CAN$
IF Ecode% THEN GOTO endXmodemOutSub

'GETACKNAK waits 10 seconds, try it 10 times, returns ACK, NAK or other

' ABORT the transfer with CAN CAN CAN
IF A$ = C$ THEN C = 1 ELSE C = 0 ' flag CRC check
IF C THEN LOCALPRINT "<CRC>" ELSE LOCALPRINT "<CheckSum>"
IF LOF(XBuffer) = 0 THEN Ecode% = 3: CLOSE #XBuffer: GOTO endXmodemOutSub
IF LOF(XBuffer) < 129 THEN GOTO LastPacket
BLK = 0
FOR y% = 1 TO LOF(XBuffer) \ 128
BLK = BLK + 1: IF BLK = 256 THEN BLK = 0
LET NEG = 255 - BLK
LET XPacket.BLK = CHR$(BLK)
LET XPacket.NEG = CHR$(NEG)
GET$ XBuffer, 128 ,XPacket.DAT
LET ChkSum% = 0
LET CRCLO% = 0
LET C$ = XPacket.DAT '+ CHR$(0) + CHR$(0)
IF C THEN

CALL CRC16(C$, ChkSum%, CRCLO%)

ELSE

ChkSum% = CheckSum%(C$)

END IF

LET XPacket.SUM = CHR$(ChkSum%)
LET XPacket.CRC = CHR$(CRCLO%)

ResendPacket:
$IF NOT %NOTASKS
CALL TASKMAN
$ENDIF
REM FORK WENT HERE **
LOCALPRINT ">"
COMPRINT (XPacket.SOH)
COMPRINT (XPacket.BLK)
COMPRINT (XPacket.NEG)
COMPRINT (XPacket.DAT)
COMPRINT (XPacket.SUM)
IF C THEN COMPRINT (XPacket.CRC)
' Wait 10 seconds for NAK

A$ = GetAckNak$
IF A$ = CAN$ THEN CLOSE #XBuffer: Ecode% = 5: GOTO endXmodemOutSub
IF A$ <> ACK$ THEN

	er = er + 1
	IF er < 10 THEN
		LOCALPRINT "<"
		GOTO ResendPacket
	ELSE
		CLOSE #XBuffer:
		COMPRINT CAN$ + CAN$ + CAN$
                		Ecode% = 4
		GOTO endXmodemOutSub
	END IF
END IF

' send block
' wait for ACK, if NAK or other, resend
er = 0
NEXT y%

LastPacket:
' send last packet
LOCALPRINT "]"

BLK = BLK + 1: IF BLK = 256 THEN BLK = 0
LET NEG = 255 - BLK
LET XPacket.BLK = CHR$(BLK)
LET XPacket.NEG = CHR$(NEG)
GET$ XBuffer, LOF(XBuffer) - ((LOF(XBuffer) \ 128) * 128), XPacket.DAT
XPacket.DAT = XPacket.DAT + STRING$(128, 26)

LET ChkSum% = 0
LET CRCLO% = 0
LET C$ = XPacket.DAT '+ CHR$(0) + CHR$(0)
IF C THEN

CALL CRC16(C$, ChkSum%, CRCLO%)

ELSE

ChkSum% = CheckSum%(C$)

END IF

LET XPacket.SUM = CHR$(ChkSum%)
LET XPacket.CRC = CHR$(CRCLO%)


ResendPacket2:

COMPRINT (XPacket.SOH)
COMPRINT (XPacket.BLK)
COMPRINT (XPacket.NEG)
COMPRINT (XPacket.DAT)
COMPRINT (XPacket.SUM)
IF C THEN COMPRINT (XPacket.CRC)
' Wait 10 seconds for NAK
REM FORK WENT HERE
A$ = GetAckNak$
IF A$ = CAN$ THEN CLOSE #XBuffer: Ecode% = 5: GOTO endXmodemOutSub

IF A$ <> ACK$ THEN
	er = er + 1

	IF er < 10 THEN
		LOCALPRINT "["
		GOTO ResendPacket2
	ELSE
		CLOSE #XBuffer
		COMPRINT CAN$ + CAN$ + CAN$
		Ecode% = 4
		GOTO endXmodemOutSub
	END IF
END IF


' send block
' wait for ACK, if NAK or other, resend
DO
endoftrans:
	LOCALPRINT "<EOT>"
	COMPRINT CHR$(4)
	A$ = GetAckNak$
	IF A$ = ACK$ THEN LOCALPRINT "<ACK>": CLOSE #XBuffer: EXIT DO
	IF LEN(A$) THEN er = er + 1: LOCALPRINT "<NAK>"
	IF er = 10 OR A$ = CAN$ THEN CLOSE #XBuffer: Ecode% = 5: EXIT DO
	GOTO endoftrans
LOOP

' after ACK, send EOT
' wait for ACK

CLOSE #XBuffer

endXmodemOutSub:
$ENDIF
END SUB

