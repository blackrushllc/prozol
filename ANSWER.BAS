' This section will set up a modem to answer the phone, however, it will
' first write a lf+cr pair (backwards) to the port.  If an PROZOL terminal is
' attached to it, it should return a burst of CHR$(4)'s.  This program will
' see this (needs 2 in a row) and automatically go into hardwired host mode.

CLOSE
i$=DIR$("init" + MID$(STR$(Port%), 2))
if i$="" THEN
	CLOSE #1
	OPEN "o",#1, "init" + MID$(STR$(Port%),2)
	print #1, "ATS0=1"
	CLOSE #1
	END IF
OPEN "i", #1, "init" + MID$(STR$(Port%),2): LINE INPUT #1, INIT$: CLOSE
CALL PROZOPRINT("INITIALIZING " + PARM$ + CrLf$)
PROZOPRINT "REQUESTING MODEM FOR RESET" + CrLf$
COMOPEN PARM$
COMPRINT CHR$(13)
CALL EFFECT("PHASERS")
DELAY .5 'allow hardwire terminal to respond
'HEY: different sound effects for different activities and on|off too
IF COMCHARS% THEN A$=COMCHAR$:IF INSTR(A$,STRING$(2,4)) THEN GOTO HARDWIRE
Delay 1.5
COMPRINT "+"
delay .25
COMPRINT "+"
delay .25
COMPRINT "+"
Delay 1.5
COMPRINT "ATZ"+CHR$(13)
Comline = 0
PROZOPRINT "Press ESC to exit to DOS or F10 for command line" + CrLf$ + CrLf$
PROZOPRINT "Waiting for RING..."
Comline = -1

Delay 1
COMPRINT INIT$+CHR$(13)
Delay 1

	LET TIM# = TIMER
	DO
		CALL DVPAUSE
		IF COMCHARS% THEN
			b$ = COMCHAR$
                        COMLINE=0
                        PROZOPRINT B$
                        COMLINE=-1
			x$ = x$ + b$
		END IF

		IF TIM# + 5 < TIMER AND INSTR(x$, "OK") = 0 THEN ERROR 2
		IF TIM# + 3600 < TIMER THEN CLOSE:CLEAR:RUN					      '    *** RECYCLE EVERY HOUR
		b$ = INKEY$: IF b$ = CHR$(0) + CHR$(68) THEN EXIT DO
			     IF b$ = CHR$(27) THEN EXIT DO
			     if b$=chr$(0,59) then exit do
		IF LEN(x$) > 100 THEN ERROR 2
		'HEY: Allow keystrokes to go to the modem
		'HEY: Answer phone with ATA instead of S0=1
		'HEY: Allow sysop to shell busy or popup on call
'		IF INSTR(x$,"RING") THEN
'		   DELAY .5
'		   COMPRINT "A"
'		   DELAY .25
'		   COMPRINT "T"
'		   DELAY .25
'		   COMPRINT "A"
'		   DELAY .25
'		   COMPRINT CHR$(13)
'		   REPLACE "RING" WITH "RANG" IN X$
'		END IF
		IF INSTR(x$, "NO") THEN ERROR 99
		LOOP WHILE INSTR(x$, "NN") = 0

        IF b$ = CHR$(0,68) THEN
                COMPRINT "ATH0M0S0=0"+CrLf$
                COMCLOSE
                Prog%=0
                GOTO PROGINPUT
        END IF
        IF b$ = CHR$(27) THEN COMPRINT "ATH0M0S0=0"+CrLf$:END
	IF b$ = CHR$(0,59) THEN GOTO ANSWERTHEPHONE
	Delay 2
	b$ = COMCHAR$: x$ = x$ + b$
        COMLINE=0
        PROZOPRINT b$
        COMLINE=-1
	Delay 1
	Baud = VAL(BAUD$)
    If Baud < 9600 THEN
	IF INSTR(X$, "9600") THEN
		Baud = 9600
		COMCLOSE
		MID$(PARM$,6)="9600"
		COMOPEN PARM$
		END IF
	IF INSTR(X$, "4800") THEN
		Baud = 4800
		COMCLOSE
		MID$(PARM$,6)="4800"
		COMOPEN PARM$
		END IF
	IF INSTR(x$, "2400") THEN
		Baud = 2400
		COMCLOSE
		MID$(PARM$,6)="2400"
		COMOPEN PARM$
		END IF
	IF INSTR(x$, "1200") THEN
		COMCLOSE
		MID$(PARM$,6)="1200"
		COMOPEN PARM$
		Baud = 1200
		END IF
    END IF
Comline = 1: e = 0 : Carrier%=1
HardWire:
DELAY 2
A$=COMCHAR$

