'TYPE CFGRecord
'        CommonVarFile   AS STRING * 25
'        OLMPath         AS STRING * 11
'END TYPE

TYPE CommonVarRecord
	Variable AS STRING * 12
	Value    AS STRING * 80
	CrLf	 AS STRING * 2
END TYPE
$IF NOT %NOCOMMENTS
TYPE CommentRecord
TaxID AS STRING * 20
Line1 AS STRING * 78
Line2 AS STRING * 78
Line3 AS STRING * 78
Line4 AS STRING * 78
Line5 AS STRING * 78
Line6 AS STRING * 78
Line7 AS STRING * 78
Line8 AS STRING * 78
Line9 AS STRING * 78
extra AS STRING * 18
ComTime AS STRING * 10
ComDate AS STRING * 10
ComUser AS STRING * 8
END TYPE

TYPE CommentIndexRecord
	TaxID AS STRING * 20
	RecordNumber AS LONG
END TYPE
$ENDIF

TYPE CODERECORD
	CODE AS STRING * 80
END TYPE

$IF NOT %NODBASE
TYPE DBaseHeaderRecord
	    Ver AS BYTE         ' dBASE version
	   Year AS BYTE         ' year
	  Month AS BYTE         ' month
	    Day AS BYTE         ' day of last update
NumberOfRecords AS DWORD        ' number of records in this database
         offset AS WORD         ' length of header
	   Size AS WORD         ' length of record
	  Blank AS STRING * 20  ' reserved for future use
END TYPE

TYPE DBaseFieldRecord
   FieldName AS STRING * 11  ' name of the field in ASCII
   FieldType AS STRING * 1   ' Type CNLM or D
	 FDA AS DWORD        ' field data address - we don't need this
	FLen AS BYTE         ' Length, we'll need this!
	DecC AS BYTE         ' number of decimals in numeric field
      Blank9 AS STRING * 14  ' reserved for future use
END TYPE

TYPE DBStructureRecord
	FieldName AS STRING * 11
	FieldType AS STRING * 1
	FieldLength AS BYTE
	FieldOffset AS INTEGER
	FieldDecimals AS BYTE
	END TYPE
$ENDIF

TYPE DBaseEditFormat
        FieldName AS STRING * 20
        FieldType AS STRING * 1
        FieldLength AS BYTE
        FieldRow AS INTEGER
        FieldCol AS INTEGER
        FieldFG AS INTEGER
        FieldBG AS INTEGER
END TYPE


TYPE LONGINTEGER
	Num AS LONG
	END TYPE

$IF NOT %NOXMODEM
TYPE XPacketType
	SOH AS STRING * 1
	BLK AS STRING * 1
	NEG AS STRING * 1
	DAT AS STRING * 128
	SUM AS STRING * 1
	CRC AS STRING * 1
	END TYPE
$ENDIF
