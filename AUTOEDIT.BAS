SUB AUTOEDIT
$IF NOT %NOAUTOEDIT
' I don't want to hear a word about this code.  It was written in 1987 in
' GWBASIC and it works fine the way it is.  This is a real incredible piece of
' history here, since this one routine is the single piece of BASIC code that
' started this whole project.  AutoEdit was written so I would not have to
' do so much work fixing database records we downloaded from a local real
' estate database service.  Years later I was led to create my own database
' service to compensate for features that were missing in the commercial
' systems available.  The rest is history.  Since then, I have changed very
' little of the inner workings of this routine.  In fact, I don't really
' understand how it even works, and have made many attempts to reproduce
' it, but it is so spaghettied that I cannot even figure out what it does.
' I guess I was doing some pretty hard drugs when I wrote it!

DIM R$(50), A$(30)
DIM CUSTOM$(25, 2)

initialize:
'initialize the autoeditor variables *************************
y = 1: M$ = "Mr.": GOSUB 1118
CHOP3RD = 1
GOSUB AUTOEDITOR: GOTO endautoeditsub

nameformatting:
'split apart multiple names ***********************************
A$(1) = "": A$(2) = ""
R$(2) = RTRIM$(R$(2)): R$(2) = LTRIM$(R$(2))
IF INSTR(R$(2), "TRUST") > 0 THEN A$(1) = R$(2): RETURN
IF INSTR(R$(2), "&") > 0 THEN A$(1) = LEFT$(R$(2), INSTR(R$(2), "&") - 1): A$(2) = MID$(R$(2), INSTR(R$(2), "&") + 1): GOTO lname
IF INSTR(R$(2), "+") > 0 THEN A$(1) = LEFT$(R$(2), INSTR(R$(2), "+") - 1): A$(2) = MID$(R$(2), INSTR(R$(2), "+") + 1): GOTO lname
IF INSTR(R$(2), " AND ") > 0 THEN A$(1) = LEFT$(R$(2), INSTR(R$(2), " AND ")): A$(2) = MID$(R$(2), INSTR(R$(2), " AND ") + 5): GOTO lname
A$(1) = R$(2): IF LEN(A$(1)) > 3 THEN A$ = RIGHT$(A$(1), 2): IF LEFT$(A$, 1) = " " THEN A$(1) = LEFT$(A$(1), LEN(A$(1)) - 2)
FOR ii% = 1 TO 26: IF INSTR(A$(1), " " + CHR$(64 + ii%) + " ") > 4 THEN A$(1) = LEFT$(A$(1), INSTR(A$(1), " " + CHR$(64 + ii%) + " ") - 1) + " " + MID$(A$(1), INSTR(A$(1), " " + CHR$(64 + ii%) + " ") + 3)
NEXT ii%

RETURN

lname:
A$(1) = RTRIM$(A$(1)): A$(1) = LTRIM$(A$(1))
A$(2) = RTRIM$(A$(2)): A$(2) = LTRIM$(A$(2))
IF LEN(A$(1)) > 3 THEN A$ = RIGHT$(A$(1), 2): IF LEFT$(A$, 1) = " " THEN A$(1) = LEFT$(A$(1), LEN(A$(1)) - 2)
IF INSTR(A$(1), " ") = 0 THEN RETURN
FOR ii% = 1 TO 26: IF INSTR(A$(1), " " + CHR$(64 + ii%) + " ") > 4 THEN A$(1) = LEFT$(A$(1), INSTR(A$(1), " " + CHR$(64 + ii%) + " ") - 1) + " " + MID$(A$(1), INSTR(A$(1), " " + CHR$(64 + ii%) + " ") + 3)
NEXT ii%
IF INSTR(A$(2), " ") = 0 THEN A$(2) = LEFT$(A$(1), INSTR(A$(1), " ")) + A$(2): RETURN
IF LEN(A$(2)) < 3 THEN RETURN
A$ = RIGHT$(A$(2), 2)
IF LEFT$(A$, 1) = " " THEN A$(2) = LEFT$(A$(1), INSTR(A$(1), " ")) + LEFT$(A$(2), INSTR(A$(2), " ") - 1): RETURN
RETURN
'split apart multiple names ********************************



zipprocess:

R$(6) = RTRIM$(R$(6)): R$(6) = LTRIM$(R$(6))
A$(4) = RTRIM$(R$(4)) + " " + R$(6)

RETURN





AUTOEDITOR:
'do a single autoedit for one record **************************


'YOU HAVE TO LET A$(Y,1), WHERE Y=1-5, EQUAL THE RAWDATA
'THEN REMOVE THE SECOND DIMENSION 1-NAME 2-NAME 3-ADD 4-CST 5-PAD
R$(2) = GetVar$("AUTONAME")
R$(4) = GetVar$("AUTOCITYSTATE")
A$(3) = GetVar$("AUTONAME3")
IF A$(3) = "" THEN A$(3) = GetVar$("AUTONAME2")
IF A$(3) = "" THEN A$(3) = GetVar$("AUTOADDRESS")
IF LEFT$(A$(3), 1) = "%" THEN LET A$(3) = GetVar$("AUTONAME2")
A$(5) = GetVar$("AUTOPROPERTY"): A$(5) = LTRIM$(A$(5))
R$(6) = GetVar$("AUTOZIP")

GOSUB nameformatting
GOSUB zipprocess



'do a single autoedit for one record **************************

NIGRIG:
SECOND$ = "": INC$ = "": FLIP = 0: APT$ = "": Flag = 0

1013 A$(8) = A$(1): A$(9) = A$(2): A$(10) = A$(3): A$(11) = A$(4): A$(12) = A$(5): A$(13) = "     "
1014 FOR n = 1 TO 5
1015 g$ = "": GG$ = ""
1016 FOR L = 1 TO LEN(A$(n)):
1017 IF MID$(A$(n), L, 1) = "" THEN 1021
1018 IF MID$(A$(n), L, 1) = " " AND LEN(g$) > 0 THEN GOTO 1052
1019 IF MID$(A$(n), L, 1) = " " THEN 1021
1020 g$ = g$ + MID$(A$(n), L, 1)
1021 NEXT L
1022 Flag = 0: IF LEN(g$) > 0 THEN Flag = 1: GOTO 1052
1023 Flag = 0: A$(n) = GG$: GG$ = "": IF LEN(A$(6)) < 5 THEN GOSUB 1058: GOTO 1025
1024 IF n <> 2 THEN GOSUB 1058 ELSE SECOND$ = "LOADED": GOSUB 1058
1025 NEXT n

1026 REM
'    ***********  insert the autoedited fields into the array  *********
1027 REM


1029
1030
1031
1032


WW = 5: GOSUB 1125: CALL VSET2("PROPERTY", LTRIM$(pno$ + " " + pnm$))
CALL VSET2("CITYLINE", A$(4))
WW = 3: GOSUB 1125: R$(29) = sno$: R$(30) = snm$: CALL VSET2("ADDRESS", LTRIM$(sno$ + " " + snm$))
CALL VSET2("NAME", A$(6))

GOSUB 1133
CALL VSET2("FORMAL", A$(7))
GOSUB 1131
GOSUB 1135
CALL VSET2("INFORMAL", A$(14))

1051 RETURN
1052 REM
1053 IF LEN(g$) = 1 THEN GG$ = GG$ + g$ + " ": GOTO 1057
1054 LA$ = RIGHT$(g$, (LEN(g$) - 1)): FIR$ = LEFT$(g$, 1)
1055  LA$ = LCASE$(LA$)
1056 GG$ = GG$ + FIR$ + LA$ + " "
1057 g$ = "": IF Flag = 1 THEN GOTO 1023 ELSE GOTO 1021
1058 REM this part checks for name patterns
1059 REM using variable a$(n,y) where n is 1-5,6 and 7 and y=1-# of recs
1060 IF n = 3 OR n = 5 THEN 1098
1061 IF n = 1 OR n = 2 THEN 1063
1062 IF n = 4 THEN 1093
1063'IF INSTR(a$(n), "Inc") > 0 OR INSTR(a$(n), " Co ") > 0 OR INSTR(a$(n), " Co.") > 0 OR INSTR(a$(n), " Corp") > 0 OR INSTR(a$(n), " Assn") > 0 OR INSTR(a$(n), "Trust") > 0 OR INSTR(a$(n), " Bank ") > 0 THEN INC$ = a$(n):    IF n = 1 THEN RETURN
1064'IF INSTR(a$(n), "Apt") > 0 OR INSTR(a$(n), "Suite") > 0 OR INSTR(a$(n), "Unit") > 0 THEN APT$ = a$(n): a$(n) = ""

1065 IF n = 2 AND A$(2) = "" THEN SECOND$ = "": GOTO 1092
1066 IF LEFT$(A$(n), 3) = "La " THEN A$(n) = LEFT$(A$(n), 2) + MID$(A$(n), 4)
IF LEFT$(A$(n), 3) = "Le " THEN A$(n) = LEFT$(A$(n), 2) + MID$(A$(n), 4)
1067 IF LEFT$(A$(n), 3) = "Mc " THEN A$(n) = LEFT$(A$(n), 2) + MID$(A$(n), 4)
1068 IF LEFT$(A$(n), 4) = "Mac " THEN A$(n) = LEFT$(A$(n), 3) + MID$(A$(n), 5)
1069 IF LEFT$(A$(n), 2) = "O " THEN A$(n) = LEFT$(A$(n), 1) + MID$(A$(n), 3)
IF LEFT$(A$(n), 3) = "St " THEN A$(n) = LEFT$(A$(n), 2) + "." + MID$(A$(n), 4)
IF LEFT$(A$(n), 3) = "Di " THEN A$(n) = LEFT$(A$(n), 2) + MID$(A$(n), 4)
IF LEFT$(A$(n), 4) = "Van " THEN A$(n) = LEFT$(A$(n), 3) + MID$(A$(n), 5)
IF LEFT$(A$(n), 4) = "Von " THEN A$(n) = LEFT$(A$(n), 3) + MID$(A$(n), 5)

1070 PATTERN$ = "": FOR t = 1 TO LEN(A$(n))
1071 temp$ = ""
1072 IF MID$(A$(n), t, 1) = " " THEN temp$ = "0" ELSE temp$ = "1"
1073 IF temp$ <> HOLD$ THEN PATTERN$ = PATTERN$ + temp$
1074 HOLD$ = temp$
1075 NEXT t
1076 IF LEN(INC$) > 4 AND n = 2 AND FLIP = 1 THEN A$(12) = A$(7): GOTO 1122
1077 IF PATTERN$ <> "1010" AND PATTERN$ <> "101010" AND LEN(INC$) > 4 AND n = 2 AND SECOND$ = "" THEN A$(11) = A$(6): GOTO 1122
1078 IF LEN(A$(n)) > 3 THEN IF PATTERN$ = "101010" AND RIGHT$(A$(n), 2) = ". " OR MID$(A$(n), LEN(A$(n)) - 3, 1) = " " THEN 1079 ELSE GOTO 1084
1079 temp$ = "": HOLD$ = "": RECOG = 1: FOR t = 1 TO LEN(A$(n)): IF MID$(A$(n), t, 1) <> " " THEN temp$ = temp$ + MID$(A$(n), t, 1): GOTO 1083
1080 IF GG$ <> "" THEN 1083
1081 IF HOLD$ = "" THEN HOLD$ = temp$: temp$ = "": GOTO 1083
1082 fgg$ = temp$: A$(14) = fgg$: GG$ = temp$ + " " + HOLD$: GOSUB 1112: A$(7) = M$ + " " + HOLD$: A$(6) = GG$: IF SECOND$ = "" THEN LSTNAME$ = HOLD$: newf$ = temp$: FLIP = 1: A$(18) = temp$: A$(20) = HOLD$ ELSE A$(19) = temp$: A$(21) = HOLD$
1083 NEXT t: GOTO 1085
1084 IF PATTERN$ = "101010" AND CHOP3RD = 1 THEN GOTO 1079 ELSE IF PATTERN$ <> "1010" THEN 1091
1085 RECOG = 1
1086 temp$ = "": HOLD$ = "": FOR t = 1 TO LEN(A$(n)): IF MID$(A$(n), t, 1) <> " " THEN temp$ = temp$ + MID$(A$(n), t, 1): GOTO 1090
1087 IF GG$ <> "" THEN 1090
1088 IF HOLD$ = "" THEN HOLD$ = temp$: temp$ = "": GOTO 1090
1089 fgg$ = temp$: A$(14) = fgg$
GG$ = temp$ + " " + HOLD$

GOSUB 1112: A$(7) = M$ + " " + HOLD$
A$(6) = GG$: IF SECOND$ = "" THEN LSTNAME$ = HOLD$: newf$ = temp$: FLIP = 1: A$(18) = temp$: A$(20) = HOLD$ ELSE A$(19) = temp$: A$(21) = HOLD$
1090 NEXT t
1091 IF SECOND$ = "LOADED" AND RECOG = 1 THEN GOSUB 1106 ELSE IF SECOND$ = "LOADED" AND n = 2 THEN A$(12) = A$(n)
1092 RECOG = 0: RETURN
1093 REM modify address......
1094 LON = LEN(A$(n)): IF LON < 12 THEN GOTO 1097 ELSE IF MID$(A$(n), LON - 6, 1) = " " AND MID$(A$(n), LON - 9, 1) = " " THEN 1095 ELSE GOTO 1097
1095 UC$ = MID$(A$(n), LON - 8, 2): UC$ = UCASE$(UC$)
1096 A$(n) = LEFT$(A$(n), LON - 10) + ", " + UC$ + "   " + RIGHT$(A$(n), 6): A$(15) = RIGHT$(A$(n), 6)
1097 SECOND$ = "": RETURN
1098 REM  custom manipulation of address, fields 3 and 5 (street address), search and replace. *******
1099 IF CUSTOM$ = "" THEN 1104
1100 FOR WHELP = 1 TO fussbudget
1101 ORGASMIC = INSTR(A$(n), CUSTOM$(WHELP, 1)): IF ORGASMIC = 0 THEN 1103
1102 A$(n) = LEFT$(A$(n), ORGASMIC - 1) + CUSTOM$(WHELP, 2) + MID$(A$(n), ORGASMIC + LEN(CUSTOM$(WHELP, 1)))
1103 NEXT WHELP
1104 IF APT$ = "" THEN 1105 ELSE IF n = 3 THEN A$(n) = A$(n) + " " + APT$: APT$ = ""
1105 RETURN
1106 REM CHECK FOR POSSIBLE HUSBAND AND WIFE

'***** LAST AND FIRST NAMES
A$(20) = LSTNAME$: A$(21) = HOLD$: A$(18) = newf$: A$(19) = fgg$

1107 IF LSTNAME$ <> HOLD$ THEN A$(6) = newf$ + " " + LSTNAME$ + " & " + A$(6): A$(7) = "Owners": A$(14) = newf$ + " and " + A$(6): GOTO 1111
1108 A$(6) = newf$ + " and " + fgg$ + " " + LSTNAME$
1109 A$(7) = "Mr. & Mrs. " + HOLD$: A$(14) = newf$ + " and " + fgg$: A$(18) = newf$: A$(19) = fgg$
1110 'SOUND 200, .5: PRINT a$(6): PRINT a$(7)
1111 RETURN
1112 cc = 0: M$ = "Mr."
IF INSTR(Female$, temp$ + " ") THEN M$ = "Ms."
RETURN
1113
1114
1115
1116
1117 RETURN
1118 IF LEN(Female$) THEN RETURN ELSE LET Buffer = FREEFILE: OPEN "FEMALES.DAT" FOR INPUT AS #Buffer
1119 IF EOF(Buffer) THEN CLOSE #Buffer: RETURN ELSE INPUT #Buffer, FEM$: Female$ = Female$ + " " + FEM$: GOTO 1119
1120 RETURN
1121 REM
1122 A$(6) = INC$: A$(7) = "Sir or Madam": GOTO 1092
1123
1124
1125 sno$ = "": snm$ = ""
1126 SP = INSTR(A$(WW), " "): IF SP = 0 THEN sno$ = "0": GOTO 1128
1127 sno$ = LEFT$(A$(WW), SP - 1): snm$ = MID$(A$(WW), SP + 1)
1128 IF INSTR(sno$, "%") > 0 THEN sno$ = ""
IF VAL(sno$) = 0 THEN sno$ = "": snm$ = A$(WW)
1129
1130 RETURN
1131 SP = INSTR(A$(14), "and"): ps = INSTR(A$(14), "&"): IF SP > 1 AND ps > 1 AND ps > SP THEN A$(14) = MID$(A$(14), SP + 3)
1132 RETURN
1133 IF A$(7) = "*NULL*" THEN A$(7) = "Sir or Madam"
1134 RETURN
1135 IF A$(14) = "*NULL*" THEN A$(14) = "Friends"
1136 RETURN

endautoeditsub:
$ENDIF
END SUB
