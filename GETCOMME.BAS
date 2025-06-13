SUB GetComment(TAX$)
$IF NOT %NOCOMMENTS
SHARED MailPath$
DIM Coms(99)
DIM Comix(99)
	LET ComBuf = FREEFILE
	LET BigBuf = FREEFILE
OPEN MailPath$ + "comment.ix" FOR RANDOM ACCESS READ WRITE SHARED AS #ComBuf LEN = LEN(CommentIndex)
x = 1: q = 0
	DO
GET #ComBuf, x, CommentIndex
 IF INSTR(CommentIndex.TaxID, TAX$) AND LTRIM$(CommentIndex.TaxID) <> "" THEN
      q = q + 1
      Comix(q) = x
      Coms(q) = CommentIndex.RecordNumber: IF q > 99 THEN EXIT DO
 END IF
x = x + 1
LOOP WHILE NOT EOF(ComBuf)

CLOSE #ComBuf

IF q THEN
OPEN MailPath$ + "comment.raf" FOR RANDOM ACCESS READ WRITE SHARED AS #BigBuf LEN = LEN(Comment)
CY = 1
DO
GET #BigBuf, Coms(CY), Comment
CALL PROZOL("COLOR 7,0:CLS")
CALL PROZOL("Print '^0^gThere are^r" + STR$(q) + " ^gComment(s) posted for ^r" + TAX$+"'")
CALL PROZOL("Print '^0'")
CALL PROZOL("Print '^cCOMMENT #^F" + STR$(CY) + "^0'")
CALL PROZOL("Print")
CALL PROZOPrint("^B^cFrom ^b" + Comment.ComUser + "^cTo ^b" + Comment.TaxID + " ^cTime: ^b" + Comment.ComTime + " ^cDate: ^b" + Comment.ComDate + "^0"+CrLf$)
CALL PROZOL("Print")
CALL PROZOPrint("^B^y" + LTRIM$(Comment.Line1) +CrLf$)
CALL PROZOPrint("^B^y" + LTRIM$(Comment.Line2) +CrLf$)
CALL PROZOPrint("^B^y" + LTRIM$(Comment.Line3) +CrLf$)
CALL PROZOPrint("^B^y" + LTRIM$(Comment.Line4) +CrLf$)
CALL PROZOPrint("^B^y" + LTRIM$(Comment.Line5) +CrLf$)
CALL PROZOPrint("^B^y" + LTRIM$(Comment.Line6) +CrLf$)
CALL PROZOPrint("^B^y" + LTRIM$(Comment.Line7) +CrLf$)
CALL PROZOPrint("^B^y" + LTRIM$(Comment.Line8) +CrLf$)
CALL PROZOPrint("^B^y" + LTRIM$(Comment.Line9) +CrLf$)
CALL PROZOPrint("^0"+CrLf$)
CALL PROZOPrint("End of Comment"+CrLf$)
CALL PROZOPrint(CrLf$)
CALL PROZOL("PROMPT '^r^B(N)ext  (P)rev  (Q)uit  (G)oodbye  (R)eply  (K)ill  --> ^0")
VALUE$=PROZOINPUT$
IF Value$ = "" THEN Value$ = "N"
IF LEN(Value$) = 1 THEN
Value$ = UCASE$(Value$)
IF Value$ = "N" THEN CY = CY + 1
IF CY > q THEN EXIT DO
IF Value$ = "P" THEN CY = CY - 1: IF CY = 0 THEN CY = 1
IF Value$ = "Q" THEN EXIT DO
IF Value$ = "G" THEN CALL SYSRESET

        IF Value$ = "K" THEN
	LET ComBuf = FREEFILE
	OPEN MailPath$ + "comment.ix" FOR RANDOM SHARED AS #ComBuf LEN = LEN(CommentIndex)
	LET CommentIndex.TaxID = "KILLED"
	LET CommentIndex.RecordNumber = Coms(CY)
	PUT #ComBuf, Comix(CY), CommentIndex
        CALL PROZOL("PRINT:PRINT ' *** This comment has been KILLED ***@CHR(7)':PRINT")
	CY = CY + 1
	IF CY > q THEN EXIT DO
	CLOSE #ComBuf
	END IF

IF Value$ = "R" THEN

CALL PROZOL("PRINT")
CALL PROZOL("PRINT 'Select a destination for your response --> '")
CALL PROZOPRINT ("1) " + Comment.ComUser+CrLf$)
CALL PROZOPRINT ("2) " + TAX$+CrLf$)
CALL PROZOL("PRINT '3) New Category or User Name...'")
CALL PROZOL("PRINT '4) System Operator'")
CALL PROZOL("PRINT '5) Everyone'")
CALL PROZOL("PRINT")
CALL PROZOL("PROMPT 'Select --> '")
VALUE$=PROZOINPUT$
A = VAL(Value$)
   IF A > 0 THEN
		IF A = 1 THEN s$ = Comment.ComUser
		IF A = 2 THEN s$ = TAX$
		IF A = 3 THEN
                 CALL PROZOL("PRINT")
                 CALL PROZOL("PRINT 'Personal mail must be addressed to the LOGIN NAME of the User.'")
                 CALL PROZOL("PRINT 'If you don't know someone's LOGIN NAME, you cannot send them mail.'")
                 CALL PROZOL("PRINT")
                 CALL PROZOL("PROMPT 'Enter Category or User Name: '")
                 VALUE$=PROZOINPUT$
                 s$ = Value$
		END IF

		IF A = 4 THEN s$ = "SYSOP"
		IF A = 5 THEN s$ = "EVERYONE"
		IF LEN(s$) THEN EditComment s$
   ELSE
       CALL PROZOL("PRINT:PRINT ' ...NO COMMENT!':PRINT CHR 7")
	ProgDelay 2
   END IF
END IF
END IF
LOOP
CLOSE #BigBuf
ELSE
CALL PROZOPrint("No mail posted for " + TAX$ + CrLf$)
END IF
$ENDIF
END SUB

