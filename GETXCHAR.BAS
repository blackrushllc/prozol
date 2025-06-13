SUB GetXChar (Ch$, toolong%, x%)
$IF NOT %NOXMODEM
  toolong% = 1
  Ch$ = CHR$(0)
  Tstart! = TIMER


  WHILE Comchars%=0 AND TIMER - Tstart! <= x%

    WEND

  IF Comchars% THEN
    Ch$ = COMINKEY$
    toolong% = 0
    END IF
$ENDIF
END SUB

