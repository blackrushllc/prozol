FUNCTION GetAckNak$
$IF NOT %NOXMODEM
    'LET dropout# = TIMER + 10
DO
  'IF TIMER > dropout# THEN Value$ = CHR$(255): EXIT DO
	IF Comchars% > 0 THEN
	A$ = COMINKEY$
	END IF
LOOP WHILE LEN(a$) = 0
	GetAckNak$ = a$
$ENDIF
END FUNCTION
