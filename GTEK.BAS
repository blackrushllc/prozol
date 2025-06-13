FUNCTION GTEKSetChannel%(csc?)
' Selects a channel on the card.  Returns TRUE if successful
tries? = 50
SetChannelWAIT:
DECR Tries?
IF Tries?=0 THEN EXIT FUNCTION
!	mov	dx,GTEKBase??
!	inc	dx
!	in	al,dx		; get status
!	test	al, &H80	; check ready bit 7
!	jz	SetChannelWAIT	; uh-oh, board not ready
!	mov	al,csc?	        ; put channel into AL
!	out	dx,al		; send command (csc) to card
GTEKSetChannel% = %TRUE
END FUNCTION

FUNCTION GTEKStatus? 
' Checks the status of the card.  Returns a status byte.
tries? = 10
StatusWAIT:
DECR tries?
IF tries?=0 THEN EXIT FUNCTION
!	mov	dx,GTEKBase??   ; put command register address in DX
!	inc	dx              ; point to data register
!	in	al,dx		; get status
!	test	al, &H80	; check ready bit 7
!	jz	StatusWAIT	; uh-oh, board not ready
!	mov	al,&H08		; force channel status update
!	out	dx,al		; send command to card

!	dec	dx              ; point to data register
!	in	al,dx		; get status byte
!	mov	tries?,al	; put status byte into byte variable

GTEKStatus? = tries?            ' return byte

END FUNCTION

FUNCTION GTEKPortInit%(Parameter$)
' set the current channel baud, parity, word and stop
' (i.e. 2400,N,8,1)
SELECT CASE VAL(Parameter$)
	CASE 300
	pbyte? = &B01000000
	CASE 1200
	pbyte? = &B10000000
	CASE 2400
	pbyte? = &B10100000
	CASE 4800
	pbyte? = &B11000000
	CASE 9600
	pbyte? = &B11100000
	CASE 19200
	pbyte? = &B00100000
	CASE ELSE
	pbyte? = &B10100000 ' default to 2400 baud
END SELECT
REPLACE "," with "" in Parameter$
P$ = UCASE$(MID$(Parameter$+",",len( str$(val(Parameter$)))))
REPLACE "," with "" in P$
SELECT CASE P$
	CASE "N81"
		pbyte? = pbyte? + &B00000011
	CASE "E71"
		pbyte? = pbyte? + &B00011010
	CASE "E72"
		pbyte? = pbyte? + &B00011110
	CASE ELSE
		pbyte? = pbyte? + &B00000011
END SELECT

tries? = 10
InitPortWAIT:
DECR tries?
IF tries?=0 THEN EXIT FUNCTION
!	mov	dx,GTEKBase??   ; put command register address in DX
!	inc	dx              ; point to data register
!	in	al,dx		; get status
!	test	al, &H80	; check ready bit 7
!	jz	InitPortWAIT	; uh-oh, board not ready
!	mov	al,&H18		; command to initialize port
!	out	dx,al		; send command to card

tries? = 10
InitPortWAIT2:
DECR tries?
IF tries?=0 THEN EXIT FUNCTION
!	mov	dx,GTEKBase??   ; put command register address in DX
!	inc	dx              ; point to data register
!	in	al,dx		; get status
!	test	al, &H80	; check ready bit 7
!	jz	InitPortWAIT2	; uh-oh, board not ready

!	dec	dx		; point to data register
! 	mov	al,pbyte? 	; put the parameters into al
!	out 	dx,al		; and write it into the data register

GTEKPortInit% = %TRUE

END FUNCTION

SUB GTEKWriteByte(wbyte?)
' Write a byte to the port.
tries? = 10
WriteByteWAIT:
DECR Tries?
IF tries?=0 THEN wbyte? = 0:EXIT SUB
!	mov	dx,GTEKBase??
!	inc	dx
!	in	al,dx		; get status
!	test	al, &H80	; check ready bit 7
!	jz	WriteByteWAIT	; uh-oh, board not ready
'!	dec	dx		; point to data port
'!	mov	al,wbyte?	; byte to send is in al
'! 	out	dx,al		; write byte to data port
OUT GTEKBase??, wbyte?
END SUB

FUNCTION GTEKReadByte?
tries? = 10
ReadByteWAIT:
DECR Tries?
IF Tries?=0 THEN EXIT FUNCTION
!	mov	dx,GTEKBase??
!	inc	dx
!	in	al,dx		; get status
!	test	al, &H80	; check ready bit 7
!	jz	ReadByteWAIT	; uh-oh, board not ready

IF (INP(GTEKBase??) AND 1) THEN GTEKReadByte? = INP(GTEKBase??)

'!	dec	dx		; point to the data port
'!	in	al,dx		; read status byte
'!	test	al,&H01		; see if there is data waiting
'!	jz	NoData		; abandon if there is no data
'!	in	al,dx		; this is the data
'!	mov	tries?,al	; use the byte, since its there
'GTEKReadByte? = tries?
'NoData:
END FUNCTION

FUNCTION GTEKStartBreak% 
' Transmit dataline goes to +12 volts until stop break is issued
tries? = 10
StartBreakWAIT:
DECR tries?
IF tries?=0 THEN EXIT FUNCTION
!	mov	dx,GTEKBase??   ; put command register address in DX
!	inc	dx              ; point to data register
!	in	al,dx		; get status
!	test	al, &H80	; check ready bit 7
!	jz	StartBreakWAIT	; uh-oh, board not ready
! 	mov	al,&H10
!	out	dx,al
GTEKStartBreak% = %TRUE
END FUNCTION

FUNCTION GTEKEndBreak% 
' Restore transmit data line to -12 volts
tries? = 10
EndBreakWAIT:
DECR tries?
IF tries?=0 THEN EXIT FUNCTION
!	mov	dx,GTEKBase??   ; put command register address in DX
!	inc	dx              ; point to data register
!	in	al,dx		; get status
!	test	al, &H80	; check ready bit 7
!	jz	EndBreakWAIT	; uh-oh, board not ready
!	mov	al, &H11
!	out	dx,al
GTEKEndBreak% = %TRUE
END FUNCTION

FUNCTION GTEKAssertDTR% 
' Set DTR to high
tries? = 10
AssertDTRWAIT:
DECR tries?
IF tries?=0 THEN EXIT FUNCTION
!	mov	dx,GTEKBase??   ; put command register address in DX
!	inc	dx              ; point to data register
!	in	al,dx		; get status
!	test	al, &H80	; check ready bit 7
!	jz	AssertDTRWAIT	; uh-oh, board not ready
!	mov	al,&H12
!	out	dx,al
GTEKAssertDTR% = %TRUE
END FUNCTION

FUNCTION GTEKNegateDTR 
' Set DTR to low
tries? = 10
NegateDTRWAIT:
DECR tries?
IF tries?=0 THEN EXIT FUNCTION
!	mov	dx,GTEKBase??   ; put command register address in DX
!	inc	dx              ; point to data register
!	in	al,dx		; get status
!	test	al, &H80	; check ready bit 7
!	jz	NegateDTRWAIT	; uh-oh, board not ready
!	mov	al,&H12
!	out	dx,al
GTEKNegateDTR% = %TRUE
END FUNCTION

FUNCTION GTEKGetGlobalCTS? 
' returns a bit pattern of the CTS conditions of each line
tries? = 10
GetGlobalCTSWAIT:
DECR tries?
IF tries?=0 THEN EXIT FUNCTION
!	mov	dx,GTEKBase??   ; put command register address in DX
!	inc	dx              ; point to data register
!	in	al,dx		; get status
!	test	al, &H80	; check ready bit 7
!	jz	GetGlobalCTSWAIT	; uh-oh, board not ready
!	mov	al,&H15
!	out	dx,al
!	dec	dx
!	in	al,dx
!	mov	tries?,al
GTEKGetClobalCTS? = tries?
END FUNCTION


FUNCTION GTEKGetGlobalCD? 
' returns a bit pattern of the Carrier Detect conditions of each line
tries? = 10
GetGlobalCDWAIT:
DECR tries?
IF tries?=0 THEN EXIT FUNCTION
!	mov	dx,GTEKBase??   ; put command register address in DX
!	inc	dx              ; point to data register
!	in	al,dx		; get status
!	test	al, &H80	; check ready bit 7
!	jz	GetGlobalCDWAIT	; uh-oh, board not ready
!	mov	al,&H14
!	out	dx,al
!	dec	dx
!	in	al,dx
!	mov	tries?,al
GTEKGetClobalCD? = tries?
END FUNCTION

FUNCTION GTEKGetModemStatus? 
' returns a bit pattern of the Carrier Detect conditions of each line
tries? = 10
GetModemStatusWAIT:
DECR tries?
IF tries?=0 THEN EXIT FUNCTION
!	mov	dx,GTEKBase??   ; put command register address in DX
!	inc	dx              ; point to data register
!	in	al,dx		; get status
!	test	al, &H80	; check ready bit 7
!	jz	GetModemStatusWAIT	; uh-oh, board not ready
!	mov	al,&H16
!	out	dx,al
!	dec	dx
!	in	al,dx
!	mov	tries?,al
GTEKGetModemStatus? = tries?
END FUNCTION


SUB GTEKPRINT(A$) 
IF LEN(A$) THEN
	FOR i% = 1 TO len(a$)
		w? = ASCII(Mid$(A$,i%,1))
		GTEKWriteByte w?
	NEXT i%
END IF
END SUB


FUNCTION GTEKINKEY$ 
	i? = GTEKReadByte
	IF i? THEN GTEKINKEY$ = CHR$(i?)
END FUNCTION


SUB GTEKXonXoffEnable
'Enable Xon/Xoff handshaking
tries? = 10
XonXoffEnableWAIT:
DECR tries?
IF tries?=0 THEN EXIT SUB
!	mov	dx,GTEKBase??   ; put command register address in DX
!	inc	dx              ; point to data register
!	in	al,dx		; get status
!	test	al, &H80	; check ready bit 7
!	jz	XonXoffEnableWAIT	; uh-oh, board not ready
!	mov	al,&H19
!	out	dx,al
!	dec	dx
!	mov	al,&B00001010
!	out	dx,al
END SUB

SUB GTEKDtrCtsEnable 
' Enable DTR/CTS handshaking
tries? = 10
DtrCtsEnableWAIT:
DECR tries?
IF tries?=0 THEN EXIT SUB
!	mov	dx,GTEKBase??   ; put command register address in DX
!	inc	dx              ; point to data register
!	in	al,dx		; get status
!	test	al, &H80	; check ready bit 7
!	jz	DtrCtsEnableWAIT	; uh-oh, board not ready
!	mov	al,&H19
!	out	dx,al
!	dec	dx
!	mov	al,&B00010100
!	out	dx,al
END SUB


SUB GTEKXonXoffDisable 
' disable handshaking
tries? = 10
XonXoffDisableWAIT:
DECR tries?
IF tries?=0 THEN EXIT SUB
!	mov	dx,GTEKBase??   ; put command register address in DX
!	inc	dx              ; point to data register
!	in	al,dx		; get status
!	test	al, &H80	; check ready bit 7
!	jz	XonXoffDisableWAIT	; uh-oh, board not ready
!	mov	al,&H19
!	out	dx,al
!	dec	dx
!	mov	al,&B00000000
!	out	dx,al
END SUB

SUB GTEKDtrCtsDisable
' Disable handshaking.  This does the same thing as xonxoffdisable
tries? = 10
DtrCtsDisableWAIT:
DECR tries?
IF tries?=0 THEN EXIT SUB
!	mov	dx,GTEKBase??   ; put command register address in DX
!	inc	dx              ; point to data register
!	in	al,dx		; get status
!	test	al, &H80	; check ready bit 7
!	jz	DtrCtsDisableWAIT	; uh-oh, board not ready
!	mov	al,&H19
!	out	dx,al
!	dec	dx
!	mov	al,&B00000000
!	out	dx,al
END SUB
