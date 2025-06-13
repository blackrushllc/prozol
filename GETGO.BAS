sub getgo
if tty then
PROZOPRINT crlf$+"Enter program name to GO:"
value$=PROZOinput$
if value$="" THEN goflag%=0:exit sub
IF GETVAR$("$$"+Value$+"$$")="" THEN goflag%=0:PROZOPRINT CrLf$+Value$+" PROGRAM NOT FOUND!"+CrLf$:PROZOPRINT CHR$(7)+CHR$(7)+CHR$(7):DELAY 2:EXIT SUB
PROZOL GETVAR$("$$"+Value$+"$$")
else
call PROZOL("prompt '@SCP()^B^G^y@CHR(7)'")
call PROZOL("window 20,30,20,50;'GO:_______________'")
call PROZOL("locate 20,34")
value$=PROZOinput$
if value$="" THEN goflag%=0:exit sub
if Getvar$("$$"+value$+"$$")="" then
goflag%=0
PROZOL "PROMPT '^R^w'"
PROZOL "WINDOW 20,20,20,60;'PROGRAM NOT FOUND!'"
PROZOPRINT CHR$(7)+CHR$(7)+CHR$(7):DELAY 2
EXIT SUB
END IF
PROZOL GETVAR$("$$"+ VALUE$ + "$$")
PROZOL "prompt '@RCP()'"
end if

end sub
