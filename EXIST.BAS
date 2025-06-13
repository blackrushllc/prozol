SUB EXIST(BYVAL F$, Ecode%)
IF DIR$(F$)="" THEN Ecode%=0 ELSE Ecode%=1
END SUB


