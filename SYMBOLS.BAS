SUB symbols (Prog$)
DO
x = INSTR(Prog$, "^")
aa$ = LEFT$(Prog$, x - 1)
IF x + 2 <= LEN(Prog$) THEN bb$ = MID$(Prog$, x + 2) ELSE bb$ = ""
Arg$ = MID$(Prog$, x + 1, 1)
nopr = 1
SELECT CASE Arg$

        ' attributes
        CASE "0"
	Result$ = CHR$(27) + "[" + "0" + "m"
        CASE "_"
	Result$ = CHR$(27) + "[" + "4" + "m"
	CASE "I"
	Result$ = CHR$(27) + "[" + "7" + "m"
	CASE "F"
	Result$ = CHR$(27) + "[" + "5" + "m"
	CASE "B"
	Result$ = CHR$(27) + "[" + "1" + "m"
	CASE "P"
	nopr = 0
	Result$ = CHR$(27) + "@"
	CASE "p"
	nopr = 0
	Result$ = CHR$(27) + "A"

        ' foreground colors
        CASE "n"
	Result$ = CHR$(27) + "[" + "30" + "m"
	CASE "r"
	Result$ = CHR$(27) + "[" + "31" + "m"
	CASE "g"
	Result$ = CHR$(27) + "[" + "32" + "m"
	CASE "y"
	Result$ = CHR$(27) + "[" + "33" + "m"
	CASE "b"
	Result$ = CHR$(27) + "[" + "34" + "m"
	CASE "m"
	Result$ = CHR$(27) + "[" + "35" + "m"
	CASE "c"
	Result$ = CHR$(27) + "[" + "36" + "m"
	CASE "w"
	Result$ = CHR$(27) + "[" + "37" + "m"

        ' background colors
        CASE "N"
	Result$ = CHR$(27) + "[" + "40" + "m"
        CASE "R"
	Result$ = CHR$(27) + "[" + "41" + "m"
        CASE "G"
	Result$ = CHR$(27) + "[" + "42" + "m"
        CASE "Y"
	Result$ = CHR$(27) + "[" + "43" + "m"
        CASE "U"  ' Underline (blue)
	Result$ = CHR$(27) + "[" + "44" + "m"
        CASE "M"
	Result$ = CHR$(27) + "[" + "45" + "m"
        CASE "C"
	Result$ = CHR$(27) + "[" + "46" + "m"
        CASE "W"
	Result$ = CHR$(27) + "[" + "47" + "m"

CASE ELSE

Result$ = CHR$(27) + "[" + Arg$ + "m"

END SELECT

IF tty AND nopr THEN Result$ = ""
IF Result$ <> "" THEN Prog$ = aa$ + Result$ + bb$ ELSE Prog$ = aa$ + bb$
LOOP WHILE INSTR(Prog$, "^")
END SUB

