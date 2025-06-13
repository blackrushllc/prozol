' PROFORM: Prozol screen format and database map generator
$ERROR ALL ON
$DIM ARRAY
$COMPILE EXE
$OPTION GOSUB ON  ' This is a MUST
DECLARE SUB GetStrLoc() 'we have to declare this because we need it
DIM FORM(25) AS STRING * 80
DIM GEN$(255)
%FALSE = 0
%TRUE  = NOT %FALSE
' These are the parameters that you need to pass to PBWRITE

	   BoxTOP% = 2     ' top of the editor window
	  BoxLEFT% = 1     ' left of window
	BoxBOTTOM% = 22    ' bottom of window
	 BoxRIGHT% = 81    ' right of window
    TextAttribute% = &H1E  ' Color of the text   (bg=0, fg=7)
  BorderAttribute% = &H4F  ' Color of the border (bg=7, fg=0)
	   Margin% = 0     ' Right margin for word wrap

	CursorRow% = 0     ' default to 0, these contain the current -
	CursorCol% = 0     '  cursor and position within the document -
       DocPointer% = 0     '  allowing you to re-enter the subroutine -
	DocOffset% = 0     '  with the document state preserved.
			   '  Call PBWRITE again later with these
			   '  variables preserved, and you will appear
			   '  inside the document exactly as you left it.

 FileName$ = "NONAME.GEN"  '  This is the default filename for LOAD/SAVE
 ExitCode% = 0             '  returns the scancode of the exit key

' save the screen and cursor position

TEMP$ = SAVESCREEN$:X%=CSRLIN:Y%=POS(0)
FOR i=1 to 23:ED$=ED$+SPACE$(80)+CHR$(13,10):NEXT i

' Just call the PBWRITE subroutine.  It is recursive and entirely self
' contained.  You may call it as many times as you want with different
' parameters to edit different documents.
CLS
LOCATE 1,1:COLOR 15,4:PRINT SPACE$(80);
LOCATE 23,1:PRINT SPACE$(80);
COLOR 15,1:PRINT SPACE$(80);
LOCATE 24,1:PRINT "F2-Save F3-Load  F10-Generate";
PBWRITE     ED$,_               ' string to contain the whole document
	    BoxTOP%,_           ' dimensions of the edit window
	    BoxLEFT%,_          '
	    BoxBOTTOM%,_        '
	    BoxRIGHT%,_         '
	    CursorRow%,_        ' default to 0, these contain the current -
	    CursorCol%,_        ' cursor and position within the document -
	    DocPointer%,_       ' allowing you to re-enter the subroutine -
	    DocOffset%,_        ' with the document state preserved.
	    FileName$,_         ' This is just the default name for SAVE/LOAD
	    TextAttribute%,_    ' The color of the text
	    BorderAttribute%,_  ' The color of the border
	    Margin%,_           ' The Right Margin
	    ExitCode%           ' key used to exit editor

' Restore the screen and cursor position

RESTORESCREEN TEMP$:LOCATE X%, Y%, 1  ' make sure cursor is visible

IF ExitCode%<>68 THEN END
IF RIGHT$(ED$,2)<>CHR$(13,10) THEN ED$=ED$+CHR$(13,10)
i=0
IF INSTR(FILENAME$,".")=0 THEN FILENAME$=FILENAME$+"."
MASTER$=LEFT$(FILENAME$,INSTR(FILENAME$,".")-1)
MAPFILE$="MAP "+MASTER$+" TO ????"

DO UNTIL ED$=""
INCR i
TEMP$=LEFT$(ED$,INSTR(ED$,CHR$(13))-1)
ED$=MID$(ED$,LEN(TEMP$)+3)
FORM(i)=TEMP$+SPACE$(80-LEN(TEMP$))
	DO
        a=instr(form(i),":")
        if a=0 then exit loop
        b=instr(form(i),">")
        if b=0 then exit loop ''''''''''''' THIS IS ACTUALLY AN ERROR
		c=a
                do
                  decr c
                loop until mid$(form(i),c,1)=" " or c=1
                if mid$(form(i),c,1)=" " then incr c
                fld$=ucase$(mid$(form(i),c,a-c))
                flen=b-a:mapflen=mapflen+flen
                row=i
                col=c
                incr gen
gen$(gen)="FIELD"+STR$(gen)+CHR$(32,34)+MASTER$+"."+Fld$+CHR$(34,44,34,67,34,44)+str$(flen)+","+STR$(row)+","+STR$(col)
mapfile$=mapfile$+"_"+CHR$(13,10)+SPACE$(8)+STR$(flen)+" AS "+Fld$
	mid$(form(i),1)=space$(b) ' cover up to ">"
	LOOP

LOOP
replace "????" with str$(mapflen) in mapfile$
PRINT "WRITING FIELD DEFINITION FILE - "+MASTER$+".FLD"
OPEN MASTER$+".FLD" FOR OUTPUT AS #1

FOR i=1 TO GEN
	PRINT #1, GEN$(i)
NEXT i
CLOSE #1
PRINT "WRITING MAP DEFINITION FILE - "+MASTER$+".MAP"
OPEN MASTER$+".MAP" FOR OUTPUT AS #1
PRINT #1, MAPFILE$
CLOSE
END

' =========================================================================
$INCLUDE "PBWRITE.BAS"
