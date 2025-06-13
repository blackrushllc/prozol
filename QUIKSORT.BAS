$IF 0

 ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
 €ﬂﬂ €ﬂ€ ﬂ€ﬂ € €     €ﬂ€ €   €ﬂ€ €ﬂ€ €€›        Digitek Data Systems
 €‹  €‹›  €  €‹›     € € €   ﬂ˛‹ € € › €    1350 Birchcrest Blvd  Suite G
 €‹‹ € € ‹€‹ € €     €‹€ €‹‹ €‹€ €‹€ € €      PortSide Charlotte, FL  33952
 ‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
$ENDIF

SUB QUIKSORT(Fi$, Reclen)
        OPTION BINARY BASE 0
        Buffy%=FREEFILE
	OPEN Fi$ FOR BINARY AS #Buffy%
	CALL QuickSort(LOF(Buffy%)\Reclen, Reclen)
	CLOSE #Buffy%
        OPTION BINARY BASE 1
END SUB


SUB QuickSort(Count&, Reclen)
CALL QuickSort2(0, Count&-1, Reclen)
END SUB

SUB QuickSort2(PortSide&, Starboard&, Reclen)
	'locate 6,1: PRINT INT(PortSide/LOF(Buffy%)* 1000);"%"

	I&=PortSide&:j&=Starboard&

	X$=THINGIE$((PortSide&+Starboard&)\2, Reclen)

	DO
		DO WHILE THINGIE$(I&,Reclen)<X$ AND I&<Starboard&:INCR I&:LOOP
		DO WHILE THINGIE$(j&,Reclen)>X$ AND j&>PortSide& :DECR j&:LOOP

		IF I&<=j& THEN
			CALL SWAPTHINGIES(I&,j&,Reclen)
			INCR I&: DECR j&:
			END IF
	LOOP WHILE i&<=J&

	IF PortSide& < j& THEN CALL QuickSort2(PortSide&, J&, Reclen)
	IF I& < Starboard& THEN CALL QuickSort2(I&, Starboard&, Reclen)
END SUB



FUNCTION THINGIE$(Number&, Reclen)

	SEEK #buffy%, Number&*Reclen
	Get$ buffy%, Reclen, I$
	THINGIE$=I$

END FUNCTION

SUB SWAPTHINGIES(a&,b&, Reclen)

Seek #buffy%, a&*Reclen
Get$ buffy%, Reclen, A$
Seek #buffy%, b&*Reclen
Get$ buffy%, Reclen, B$

Seek #buffy%, a&*Reclen
PUT$ #buffy%, B$
Seek #buffy%, b&*Reclen
PUT$ #buffy%, A$

END SUB

OPTION BINARY BASE 1