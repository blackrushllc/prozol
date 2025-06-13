' All of the following subroutines are necessary to perform the recursive
' descent parser.  CALC is the only callable routine, and must be passed
' a string containing a valid math expression.
' An invalid expression, such as (2**4) or (1+2+3+) will result in a
' SYNTAX ERROR message, printed on the screen by the sub PTV().  Mismatched
' parenthesis result in an error message displayed by sub LEVEL6().  These
' error messages could be replaced with the ERROR nn statement, allowing your
' own error-handling routines to report the error.
'
' This routine supports boolean expressions (1>2) and unary operators (5*-1)
DEFDBL A-Z
FUNCTION Calc (byval A$)
'EVALUATE A$, Result!, ErrCode%
'Calc=Result!
'IF ErrCode% THEN ERROR 101
R = 0
P = 1
IF A$ = "" THEN GOTO EndCalcSub
Arg$=A$
CALL GetExp(R)
LET Calc = R
EndCalcSub:
END FUNCTION

SUB Arith (OO$, R, H)
IF OO$ = "-" THEN R = (R - H)
IF OO$ = "+" THEN R = (R + H)
IF OO$ = "*" THEN R = (R * H)
IF OO$ = "/" THEN R = (R / H)
IF OO$ = "^" THEN R = (R ^ H)
IF OO$ = "<" THEN R = (R < H)
IF OO$ = ">" THEN R = (R > H)
IF OO$ = "=" THEN R = (R = H)
END SUB

SUB GetExp (R)
CALL GetToken
CALL Level1(R)
END SUB

SUB GetToken
Token$ = ""
WHILE MID$(Arg$, P, 1) = " ": incr P: WEND
IF INSTR("-+*/^()<>=", MID$(Arg$, P, 1)) THEN TokenType = 1: Token$ = MID$(Arg$, P, 1): P = P + 1: EXIT SUB
IF INSTR("01234567890.",MID$(Arg$, P, 1)) THEN WHILE INSTR(" -+*/^()<>=", MID$(Arg$, P, 1)) = 0: Token$ = Token$ + MID$(Arg$, P, 1): P = P + 1: WEND: TokenType = 2
END SUB

SUB Level1 (R)
CALL Level2(R): OO$ = Token$
WHILE OO$ = "<" OR OO$ = ">" OR OO$ = "="
CALL GetToken
CALL Level2(H)
CALL Arith(OO$, R, H)
OO$ = Token$
WEND
END SUB

SUB Level2 (R)
CALL Level3(R)
OO$ = Token$
WHILE OO$ = "+" OR OO$ = "-"
CALL GetToken
CALL Level3(H)
CALL Arith(OO$, R, H)
OO$ = Token$
WEND
END SUB

SUB Level3 (R)
CALL Level4(R)
OO$ = Token$
WHILE OO$ = "*" OR OO$ = "/"
CALL GetToken
CALL Level4(H)
CALL Arith(OO$, R, H)
OO$ = Token$
WEND
END SUB

SUB Level4 (R)
CALL Level5(R)
IF Token$ = "^" THEN CALL GetToken: CALL Level4(H): CALL Arith("^", R, H)
END SUB

SUB Level5 (R)
OO$ = ""
IF TokenType = 1 AND (Token$ = "+" OR Token$ = "-") THEN OO$ = Token$: CALL GetToken
CALL Level6(R): IF OO$ <> "" THEN CALL Un(OO$, R)
END SUB

SUB Level6 (R)
IF Token$ = "(" AND TokenType = 1 THEN 230
CALL Ptv(R): EXIT SUB
230 CALL GetToken
CALL Level1(R)
IF Token$ <> ")" THEN ERROR 102
CALL GetToken
END SUB

SUB Ptv (R)
IF TokenType = 2 THEN R = VAL(Token$): CALL GetToken: EXIT SUB
ERROR 101
END SUB

SUB Un (OO$, R)
IF OO$ = "-" THEN R = -R
END SUB

DEFINT A-Z
