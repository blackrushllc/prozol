SUB DMXMENU (WA as integer, WB as integer, WC  as integer, WD as integer, title$, item$())
IF Global$(4)="" THEN Global$(4)="^C^w^B"
PROZOPRINT GLOBAL$(4)
WA = WA - 1: WB = WB - 1: WC = WC + 1: WD = WD + 1
IF tty THEN

	FOR zxy = 0 TO WC - WA
		IF zxy = 0 THEN
                'PROZOPRINT "*" + STRING$((WD - WB) - 1, "*") + "*" + CrLf$
		ELSEIF zxy = 1 THEN
                PROZOPRINT title$ + " (" + Global$(1)+")" + CrLf$
		ELSEIF zxy = 2 THEN
                PROZOPRINT CrLf$
		ELSE
                PROZOPRINT "  " + LEFT$(item$(zxy - 2) + SPACE$(80), (WD - WB) - 3) + "  " + CrLf$: IF LEN(item$(zxy - 2)) THEN items = items + 1
		END IF
	NEXT zxy
		DO
                PROZOPRINT "Select (1-" + MID$(STR$(items), 2) + ") --> "
                value$=PROZOINPUT$
                if ucase$(value$)="X" then value$="0":exit do
                if value$="" then value$="0": exit do
                v = VAL(Value$)
		IF v <= items AND v > 0 THEN EXIT DO
		LOOP
                PUSHARG Value$
	' items = max value


ELSE
        IF LEN(Global$(4)) THEN PROZOPRINT Global$(4)
	FOR zxy = 0 TO WC - WA
		A$ = CHR$(27) + "[" + MID$(STR$(WA + zxy), 2) + ";" + MID$(STR$(WB), 2) + "f"
		IF zxy < 3 THEN
                PROZOPRINT A$ + CHR$(186) + SPACE$((WD - WB) - 1) + CHR$(186)
		ELSE
		ansipos$ = CHR$(27) + "[" + MID$(STR$(WA + zxy), 2) + ";" + MID$(STR$(WB + 3), 2) + "f"
                PROZOPRINT A$ + CHR$(186) + "  " + LEFT$(item$(zxy - 2) + SPACE$(80), (WD - WB) - 3) + CHR$(186): IF LEN(item$(zxy - 2)) THEN items = items + 1: item$(zxy - 2) = ansipos$ + item$(zxy - 2)
		END IF
	NEXT zxy


'***PROZOPRINT the window corners
PROZOLOCATE WA, WB
PROZOPRINT CHR$(201)
PROZOLOCATE WA, WD
PROZOPRINT CHR$(187)
PROZOLOCATE WC, WB
PROZOPRINT CHR$(200)
PROZOLOCATE WC, WD
PROZOPRINT CHR$(188)
PROZOLOCATE WA, WB + 1
' PROZOPRINT the window top and bottom
PROZOPRINT STRING$((WD - WB) - 1, 205)
PROZOLOCATE WC, WB + 1
PROZOPRINT STRING$((WD - WB) - 1, 205)
PROZOLOCATE WA, WB + 1
PROZOPRINT "^0^B^b[" + Global$(1) + "]^0^B" + Global$(4)

'***PROZOPRINT the menu title
IF LEN(Title$) THEN
PROZOLOCATE WA+1, WB + (INT((WD - WB) / 2) - INT(LEN(title$) / 2))
PROZOPRINT title$
END IF
item = 1
Redrawbox:
Redrawflag%=0
Ten#=TIMER+10
Prick#=TIMER+50
Dropout#=TIMER+300
dO
PROZOPRINT " ^0^I^B" + item$(item)
Value$ = ""
DO WHILE Value$ = ""
Value$=PROZOINKEY$
$IF NOT %NOTASKS
CALL TASKMAN
$ENDIF
REM FORK WENT HERE
IF Value$ = CHR$(13) OR Value$ = CHR$(3) OR UCASE$(Value$)="X" THEN EXIT DO
IF Value$="G" OR Value$=CHR$(7) THEN GoFlag%=-1:EXIT DO
IF INSTR("X0123456789ABCD+- "+CHR$(13), Value$) = 0 THEN Value$ = ""
if comline and direct$="" then
  IF Timer > Ten# THEN LET Ten# = TIMER + 10:IF OLM% AND Value$="" THEN CALL GETOLM:LET Prick# = TIMER + 50:LET DropOut#=Timer+300:Redrawflag%=-1
  IF Timer > Prick# THEN LET Prick#=Timer + 50:PROZOPRINT CHR$(7)
  IF TIMER > dropout# OR TIMER > UserTime# THEN PROZOPRINT CHR$(7): CALL TIMEOUT:Redrawflag%=-1
end if
LOOP
IF Redrawflag% THEN GOTO Redrawbox
IF  GoFlag% THEN EXIT DO
IF Value$=CHR$(13) OR Value$ = CHR$(3) OR UCASE$(Value$)="X" THEN EXIT DO
IF val(Value$)>0 and val(value$)<items+1 then CALL PROZOPRINT("^0^B" + Global$(4) + item$(item)):item=val(value$):PROZOPRINT " ^0^I^B" + item$(item):exit do
CALL PROZOPRINT("^0^B" + Global$(4) + item$(item))
IF VAL(Value$) THEN item = VAL(Value$): IF item > items THEN item = 1
CALL PROZOPRINT("^0^B" + Global$(4) + item$(item))
IF INSTR(" +B", Value$) THEN item = item + 1 ELSE IF INSTR("-A", Value$) THEN item = item - 1 ELSE xtries = xtries + 1: IF xtries > 50 THEN CALL SYSRESET
IF item = 0 THEN item = items
IF item > items THEN item = 1
LOOP
IF GoFlag% THEN CALL GETGO:IF GoFlag%=0 THEN GOTO RedrawBox
IF UCASE$(Value$) = "X" THEN item = 0
IF Value$ = CHR$(3) THEN CALL SYSRESET
PUSHARG MID$(STR$(item), 2)

END IF
FOR q = 1 TO items: LET item$(q) = "": NEXT q
END SUB

