SUB EDLIN (Fi$)
        IF Fi$="" THEN
                PROZOPRINT "No filename specified."+CHR$(7)+CrLf$
                EXIT SUB
        END IF
        DIM FB$(5000)
        IF Dir$(Fi$) <>"" THEN
                FF=FREEFILE
                OPEN Fi$ FOR INPUT AS #FF
                DO UNTIL EOF(1)
                INCR X
                LINE INPUT #1,FB$(X)
                IF X=5000 THEN
                        PROZOPRINT "File too big, 5000 lines loaded."+CHR$(7)+CrLf$
                        EXIT LOOP
                END IF
                LOOP
                CLOSE #FF
        ELSE
                PROZOPRINT "New file."+CrLf$
        END IF

X=1
DO
        PROZOPRINT "*"
        A$=PROZOINPUT$
        A$=LTRIM$(A$)
        IF ExitFlag% THEN EXIT SUB
        IF A$="" THEN GOSUB EdlinHelp:ITERATE LOOP
        C$=LEFT$(A$,1)
        IF LEN(A$)>1 THEN A$=LTRIM$(MID$(A$,2)) ELSE A$=""
        SELECT CASE UCASE$(C$)
                CASE "N"
                	if len(a$) then if not instr(a$,"\") then fi$=A$
                CASE "Q"
                        QuitFlag%=%TRUE
                CASE "W","E"
                        FOR X=1 TO 5000
                        IF LEN(FB$(X)) THEN Y=X
                        NEXT X
                        'IF LEN(A$) THEN Fi$=LTRIM$(A$)
                        OPEN Fi$ FOR OUTPUT AS #FF
                        FOR X=1 TO Y
                                PRINT #FF, FB$(X)
                        NEXT X
                        CLOSE #FF
                        PROZOPRINT STR$(Y)+" lines written to " + FI$+CrLf$

                        IF UCASE$(C$)="E" THEN QuitFlag%=%TRUE

                CASE "L"
                        IF INSTR(A$,ANY " ,;:") THEN Z=VAL(MID$(A$,_
                         INSTR(A$,ANY " ,;:")+1)):A$=LEFT$(A$,_
                         INSTR(A$,ANY " ,;:")-1) ELSE Z=0
                        IF LEN(A$) THEN X=VAL(A$)
                        IF X=0 THEN X=1
                        IF Z=0 THEN Z=1
                        FOR Y=X TO X+(Z-1)
                                K$=PROZOINKEY$:IF len(K$) THEN EXIT FOR
                                PROZOPRINT LTRIM$(STR$(Y))+" "+FB$(Y)+CrLf$
                        NEXT Y
                CASE "D"
                        IF INSTR(A$,ANY " ,;:") THEN Z=VAL(MID$(A$,_
                         INSTR(A$,ANY " ,;:")+1)):A$=LEFT$(A$,_
                         INSTR(A$,ANY " ,;:")-1) ELSE Z=0
                        IF LEN(A$) THEN X=VAL(A$)
                        IF X>0 THEN
                                IF Z=0 THEN
                                        FB$(5000)=""
                                        FOR YY=X TO 4999
                                         FB$(YY)=FB$(YY+1)
                                        NEXT X
                                        'ARRAY DELETE FB$(X)
                                        PROZOPRINT "Line"+STR$(X)+" deleted."+CrLf$
                                ELSE
                                        IF Z<5000-X THEN
                                        FOR Y=X TO X+(Z-1)
                                                FB$(5000)=""
                                                FOR YY=X TO 4999
                                                 FB$(YY)=FB$(YY+1)
                                                NEXT YY
                                                'ARRAY DELETE FB$(Y)
                                        NEXT Y
                                        PROZOPRINT STR$(Z)+" lines deleted."+CrLf$
                                        ELSE
                                        PROZOPRINT CHR$(7)+"Error: too many lines specified"+CrLf$
                                        END IF
                                END IF
                        ELSE
                                PROZOPRINT "No lines deleted."+CrLf$
                        END IF

                CASE "I"
                        IF VAL(A$) THEN
                                X=VAL(A$)
                                IF X<5001 THEN
                                 GetMore:
                                 PROZOPRINT LTRIM$(STR$(X))+" "
                                 A$=PROZOINPUT$
                                  IF A$="" THEN
                                        PROZOPRINT "Insert finished."+CrLf$
                                  ELSE
                                        ARRAY INSERT FB$(X),A$
                                        INCR X
                                        GOTO GetMore
                                  END IF
                                 END IF
                        ELSE
                                PROZOPRINT "No insert line specified."+CrLf$
                        END IF

                CASE "A"
                        X=0
                        FOR Y=1 TO 5000
                        IF LEN(FB$(Y)) THEN X=Y
                        NEXT Y
                        INCR X
                        IF X<5001 THEN
                         GetMore2:
                         PROZOPRINT LTRIM$(STR$(X))+" "
                         A$=PROZOINPUT$
                          IF A$="" THEN
                                PROZOPRINT "Append finished."+CrLf$
                          ELSE
                                FB$(X)=A$
                                INCR X
                                GOTO GetMore2
                          END IF
                         END IF
                CASE ELSE
                        IF VAL(C$+A$) THEN
                         X=VAL(C$+A$)
                         PROZOPRINT LTRIM$(STR$(X))+" "+FB$(X)+CrLf$
                         OldV$=FB$(X)
                         A$=PROZOINPUT$
                         IF A$<>"" THEN FB$(X)=A$ ELSE PROZOPRINT "Edit aborted."+CrLf$
                        END IF
               END SELECT

LOOP UNTIL QuitFlag%
EXIT SUB

EdlinHelp:
PROZOPRINT "Editor help - " +CrLf$
PROZOPRINT "The character * is your command prompt.  When you see this character you" +CrLf$
PROZOPRINT "May enter a line number to edit followed by a carriage return.  The editor" + CrLf$
PROZOPRINT "will show you the line as it currently is and you may edit it.  Or, you may"+CrLf$
PROZOPRINT "enter any one of these one-letter commands:"+CrLf$+CrLf$
PROZOPRINT "Q - Quit without saving"+CrLf$
PROZOPRINT "W - Save the document as it currently is, then continue"+CrLf$
PROZOPRINT "E - Save and then Quit"+CrLf$
PROZOPRINT "L - List, follow L with a line number, and an optional number of lines, i.e."+CrLf$
PROZOPRINT "    L20 will list on the screen just line 20, or"+CrLf$
PROZOPRINT "    L1,10 will just list 10 lines starting at line 1"+CrLf$
PROZOPRINT "D - Delete one line (i.e. D20) or add a number of lines to delete (i.e. D1,10)"+CrLf$
PROZOPRINT "I - Followed by a line number, allows you to begin typing and inserting lines"+CrLf$
PROZOPRINT "A - Begins accepting lines of text to append to the document"+CrLf$
PROZOPRINT "    Also use  A  or  I1  to start typing a new document"+CrLf$
PROZOPRINT "N - followed by a filename will change the name of the document"+CrLf$
return
END SUB


