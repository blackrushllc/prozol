SUB DMMENU (WA AS INTEGER, WB AS INTEGER, WC AS INTEGER, WD AS INTEGER, title$, item$())
WA = WA - 1: WB = WB - 1: WC = WC + 1: WD = WD + 1
IF tty THEN

	FOR zxy = 0 TO WC - WA
		IF zxy = 0 THEN

		ELSEIF zxy = 1 THEN
                PROZOPRINT title$ + CrLf$
		ELSEIF zxy = 2 THEN
		ELSE
                PROZOPRINT item$(zxy - 2) + CrLf$: IF LEN(item$(zxy - 2)) THEN items = items + 1
		END IF
	NEXT zxy
ELSE
FOR zxy = 0 TO WC - WA
A$ = CHR$(27) + "[" + MID$(STR$(WA + zxy), 2) + ";" + MID$(STR$(WB), 2) + "f"
IF zxy < 3 THEN PROZOPRINT A$ + CHR$(179) + SPACE$((WD - WB) - 1) + CHR$(179) ELSE PROZOPRINT A$ + CHR$(179) + "  " + LEFT$(item$(zxy - 2) + SPACE$(80), (WD - WB) - 3) + CHR$(179): item$(zxy - 2) = ""
NEXT zxy

'***PROZOPRINT the window
PROZOLOCATE WA, WB: PROZOPRINT CHR$(213): PROZOLOCATE WA, WD: PROZOPRINT CHR$(184): PROZOLOCATE WC, WB: PROZOPRINT CHR$(212): PROZOLOCATE WC, WD: PROZOPRINT CHR$(190)
PROZOLOCATE WA, WB + 1: PROZOPRINT STRING$((WD - WB) - 1, 205): PROZOLOCATE WC, WB + 1: PROZOPRINT STRING$((WD - WB) - 1, 205)

'***PROZOPRINT the header and the item list
PROZOLOCATE WA + 1, WB + (INT((WD - WB) / 2) - INT(LEN(title$) / 2))
PROZOPRINT title$
END IF
END SUB

