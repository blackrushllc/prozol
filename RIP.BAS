$IF NOT %NORIP
SUB RIP (S$)
        if s$="" then exit sub
	RipPrint "!|"
	if val(left$(s$,1)) then
        	ripprint left$(s$,2)
                s$=mid$(s$,3)
        else
        	RipPrint left$(s$,1)
                s$=mid$(s$,2)
        end if
        if s$="" then RipPrint chr$(13):exit sub
        for y=1 to len(s$)
        	b$=mid$(s$,y,1)
                if b$="2" then
                	RipPrint meganum2$(val(poparg$))
                        iterate for
                end if

                if b$="1" then
                	RipPrint meganum1$(val(poparg$))
                	iterate for
                end if

                if b$="3" then
                	RipPrint meganum3$(val(poparg$))
                        iterate for
        	end if
                if b$="4" then
                	RipPrint meganum4$(val(poparg$))
		end if

                if b$="$" then
                	RipPrint poparg$
        		iterate for
                end if

                if instr("<>[]?",b$) then
                	RipPrint b$
                        iterate for
                end if

                if b$="0" then
                	RipPrint "0"
                        iterate for
                end if

                if litflag then
                	RipPrint b$
                        litflag=%false
                	iterate for
                end if

                if b$="_" then
                	litflag=%true
                end if
	next y
        RipPrint chr$(13)
END SUB

FUNCTION MEGANUM1$(n%)
	if n%<36 then
        	MEGANUM1$=MID$("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ",n%+1,1)
	else
        	MEGANUM1$="0"
	end if
END FUNCTION

FUNCTION MEGANUM2$(n%)
	if n%<36 THEN
        	MEGANUM2$="0"+MID$("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ",n%+1,1)
	else
                h%=(n%\36)
                l%=n%-(h%*36)
                h$=MID$("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ",h%+1,1)
                l$=MID$("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ",l%+1,1)
		MEGANUM2$=h$+l$
	end if
END FUNCTION



FUNCTION MEGANUM3$(n%)
	if n%<36 THEN
        	MEGANUM3$="00"+MID$("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ",n%+1,1)
	else
                h%=(n%\36)
                l%=n%-(h%*36)
                h$=MID$("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ",h%+1,1)
                l$=MID$("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ",l%+1,1)
		MEGANUM3$="0"+h$+l$
	end if
END FUNCTION


FUNCTION MEGANUM4$(n&)
radix=36
                d4&=n&\(radix*radix*radix)
                d3&=(n& - (d4&*(radix*radix*radix)) )\(radix*radix)

                d2&=(n&- ((d4&*(radix*radix*radix)) + (d3&*(radix*radix))))\radix

                d1&= n&-((d4&*(radix*radix*radix))+(d3&*(radix*radix))+(d2&*radix))


                d4$=MID$("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ",d4&+1,1)
                d3$=MID$("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ",d3&+1,1)
                d2$=MID$("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ",d2&+1,1)
                d1$=MID$("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ",d1&+1,1)
		MEGANUM4$=d4$+d3$+d2$+d1$
END FUNCTION



sub ripprint (x$)
	comprint x$
        ansiprint x$
end sub


$ENDIF