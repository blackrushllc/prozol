
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
'|   BVX1DX      BTINI.INC                                              |
'|                                                                      |
'|                                                                      |
'|    December 12 1993                                                  |
'+----------------------------------------------------------------------+


PUBLIC Act.Keys$, BT.Update.Always%
%FALSE = 0
%TRUE = -1
%dbIndex = -1
%Bt.Max.Half.Node =  25
%Bt.Max.Node = %Bt.Max.Half.Node * 2

SHARED Bt.Update.Always%,Act.Keys$,Bt.File.Num%
SHARED Keys$(),Ptr$(),Stk&(),Itm$(),Dta$()
GGG% = %Bt.Max.Node + 1
DIM Keys$(0:ggg%),Ptr$(0:ggg%),Stk&(0:30,0:1),Itm$(0:ggg%),Dta$(0:ggg%)
