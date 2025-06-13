FUNCTION REL$(FLD AS STRING * 20)
	R$=RTRIM$(FLD,ANY CHR$(0,32))+":"
        IF INSTR(R$,".") THEN R$=MID$(R$,INSTR(R$,".")+1)
        REL$=R$
END FUNCTION

SUB VarEditFields(Ecode%)
Ecode%=0
of%=3:ob%=4
Fld%=1 ' start with the first field on the screen
' Now make one pass and DRAW the fields on the screen with defaults
DO UNTIL DBE(Fld%).FieldLength=0
        PROZOLOCATE DBE(Fld%).FieldRow,DBE(Fld%).FieldCol
        PROZOCOLOR of%,ob%
        PROZOPRINT REL$(DBE(Fld%).FieldName)
        PROZOPRINT "@SCP()"
        PROZOCOLOR DBE(Fld%).FieldFG,DBE(Fld%).FieldBG
        PROZOPRINT SPACE$(DBE(Fld%).FieldLength)
        PROZOPRINT "@RCP()"
        IF DBE(Fld%).FieldType="N" THEN
                PROZOPRINT LTRIM$(GETVAR$((DBE(Fld%).FieldName)))
	ELSE
                PROZOPRINT GETVAR$((DBE(Fld%).FieldName))
	END IF

	INCR Fld%
LOOP


Fld%=1 ' start with the first field on the screen
' Now go back and edit the fields
DO UNTIL DBE(Fld%).FieldLength=0
        PROZOLOCATE DBE(Fld%).FieldRow,DBE(Fld%).FieldCol
        PROZOCOLOR of%,ob%
        PROZOPRINT REL$(DBE(Fld%).FieldName)
        r%=PROZOCSRLIN:C%=PROZOPOS
        IF DBE(Fld%).FieldType="N" THEN
                num%=1
        	ED$=LTRIM$(GETVAR$((DBE(Fld%).FieldName)))
	ELSE
                num%=0
        	ED$=GETVAR$((DBE(Fld%).FieldName))
	END IF

        ED$=DBGET$(r%, c%, (DBE(Fld%).FieldLength), (DBE(Fld%).FieldFG),_
                  (DBE(Fld%).FieldBG), ED$, -1, num%,KeyFlag%)

        IF num% THEN
        	VSET2 DBE(Fld%).FieldName, STR$(VAL(ED$))
        ELSE
        	VSET2 DBE(Fld%).FieldName,ED$
	END IF

	SELECT CASE KeyFlag%
        	CASE 10
                        PUSHARG "-1"
                        EXIT LOOP
		CASE 5
                        PUSHARG "0"
                	EXIT LOOP
		CASE 0,2,6
                	INCR Fld%
                        IF DBE(Fld%).FieldLength=0 THEN
                                PUSHARG "-1"
                                EXIT LOOP
                                END IF
                CASE 4,8
                	DECR Fld%
                        IF Fld%=0 THEN Fld%=1
		END SELECT
LOOP
PROZOCOLOR Of%, Ob%

END SUB

FUNCTION DBGET$(y%,x%,length%,fg%,bg%,whole$,ins%,num%,keyflag%)
LOCAL tscan%, xitflag%, curpos%, tempwhole$, first%
  ofg%=(PBVSCRNTXTATTR AND &HF)
  ofb%=PBVSCRNTXTATTR / &H10
  keyflag% = 0
  tempwhole$ = whole$
  first% = %TRUE
  PROZOLOCATE y%,x%
  PROZOCOLOR fg%,bg% : PROZOPRINT SPACE$(length%)
  xitflag% = %FALSE
  curpos% = 0

  DO
	'IF ins% THEN tscan% = %INSERTSCAN ELSE tascn% = %OVERWRITESCAN
        IF LEN(Whole$)>Length% THEN WHOLE$=LEFT$(Whole$,Length%)
        IF LEN(Whole$)<Length% THEN WHOLE$=WHOLE$+SPACE$(Length%=LEN(Whole$))
        PROZOLOCATE y%,x% : PROZOPRINT whole$
        PROZOLOCATE y%,x%+curpos%

	ky$ = GETKEY$("")
	IF ky$ < CHR$(31) THEN first% = %FALSE
	SELECT CASE ky$
	  CASE > CHR$(31)
		IF num% THEN
		  IF ky$ > CHR$(62) THEN EXIT SELECT
		END IF
		IF first% THEN
		  whole$ = ky$
		  curpos% = 1
		  first% = %FALSE
		  EXIT SELECT
		END IF
		IF ins% THEN
		  IF curpos% < LEN(whole$) THEN
			whole$ = RTRIM$(whole$)
			IF LEN(whole$) < length% THEN
			  whole$ = LEFT$(whole$,curpos%)+ky$+RIGHT$(whole$,LEN(whole$)-curpos%)
			  INCR curpos%,1
			  IF curpos% = length% THEN DECR curpos%,1
			END IF
		  ELSE
			whole$ = whole$ + ky$
			INCR curpos%,1
			IF curpos% = length% THEN DECR curpos%,1
		  END IF
		ELSE
		  IF curpos% < LEN(whole$) THEN
			MID$(whole$,curpos%+1) = ky$
		  ELSE
			whole$ = whole$ + ky$
		  END IF
		  INCR curpos%,1
		  IF curpos% = length% THEN DECR curpos%,1
		END IF
	  CASE CHR$(0,75) '**** LEFT ****
		IF curpos% <> 0 THEN DECR curpos%,1
	  CASE CHR$(0,77)'**** RIGHT ****
		IF curpos% <> length%-1 THEN INCR curpos%,1
		IF curpos% > LEN(whole$) THEN whole$=whole$+" "
	  CASE CHR$(0,71)'**** HOME ****
		curpos% = 0
	  CASE CHR$(0,79)'**** END ****
		   whole$ = RTRIM$(whole$)
		   curpos% = LEN(whole$)
		   IF LEN(whole$) = length% THEN DECR curpos%,1
	  CASE CHR$(0,82)'**** INS ****
		ins% = NOT ins%
		IF tscan% = 3 THEN tscan% = 6 ELSE tscan% = 3
	  CASE CHR$(0,83)'**** DEL ****
		IF curpos% > LEN(whole$)-1 THEN EXIT SELECT
		whole$ = LEFT$(whole$,curpos%) + RIGHT$(whole$,LEN(whole$)-curpos%-1)
	  CASE CHR$(8)'**** BACKSPACE ****
		IF curpos% <> 0 THEN
		  whole$ = LEFT$(whole$,curpos%-1) + RIGHT$(whole$,LEN(whole$)-curpos%)
		  DECR curpos%,1
		END IF
	  CASE CHR$(13)'**** ENTER ****
		xitflag% = %TRUE
		keyflag% = 0
	  CASE CHR$(27)'**** ESC ****
		xitflag% = %TRUE
		keyflag% = 5
		whole$ = tempwhole$
	  CASE CHR$(0,72)'**** UP ARROW ****
		xitflag% = %TRUE
		keyflag% = 8
	  CASE CHR$(0,80)'**** DOWN ARROW ****
		xitflag% = %TRUE
		keyflag% = 2
	  CASE CHR$(9)'**** TAB ****
		xitflag% = %TRUE
		keyflag% = 6
	  CASE CHR$(0,15)'**** SHFT-TAB ****
		xitflag% = %TRUE
		keyflag% = 4
          CASE CHR$(0,117),CHR$(0,68),CHR$(14)
          	xitflag%=%TRUE
                keyflag%=10

	END SELECT

  LOOP UNTIL xitflag%
  xitflag%=%FALSE
  PROZOCOLOR ofg%, obg%
  DBGET$ = RTRIM$(whole$)

END FUNCTION

FUNCTION getkey$(mstr$)
  IF mstr$ = "" THEN
    DO
      IF INSTAT THEN k$=PROZOINKEY$ ELSE k$ = PROZOINKEY$:IF K$=CHR$(27) THEN GOSUB K.Arrow
    LOOP UNTIL k$ <> ""
  ELSE
    DO
     IF INSTAT THEN k$ = PROZOINKEY$ ELSE k$=PROZOINKEY$:IF K$=CHR$(27) THEN GOSUB K.ARROW
    LOOP UNTIL INSTR(k$,ANY mstr$)
  END IF
GOTO EndGetKeyFunction

K.ARROW:
DELAY .25
	IF COMCHARS% THEN K$=K$+COMCHAR$ ELSE RETURN
        IF INSTR(K$,"A") THEN K$=CHR$(0,72)
        IF INSTR(K$,"B") THEN K$=CHR$(0,80)
        IF INSTR(K$,"C") THEN K$=CHR$(0,75)
        IF INSTR(K$,"D") THEN K$=CHR$(0,77)
RETURN


EndGetKeyFunction:
  getkey$ = k$
END FUNCTION
