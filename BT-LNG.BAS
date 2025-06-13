'+----------------------------------------------------------------------+
'|                                                                      |
'|   This source code was adapted from original source code written     |
'|   by Joe Vest and subsequently modified by Ray Yates and Erik        |
'|   Olson (and, perhaps others).  This source is being developed and   |
'|   adapted for private use.  Although the original source provided    |
'|   by Joe Vest was disseminated without copyright, the source         |
'|   presented here is the copyrighted property of Paul Propst, with    |
'|   all rights reserved.  As of this date, the source included here    |
'|   represents a copyrighted "work in progress".                       |
'|                                                                      |
'|   CopyRight 1993 by Paul Propst                                      |
'|   BVX1DX      BT-LNG.BAS                                             |
'|                                                                      |
'|                                                                      |
'|    December 12 1993                                                  |
'+----------------------------------------------------------------------+

DEFINT A-Z

SUB BT(FileName$,Action$,KeyIn$,DataIn$,RetKey$,RetData$,RetStatus%) STATIC PUBLIC
  STATIC LastFile$,Cur.Lvl%,_
         Hlf.Node$,Hlf.Node%,Key.Len$,Key.Len%,Dta.Len$,Dta.Len%,_
         Itm.Len$,Itm.Len%,IDCode$,Root.Node$,Root.Rec&,Nxt.Node$,_
         Nxt.Node&,Lst.Del$,Lst.Del&,Num.Act$,Num.Act%,Num.Keys$,_
         Keys.Act&,Itm.Ptr%,Cur.Rec&


  UsrAct$ = UCASE$(Left$(Action$+" ",1))
  IF UsrAct$ = "C" THEN
    GOSUB BT.Create
  ELSE
    Status% = -1
    IF UsrAct$ <> "Q" THEN
      IF UCASE$(FileName$) <> UCASE$(LastFile$) THEN GOSUB BT.OPEN.New
      IF LastFile$ = "" THEN Status% = 0
    END IF
    IF Status% THEN
      SELECT CASE UsrAct$
        CASE "F"  'Get First Key
          Cur.Lvl% = 0
          GOSUB Bt.Get.Next
        CASE "L"  'Get Last Key
          Cur.Lvl% = 0
          GOSUB Bt.Get.Prev
        CASE "S"  'Search for key in Ky$
          Ky$ = KeyIn$
          GOSUB Bt.Search
        CASE "A"  'Add a non-unique key
          Ky$ = KeyIn$
          Da$ = DataIn$
          GOSUB BT.Add.Non.Unique
        CASE "U"  'Add a unique key
          Ky$ = KeyIn$
          Da$ = DataIn$
          GOSUB BT.Add.Unique
        CASE "D"  'Delete the key/data given
          Ky$ = KeyIn$
          GOSUB BT.Search
          Do Until Status% = 0
            IF Ky$ <> Keys$(Itm.Ptr%) THEN
              Status% = 0
              EXIT LOOP
            END IF
            IF DataIn$ = Dta$(Itm.Ptr%) THEN
              GOSUB BT.Del.Cur
              Status% = -1
              EXIT LOOP
            ELSE
              GOSUB BT.Get.Next
            END IF
          LOOP
        CASE "N"  'Get Next Key
          GOSUB BT.Get.Next
        CASE "P"  'Get Previous Key
          GOSUB Bt.Get.Prev
        CASE "Q"
          IF LastFile$="" THEN
            Status% =  0
          ELSE
            Status% = -1
          END IF
        CASE ELSE 'Error in Action code
          RetKey$ = ""
          RdTmp.Add$= ""
          Status% = 0
      END SELECT
    END IF
    IF INSTR("AUDQ",UsrAct$) AND Status% AND (BT.Update.Always% OR UsrAct$="Q") THEN
      GOSUB BT.Update.Stats
      Call UpdateFile(BT.File.Num%)
      IF UsrAct$ = "Q" THEN
        CLOSE BT.File.Num%
        LastFile$ = ""
      END IF
    END IF
  END IF
  RetKey$ = Keys$(Itm.Ptr%)
  RetData$= Dta$(Itm.Ptr%)
  RetStatus% = Status%
  EXIT SUB

BT.OPEN.New:
  IF LastFile$ <> "" THEN GOSUB BT.Update.Stats
  CLOSE BT.File.Num%
  BT.File.Num% = FREEFILE  'ADDED
  OPEN FileName$ FOR RANDOM SHARED AS #BT.File.Num% LEN=1024
  GOSUB Bt.Get.Stats
  IF Status% = 0 THEN
    LastFile$ = ""
    CLOSE BT.File.Num%
  ELSE
    LastFile$ = FileName$
    GOSUB BT.Get.Stats
    GOSUB Bt.Field.Node
  END IF
  RETURN

BT.Create:
  CLOSE BT.File.Num%
  Hlf.Node% = ( (1021 \ (Len(KeyIn$) + Len(DataIn$) + 4)) \ 2 )
  IF Hlf.Node% < 1 THEN
    Status% = 0
    LastFile$ = ""
    RETURN
  END IF
  IF Hlf.Node% > %BT.Max.Half.Node THEN Hlf.Node% = %BT.Max.Half.Node
  BT.File.Num% = FREEFILE  'ADDED
  OPEN "O",#BT.File.Num%,FileName$
  CLOSE BT.File.Num%
  BT.File.Num% = FREEFILE  'ADDED
  OPEN "R",#BT.File.Num%,FileName$,1024
  GOSUB BT.Field.Stats
  LSET Hlf.Node$ = MKI$(Hlf.Node%)
  LSET Key.Len$ = MKI$(Len(KeyIn$))
  LSET Dta.Len$ = MKI$(Len(DataIn$))
  LSET Itm.Len$ = MKI$(Len(KeyIn$) + Len(DataIn$) + 4)
  LSET IDCode$ = "BT"
  LSET Root.Node$ = MKL$(2)
  LSET Nxt.Node$ = MKL$(3)
  LSET Lst.Del$ = MKL$(0)
  LSET Num.Act$ = MKI$(1)
  LSET Num.Keys$ = MKL$(0)
  PUT BT.File.Num%,1
  Status% = -1
  CLOSE BT.File.Num%
  LastFile$ = ""
  RETURN

BT.GET.STATS:
  GOSUB BT.Field.STATS
  IF IDCode$ <> "BT" THEN
    Status% = 0
    LastFile$ = ""
  ELSE
    Status% = -1
    Hlf.Node%=CVI(Hlf.Node$)
    Key.Len%=CVI(Key.Len$)
    Dta.Len%=CVI(Dta.Len$)
    Itm.Len%=CVI(Itm.Len$)
    Root.Rec&=CVL(Root.Node$)
    Nxt.Node&=CVL(Nxt.Node$)
    Lst.Del&=CVL(Lst.Del$)
    Num.Act%=CVI(Num.Act$)
    Keys.Act&=CVL(Num.Keys$)

  END IF
  RETURN

BT.Field.STATS:
  FIELD BT.File.Num%,2 AS Hlf.Node$,2 AS Key.Len$,2 AS Dta.Len$,2 AS Itm.Len$, _
  2 AS IDCode$,4 AS Root.Node$,4 AS Nxt.Node$,4 AS Lst.Del$,2 AS Num.Act$,_
  4 AS Num.Keys$
  Cur.Rec&=1
  GOSUB BT.GET.CUR
  RETURN

BT.FIELD.NODE:
  FIELD BT.File.Num%,1 AS Act.Keys$,4 AS Ptr$(0)
  FOR Cnt%=1 TO Hlf.Node% * 2
    FIELD BT.File.Num%,5+Itm.Len%*(Cnt%-1) AS Tmp2$,(Key.Len%) AS Keys$(Cnt%),_
    (Dta.Len%) AS Dta$(Cnt%),4 AS Ptr$(Cnt%)
    FIELD BT.File.Num%,5+Itm.Len%*(Cnt%-1) AS Tmp2$,(Itm.Len%) AS Itm$(Cnt%)
  NEXT Cnt%
  RETURN

BT.GET.STACK.NODE:
  Cur.Rec&=Stk&(Cur.Lvl%,0)
  Itm.Ptr%=Stk&(Cur.Lvl%,1)
  GOSUB BT.GET.CUR
  RETURN

BT.POP:
  Decr Cur.Lvl%
  GOSUB BT.GET.STACK.NODE
  RETURN

BT.PUSH:
  Stk&(Cur.Lvl%,0)=Cur.Rec&
  Stk&(Cur.Lvl%,1)=Itm.Ptr%
  RETURN

BT.Update.Stats:
  Cur.Rec&=1
  GET BT.File.Num%,Cur.Rec&
  LSET Root.Node$=MKL$(Root.Rec&)
  LSET Nxt.Node$=MKL$(Nxt.Node&)
  LSET Lst.Del$=MKL$(Lst.Del&)
  LSET Num.Act$=MKI$(Num.Act%)
  LSET Num.Keys$=MKL$(Keys.Act&)
  PUT BT.File.Num%,Cur.Rec&
  RETURN

BT.GET.CUR:
  CoreRecs&& = Cur.Rec& * 1024
  IF (CoreRecs&& > LOF(BT.File.Num%)) THEN
    Field BT.File.Num%, 1024 as Dmy$
    Lset Dmy$ = String$(1024,0)
    Put BT.File.Num%, Cur.Rec&
  END IF
  GET BT.File.Num%,Cur.Rec&
  RETURN

'*** SEARCH FOR FIRST OCCURANCE OF KEY ***

BT.SEARCH:
  Temp&=0
BT.NON.UNQ:
  Status%=0
  Cur.Lvl%=1
  Cur.Rec&=Root.Rec&
  IF LEN(KY$)<>Key.Len% THEN KY$=LEFT$(KY$+STRING$(Key.Len%," "),Key.Len%)
BT.SCAN.NODE:
  GOSUB BT.GET.CUR
  Itm.Ptr%=1
  Cnt%=ASC(Act.Keys$)
BT.S.N.LOOP:
  Wrk.Hlf%=INT((Itm.Ptr%+Cnt%)/2)
  IF KY$>Keys$(Wrk.Hlf%) OR (Temp&<0 AND KY$=Keys$(Wrk.Hlf%)) THEN_
    Itm.Ptr%=Wrk.Hlf%+1 ELSE Cnt%=Wrk.Hlf%-1
  IF Cnt%>=Itm.Ptr% THEN
    GOTO BT.S.N.LOOP
  ELSE
    GOSUB BT.PUSH
    IF Itm.Ptr%<=ASC(Act.Keys$) THEN
      IF KY$=Keys$(Itm.Ptr%) THEN
        Status%=-1
        IF CVL(Ptr$(Itm.Ptr%-1))=0 THEN RETURN
      END IF
    END IF
  END IF
  IF CVL(Ptr$(Itm.Ptr%-1))>0 THEN
    Cur.Rec&=CVL(Ptr$(Itm.Ptr%-1))
    Incr Cur.Lvl%
    GOTO BT.SCAN.NODE
  END IF
  IF Status% THEN BT.GN.L.SON
  IF Temp& = 0 THEN
    GOSUB BT.GN.OK
    Status% = 0
  END IF
  RETURN

'*** ADD KEY AT CURRENT NODE LOCATION ***

BT.ADD.AT.CUR:
  Tmp.Add$=LEFT$(KY$+SPACE$(Key.Len%),Key.Len%)+LEFT$(DA$+SPACE$(Dta.Len%),Dta.Len%)+MKL$(0)
  Temp&=0
BT.CHK.FULL:
  IF ASC(Act.Keys$)<Hlf.Node%*2 THEN
    LSET Act.Keys$=CHR$(ASC(Act.Keys$)+1)
    Cnt%=ASC(Act.Keys$)
    GOSUB BT.INS.IN.NODE
    LSET Ptr$(Itm.Ptr%-1)=MKL$(Temp&)
    PUT BT.File.Num%,Cur.Rec&
    INCR Keys.Act&
    Tmp.Add$=""
    Temp$=""
    Emerg$=""
    Status% = -1
    RETURN
  END IF
  IF Itm.Ptr%>Hlf.Node%+1 THEN
    GOTO BT.ADD.RIGHT
  ELSEIF Itm.Ptr%=Hlf.Node%+1 THEN
    Emerg$=Tmp.Add$
  ELSE
    Emerg$=Itm$(Hlf.Node%)
    Cnt%=Hlf.Node%
    GOSUB BT.INS.IN.NODE
  END IF
  LSET Ptr$(Itm.Ptr%-1)=MKL$(Temp&)
  LSET Act.Keys$=CHR$(Hlf.Node%)
  FIELD BT.File.Num%,5+Hlf.Node%*(Itm.Len%) AS Tmp2$,Hlf.Node%*(Itm.Len%) AS Tmp2$
  Temp$=Tmp2$
  PUT BT.File.Num%,Cur.Rec&
  Temp&=Cur.Rec&
  GOSUB BT.GET.AVAIL.NODE
  GOSUB BT.SET.COPY
  GOSUB BT.SET.RGHT.SON
  GOTO BT.WRT.NODE
BT.ADD.RIGHT:
  FIELD BT.File.Num%,1 AS Tmp2$,2+Hlf.Node%*(Itm.Len%) AS Tmp2$
  Temp$=Tmp2$
  Itm.Ptr%=Itm.Ptr%-Hlf.Node%
  Emerg$=Itm$(Hlf.Node%+1)
  FOR Cnt%=1 TO Itm.Ptr%-2
    LSET Itm$(Cnt%)=Itm$(Cnt%+Hlf.Node%+1)
  NEXT Cnt%
  LSET Itm$(Itm.Ptr%-1)=Tmp.Add$
  IF Itm.Ptr%>Hlf.Node% THEN
    GOTO BT.SET.LFT.SON
  ELSE
    FOR Cnt%=Itm.Ptr% TO Hlf.Node%
      LSET Itm$(Cnt%)=Itm$(Cnt%+Hlf.Node%)
    NEXT Cnt%
  END IF
BT.SET.LFT.SON:
  GOSUB BT.SET.RGHT.SON
  LSET Ptr$(Itm.Ptr%-2)=MKL$(Temp&)
  PUT BT.File.Num%,Cur.Rec&
  GOSUB BT.GET.AVAIL.NODE
  FIELD BT.File.Num%,1 AS Tmp2$,LEN(Temp$) AS Tmp2$
  LSET Tmp2$=Temp$
  LSET Act.Keys$=CHR$(Hlf.Node%)
  Temp&=Cur.Rec&
BT.WRT.NODE:
  PUT BT.File.Num%,Cur.Rec&
  Tmp.Add$=Emerg$
  Decr Cur.Lvl%
  IF Cur.Lvl%=0 THEN
    GOSUB BT.GET.AVAIL.NODE
    Itm.Ptr%=1
    Root.Rec&=Cur.Rec&
    LSET Ptr$(0)=MKL$(Temp&)
    GOTO BT.CHK.FULL
  ELSE
    GOSUB BT.GET.STACK.NODE
    GOTO BT.CHK.FULL
  END IF
BT.INS.IN.NODE:
  FOR Cnt%=Cnt% TO Itm.Ptr%+1 STEP -1
    LSET Itm$(Cnt%)=Itm$(Cnt%-1)
  NEXT Cnt%
  LSET Itm$(Itm.Ptr%)=Tmp.Add$
  RETURN
BT.GET.AVAIL.NODE:
  IF Lst.Del&>0 THEN
    Cur.Rec&=Lst.Del&
    GOSUB BT.GET.CUR
    Lst.Del&=CVL(Ptr$(0))
  ELSE
    Cur.Rec&=Nxt.Node&
    GOSUB BT.GET.CUR
    INCR Nxt.Node&
  END IF
  INCR Num.Act%
  LSET Act.Keys$=CHR$(0)
  RETURN
BT.SET.RGHT.SON:
  LSET Act.Keys$=CHR$(Hlf.Node%)
  LSET Ptr$(0)=RIGHT$(Emerg$,4)
  MID$(Emerg$,LEN(Emerg$)-3,4)=MKL$(Cur.Rec&)
  RETURN
BT.SET.COPY:
  FIELD BT.File.Num%,5 AS Tmp2$,LEN(Temp$) AS Tmp2$
  LSET Tmp2$=Temp$
  RETURN

'*** Get Next Key in the Index ***

BT.GET.NEXT:
  IF Cur.Lvl%=0 THEN
    Cur.Rec&=Root.Rec&
    Cur.Lvl%=1
    Itm.Ptr%=1
  ELSE
    Itm.Ptr%=Itm.Ptr%+1
  END IF
BT.GN.L.SON:
  GOSUB BT.GET.CUR
  IF CVL(Ptr$(Itm.Ptr%-1))<>0 THEN
    GOSUB BT.PUSH
    Cur.Rec&=CVL(Ptr$(Itm.Ptr%-1))
    Incr Cur.Lvl%
    Itm.Ptr%=1
    GOTO BT.GN.L.SON
  END IF
BT.GN.OK:
  IF Itm.Ptr%<=ASC(Act.Keys$) THEN
    Status%=-1
    RETURN
  ELSEIF Cur.Lvl%=1 THEN
    Cur.Lvl%=0
    Status%=0
    RETURN
  ELSE
    GOSUB BT.POP
    GOTO BT.GN.OK
  END IF

'*** Get Previous Key in the Index ***

BT.GET.PREV:
  IF Cur.Lvl%=0 THEN Cur.Rec&=Root.Rec& ELSE BT.GP.RHT
BT.DWN1:
  Incr Cur.Lvl%
  GOSUB BT.GET.CUR
  Itm.Ptr%=ASC(Act.Keys$)+1
BT.GP.RHT:
  GOSUB BT.PUSH
  IF CVL(Ptr$(Itm.Ptr%-1))>0 THEN
    Cur.Rec&=CVL(Ptr$(Itm.Ptr%-1))
    GOTO BT.DWN1
  END IF
BT.GP.OK:
  IF Itm.Ptr%>1 THEN
    Itm.Ptr%=Itm.Ptr%-1
    Status%=-1
    RETURN
  ELSEIF Cur.Lvl%=1 THEN
    Status%=0
    Cur.Lvl%=0
    RETURN
  ELSE
    GOSUB BT.POP
    GOTO BT.GP.OK
  END IF


'*** Delete The Key at the Current Place in the Index ***

BT.DEL.CUR:
  GOSUB BT.PUSH
  IF CVL(Ptr$(Itm.Ptr%))>0 THEN
    GOTO BT.DC.REPLACE
  ELSE
    GOSUB BT.DECR.NODE
    IF Itm.Ptr%-1<>ASC(Act.Keys$) THEN GOSUB BT.SHF.FM.RHT
  END IF
  PUT BT.File.Num%,Cur.Rec&
  IF (Cur.Rec&=Root.Rec&) OR (ASC(Act.Keys$)>=Hlf.Node%) THEN BT.DC.DONE
  DO
    GOSUB BT.UNDERFLOW
  LOOP UNTIL Status% = 0
BT.DC.DONE:
  DECR Keys.Act&
  RETURN
BT.DC.REPLACE:
  GOSUB BT.GET.NEXT
  Tmp.Add$=Itm$(Itm.Ptr%)
  GOSUB BT.GET.PREV
  GOSUB BT.REP.FTH.ITEM
  PUT BT.File.Num%,Cur.Rec&
  GOSUB BT.GET.NEXT
  GOTO BT.DEL.CUR

BT.UNDERFLOW:
  Status%=-1
  GOSUB BT.POP
  IF ASC(Act.Keys$)=Itm.Ptr%-1 THEN
    GOTO BT.UNF.2.LFT
  ELSE
    Cur.Rec&=CVL(Ptr$(Itm.Ptr%))
    GOSUB BT.GET.MVBL
    Emerg$=Ptr$(0)
  END IF
  IF Wrk.Hlf%<= 0 THEN
    GOTO BT.MRG.RHT
  ELSE
    FIELD BT.File.Num%,5 AS Tmp2$,Itm.Len%*(Wrk.Hlf%-1) AS Tmp2$
    Temp$=Tmp2$
    Tmp.Add$=Itm$(Wrk.Hlf%)
    LSET Ptr$(0)=Ptr$(Wrk.Hlf%)
    LSET Act.Keys$=CHR$(ASC(Act.Keys$)-Wrk.Hlf%)
    IF ASC(Act.Keys$)>0 THEN
      FOR Cnt%=1 TO ASC(Act.Keys$)
        LSET Itm$(Cnt%)=Itm$(Cnt%+Wrk.Hlf%)
      NEXT Cnt%
    END IF
  END IF
  PUT BT.File.Num%,Cur.Rec&
  GOSUB BT.GET.STACK.NODE
  Temp$=Itm$(Itm.Ptr%)+Temp$
  GOSUB BT.REP.FTH.ITEM
  GOSUB BT.WRT.FTH
  FIELD BT.File.Num%,5+Itm.Len%*(Hlf.Node%-1) AS Tmp2$,LEN(Temp$) AS Tmp2$
  LSET Tmp2$=Temp$
  LSET Ptr$(Hlf.Node%)=Emerg$
  GOTO BT.ADJ.CNT
BT.MRG.RHT:
  FIELD BT.File.Num%,5 AS Tmp2$,Hlf.Node%*(Itm.Len%) AS Tmp2$
  Temp$=Tmp2$
  Tmp2$=Ptr$(0)
  LSET Act.Keys$=CHR$(0)
  LSET Ptr$(0)=MKL$(Lst.Del&)
  Lst.Del&=Cur.Rec&
  DECR Num.Act%
  PUT BT.File.Num%,Cur.Rec&
  GOSUB BT.GET.STACK.NODE
  LSET Ptr$(Itm.Ptr%)=Tmp2$
  Temp$=Itm$(Itm.Ptr%)+Temp$
  GOSUB BT.DECR.NODE
  IF Cur.Rec&=Root.Rec& AND ASC(Act.Keys$)=0 THEN
    Root.Rec&=Stk&(Cur.Lvl%+1,0)
    LSET Ptr$(0)=MKL$(Lst.Del&)
    Lst.Del&=Cur.Rec&
    DECR Num.Act%
    Status%=0
    GOTO BT.WRT.MOD.FTH
  END IF
  IF (ASC(Act.Keys$)>=Hlf.Node%) OR (Cur.Rec&=Root.Rec&) THEN Status%=0
  IF ASC(Act.Keys$)>=Itm.Ptr% THEN GOSUB BT.SHF.FM.RHT
BT.WRT.MOD.FTH:
  GOSUB BT.WRT.FTH
  FIELD BT.File.Num%,5+Itm.Len%*(Hlf.Node%-1) AS Tmp2$,LEN(Temp$) AS Tmp2$
  GOTO BT.PUT.IN.BUF
BT.UNF.2.LFT:
  Cur.Rec&=CVL(Ptr$(Itm.Ptr%-2))
  GOSUB BT.GET.MVBL
  IF Wrk.Hlf%<=0 THEN BT.MRG.LFT
  LSET Act.Keys$=CHR$(ASC(Act.Keys$)-Wrk.Hlf%)
  Tmp.Add$=Itm$(ASC(Act.Keys$)+1)
  FIELD BT.File.Num%,5+Itm.Len%*(ASC(Act.Keys$)+1) AS Tmp2$,Itm.Len%*(Wrk.Hlf%-1) AS Tmp2$
  Temp$=Tmp2$
  Emerg$=Ptr$(ASC(Act.Keys$)+1)
  PUT BT.File.Num%,Cur.Rec&
  GOSUB BT.GET.STACK.NODE
  Temp$=Temp$+Itm$(Itm.Ptr%-1)
  LSET Itm$(Itm.Ptr%-1)=Tmp.Add$
  LSET Ptr$(Itm.Ptr%-1)=MKL$(Stk&(Cur.Lvl%+1,0))
  GOSUB BT.WRT.FTH
  IF Hlf.Node%>1 THEN
    FOR Cnt%=Hlf.Node%-1 TO 1 STEP -1
      LSET Itm$(Cnt%+Wrk.Hlf%)=Itm$(Cnt%)
    NEXT Cnt%
  END IF
  GOSUB BT.SET.COPY
  LSET Ptr$(Wrk.Hlf%)=Ptr$(0)
  LSET Ptr$(0)=Emerg$
BT.ADJ.CNT:
  LSET Act.Keys$=CHR$(Hlf.Node%-1+Wrk.Hlf%)
  PUT BT.File.Num%,Cur.Rec&
  Status%=0
  RETURN
BT.MRG.LFT:
  FIELD BT.File.Num%,1 AS Tmp2$,2+ASC(Act.Keys$)*(Itm.Len%) AS Tmp2$
  Temp$=Tmp2$
  LSET Act.Keys$=CHR$(0)
  LSET Ptr$(0)=MKL$(Lst.Del&)
  Lst.Del&=Cur.Rec&
  DECR Num.Act%
  PUT BT.File.Num%,Cur.Rec&
  GOSUB BT.GET.STACK.NODE
  Temp$=Temp$+LEFT$(Itm$(Itm.Ptr%-1),Itm.Len%-2)
  LSET Ptr$(Itm.Ptr%-2)=MKL$(Stk&(Cur.Lvl%+1,0))
  GOSUB BT.DECR.NODE
  Status%=0
  IF Cur.Rec&=Root.Rec& AND ASC(Act.Keys$)=0 THEN
    Root.Rec&=Stk&(Cur.Lvl%+1,0)
    LSET Ptr$(0)=MKL$(Lst.Del&)
    Lst.Del&=Cur.Rec&
    DECR Num.Act%
  ELSEIF (Cur.Rec&<>Root.Rec&) AND (ASC(Act.Keys$)<Hlf.Node%) THEN
    Status%=-1
  END IF
  GOSUB BT.WRT.FTH
  FIELD BT.File.Num%,5 AS Tmp2$,Itm.Len%*ASC(Act.Keys$) AS Tmp2$
  Temp$=Temp$+Ptr$(0)+Tmp2$
  FIELD BT.File.Num%,1 AS Tmp2$,LEN(Temp$) AS Tmp2$
BT.PUT.IN.BUF:
  LSET Tmp2$=Temp$
  LSET Act.Keys$=CHR$(Hlf.Node%*2)
  PUT BT.File.Num%,Cur.Rec&
  IF Status% THEN
    GOSUB BT.POP
    RETURN
  ELSE
    RETURN
  END IF
BT.SHF.FM.RHT:
  FOR Cnt%=Itm.Ptr% TO ASC(Act.Keys$)
    LSET Itm$(Cnt%)=Itm$(Cnt%+1)
  NEXT Cnt%
  RETURN
BT.WRT.FTH:
  PUT BT.File.Num%,Cur.Rec&
  Incr Cur.Lvl%
  GOSUB BT.GET.STACK.NODE
  RETURN
BT.DECR.NODE:
  LSET Act.Keys$=CHR$(ASC(Act.Keys$)-1)
  RETURN
BT.GET.MVBL:
  GOSUB BT.GET.CUR
  Wrk.Hlf%=INT((ASC(Act.Keys$)-Hlf.Node%+1)/2)
  RETURN
BT.REP.FTH.ITEM:
  Tmp2$=Ptr$(Itm.Ptr%)
  LSET Itm$(Itm.Ptr%)=Tmp.Add$
  LSET Ptr$(Itm.Ptr%)=Tmp2$
  RETURN

BT.ADD.NON.UNIQUE:
  Temp&=-1
  GOSUB BT.NON.UNQ
  GOSUB BT.ADD.AT.CUR
  RETURN

BT.ADD.UNIQUE:
  Temp& = 1
  GOSUB BT.Non.Unq
  IF Status% THEN
    Status% = 0
  ELSE
    GOSUB BT.ADD.AT.CUR
  END IF
  RETURN

END SUB 'BT

SUB UpdateFile(FileNum%)
  FLUSH (FileNum%)
END SUB

SUB UpdateALL
  FLUSH
END SUB
