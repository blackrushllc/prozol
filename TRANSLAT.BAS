SUB translate (b$)
SHARED CommonVarFile$
DO
A = INSTR(b$, "<")
IF A = 0 THEN EXIT DO
b = INSTR(A, b$, ">"): IF b = 0 THEN EXIT DO
IF b = A + 1 THEN EXIT DO
C = b - (A + 1)
v$ = MID$(b$, A + 1, C)
Va$=GETVAR$((V$))
IF Va$="" THEN
	Fi%=FREEFILE
	OPEN COMMONVARFILE$ FOR RANDOM SHARED AS #Fi% LEN=LEN(CommonVar)
	FOR r% = 1 TO LOF(Fi%)\LEN(CommonVar)
		GET Fi%, r%, CommonVar
		IF ucase$(LEFT$(CommonVar.Variable,LEN(v$)+1))_
		     = ucase$(v$)+"=" THEN_
			va$=rtrim$(ltrim$(CommonVar.Value)):EXIT FOR
       NEXT r%
	Close Fi%
end if
REPLACE "<"+v$+">" WITH Va$ IN b$ 'added 10/20
LOOP
END SUB

