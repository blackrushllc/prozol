for y=1 to 100:ansiprint chr$(13,10):next y
ansiprint meganum2$(333)


FUNCTION MEGANUM2$(n%)
	if n%<36 THEN
        	MEGANUM2$="0"+MID$("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ",n%+1,1)
	else
                h%=(n%\36)
                l%=n%-(h%*36)
                ansiprint "{"+str$(h%)+"}"+CHR$(13,10)+"{"+str$(l%)+"}"+CHR$(13,10,13,10)
                h$=MID$("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ",h%+1,1)
                l$=MID$("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ",l%+1,1)
		MEGANUM2$=h$+l$
	end if
END FUNCTION

SUB ANSIPrint(BYVAL Oput$)

For i%=1 to len(Oput$)
	Reg 1,&h200
	Reg 4,asc(Mid$(OPut$,i%,1))
	CALL INTERRUPT &H21
Next i%

END SUB

