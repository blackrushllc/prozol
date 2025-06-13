' This program writes the include file for "fixup.inc"
type fixuptype
        keyword as string * 8
        offset  as word
end type
dim fixup(256) as fixuptype

open "fixup.inc" for output as #1
x%=0
do
read kwd$,lbl$
if kwd$="X" then exit loop
print #1, "fixup("+ltrim(str$(x))+").keyword = " + chr$(34)+kwd$+chr$(34)
print #1, "fixup("+ltrim(str$(x))+").offset  = codeptr("+lbl$+")"
incr x
loop
close #1

