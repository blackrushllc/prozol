SUB dmwindo (WA as integer, WB as integer, WC as integer, WD as integer, title$, item$())

WA = WA - 1: WB = WB - 1: WC = WC + 1: WD = WD + 1
	FOR zxy = 0 TO WC - WA
	A$ = CHR$(27) + "[" + MID$(STR$(WA + zxy), 2) + ";" + MID$(STR$(WB), 2) + "f"
        IF zxy < 3 THEN PROZOPRINT A$ + CHR$(186) + SPACE$((WD - WB) - 1) + CHR$(186) ELSE PROZOPRINT A$ + CHR$(186) + "  " + LEFT$(item$(zxy - 2) + SPACE$(80), (WD - WB) - 3) + CHR$(186): item$(zxy - 2) = ""
	NEXT zxy

'***PROZOPRINT the window
PROZOLOCATE WA, WB: PROZOPRINT CHR$(201): PROZOLOCATE WA, WD: PROZOPRINT CHR$(187): PROZOLOCATE WC, WB: PROZOPRINT CHR$(200): PROZOLOCATE WC, WD: PROZOPRINT CHR$(188)
PROZOLOCATE WA, WB + 1: PROZOPRINT STRING$((WD - WB) - 1, 205): PROZOLOCATE WC, WB + 1: PROZOPRINT STRING$((WD - WB) - 1, 205)
PROZOLOCATE WA, WB + 1: PROZOPRINT "[" + Global$(1) + "]"
'***PROZOPRINT the header And the item list
PROZOLOCATE WA + 1, WB + (INT((WD - WB) / 2) - INT(LEN(title$) / 2))
PROZOPRINT title$

PROZOLOCATE WC - 1, WB + 2
PROZOPRINT " Select --> "
VALUE$=PROZOINPUT$
PUSHARG Value$
END SUB


