SUB TASKMAN
' TASKS(n) is a shared variable which indicates if backgrounds tasks 1
' through 16 are active.  A background task is a single prozol procedure
' which can be defined and executed in the background
IF CurrentDepth%>TaskDepth% THEN EXIT SUB
INCR CurrentDepth%
FOR T=1 to 16
        IF Task(T)>0 THEN
                INCR TaskLine(T)
                IF T=100 Then Task(T)=0:TaskLine(T)=0:ITERATE FOR
                PROZOL TaskProg$(T,TaskLine(T))

        END IF
NEXT Y
DECR CurrentDepth%
END SUB
