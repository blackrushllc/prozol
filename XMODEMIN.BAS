SUB XmodemIn (filename$, success%)
$IF NOT %NOXMODEM
  DIM bdta AS STRING * 128
  false% = 0
  true% = 1
  CRCSend% = 99
  success% = false%
  FirstOk% = false%
  BlockHi% = 0
  PrevBlock% = 0
  NAK$ = CHR$(5)
  ACK$ = CHR$(6)
  SOH$ = CHR$(1)
  EOT$ = CHR$(4)
  CAN$ = CHR$(24)
  CPM$ = CHR$(26)
  Filenum = FREEFILE
  PROZOPRINT "Xmodem receive.  Begin Transfer now..." + CrLf$
  If ComLine=0 THEN PROZOPRINT "Not connected"+CrLf$: Exit Sub
  OPEN filename$ FOR RANDOM AS #Filenum LEN = 128


  FOR y = 1 TO 5
	Tm! = TIMER
	LOCALPRINT "<C>": COMPRINT "C"
	WHILE ComChars%=0 AND TIMER - Tm! <= 3: WEND
	IF ComChars% THEN EXIT FOR
  NEXT y
  IF y = 5 THEN LOCALPRINT "Too Many Tries!": GOTO XmodemReceiveAbort
  LOCALPRINT "<OK>"
  DO
    Retries% = 0
    DO
      Retries% = Retries% + 1
      r$ = ""
      x% = 10
      LOCALPRINT "?"
      DO
	CALL GetXChar(Ch$, toolong%, x%)
	'IF Instat THEN
	  'k$ = INKEY$
	  'IF k$ = CHR$(27) THEN r$ = CAN$
	'END IF
	IF NOT toolong% THEN r$ = r$ + Ch$
	x% = 2
      LOOP UNTIL toolong% OR LEN(r$) = 133
      IF FirstOk% = false% THEN
	IF LEN(r$) = 132 THEN CRCSend% = false%
	IF LEN(r$) = 133 THEN CRCSend% = 1 ELSE LOCALPRINT "!133"
      END IF
      Ok% = 0
      Start$ = LEFT$(r$, 1)
      IF LEN(r$) < 133 THEN LOCALPRINT "<LEN?>": GOTO NotOK
      Block% = ASC(MID$(r$, 2, 1))
      BlkCk% = 255 - ASC(MID$(r$, 3, 1))
      dta$ = MID$(r$, 4, 128)
      Chk$ = MID$(r$, 132, 3)
      IF Start$ <> SOH$ THEN LOCALPRINT "<BAD SOH>": GOTO NotOK
      IF LEN(dta$) <> 128 THEN LOCALPRINT "<LEN?>": GOTO NotOK
      IF Block% <> BlkCk% THEN LOCALPRINT "<BAD BLK#>": GOTO NotOK
D$ = dta$ '+ CHR$(0) + CHR$(0)
CRC.Hi% = 0: CRC.Low% = 0: ChkSum% = 0
CALL CRC16(D$, CRC.Hi%, CRC.Low%)
ChkSum% = CheckSum%(D$)


IF CRCSend% THEN
	IF Chk$ <> CHR$(CRC.Hi%) + CHR$(CRC.Low%) THEN LOCALPRINT "<BAD CRC>": GOTO NotOK
      ELSE
	IF Chk$ <> CHR$(ChkSum%) THEN LOCALPRINT "<BAD CKS>": GOTO NotOK
      END IF
      Ok% = 1: LOCALPRINT "="
NotOK:
      IF Ok% = 0 THEN COMPRINT NAK$ : LOCALPRINT "<"
    LOOP UNTIL Ok% OR Retries% > 10 OR Start$ = CAN$ OR Start$ = EOT$

    IF Start$ = SOH$ AND Ok% THEN
      LOCALPRINT ">"
$IF NOT %NOTASKS
CALL TASKMAN
$ENDIF
REM FORK WENT HERE
      IF Block% = 0 AND PrevBlock% = 255 THEN BlockHi% = BlockHi% + 1
      bdta = dta$
      PUT #Filenum, Block% + (BlockHi% * 256), bdta$
      PrevBlock% = Block%
      FirstOk% = true%

      COMPRINT ACK$
    END IF

  LOOP UNTIL Start$ = CAN$ OR Start$ = EOT$ OR Retries% > 10

  IF Start$ <> EOT$ THEN GOTO XmodemReceiveAbort

  Retries% = 0
  DO
    Retries% = Retries% + 1
    COMPRINT ACK$
    CALL GetXChar(Ch$, toolong%, x%)
    'IF Instat THEN
    '  k$ = INKEY$
    '  IF k$ = CHR$(27) THEN Ch$ = CAN$
    'END IF
  LOOP UNTIL Ch$ <> EOT$ OR Retries% > 10

  IF Retries% < 11 AND Ch$ <> CAN$ THEN
    success% = true%
    GOTO XmodemReceiveExit
  END IF

XmodemReceiveAbort:
  COMPRINT STRING$(5, CAN$) + STRING$(5, 8)

XmodemReceiveExit:
  CLOSE #Filenum
  IF success% = false% THEN KILL filename$
END SUB 'XmodemReceive

SUB LOCALPRINT(Oput$)
For i%=1 to len(Oput$)
	Reg 1,&h200
	Reg 4,asc(Mid$(OPut$,i%,1))
	CALL INTERRUPT &H21
Next i%
$ENDIF
END SUB
