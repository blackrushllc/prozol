$IF NOT %NORIP
GOTO EXITSELECT
PtrRIP.VER:
	COMPRINT CHR$(27,91,48,33)
        DELAY 2
        PUSHARG COMCHAR$

GOTO EXITSELECT
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
PtrRIP.TEXT.WINDOW:
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'        Function:  Define the size and location of the Text Window
'           Level:  0
'         Command:  w
'       Arguments:  x0:2, y0:2, x1:2, y1:2, wrap:1, size:1
'          Format:  !|w <x0> <y0> <x1> <y1> <wrap> <size>
'         Example:  !|w00001B0M10
        RIP "w222211"
        GOTO EXITSELECT
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
PtrRIP.VIEWPORT:
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'        Function:  Define the size & location of the Graphics Window
'           Level:  0
'         Command:  v
'       Arguments:  x0:2, y0:2, x1:2, y1:2
'          Format:  !|v <x0> <y0> <x1> <y1>
'         Example:  !|v00002E1M
        RIP "v2222"
        GOTO EXITSELECT
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
PtrRIP.RESET.WINDOWS:
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'        Function:  Clear Graphics/Text Windows & reset to full screen
'           Level:  0
'         Command:  *
'       Arguments:  <none>
'          Format:  !|*
'         Example:  !|*
        RIP "*"
        GOTO EXITSELECT
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
PtrRIP.ERASE.WINDOW:
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'        Function:  Clears Text Window to current background color
'           Level:  0
'         Command:  e
'       Arguments:  <none>
'          Format:  !|e
'         Example:  !|e
        RIP "e"
        GOTO EXITSELECT
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
PtrRIP.ERASE.VIEW:
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'        Function:  Clear Graphics Window to current background color
'           Level:  0
'         Command:  E
'       Arguments:  <none>
'          Format:  !|E
'         Example:  !|E
        RIP "E"
        GOTO EXITSELECT
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
PtrRIP.GOTOXY:
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'        Function:  Move text cursor to row & column in Text Window
'           Level:  0
'         Command:  g
'       Arguments:  x:2, y:2
'          Format:  !|g <x> <y>
'         Example:  !|g0509
        RIP "g22"
        GOTO EXITSELECT
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
PtrRIP.HOME:
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'        Function:  Move cursor to upper-left corner of Text Window
'           Level:  0
'         Command:  H
'       Arguments:  <none>
'          Format:  !|H
'         Example:  !|H
        RIP "H"
        GOTO EXITSELECT
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
PtrRIP.ERASE.EOL:
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'        Function:  Erase current line from cursor to end of line
'           Level:  0
'         Command:  >
'       Arguments:  <none>
'          Format:  !|>
'         Example:  !|>
        RIP ">"
        GOTO EXITSELECT
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
PtrRIP.COLOR:
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'        Function:  Set current Drawing Color for graphics
'           Level:  0
'         Command:  c
'       Arguments:  color:2
'          Format:  !|c <color>
'         Example:  !|cA
        RIP "c2"
        GOTO EXITSELECT
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
PtrRIP.SET.PALETTE:
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'        Function:  Set 16-color Palette from master 64-color palette
'           Level:  0
'         Command:  Q
'       Arguments:  c1:2, c2:2, ... c16:2
'          Format:  !|Q <c1> <c2> ... <c16>
'         Example:  !|Q000102030405060708090A0B0C0D0E0F
        RIP "Q2222222222222222"
        GOTO EXITSELECT
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
PtrRIP.ONE.PALETTE:
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'        Function:  Set color of 16-color Palette from Master Palette
'           Level:  0
'         Command:  a
'       Arguments:  color:2 value:2
'          Format:  !|a <color> <value>
'         Example:  !|a051B
        RIP "a22"
        GOTO EXITSELECT
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
PtrRIP.WRITE.MODE:
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'        Function:  Set drawing mode for graphics primitives
'           Level:  0
'         Command:  W
'       Arguments:  mode:2
'          Format:  !|W <mode>
'         Example:  !|W00
        RIP "W2"
        GOTO EXITSELECT
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
PtrRIP.MOVE:
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'        Function:  Move the current drawing position to (X,Y)
'           Level:  0
'         Command:  m
'       Arguments:  x:2, y:2
'          Format:  !|m <x> <y>
'         Example:  !|m0509
        RIP "m22"
        GOTO EXITSELECT
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
PtrRIP.TEXT:
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'        Function:  Draw text in current font/color at current spot
'           Level:  0
'         Command:  T
'       Arguments:  text-string
'          Format:  !|T <text-string>
'         Example:  !|Thello world
        RIP "T$"
        GOTO EXITSELECT
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
PtrRIP.TEXT.XY:
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'        Function:  Draw text in current font/color at specific spot
'           Level:  0
'         Command:  @
'       Arguments:  x:2, y:2 and text-string
'          Format:  !|@ <x> <y> <text-string>
'         Example:  !|@0011hello world
        RIP "@22$"
        GOTO EXITSELECT
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
PtrRIP.FONT.STYLE:
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'        Function:  Select current font style, orientation and size
'           Level:  0
'         Command:  Y
'       Arguments:  font:2, direction:2, size:2, res:2
'          Format:  !|Y <font> <direction> <size> <res>
'         Example:  !|Y01000400
        RIP "Y22200"
        GOTO EXITSELECT
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
PtrRIP.PIXEL:
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'        Function:  Draws a one pixel using current drawing color
'           Level:  0
'         Command:  X
'       Arguments:  x:2, y:2
'          Format:  !|X <x> <y>
'         Example:  !|X1122
        RIP "X22"
        GOTO EXITSELECT
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
PtrRIP.LINE:
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'        Function:  Draw a line in the current color/line style
'           Level:  0
'         Command:  L
'       Arguments:  x0:2, y0:2, x1:2, y1:2
'          Format:  !|L <x0> <y0> <x1> <y1>
'         Example:  !|L00010A0E
        RIP "L2222"
        GOTO EXITSELECT
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
PtrRIP.RECTANGLE:
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'        Function:  Draw a rectangle in current color/line style
'           Level:  0
'         Command:  R
'       Arguments:  x0:2, y0:2, x1:2, y1:2
'          Format:  !|R <x0> <y0> <x1> <y1>
'         Example:  !|R00010A0E
        RIP "R2222"
        GOTO EXITSELECT
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
PtrRIP.BAR:
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'        Function:  Draw filled rectangle with fill color/pattern
'           Level:  0
'         Command:  B
'       Arguments:  x0:2, y0:2, x1:2, y1:2
'          Format:  !|B <x0> <y0> <x1> <y1>
'         Example:  !|B00010A0E
        RIP "B2222"
        GOTO EXITSELECT
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
PtrRIP.CIRCLE:
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'        Function:  Draw circle in current color and line thickness
'           Level:  0
'         Command:  C
'       Arguments:  x.center:2, y.center:2, radius:2
'          Format:  !|C <x.center> <y.center> <radius>
'         Example:  !|C1E180M
        RIP "C222"
        GOTO EXITSELECT
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
PtrRIP.OVAL:
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'        Function:  Draw elliptical arc in current color/line style
'           Level:  0
'         Command:  O
'       Arguments:  x:2, y:2, st.ang:2, end.ang:2, x.rad:2, y.rad:2
'          Format:  !|O <x> <y> <st.ang> <end.ang> <x.rad> <y.rad>
'         Example:  1E1A18003G150Z
        RIP "O222222"
        GOTO EXITSELECT
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
PtrRIP.FILLED.OVAL:
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'        Function:  Draw filled ellipse using current color/pattern
'           Level:  0
'         Command:  o
'       Arguments:  x.center:2, y.center:2, x.rad:2, y.rad:2
'          Format:  !|o <x.center> <y.center> <x.rad> <y.rad>
'         Example:  !|o1G2B0M0G
        RIP "o2222"
        GOTO EXITSELECT
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
PtrRIP.ARC:
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'        Function:  Draw circular arc in current color/line thickness
'           Level:  0
'         Command:  A
'       Arguments:  x:2, y:2, start.ang:2, end.ang:2, radius:2
'          Format:  !|A <x> <y> <start.ang> <end.ang> <radius>
'         Example:  !|A1E18003G15
        RIP "A22222"
        GOTO EXITSELECT
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
PtrRIP.OVAL.ARC:
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'        Function:  Draw an elliptical arc
'           Level:  0
'         Command:  V
'       Arguments:  x:2, y:2, st.ang:2, e.ang:2, radx:2 rady:2
'          Format:  !|V <x> <y> <st.ang> <e.ang> <radx> <rady>
'         Example:  !|V1E18003G151Q
        RIP "V222222"
        GOTO EXITSELECT
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
PtrRIP.PIE.SLICE:
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'        Function:  Draws a circular pie slice
'           Level:  0
'         Command:  I
'       Arguments:  x:2, y:2, start.ang:2, end.ang:2, radius:2
'          Format:  !|I <x> <y> <start.ang> <end.ang> <radius>
'         Example:  !|I1E18003G15
        RIP "I22222"
        GOTO EXITSELECT
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
PtrRIP.OVAL.PIE.SLICE:
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'        Function:  Draws an elliptical pie slice
'           Level:  0
'         Command:  i
'       Arguments:  x:2, y:2, st.ang:2, e.ang:2, radx:2 rady:2
'          Format:  !|i <x> <y> <st.ang> <e.ang> <radx> <rady>
'         Example:  !|i1E18003G151Q
        RIP "i222222"
        GOTO EXITSELECT
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
PtrRIP.BEZIER:
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'        Function:  Draw a bezier curve
'           Level:  0
'         Command:  Z
'       Arguments:  x1:2 y1:2 x2:2 y2:2 x3:2 y3:2 x4:2 y4:2 cnt:2
'          Format:  !|Z <x1> <y1> <x2> <y2> <x3> <y3> <x4> <y4> <cnt>
'         Example:  !|Z0A0B0C0D0E0F0G0H1G
        RIP "Z222222222"
        GOTO EXITSELECT
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
PtrRIP.FILL:
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'        Function:  Flood fill screen area with current fill settings
'           Level:  0
'         Command:  F
'       Arguments:  x:2, y:2, border:2
'          Format:  !|F <x> <y> <border>
'         Example:  !|F25090F
        RIP "F222"
        GOTO EXITSELECT
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
PtrRIP.LINE.STYLE:
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'        Function:  Defines a line style and thickness
'           Level:  0
'         Command:  =
'       Arguments:  style:2, user.pat:4, thick:2
'          Format:  !|= <style> <user.pat> <thick>
'         Example:  !|=01000001
        RIP "=242"
        GOTO EXITSELECT
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
PtrRIP.FILL.STYLE:
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'        Function:  Set current fill style (predefined) & fill color
'           Level:  0
'         Command:  S
'       Arguments:  pattern:2, color:2
'          Format:  !|S <pattern> <color>
'         Example:  !|S050F
        RIP "S22"
        GOTO EXITSELECT
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
PtrRIP.FILL.PATTERN:
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'        Function:  Set user-definable (custom) fill pattern/color
'           Level:  0
'         Command:  s
'       Arguments:  c1:2 c2:2 c3:2 c4:2 c5:2 c6:2 c7:2 c8:2 col:2
'          Format:  !|s <c1> <c2> <c3> <c4> <c5> <c6> <c7> <c8> <col>
'         Example:  !|s11223344556677880F
        RIP "s222222222"
        GOTO EXITSELECT
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
PtrRIP.MOUSE:
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'        Function:  Defines a rectangular hot mouse region
'           Level:  1
'         Command:  M
'       Arguments:  num:2 x0:2 y0:2 x1:2 y1:2 clk:1 clr:1 res:5 text
'          Format:  !|1M <num> <x0><y0><x1><y1> <clk><clr><res><text>
'         Example:  !|1M00001122331100000host command^M
        RIP "1M222221100000$"
        GOTO EXITSELECT
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
PtrRIP.KILL.MOUSE.FIELDS:
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'        Function:  Destroys all previously defined hot mouse regions
'           Level:  1
'         Command:  K
'       Arguments:  <none>
'          Format:  !|1K
'         Example:  !|1K
        RIP "1K"
        GOTO EXITSELECT
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
PtrRIP.BEGIN.TEXT:
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'        Function:  Define a rectangular text region
'           Level:  1
'         Command:  T
'       Arguments:  x1:2, y1:2, x2:2, y2:2, res:2
'          Format:  !|1T <x1> <y1> <x2> <y2> <res>
'         Example:  !|1T00110011
        RIP "1T222200"
        GOTO EXITSELECT
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
PtrRIP.REGION.TEXT:
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'        Function:  Display a line of text in rectangular text region
'           Level:  1
'         Command:  t
'       Arguments:  justify:1 and text-string
'          Format:  !|1t <justify> <text-string>
'         Example:  !|1t1This is a text line to be justified
        RIP "1t1$"
        GOTO EXITSELECT
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
PtrRIP.END.TEXT:
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'        Function:  End a rectangular text region
'           Level:  1
'         Command:  E
'       Arguments:  <none>
'          Format:  !|1E
'         Example:  !|1E
        RIP "1E"
        GOTO EXITSELECT
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
PtrRIP.GET.IMAGE:
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'        Function:  Copy rectangular image to clipboard (as icon)
'           Level:  1
'         Command:  C
'       Arguments:  x0:2, y0:2, x1:2, y1:2, res:1
'          Format:  !|1C <x0> <y0> <x1> <y1> <res>
'         Example:  !|1C001122330
        RIP "1C22220"
        GOTO EXITSELECT
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
PtrRIP.PUT.IMAGE:
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'        Function:  Pastes the clipboard contents onto the screen
'           Level:  1
'         Command:  P
'       Arguments:  x:2, y:2, mode:2, res:1
'          Format:  !|1P <x> <y> <mode> <res>
'         Example:  !|1P0011010
        RIP "1P2220"
        GOTO EXITSELECT
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
PtrRIP.WRITE.ICON:
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'        Function:  Write contents of the clipboard (icon) to disk
'           Level:  1
'         Command:  W
'       Arguments:  res:1, filename
'          Format:  !|1W <res> <filename>
'         Example:  !|1W0filename.icn
        RIP "1W0$"
        GOTO EXITSELECT
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
PtrRIP.LOAD.ICON:
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'        Function:  Loads and displays a disk-based icon to screen
'           Level:  1
'         Command:  I
'       Arguments:  x:2, y:2, mode:2, clipboard:1, res:2, filename
'          Format:  !|1I <x> <y> <mode> <clipboard> <res> <filename>
'         Example:  !|1I001101010button.icn
        RIP "1I222100$"
        GOTO EXITSELECT
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
PtrRIP.BUTTON.STYLE:
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'        Function:  Button style definition
'           Level:  1
'         Command:  B
'       Arguments:  wid:2 hgt:2 orient:2 flags:4 size:2
'                    dfore:2 dback:2 bright:2 dark:2 surface:2
'                    grp.no:2 flags2:2 uline.col:2 corner.col:2
'                    res:6
'          Format:  !|1B <wid> <hgt> <orient> <flags>
'                    <bevsize> <dfore> <dback> <bright> <dark>
'                    <surface> <grp.no> <flags2> <uline.col>
'                    <corner.col> <res>
'         Example:  !|1B0A0A010274030F080F080700010E07000000
        RIP "1B22242222222222000000"
        GOTO EXITSELECT
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
PtrRIP.BUTTON:
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'        Function:  Define a Mouse Button
'           Level:  1
'         Command:  U
'       Arguments:  x0:2 y0:2 x1:2 y1:2 hotkey:2 flags:1 res:1
'                    ...text
'          Format:  !|1U <x0> <y0> <x1> <y1> <hotkey> <flags>
'                    <res> <text>
'         Example:  !|1U010100003200iconfile<>Label<>HostCmd^m
        RIP "1U2222210$"
        GOTO EXITSELECT
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
PtrRIP.DEFINE:
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'        Function:  Define a text variable
'           Level:  1
'         Command:  D
'       Arguments:  flags:3 res:2 ...text
'          Format:  !|1D <flags> <res> <text>
'         Example:  !|1D00700text.var,60:?question?default data
        RIP "1D300$"
        GOTO EXITSELECT
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
PtrRIP.COPY.REGION:
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'        Function:  Copy screen region up/down
'           Level:  1
'         Command:  G
'       Arguments:  x0:2 y0:2 x1:2 y1:2 res:2 dest.line:2
'          Format:  !|1G <x0> <y0> <x1> <y1> <res> <dest.line>
'         Example:  !|1G080G140M0005
        RIP "1G2222002"
        GOTO EXITSELECT
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
PtrRIP.READ.SCENE:
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'        Function:  Playback local .RIP file
'           Level:  1
'         Command:  R
'       Arguments:  res:8 filename...
'          Format:  !|1R <res> <filename>
'         Example:  !|1R00000000testfile.rip
        RIP "1R00000000$"
        GOTO EXITSELECT
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
PtrRIP.FILE.QUERY:
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'        Function:  Query existing information on a particular file
'           Level:  1
'         Command:  F
'       Arguments:  mode:2 res:4 filename...
'          Format:  !|1F <mode> <res> <filename>
'         Example:  !|1F010000testfile.icn
        RIP "1F20000$"
        GOTO EXITSELECT
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
PtrRIP.NO.MORE:
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'        Function:  End of RIPscrip Scene
'           Level:  0
'         Command:  #
'       Arguments:  <none>
'          Format:  !|#
'         Example:  !|#
        RIP "#"
        GOTO EXITSELECT
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
PtrRIP.QUERY:
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'        Function:  Query the contents of a text variable
'           Level:  1
'         Command:  <escape>
'       Arguments:  mode:1 res:3 ...text
'          Format:  !|1<escape> <mode> <res> <text>
'         Example:  !|1<escape>0000this is a query $COMMAND$^m
        RIP "1"+chr$(27)+"10000$"
        GOTO EXITSELECT
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
PtrRIP.ENTER.BLOCK.MODE:
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'        Function:  Enter block transfer mode with host
'           Level:  9 (system command)
'         Command:  <escape>
'       Arguments:  mode:1 proto:1 file.type:2 res:4
'                    [filename:2] <>
'          Format:  !|9<escape> <proto> <file.type> <res>
'                    [filename] <>
'         Example:  !|9<escape>00010000ICONFILE.ICN<>
        RIP "9"+CHR$(27)+"1120000$<>"
        GOTO EXITSELECT


' THESE REMAINING FUNCTIONS WILL HAVE TO BE TREATED A BIT DIFFERENTLY
' (I'll do this later)
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
PtrRIP.POLYGON:
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'        Function:  Draw polygon in current color/line-style
'           Level:  0
'         Command:  P
'       Arguments:  npoints:2, x1:2, y1:2, ... xn:2, yn:2
'          Format:  !|P <npoints> <x1> <y1> ... <xn> <yn>
'         Example:  !|P03010105090905
'        RIP "P"
        GOTO EXITSELECT
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
PtrRIP.FILL.POLYGON:
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'        Function:  Draw filled polygon in current color/fill pattern
'           Level:  0
'         Command:  p
'       Arguments:  npoints:2, x1:2, y1:2, ... xn:2, yn:2
'          Format:  !|p <npoints> <x1> <y1> ... <xn> <yn>
'         Example:  !|p03010105050909
'        RIP "p"
        GOTO EXITSELECT
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
PtrRIP.POLYLINE:
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'        Function:  Draw a Poly-Line (multi-faceted line)
'           Level:  0
'         Command:  l
'       Arguments:  npoints:2, x1:2, y1:2, ... xn:2, yn:2
'          Format:  !|l <npoints> <x1> <y1> ... <xn> <yn>
'         Example:  !|l03010105090905
'        RIP "4"
        GOTO EXITSELECT

$ENDIF