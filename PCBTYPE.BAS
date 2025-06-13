sub pcbtype (fi$,s$,response$)
' this subroutine types a PC-Board style file list to the screen and
' prompts the user to select one or more files.  the selected files are
' return in response$.  s$ contains the search parameters.  s$ can be
' blank for all files, or can be a "since" date, or can be a search
' string.  The format of the pcb can be pretty loose, but must contain
' a | in any line that is to be continued from the previous line, and
' must contain a standard 8 digit date parsed with dashes. somewhere in
' the first line of each entry.  I.E.:

'PROZOL.ZIP     219242   01-09-94   This is the complete prozol package
'                                 | without source, of course.  Written
'                                 | by Erik Olson in PowerBASIC 3.0
'
' the first two lines of the file are a header and are not scanned, only
' printed.  This routine will be expanded to allow "Mark" and other options
s$=ucase$(s$)

' if s$ is a date then copy it into to d$

if dir$(fi$)="" then exit sub
FF=FREEFILE
open fi$ for input as #ff
if eof(ff) then close #ff:exit sub else line input #ff, h1$:prozoprint h1$+CrLf$
if eof(ff) then close #ff:exit sub else line input #ff, h2$:prozoprint h2$+CrLf$
if eof(ff) then close #ff:exit sub else line input #ff, a$
nonstop=0 'if enabled, pausing is off
ln=0 'number of lines that have displayed
do until eof(ff)
        lntmp=1
        do    ' build an image of one entry, store next entry line 1 in b$
                if eof(ff) then exit do
		line input #1,b$
                if left$(ltrim$(b$),1)="|" then
                        replace "|" with " " in b$
                	a$=a$+CrLf$+b$
                	incr lntmp ' number of lines in this entry
		else
                	exit do
                end if
        loop
' now a$ is an entry.  We must check to see if it meets our criteria
' if it does meet our criteria then ln=lntmp, lntmp=0 else ln=0
if len(d$) then
	' check date
else
    if s$="" then
        	meets=%true
                ln=ln+lntmp
                lntmp=0
    else
	if instr(ucase$(a$),s$) then
        	meets=%true
                ln=ln+lntmp
        else
        	meets=%false
                lntmp=0
        end if
    end if

end if

if meets then

if nostop=0 then
' if it won't scroll to far, display a$, otherwise askfile
	if ln<20 then
        	prozoprint a$ + CrLf$
                lntmp=0
	else
		gosub askfile
                ln=0
                if quitnow% then exit do
	end if
end if

' if nonstop=1 or if we didn't display it before, display it now
if nonstop or lntmp>0 then
	prozoprint a$+CrLf$
        ln=lntmp ' carry forward line counter
	lntmp=0
end if

end if ' if meets

meets%=0

' set a$ to b$ for next iteration.
k$=ucase$(prozoinkey$):if k$=chr$(27) or k$="X" or k$="S" or k$="Q" then exit do
if not eof(ff) then a$=b$: else if ln>0 then gosub askfile
if quitnow% then exit do
loop
close #ff
exit sub

askfile:
if eof(ff) then
 prozoprint "(End of List) .. Enter selection(s) or press [ENTER] --> "
 k$=prozoinput$
else
 prozoprint "[S]top, [N]on-stop, [D]ownload, or [ENTER] for more --> "
 k$=prozoinput$
end if
if GoFlag% then quitnow%=%true:return
if k$="" then
        if not eof(ff) then prozocls:prozoprint h1$+CrLf$:prozoprint h2$+CrLf$
        return
end if
k$=ucase$(k$)
if k$="S" or k$="Q" then quitnow%=%true:return
if k$="N" then nonstop=%true:return
if k$="D" then
	prozoprint "Enter filename(s): "
        response$=prozoinput$
        if Goflag% then quitnow%=%true : return
        if response$="" then return
        response$=ucase$(response$)
        quitnow%=%true
else
        if len(k$)>1 then
                response$=ucase$(k$)
                quitnow%=%true
        else
                goto askfile
        end if
end if

return
end sub
