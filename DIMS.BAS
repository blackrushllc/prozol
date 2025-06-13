GGG% = %Bt.Max.Node + 1
DIM Keys$(0:ggg%),Ptr$(0:ggg%),Stk&(0:30,0:1),Itm$(0:ggg%),Dta$(0:ggg%)

$IF NOT %NODBASE
DIM DBH AS DBaseHeaderRecord
DIM DBF AS DBaseFieldRecord
DIM DBS(256) AS DBStructureRecord
$ENDIF

DIM STATIC DBE(256) AS DBaseEditFormat

REDIM 	PROGRAM$(1000)  	' Array to store program source code
DIM STATIC VAR$	(2048)   	' Array to store variable names
DIM STATIC VALUE$ (2048)   	' Array to store variable contents
DIM 	ARG$	(1024)    	' Buffer array for argument stack pushpop
DIM	GosubStack%(32)		' Stack to store return pointers
DIM     LITERAL$(1024)            ' Storage of parameter names
DIM GenStack$ (16,32)           ' Storage for misc. stacks
DIM GenPointer%(16)             ' Storage for stack ptrs
'DIM CFG AS CFGRecord
DIM Rec AS LONGINTEGER
DIM CODE AS CODERECORD
$IF NOT %NOCOMMENTS
DIM Comment AS CommentRecord
DIM CommentIndex AS CommentIndexRecord
$ENDIF
$IF NOT %NOTASKS
DIM Task(16), TaskProg$(100,16), TaskLine(16)
$ENDIF
DIM item$(15)
DIM Global$(64)
DIM C$(9)                  ' This array is use by CHAT mode
DIM CallStack%(64)         ' For gosubs
'DIM IfStack%(64)
'DIM Query$(32)
DIM IxPtr&(50,3)
DIM CommonVar as CommonVarRecord
