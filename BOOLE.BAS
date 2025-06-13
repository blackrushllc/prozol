SUB BOOLE (B$)
' find .AND. .OR. .NOT. etc and modify boolean recursively
IF INSTR(B$,".AND.") THEN
p%=instr(B$,".AND.")
C$=MID$(B$,p%+5):CALL BOOLE(C$)
B$=LEFT$(B$,p%+4)+C$


ELSEIF INSTR(B$,".OR.") THEN

ELSEIF INSTR(B$,".NOT.") THEN

END IF

END SUB
