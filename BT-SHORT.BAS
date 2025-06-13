$IF NOT %NODBASE
'PUBLIC Act.Keys$, BT.Update.Always%
' be sure that you have the above PUBLIC statement near the top of
' the calling program.
'EXTERNAL Act.Keys$, BT.Update.Always%
' and put this line at the top of this file if you are creating a unit,
' otherwise, PUBLIC and EXTERNAL are not necessary with include files
Sub BT(FileName$,Action$,SKy$,SDta$,RKy$,RDta$,RCCODE%) PUBLIC
  Static Keys$(),Ptr$(),Stk%(),Itm$(),Dta$(),LastFile$,Cur.Lvl%,_
         Hlf.Node$,Hlf.Node%,Key.Len$,Key.Len%,Dta.Len$,Dta.Len%,_
         Itm.Len$,Itm.Len%,CCODE$,Root.Node$,Root.Rec%,Nxt.Node$,_
         Nxt.Node%,Lst.Del$,Lst.Del%,Num.Act$,Num.Act%,Num.Keys$,_
         Keys.Act%,Itm.Ptr%,Cur.Rec%

  DIM    Keys$(%BT.Max.Node),Ptr$(%BT.Max.Node),Stk%(10,1),_
         Itm$(%BT.Max.Node),Dta$(%BT.Max.Node)

  UsrAct$ = Ucase$(Left$(Action$+" ",1))
  If UsrAct$ = "C" Then
    Gosub BT.Create
  Else
    Status% = -1
    If UsrAct$ <> "Q" Then
      If Ucase$(FileName$) <> Ucase$(LastFile$) then Gosub BT.Open.New
      If LastFile$ = "" Then Status% = 0
    End if
    If Status% Then
      Select Case UsrAct$
        Case "F"  'Get First Key
          Cur.Lvl% = 0
          Gosub Bt.Get.Next
        Case "L"  'Get Last Key
          Cur.Lvl% = 0
          Gosub Bt.Get.Prev
        Case "S"  'Search for key in Ky$
          Ky$ = Sky$
          Gosub Bt.Search
        Case "A"  'Add a non-unique key
          Ky$ = Sky$
          Da$ = SDta$
          Gosub BT.Add.Non.Unique
        Case "U"  'Add a unique key
          Ky$ = Sky$
          Da$ = Sdta$
          Gosub BT.Add.Unique
        Case "D"  'Delete the key/data given
          Ky$ = Sky$
          Gosub BT.Search
          Do Until Status% = 0
            If Ky$ <> Keys$(Itm.Ptr%) Then
              Status% = 0
              Exit Loop
            End if
            If SDta$ = Dta$(Itm.Ptr%) Then
              Gosub BT.Del.Cur
              Status% = -1
              Exit Loop
            Else
              Gosub BT.Get.Next
            End if
          Loop
        Case "N"  'Get Next Key
          Gosub BT.Get.Next
        Case "P"  'Get Previous Key
          Gosub Bt.Get.Prev
        Case "Q"
          If LastFile$="" then
            Status% =  0
          Else
            Status% = -1
          End if
        Case Else 'Error in Action CCODE
          Rky$ = ""
          RdTmp.Add$= ""
          Status% = 0
      End Select
    End if
    If Instr("AUDQ",UsrAct$) And Status% And (BT.Update.Always% or UsrAct$="Q") Then
      Gosub BT.Update.Stats
      Call UpdateFile(%BT.File.Num)
      If UsrAct$ = "Q" Then
        Close %BT.File.Num
        LastFile$ = ""
      End if
    End if
  End if
  Rky$ = Keys$(Itm.Ptr%)
  Rdta$= Dta$(Itm.Ptr%)
  RCCODE% = Status%
  Exit Sub

BT.Open.New:
  If LastFile$ <> "" Then Gosub BT.Update.Stats
  Close %BT.File.Num
  Open FileName$ FOR RANDOM SHARED AS #%BT.File.Num LEN=256
  Gosub Bt.Get.Stats
  If Status% = 0 Then
    LastFile$ = ""
    Close %BT.File.Num
  Else
    LastFile$ = FileName$
    Gosub BT.Get.Stats
    Gosub Bt.Field.Node
  End if
  Return

BT.Create:
  Close %BT.File.Num
  Hlf.Node% = ( (253 \ (Len(SKy$) + Len(SDta$) + 2)) \ 2 )
  If Hlf.Node% < 1 Then
    Status% = 0
    LastFile$ = ""
    Return
  End if
  If Hlf.Node% > %BT.Max.Half.Node then Hlf.Node% = %BT.Max.Half.Node
  Open "O",%BT.File.Num,FileName$
  Close %BT.File.Num
  Open "R",%BT.File.Num,FileName$,256
  Gosub BT.Field.Stats
  Lset Hlf.Node$ = MKI$(Hlf.Node%)
  Lset Key.Len$ = MKI$(Len(SKy$))
  Lset Dta.Len$ = MKI$(Len(SDta$))
  Lset Itm.Len$ = MKI$(Len(SKy$) + Len(SDta$) + 2)
  Lset CCODE$ = "BT"
  Lset Root.Node$ = MKI$(2)
  Lset Nxt.Node$ = MKI$(3)
  Lset Lst.Del$ = MKI$(0)
  Lset Num.Act$ = MKI$(1)
  Lset Num.Keys$ = MKI$(0)
  Put %BT.File.Num,1
  Status% = -1
  Close %BT.File.Num
  LastFile$ = ""
  Return

BT.GET.STATS:
  GOSUB BT.Field.STATS
  If CCODE$ <> "BT" Then
    Status% = 0
    LastFile$ = ""
  Else
    Status% = -1
    Hlf.Node%=CVI(Hlf.Node$)
    Key.Len%=CVI(Key.Len$)
    Dta.Len%=CVI(Dta.Len$)
    Itm.Len%=CVI(Itm.Len$)
    Root.Rec%=CVI(Root.Node$)
    Nxt.Node%=CVI(Nxt.Node$)
    Lst.Del%=CVI(Lst.Del$)
    Num.Act%=CVI(Num.Act$)
    Keys.Act%=CVI(Num.Keys$)
  End if
  RETURN

BT.Field.STATS:
  FIELD %BT.File.Num,2 AS Hlf.Node$,2 AS Key.Len$,2 AS Dta.Len$,2 AS Itm.Len$, _
  2 AS CCODE$,2 AS Root.Node$,2 AS Nxt.Node$,2 AS Lst.Del$,2 AS Num.Act$,_
  2 AS Num.Keys$
  Cur.Rec%=1
  GOSUB BT.GET.CUR
  RETURN

BT.FIELD.NODE:
  FIELD %BT.File.Num,1 AS Act.Keys$,2 AS Ptr$(0)
  FOR Cnt%=1 TO Hlf.Node%*2
    FIELD %BT.File.Num,3+Itm.Len%*(Cnt%-1) AS Tmp2$,(Key.Len%) AS Keys$(Cnt%),_
    (Dta.Len%) AS Dta$(Cnt%),2 AS Ptr$(Cnt%)
    FIELD %BT.File.Num,3+Itm.Len%*(Cnt%-1) AS Tmp2$,(Itm.Len%) AS Itm$(Cnt%)
  NEXT Cnt%
  RETURN

BT.GET.STACK.NODE:
  Cur.Rec%=Stk%(Cur.Lvl%,0)
  Itm.Ptr%=Stk%(Cur.Lvl%,1)
  GOSUB BT.GET.CUR
  RETURN

BT.POP:
  Decr Cur.Lvl%
  GOSUB BT.GET.STACK.NODE
  RETURN

BT.PUSH:
  Stk%(Cur.Lvl%,0)=Cur.Rec%
  Stk%(Cur.Lvl%,1)=Itm.Ptr%
  RETURN

BT.Update.Stats:
  Cur.Rec%=1
  GET %BT.File.Num,Cur.Rec%
  LSET Root.Node$=MKI$(Root.Rec%)
  LSET Nxt.Node$=MKI$(Nxt.Node%)
  LSET Lst.Del$=MKI$(Lst.Del%)
  LSET Num.Act$=MKI$(Num.Act%)
  LSET Num.Keys$=MKI$(Keys.Act%)
  PUT %BT.File.Num,Cur.Rec%
  RETURN

BT.GET.CUR:
  If Cur.Rec% * 256 > Lof(%BT.File.Num) Then
    Field %BT.File.Num,256 as Dmy$
    Lset Dmy$ = String$(256,0)
    Put %BT.File.Num,Cur.Rec%
  End if
  GET %BT.File.Num,Cur.Rec%
  RETURN

'*** SEARCH FOR FIRST OCCURANCE OF KEY ***

BT.SEARCH:
  Temp%=0
BT.NON.UNQ:
  Status%=0
  Cur.Lvl%=1
  Cur.Rec%=Root.Rec%
  IF LEN(KY$)<>Key.Len% THEN KY$=LEFT$(KY$+STRING$(Key.Len%," "),Key.Len%)
BT.SCAN.NODE:
  GOSUB BT.GET.CUR
  Itm.Ptr%=1
  Cnt%=ASC(Act.Keys$)
BT.S.N.LOOP:
  Wrk.Hlf%=INT((Itm.Ptr%+Cnt%)/2)
  IF KY$>Keys$(Wrk.Hlf%) OR (Temp%<0 AND KY$=Keys$(Wrk.Hlf%)) THEN_
    Itm.Ptr%=Wrk.Hlf%+1 ELSE Cnt%=Wrk.Hlf%-1
  IF Cnt%>=Itm.Ptr% THEN
    GOTO BT.S.N.LOOP
  ELSE
    GOSUB BT.PUSH
    IF Itm.Ptr%<=ASC(Act.Keys$) THEN
      IF KY$=Keys$(Itm.Ptr%) THEN
        Status%=-1
        IF CVI(Ptr$(Itm.Ptr%-1))=0 THEN RETURN
      END IF
    END IF
  END IF
  IF CVI(Ptr$(Itm.Ptr%-1))>0 THEN
    Cur.Rec%=CVI(Ptr$(Itm.Ptr%-1))
    Incr Cur.Lvl%
    GOTO BT.SCAN.NODE
  END IF
  IF Status% THEN BT.GN.L.SON
  If Temp% = 0 Then
    Gosub BT.GN.OK
    Status% = 0
  End if
  RETURN



'*** ADD KEY AT CURRENT NODE LOCATION ***

BT.ADD.AT.CUR:
  Tmp.Add$=LEFT$(KY$+STRING$(Key.Len%," "),Key.Len%)+LEFT$(DA$+STRING$(Dta.Len%," "),Dta.Len%)+MKI$(0)
  Temp%=0
BT.CHK.FULL:
  IF ASC(Act.Keys$)<Hlf.Node%*2 THEN
    LSET Act.Keys$=CHR$(ASC(Act.Keys$)+1)
    Cnt%=ASC(Act.Keys$)
    GOSUB BT.INS.IN.NODE
    LSET Ptr$(Itm.Ptr%-1)=MKI$(Temp%)
    PUT %BT.File.Num,Cur.Rec%
    Keys.Act%=Keys.Act%+1
    Tmp.Add$=""
    Temp$=""
    Emerg$=""
    Status% = -1
    RETURN
  END IF
  IF Itm.Ptr%>Hlf.Node%+1 THEN
    GOTO BT.ADD.RIGHT
  ELSEIF Itm.Ptr%=Hlf.Node%+1 Then
    Emerg$=Tmp.Add$
  ELSE
    Emerg$=Itm$(Hlf.Node%)
    Cnt%=Hlf.Node%
    GOSUB BT.INS.IN.NODE
  END IF
  LSET Ptr$(Itm.Ptr%-1)=MKI$(Temp%)
  LSET Act.Keys$=CHR$(Hlf.Node%)
  FIELD %BT.File.Num,3+Hlf.Node%*(Itm.Len%) AS Tmp2$,Hlf.Node%*(Itm.Len%) AS Tmp2$
  Temp$=Tmp2$
  PUT %BT.File.Num,Cur.Rec%
  Temp%=Cur.Rec%
  GOSUB BT.GET.AVAIL.NODE
  GOSUB BT.SET.COPY
  GOSUB BT.SET.RGHT.SON
  GOTO BT.WRT.NODE
BT.ADD.RIGHT:
  FIELD %BT.File.Num,1 AS Tmp2$,2+Hlf.Node%*(Itm.Len%) AS Tmp2$
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
  LSET Ptr$(Itm.Ptr%-2)=MKI$(Temp%)
  PUT %BT.File.Num,Cur.Rec%
  GOSUB BT.GET.AVAIL.NODE
  FIELD %BT.File.Num,1 AS Tmp2$,LEN(Temp$) AS Tmp2$
  LSET Tmp2$=Temp$
  LSET Act.Keys$=CHR$(Hlf.Node%)
  Temp%=Cur.Rec%
BT.WRT.NODE:
  PUT %BT.File.Num,Cur.Rec%
  Tmp.Add$=Emerg$
  Decr Cur.Lvl%
  IF Cur.Lvl%=0 THEN
    GOSUB BT.GET.AVAIL.NODE
    Itm.Ptr%=1
    Root.Rec%=Cur.Rec%
    LSET Ptr$(0)=MKI$(Temp%)
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
  IF Lst.Del%>0 THEN
    Cur.Rec%=Lst.Del%
    GOSUB BT.GET.CUR
    Lst.Del%=CVI(Ptr$(0))
  ELSE
    Cur.Rec%=Nxt.Node%
    GOSUB BT.GET.CUR
    Nxt.Node%=Nxt.Node%+1
  END IF
  Num.Act%=Num.Act%+1
  LSET Act.Keys$=CHR$(0)
  RETURN
BT.SET.RGHT.SON:
  LSET Act.Keys$=CHR$(Hlf.Node%)
  LSET Ptr$(0)=RIGHT$(Emerg$,2)
  MID$(Emerg$,LEN(Emerg$)-1,2)=MKI$(Cur.Rec%)
  RETURN
BT.SET.COPY:
  FIELD %BT.File.Num,3 AS Tmp2$,LEN(Temp$) AS Tmp2$
  LSET Tmp2$=Temp$
  RETURN


'*** Get Next Key in the Index ***

BT.GET.NEXT:
  IF Cur.Lvl%=0 THEN
    Cur.Rec%=Root.Rec%
    Cur.Lvl%=1
    Itm.Ptr%=1
  ELSE
    Itm.Ptr%=Itm.Ptr%+1
  END IF
BT.GN.L.SON:
  GOSUB BT.GET.CUR
  IF CVI(Ptr$(Itm.Ptr%-1))<>0 THEN
    GOSUB BT.PUSH
    Cur.Rec%=CVI(Ptr$(Itm.Ptr%-1))
    Incr Cur.Lvl%
    Itm.Ptr%=1
    GOTO BT.GN.L.SON
  END IF
BT.GN.OK:
  IF Itm.Ptr%<=ASC(Act.Keys$) THEN
    Status%=-1
    RETURN
  ELSEIF Cur.Lvl%=1 Then
    Cur.Lvl%=0
    Status%=0
    RETURN
  ELSE
    GOSUB BT.POP
    GOTO BT.GN.OK
  END IF


'*** Get Previous Key in the Index ***

BT.GET.PREV:
  IF Cur.Lvl%=0 THEN Cur.Rec%=Root.Rec% ELSE BT.GP.RHT
BT.DWN1:
  Incr Cur.Lvl%
  GOSUB BT.GET.CUR
  Itm.Ptr%=ASC(Act.Keys$)+1
BT.GP.RHT:
  GOSUB BT.PUSH
  IF CVI(Ptr$(Itm.Ptr%-1))>0 THEN
    Cur.Rec%=CVI(Ptr$(Itm.Ptr%-1))
    GOTO BT.DWN1
  END IF
BT.GP.OK:
  IF Itm.Ptr%>1 THEN
    Itm.Ptr%=Itm.Ptr%-1
    Status%=-1
    RETURN
  ELSEIF Cur.Lvl%=1 Then
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
  IF CVI(Ptr$(Itm.Ptr%))>0 THEN
    GOTO BT.DC.REPLACE
  ELSE
    GOSUB BT.DECR.NODE
    IF Itm.Ptr%-1<>ASC(Act.Keys$) THEN GOSUB BT.SHF.FM.RHT
  END IF
  PUT %BT.File.Num,Cur.Rec%
  IF (Cur.Rec%=Root.Rec%) OR (ASC(Act.Keys$)>=Hlf.Node%) THEN BT.DC.DONE
  DO
    GOSUB BT.UNDERFLOW
  LOOP UNTIL Status% = 0
BT.DC.DONE:
  Keys.Act%=Keys.Act%-1
  RETURN
BT.DC.REPLACE:
  GOSUB BT.GET.NEXT
  Tmp.Add$=Itm$(Itm.Ptr%)
  GOSUB BT.GET.PREV
  GOSUB BT.REP.FTH.ITEM
  PUT %BT.File.Num,Cur.Rec%
  GOSUB BT.GET.NEXT
  GOTO BT.DEL.CUR

BT.UNDERFLOW:
  Status%=-1
  GOSUB BT.POP
  IF ASC(Act.Keys$)=Itm.Ptr%-1 THEN
    GOTO BT.UNF.2.LFT
  ELSE
    Cur.Rec%=CVI(Ptr$(Itm.Ptr%))
    GOSUB BT.GET.MVBL
    Emerg$=Ptr$(0)
  END IF
  IF Wrk.Hlf%<= 0 THEN
    GOTO BT.MRG.RHT
  ELSE
    FIELD %BT.File.Num,3 AS Tmp2$,Itm.Len%*(Wrk.Hlf%-1) AS Tmp2$
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
  PUT %BT.File.Num,Cur.Rec%
  GOSUB BT.GET.STACK.NODE
  Temp$=Itm$(Itm.Ptr%)+Temp$
  GOSUB BT.REP.FTH.ITEM
  GOSUB BT.WRT.FTH
  FIELD %BT.File.Num,3+Itm.Len%*(Hlf.Node%-1) AS Tmp2$,LEN(Temp$) AS Tmp2$
  LSET Tmp2$=Temp$
  LSET Ptr$(Hlf.Node%)=Emerg$
  GOTO BT.ADJ.CNT
BT.MRG.RHT:
  FIELD %BT.File.Num,3 AS Tmp2$,Hlf.Node%*(Itm.Len%) AS Tmp2$
  Temp$=Tmp2$
  Tmp2$=Ptr$(0)
  LSET Act.Keys$=CHR$(0)
  LSET Ptr$(0)=MKI$(Lst.Del%)
  Lst.Del%=Cur.Rec%
  Num.Act%=Num.Act%-1
  PUT %BT.File.Num,Cur.Rec%
  GOSUB BT.GET.STACK.NODE
  LSET Ptr$(Itm.Ptr%)=Tmp2$
  Temp$=Itm$(Itm.Ptr%)+Temp$
  GOSUB BT.DECR.NODE
  IF Cur.Rec%=Root.Rec% AND ASC(Act.Keys$)=0 THEN
    Root.Rec%=Stk%(Cur.Lvl%+1,0)
    LSET Ptr$(0)=MKI$(Lst.Del%)
    Lst.Del%=Cur.Rec%
    Num.Act%=Num.Act%-1
    Status%=0
    GOTO BT.WRT.MOD.FTH
  END IF
  IF (ASC(Act.Keys$)>=Hlf.Node%) OR (Cur.Rec%=Root.Rec%) THEN Status%=0
  IF ASC(Act.Keys$)>=Itm.Ptr% THEN GOSUB BT.SHF.FM.RHT
BT.WRT.MOD.FTH:
  GOSUB BT.WRT.FTH
  FIELD %BT.File.Num,3+Itm.Len%*(Hlf.Node%-1) AS Tmp2$,LEN(Temp$) AS Tmp2$
  GOTO BT.PUT.IN.BUF
BT.UNF.2.LFT:
  Cur.Rec%=CVI(Ptr$(Itm.Ptr%-2))
  GOSUB BT.GET.MVBL
  IF Wrk.Hlf%<=0 THEN BT.MRG.LFT
  LSET Act.Keys$=CHR$(ASC(Act.Keys$)-Wrk.Hlf%)
  Tmp.Add$=Itm$(ASC(Act.Keys$)+1)
  FIELD %BT.File.Num,3+Itm.Len%*(ASC(Act.Keys$)+1) AS Tmp2$,Itm.Len%*(Wrk.Hlf%-1) AS Tmp2$
  Temp$=Tmp2$
  Emerg$=Ptr$(ASC(Act.Keys$)+1)
  PUT %BT.File.Num,Cur.Rec%
  GOSUB BT.GET.STACK.NODE
  Temp$=Temp$+Itm$(Itm.Ptr%-1)
  LSET Itm$(Itm.Ptr%-1)=Tmp.Add$
  LSET Ptr$(Itm.Ptr%-1)=MKI$(Stk%(Cur.Lvl%+1,0))
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
  PUT %BT.File.Num,Cur.Rec%
  Status%=0
  RETURN
BT.MRG.LFT:
  FIELD %BT.File.Num,1 AS Tmp2$,2+ASC(Act.Keys$)*(Itm.Len%) AS Tmp2$
  Temp$=Tmp2$
  LSET Act.Keys$=CHR$(0)
  LSET Ptr$(0)=MKI$(Lst.Del%)
  Lst.Del%=Cur.Rec%
  Num.Act%=Num.Act%-1
  PUT %BT.File.Num,Cur.Rec%
  GOSUB BT.GET.STACK.NODE
  Temp$=Temp$+LEFT$(Itm$(Itm.Ptr%-1),Itm.Len%-2)
  LSET Ptr$(Itm.Ptr%-2)=MKI$(Stk%(Cur.Lvl%+1,0))
  GOSUB BT.DECR.NODE
  Status%=0
  IF Cur.Rec%=Root.Rec% AND ASC(Act.Keys$)=0 THEN
    Root.Rec%=Stk%(Cur.Lvl%+1,0)
    LSET Ptr$(0)=MKI$(Lst.Del%)
    Lst.Del%=Cur.Rec%
    Num.Act%=Num.Act%-1
  ELSEIF (Cur.Rec%<>Root.Rec%) AND (ASC(Act.Keys$)<Hlf.Node%) Then
    Status%=-1
  END IF
  GOSUB BT.WRT.FTH
  FIELD %BT.File.Num,3 AS Tmp2$,Itm.Len%*ASC(Act.Keys$) AS Tmp2$
  Temp$=Temp$+Ptr$(0)+Tmp2$
  FIELD %BT.File.Num,1 AS Tmp2$,LEN(Temp$) AS Tmp2$
BT.PUT.IN.BUF:
  LSET Tmp2$=Temp$
  LSET Act.Keys$=CHR$(Hlf.Node%*2)
  PUT %BT.File.Num,Cur.Rec%
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
  PUT %BT.File.Num,Cur.Rec%
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
  Temp%=-1
  GOSUB BT.NON.UNQ
  GOSUB BT.ADD.AT.CUR
  RETURN

BT.ADD.UNIQUE:
  Temp% = 1
  GOSUB BT.Non.Unq
  If Status% Then
    Status% = 0
  Else
    GOSUB BT.ADD.AT.CUR
  End if
  RETURN

End Sub 'BT
     'ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
     'ณ  TITLE: UPDTFILE.INC                         Version 1.0  ณ
     'ณ  DESC.: Routines for updating files to disk (For Turbo B) ณ
     'ณ  DATE : October 21, 1987                                  ณ
     'ณ  AUTH.: Joe Vest   (BIX & GEnie: JVEST - CIS: 74017,1672) ณ
     'ณ         8051 E. Roper St., Long Beach, CA, 90808          ณ
     'ณ                                                           ณ
     'ณ  Placed in the public domain Oct. 21, 1987 by Joe Vest.   ณ
     'ณ                                                           ณ
     'ณ     ***** USE THESE ROUTINES AT YOUR OWN RISK *****       ณ
     'ณ                                                           ณ
     'ณ  The author makes no guarantee as to the accuracy or      ณ
     'ณ  suitability for a purpose of these routines.  Your use   ณ
     'ณ  of these routines signifies your acceptance of the       ณ
     'ณ  complete responsibility for any and all outcomes as      ณ
     'ณ  the result of said use.                                  ณ
     'ณ                                                           ณ
     'ณ  Isn't it sad that the inherent greed of certain people   ณ
     'ณ  in our society compels me to put a statement like that   ณ
     'ณ  in a document that is circulated without charge for      ณ
     'ณ  informational purposes?  Just remember, TANSTAAFL!       ณ
     'ณ                                                           ณ
     'ณ อออออออออออออออออออออออออออออออออออออออออออออออออออออออออ ณ
     'ณ                                                           ณ
     'ณ  I would like to thank Tod Golding of Borland Technical   ณ
     'ณ  Support for showing me where the file handles for Turbo  ณ
     'ณ  BASIC's files are located in memory. Without this know-  ณ
     'ณ  ledge, these routines could not have been written.       ณ
     'ณ                                                           ณ
     'ณ อออออออออออออออออออออออออออออออออออออออออออออออออออออออออ ณ
     'ณ                                                           ณ
     'ณ  Documentation:                                           ณ
     'ณ                                                           ณ
     'ณ    These subprograms are designed to allow the programmer ณ
     'ณ  to force the updating to disk of a particular file or of ณ
     'ณ  all currently opened files. The routines force a write   ณ
     'ณ  of the file's data and directory entry by causing MS-DOS ณ
     'ณ  to duplicate the file's handle and then closing the      ณ
     'ณ  duplicate handle. This performs the same function as a   ณ
     'ณ  CLOSE [filenum] in BASIC while still leaving the file    ณ
     'ณ  open. Consequently, you do not incur the overhead of     ณ
     'ณ  actually having to open the file again. The routines     ณ
     'ณ  also force all MS-DOS buffers to be physically written   ณ
     'ณ  to the disk by performing a disk reset.                  ณ
     'ณ    These routines can help you to make a bomb proof       ณ
     'ณ  program because once a file has been updated, the user   ณ
     'ณ  could turn the power off ARG! without loosing any infor- ณ
     'ณ  mation from the file. Why? because all the file's data   ณ
     'ณ  buffers and the directory information are on the disk    ณ
     'ณ  and not in memory.                                       ณ
     'ณ                                                           ณ
     'ณ  The calling procedure is:                                ณ
     'ณ    CALL UpdateFile(FileNum%)                              ณ
     'ณ         Where FileNum% is the buffer number of a file     ณ
     'ณ               that is currently open.                     ณ
     'ณ  or                                                       ณ
     'ณ    CALL UpdateALL                                         ณ
     'ณ         This will search for all open files and update    ณ
     'ณ         each of them in turn.                             ณ
     'ณ                                                           ณ
     'ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู


     'อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

Sub UpdateFile(FileNum%)
  Local FileHandle%,Flags%

  FileHandle% = FileAttr(FileNum%,2)
  'FileHandle% = FnFileHandleAddress%(FileNum%)
  If FileHandle% = 0 Then Exit Sub
  Reg 1,&h4500        'Duplicate Handle => AX
  Reg 2,FileHandle%   'Handle => BX
  Call Interrupt &h21 'Perform system service
  Flags% = Reg(0)
  If (Flags% and 1%) = 1% or Reg(1) = 0 Then Exit Sub
  Reg 2,Reg(1)        'Dup.Handle (AX) => BX
  Reg 1,&h3E00        'Close File => AX
  Call Interrupt &h21
  If (Flags% and 1%) = 1% Then Exit Sub
  Reg 1,&h0D00        'Reset Disk
  Call Interrupt &h21

End Sub 'UpdateFile

     'อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

SUB UpdateALL
  LOCAL Segment%,Ofs%,xDone%,FileHandle%,Flags%

  DEF SEG
  Segment% = PEEK(0) + (256 * PEEK(1))   ' Get the string segment.
  DEF SEG  = Segment%
  Ofs%     = PEEK(6) + (256 * PEEK(7))   ' Peek at the first file number.
  xDone%    = -1
  WHILE (PEEK(Ofs%+4) + (256 * PEEK(Ofs%+5))) <> 0
    FileHandle% = Peek(Ofs%+6) + (256 * PEEK(Ofs%+7))
    If FileHandle% <> 0 Then
      Reg 1,&h4500        'Duplicate Handle => AX
      Reg 2,FileHandle%   'Handle => BX
      Call Interrupt &h21 'Perform system service
      Flags% = Reg(0)
      If (Flags% and 1%) = 0% and Reg(1) <> 0 Then
        Reg 2,Reg(1)        'Dup.Handle (AX) => BX
        Reg 1,&h3E00        'Close File => AX
        Call Interrupt &h21
      End if
    End if
    DEF SEG  = Segment%
    Ofs% = PEEK(Ofs%) + (256 * PEEK(Ofs%+1))   ' Traverse the linked list.
  WEND
  Reg 1,&h0D00        'Reset Disk
  Call Interrupt &h21

END Sub 'UpdateALL
$ENDIF