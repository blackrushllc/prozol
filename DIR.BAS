SUB DIR (Arg$)
IF Arg$="" THEN Arg$="*.*"
OUTSTREAM "Directory {"+Arg$+"}"+CrLf$
A$=DIR$(Arg$)
DO
A$=A$+SPACE$(20-len(A$))
OUTSTREAM A$
A$=DIR$
LOOP WHILE A$<>""
OUTSTREAM CrLf$+CrLf$
END SUB

