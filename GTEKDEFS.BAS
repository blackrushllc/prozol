DECLARE FUNCTION GTEKSetChannel%(BYTE)  ' returns true or false
DECLARE FUNCTION GTEKStatus?()          ' returns a status byte
DECLARE FUNCTION GTEKPortInit%(STRING)  ' returns true or false
DECLARE SUB 	 GTEKWriteByte(BYTE)    ' sets BYTE to 0 if fails
DECLARE FUNCTION GTEKReadByte?()        ' returns data byte or 0
DECLARE SUB	 GTEKPRINT(STRING)	' writes a string to current channel
DECLARE FUNCTION GTEKINKEY$()		' returns a character if available
DECLARE FUNCTION GTEKStartBreak%()      ' returns true or false
DECLARE FUNCTION GTEKEndBreak%()        ' returns true or false
DECLARE FUNCTION GTEKAssertDTR%()       ' returns true or false
DECLARE FUNCTION GTEKNegateDTR()        ' returns true or false
DECLARE FUNCTION GTEKGetGlobalCTS?()    ' returns a CTS bit pattern of channels
DECLARE FUNCTION GTEKGetGlobalCD?()     ' returns a CD bit pattern of channels
DECLARE FUNCTION GTEKGetModemStatus?()  ' returns bit pattern of modem status
					' bit 7 - Carrier Detect
					' bit 6 - reserved
					' bit 5 - Transmitter inhibited
					' bit 4 - Clear to Send status
					' bit 3 - Delta CD
					' bit 2 - reserved
					' bit 1 - Xoff recieved, not cleared
                                        ' bit 0 - Delta CTS
DECLARE SUB 	 GTEKXonXoffEnable()    ' Enable Xon/Xoff handshaking
DECLARE SUB 	 GTEKDtrCtsEnable()     ' Enable DTR/CTS handshaking
DECLARE SUB 	 GTEKXonXoffDisable()   ' Disable Xon/Xoff
DECLARE SUB 	 GTEKDtrCtsDisable()    ' Disable DTR/CTS
