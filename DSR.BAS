SUB ModemStatus(BaseAddress%,DeltaCTS%,DeltaDSR%,DeltaRI%,DeltaRLSD%,CTS%,DSR%,RI%,RLSD%)
'Modem Status                       &H3FE
'Do an Input to read this status register.
'  1 - Bit 0 says that not CTS inp to processor has chng since last read
'  2 - Bit 1 says that not DSR inp to processor has chng since last read
'  4 - Bit 2 is trail of TERI, ind not RI ahgd since last read
'  8 - DRLSD ind not RLSD inp chgd since last read
' 16 - Complement of CTS, if = logic 1 is equiv to RTS in the MCR
' 32 - Complement of DSR, if = logic 1 is equiv to DTR in the MCR
' 64 - Complement of RI, if MCR = logic 1 then equiv to out 1 in the MCR
'128 - Complement of RLSD if MCR = logic 1 then equiv to out 2 in the MCR
MSR%=INP(BaseAddress%+6)
IF (MSR% AND &B00000001) THEN DeltaCTS%=1 ELSE DeltaCTS%=0
IF (MSR% AND &B00000010) THEN DeltaDSR%=1 ELSE DeltaDSR%=0
IF (MSR% AND &B00000100) THEN DeltaRI%=1 ELSE DeltaRI%=0
IF (MSR% AND &B00001000) THEN DeltaRLSD%=1 ELSE DeltaRLSD%=0
IF (MSR% AND &B00010000) THEN CTS%=1 ELSE CTS%=0
IF (MSR% AND &B00100000) THEN DSR%=1 ELSE DSR%=0
IF (MSR% AND &B01000000) THEN RI%=1 ELSE RI%=0
IF (MSR% AND &B10000000) THEN RLSD%=1 ELSE RLSD%=0
END SUB
