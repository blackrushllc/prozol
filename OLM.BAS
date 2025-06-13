SUB GETOLM
SHARED OLMPath$
 IF DIR$(OLMPath$+Global$(1)+".OLM")<>"" THEN
	LET Fi%=FREEFILE
        PROZOPRINT CHR$(7)
        IF tty THEN PROZOPRINT CrLf$
	OPEN OLMPath$+Global$(1)+".OLM" FOR INPUT AS #Fi%
	DO WHILE NOT EOF(Fi%)

                LINE INPUT #Fi%, A$
                CALL PROZOL("PRINT '@SCP()@LOCATE(22,1)"+A$+"@RCP()'")
                PROGDELAY 2
	LOOP
	CLOSE #Fi%
	KILL OLMPath$+Global$(1)+".OLM"
        'PROZOPRINT "Press a key..."+CrLf$
	'CWAIT
        IF tty THEN PROZOPRINT LastPrompt$
 END IF
END SUB
