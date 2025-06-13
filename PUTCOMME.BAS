SUB PutComment (TAX$)
SHARED MailPath$
LET BUF = FREEFILE
OPEN MailPath$ + "comment.dbf" FOR RANDOM ACCESS READ WRITE SHARED AS #BUF LEN = LEN(Comment)
x = LOF(BUF) / LEN(Comment) + 1
PUT #BUF, x, Comment
CLOSE #BUF

OPEN MailPath$ + "comment.ix" FOR RANDOM ACCESS READ WRITE SHARED AS #BUF LEN = LEN(CommentIndex)
LET CommentIndex.TaxID = Comment.TaxID
LET CommentIndex.RecordNumber = x
PUT #BUF, LOF(BUF) / LEN(CommentIndex) + 1, CommentIndex
CLOSE #BUF
END SUB

