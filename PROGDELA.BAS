SUB ProgDelay (seconds%)
LET temp! = TIMER + seconds%
WHILE TIMER < temp!
CheckCarrier
$IF NOT %NOTASKS
CALL TASKMAN
$ENDIF
REM FORK WENT HERE **
WEND
END SUB

