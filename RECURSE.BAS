SUB RECURSE (c$)
' THIS ROUTINE CALCULATES THE VALUE OF AN INLINE EQUASION (recursive decent)
' inlines can be nested 3/13/93
b$=c$
DO
aA = INSTR(b$, "[")                ' find first [
IF aA = 0 THEN EXIT DO             ' if none then quit
n=instr(aA+1,B$, "[")              ' find a second [

IF n THEN                         ' if it is there then
' recursive                       ' grab everything after first [
	d$=mid$(B$,aa+1)           '
	CALL RECURSE(D$)          ' call recurse on that
	B$=LEFT$(B$,aa)+D$         ' add result to left up to first [
END IF                            '
b = INSTR(aA, b$, "]"): IF b = 0 THEN EXIT DO ' if no ] then quit
IF b = aA + 1 THEN EXIT DO         ' if [] then quit
C = b - (aA + 1)                   ' extract the equasion
v$ = MID$(b$, aA + 1, C)           ' put equasion into v$
Va$=MID$(STR$(CALC(v$)),2)        ' calculate value of v$
REPLACE "["+v$+"]" WITH Va$ IN b$ ' replace the calculation with result
LOOP 				  ' keep going until no more [
c$=b$                             ' return result in original parameter
END SUB


FUNCTION Calc (A$)
SHARED Token$, TokenType, P, Arg$
IF INSTR(A$,"@") THEN FUNCTIONS A$
Arg$=A$
R = 0
P = 1
IF Arg$ = "" THEN GOTO EndCalcSub
CALL GetExp(R)
LET Calc = R
EndCalcSub:
END FUNCTION


SUB Arith (O$, R, H)
SHARED Arg$, Token$, TokenType, P
IF O$ = "-" THEN R = R - H
IF O$ = "+" THEN R = R + H
IF O$ = "*" THEN R = R * H
IF O$ = "/" THEN R = R / H
IF O$ = "^" THEN R = R ^ H
IF O$ = "<" THEN R = R < H
IF O$ = ">" THEN R = R > H
IF O$ = "=" THEN R = R = H
END SUB

SUB GetExp (R)
SHARED Arg$, Token$, TokenType, P
CALL GetToken
CALL Level1(R)
END SUB

SUB GetToken
SHARED Arg$, Token$, TokenType, P
Token$ = ""
WHILE MID$(Arg$, P, 1) = " ": P = P + 1: WEND
'Tokentype 1 is an operator
IF INSTR(MID$(Arg$, P, 1), ANY "-+*/^()<>=") THEN TokenType = 1: Token$ = MID$(Arg$, P, 1): P = P + 1: EXIT SUB
'Toekentype 2 is a number
IF INSTR(MID$(Arg$, P, 1), ANY "0123456789.") THEN WHILE INSTR(" -+*/^()<>=", MID$(Arg$, P, 1)) = 0: Token$ = Token$ + MID$(Arg$, P, 1): P = P + 1: WEND: TokenType = 2:EXIT SUB
WHILE INSTR(" -+*/^()<>=01234567890.", MID$(Arg$, P, 1)) = 0: Token$ = Token$ + MID$(Arg$, P, 1): P = P + 1: WEND: TokenType = 3
END SUB

SUB Level1 (R)
SHARED Arg$, Token$, TokenType, P
CALL Level2(R): O$ = Token$
WHILE O$ = "<" OR O$ = ">" OR O$ = "="
CALL GetToken
CALL Level2(H)
CALL Arith(O$, R, H)
O$ = Token$
WEND
END SUB

SUB Level2 (R)
SHARED Arg$, Token$, TokenType, P
CALL Level3(R)
O$ = Token$
WHILE O$ = "+" OR O$ = "-"
CALL GetToken
CALL Level3(H)
CALL Arith(O$, R, H)
O$ = Token$
WEND
END SUB

SUB Level3 (R)
SHARED Arg$, Token$, TokenType, P
CALL Level4(R)
O$ = Token$
WHILE O$ = "*" OR O$ = "/"
CALL GetToken
CALL Level4(H)
CALL Arith(O$, R, H)
O$ = Token$
WEND
END SUB

SUB Level4 (R)
SHARED Arg$, Token$, TokenType, P
CALL Level5(R)
IF Token$ = "^" THEN CALL GetToken: CALL Level4(H): CALL Arith("^", R, H)
END SUB

SUB Level5 (R)
SHARED Arg$, Token$, TokenType, P
O$ = ""
IF TokenType = 1 AND (Token$ = "+" OR Token$ = "-") THEN O$ = Token$: CALL GetToken
CALL Level6(R): IF O$ <> "" THEN CALL Un(O$, R)
END SUB

SUB Level6 (R)
SHARED  Arg$, Token$, TokenType, P
IF Token$ = "(" AND TokenType = 1 THEN 230
CALL Ptv(R): EXIT SUB
230 CALL GetToken
CALL Level1(R)
IF Token$ <> ")" THEN PRINT "Mismatched Parenthesis"  ' or use ERROR nn
CALL GetToken
END SUB

SUB Ptv (R)
SHARED Arg$, Token$, TokenType, P
IF TokenType = 2 THEN R = VAL(Token$): CALL GetToken: EXIT SUB
PRINT "Bad Syntax"   ' or use ERROR nn
END SUB

SUB Un (O$, R)
SHARED Arg$, Token$, TokenType, P
IF O$ = "-" THEN R = -R
END SUB

