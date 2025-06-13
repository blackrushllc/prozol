open "\rip\rip.cmd" for input as #1
open "\rip\rip.xxx" for output as #2

do until eof(1)
if len(inkey$) then exit loop
print "-";
line input #1, a$
print a$
if left$(a$,1)="'" or left$(a$,3)="Ptr" then print #2, a$':print a$
loop
