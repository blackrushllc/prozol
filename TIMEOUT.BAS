SUB TIMEOUT
IF TIMER > USERTIME# THEN PROZOCLS:PROZOPRINT "SORRY.  Your time limit has been exceeded for this session.  Please call back."+CrLf$:ERROR 1
IF tty THEN
PROZOPRINT CrLf$ + CrLf$
PROZOPRINT CHR$(7) + "Press [ENTER] to continue, or logout in 30 seconds..." + CrLf$ + CHR$(7)
  LET dropout# = TIMER + 30
  DO
  CALL DVPAUSE
  A$=PROZOINKEY$
  IF TIMER > dropout# THEN ERROR 1
  LOOP WHILE A$=""

IF A$ = CHR$(3) THEN ERROR 1
ELSE ' if ansi then
 PROZOPRINT "^B^F^R^w@CHR(7)"
 PROZOL "WINDOW 20,15,20,65;'Press [ENTER] to continue, or logout in 30 seconds...'"
  LET dropout# = TIMER + 30
  DO
  A$=PROZOINKEY$
  IF TIMER > dropout# THEN ERROR 1
  LOOP WHILE A$=""

IF A$ = CHR$(3) THEN ERROR 1
end if
END SUB

