%False = 0
%True = NOT %False

' constants for including or excluding portions of the program
%NORIP        =  %False   ' Include RIPSCRIPT commands
'%NORIP        =  %True    ' do not include RIPSCRIPT
'%NOXMODEM     =  %False   ' Include Xmodem send and recieve
%NOXMODEM     =  %True   ' don't (if you prefer to use a door instead)
%NOCHAT       =  %False   ' Include 6-way live CHAT
'%NOCHAT       =  %True   ' don't (especially on a single user system)
%NOCOMMENTS   =  %False   ' Include the 9-line comment editor and viewer
'%NOCOMMENTS   =  %True   ' don't
'%NOCONFERENCE =  %False   ' Include the conference system
%NOCONFERENCE =  %True   ' don't
%NODBASE      =  %False   ' Include dBASE file support and BTree index
'%NODBASE      =  %True   ' don't
%NOAUTOEDIT   =  %False   ' Include the name and address reformatter
'%NOAUTOEDIT   =  %True   ' don't
%NOTASKS        = %True   ' do not include task manager
'%NOTASKS       = %False  ' include it (it's not ready)

'%KILLF10   = %true         ' Trap F10 to force exit to DOS (for debugging)
'%MONOWATCH = %true         ' broadcast to mono monitor (for debugging)
%KILLF10   = %false        ' don't trap f10
%MONOWATCH = %false        ' don't broadcast to mono monitor

'  %BT.Max.Half.Node = 15
'  %BT.Max.Node = %BT.Max.Half.Node * 2
'  %BT.File.Num = 2801
%dbIndex = -1
%Bt.Max.Half.Node =  25
%Bt.Max.Node = %Bt.Max.Half.Node * 2

%DoStack = 1
%ForStack = 2
