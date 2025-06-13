FUNCTION DirExist%(byval Spec$)
DirSpec$=Spec$
IF (DirSpec$="\") OR _
   (LEN(DirSpec$)=3 AND _
    MID$(DirSpec$,2,1)=":" AND _
    RIGHT$(DirSpec$,1)="\") THEN
   DirExist%=-1
ELSE
   IF RIGHT$(DirSpec$,1)="\" THEN
      DirSpec$ = LEFT$(DirSpec$,LEN(DirSpec$)-1)
   END IF
   F$ = DIR$(DirSpec$,0)
   IF F$="" THEN
      F$ = DIR$(DirSpec$,16)
      If F$="" then
         DirExist%=0     'Doesnt exist
      ELSE
         DirExist%=-1    'It does exist
      END IF
   ELSE
      DirExist%=0         'Its a file, not a subdirectory
   END IF
END IF
END FUNCTION
