SUB PUSH(p%)
INCR StackPointer%
CallStack%(StackPointer%) = p%
END SUB

SUB POP(p%)
IF StackPointer% = 0 THEN ERROR 800
p%=CallStack%(StackPointer%)
DECR StackPointer%

END SUB

SUB IFPUSH(p%)
INCR IfPointer%
IfStack%(IfPointer%) = p%
END SUB

SUB IFPOP(p%)
IF IfPointer% = 0 THEN ERROR 801
p%=IfStack%(IfPointer%)
DECR IfPointer%

END SUB



