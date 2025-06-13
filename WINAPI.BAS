' Based on WinFuncs fax from David Hackamack
' (say that 10 times fast)
' PowerBASIC (06/15/93) Erik Olson

' These routines are not implemented in PROZOL 1, however they may be
' inserted where desired.

DECLARE SUB StartWinCriticalCode()
DECLARE SUB EndWinCriticalCode()
DECLARE SUB GiveUpTimeSlice()
DECLARE FUNCTION WinDozeActive%(Ver!)
DECLARE FUNCTION GetCurrentWindowsVM%()


SUB EndWinCriticalCode
	REG 1, &H1682
	CALL INTERRUPT &H2F
END SUB

FUNCTION GetCurrentWinDozeVM%
	' gets current virtual machine ID under windoZe
        BXI%=0
        !MOV AX,&H1683
        !INT &H2F
	!MOV BXI%,BX
	GetCurrentWinDozeVM% = BXI%
END FUNCTION

SUB GiveUpTimeSlice
	REG 1,&H1680
	CALL INTERRUPT &H2F
END SUB

SUB StartWinCriticalCode
	REG 1, &H1681
	CALL INTERRUPT &H2F
END SUB

FUNCTION WinDozeActive%(Ver!)
	'determines whether windows is active and which version
	REG 1, &H1600
	CALL INTERRUPT &H2F
	IF (REG(1) AND &HFF<>0) AND (REG(1) AND &HFF <>&H80) AND (REG(1) <> &H1600) THEN
		WinDozeActive%=-1
		Ver!=(((REG(1) AND &HFF) * 100)+REG(1)\&HFF)/100
	ELSE
		REG 2,0
		REG 6,0
		REG 9,0
		REG 1, &H4B02
		CALL INTERRUPT &H2F

		IF REG(9) OR REG(6) THEN
			WindozeActive%=1

		ELSE
			IF LEN(ENVIRON$("windir")) THEN WindozeActive%=2
		END IF
	END IF
END FUNCTION


