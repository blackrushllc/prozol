'obase commands
GOTO EXITSELECT
PtrOFIND:'      CASE "OFIND"
	FI$=POPARG$
        IXFI$=FI$
        DA$=POPARG$
        FL%=VAL(POPARG$)
        IXlen%=FL%
        PUSHARG STR$(OFIND???(FI$,DA$,FL%,E%))

GOTO EXITSELECT
PtrOSKIP:'      CASE "OSKIP"
        FI$=IXFI$
        n%=VAL(POPARG$)
        FL%=Ixlen%
        PUSHARG STR$(OSKIP???(FI$,N%,FL%,E%))

