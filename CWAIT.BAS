SUB CWAIT
  LET dropout# = TIMER + 300
  StartCwaitLoop:
  CALL DVPAUSE
  IF LEN(PROZOINKEY$) THEN EXIT SUB
  if comline and direct$="" then
  IF TIMER > dropout# THEN CALL TIMEOUT
  end if
  GOTO StartCwaitLoop

END SUB

