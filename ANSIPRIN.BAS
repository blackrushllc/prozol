SUB ANSIPrint(BYVAL Oput$)

For i%=1 to len(Oput$)
	Reg 1,&h200
	Reg 4,asc(Mid$(OPut$,i%,1))
	CALL INTERRUPT &H21
Next i%

END SUB

