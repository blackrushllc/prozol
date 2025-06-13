A PROZOL COMPILER !!!!
= ====== ======== ====
Well, almost.  Prozol can now "prep" it's programs.  It is more like tokenizing
then compiling, but for our purposes here, we will refer to raw programs as
"interpreted" and prepped programs as "compiled".  The compiled programs run
a HELL of a lot faster than the regular interpreted ones.  In fact, because
of some significant internal changes to prozol, the interpreted programs
now actually run a lot slower.  About ten times slower.  I'll see if I can
up this.  Prozol can automatically tell if a file is compiled or not when
you LOAD or RUN it, so you can freely intermix compiled programs with
interpreted ones.  The compiled ones are loaded very fast and instantly
begin running.  The interpreted ones are loaded and then executed with
prozol compiling each line before it is executed.  This still makes it easy
to write and debug programs, but the slow speed can be a real drag.  I will
take steps to speed up the interpreted programs in the next version.

To make compiling easier, I have built in a command line switch that tells
prozol to compile one or a bunch of files, and then exit to DOS when it's
done.

To see the big difference between version .96 and .97, try this line
on each one:

        incr x:print x:until len inkey

(since prozol will compile the whole line before executing it, it will
run just as fast as if you had compiled it to a disk file.)

To see how much slower prozol .97 is at interpreting, try the same
program, like this:

        1 start
        2 incr x
        3 print x
        4 goto start if not len inkey

then type RUN.  OUCH!  My five year old can count on his fingers faster
than this!

To compile this program, simply type

        XSAVE "test.prx"

Saving it as a compiled file will also compile it in memory, so now when
you run it, you will see the dramatic speed difference of compiled PROZOL!



BUGS not yet corrected
======================
- PCBTYPE and DISPLAY can crash on <> and @() symbols
- internal Xmodem does not work.  Use DSZ instead.  I might just phase it out.
- sometimes a keyboard hit doesn't do anything in scrolling menus. ???
- Because of a bug in the internal ANSI driver I am using, the blue background
  is actually showing up as orange (low intensity yellow).  Hopefully this
  is corrected in a newer version which I will look for.  The internal ANSI
  driver is quite a bit faster than DOS and does not require ANSI.SYS to
  be loaded, so memory is saved.
- UPDATE, and DELETE of the high performance indexes is not yet
  implemented.  (Gee, that makes them extremely useful, huh?)
- DBASE indexes are updated without deleting the old entry
- INPUT to a dbase field does not work.  You must use a temporary variable
- Error handler closes all files (oops)

FIXES/CHANGES to version 0.98
+ DO now required before WHILE or UNTIL.  DO must be used alone, WHILE and
  UNTIL are followed by an expression.  This allows DO loops to be placed
  in the middle of a line or subroutine.  DO loops may be nested to 32 levels.
+ Lost carrier is detected immediately.
+ Fixed baud rates (no adjust) at 9600 and above
+ Added PROC keyword (see below)
+ Compiles programs about twice as fast.
+ Went back to DOS level ANSI driver.  Hanlin's didn't work in monochrome
  under Desqview 2.4+
+ Implemented RIPScript commands (see RIP.DOC)
+ Com ports 3 and 4 addresses are poked into BIOS (required by most machines)
+ dBASE indexes (BTREE) can now handle 2 trillion records instead of just
  65,535 records.

PROC keyword
============
Anywhere in your program (you must compile or XSAVE it to use PROC) you can
have a procedure defined like this:

        procname proc : { statements ......
                            .......}

or

        procname proc : statement

Then, anywhere in your program (or in subsequently loaded and executed programs)
you can say

        call procname

and the procedure will execute.


FIXES/CHANGES to version 0.97
+ Error on GOTO/GOSUB shows the right line number where it crashes
  (it was showing line number -2)
+ Interpreted programs execute a LOT slower now (Sorry, this has to be)
  (to make them run faster, block them with { and }.  There are certain
  restrictions to lines blocked like this, so do this carefully)
+ "compiled" programs execute a LOT LOT LOT LOT faster.
+ A command line compiler is built into prozol:
        To compile programs with prozol from the command line, type:

                PROZOL -ext filespec

        where "ext" is any extension to give your compiled programs, and
        "filespec" is any file, wildcard spec, or list of files to compile.
        For example,

                PROZOL -PRX *.PRO

        This will compile every file in the current directory with a .PRO
        extension to files with the same name and a .PRX extension.  To set
        PROZOL to assume that all RUN and GO commands will look for .PRX,
        use the EXT command (EXT ".PRX").  Prozol will look for files with
        this extension.  If there is no file with a PRX extension, prozol
        will try to run .PRO, .TTY, and .BBS before giving up.

        One more example:

                PROZOL -PRX MAIN.PRO LOGIN.PRO LOGIN.MAP COLORS.PRO

        This will compile the four files.  All files will have an extension
        of .PRX


+ LOAD and RUN automatically detect whether a program is compiled.
+ LOAD and RUN try default extension, then PRO, BBS, TTY, then PRX
+ PLOAD and PRUN will load and pre-compile an interpreted program to memory
+ XLOAD will load a compiled prozol program (so will LOAD and RUN)
+ XSAVE will save an uncompiled program to disk in compiled format
+ PRX is assumed, but not required, for "compiled" prozol programs
+ a single line or block of interpreted code will run just as fast as
  compiled code.  use { and } to block several lines of interpreted code
+ CALL FILE will work on raw or compiled prozol files.
+ All PROZOL commands must be 8 letters or less, therefore...
+ the EXTENSION command has been changed to EXT
+ GETCOMMENT has been changed to GETCOMM
+ EDITCOMMENT has been changed to EDITCOMM
+ SETPROMPT has been changed to SETPRMPT
+ CREATEINDEX is now CREATEI
+ CREATEFORMAT is now CREATEF
+ !!!! You cannot RE-SAVE a compiled program. DON'T TRY (you'll kill it) !!!!
  (in otherwords, you can't load a compiled program and then type XSAVE ...)
+ Internal representation of string constants is high ASCII characters
  (this is not important) allowing thousands of string constants per program
+ the LINE command now works as it should.  Returns the contents of a line
  (i.e. CALL LINE TimeOfDay)
+ ERRORMSG [on|off] (default on) OFF disables full error message at prog end
+ GOTO and GOSUB now support line numbers (must be physical line).  This
  is not reccommended, since brackets and line continuation makes it difficult
  to tell what a line number will be when the program is loaded)
+ Added some new functions (the were in the old @fun() format, but not
  available directly in prozol statements):
        LOOKUP file,searchstring
                returns the entire line of a file where searchstring occurs
                at the beginning of that line.
        USING formatstring,number
                works just like the BASIC USING$ function
        FIX string,size
                returns a string fixed to a specific length
        PARM
                returns the current modem parameters (i.e. 2400,N,8,1)
        PORT
                returns the current port number (1-4)
        CRC string
                returns a 16 bit CRC of the string argument
        DUP character,number
                returns the character duplicated a number of times
        BAUD
                returns the current baud rate (i.e. "2400")

+ PCBTYPE prompts differently at the end of file

FIXES/CHANGES to version 0.96
+ PCBTYPE function returns a filename or filenames selected.  It is used to
  dump a PC-board file listing to the screen and prompt the user to select
  one or more files.  The syntax is: SET F TO PCBTYPE "pcbfile",""
  The second parameter may contain an optional search string and only files
  that contain the search string will be displayed, like ".ZIP", etc.  Date
  ranges are coming soon.
+ DISPLAY command dumps a file with [S]top, [N]onstop, continue... use the
  MORE nn command to specify number of lines before pause, or MORE 0 to
  disable pause.  DISPLAY does not execute $metacommands in the file, just
  vars, symbols, and functions.  Similar to the TYPE command.
+ SUBDIR function returns true if a specified directory name exists
+ added EDLIN line editor, Invoke with EDLIN "filename", includes help screen
+ added DIR function which works just like PB's DIR$ function
+ Default file extension is .PRO, however, if whatever the default is, is
  not found, prozol will attempt to load or run .TTY, .BBS, then .PRO in
  that order.
+ Increased number of variables from 256 to 2048
+ Fixed problem with assigning values to mapped strings not overwriting
  remaining space (i.e., if A.B was "abcdefg" and you said SET A.B to "X"
  it would have set A.B to "Xbcdefg".  This is now fixed.
+ fixed READ from a sequential file
+ added EXTENSION command to set default program extension
+ fixed direct input to a mapped element (input "prompt:",main.field)
+ GO commands only execute the contents of variables.  For instance, if
  you were to say GO FILES, prozol would look for a variable named
  $$FILES$$.  If this variable exists, then whatever is in it will be
  executed as a literal command.  For instance, you could say
  SET $$FILES$$ TO "run '\pro\files.pro'" and then it would work.  The
  GO commands will be ignored if there is no GO variable.
+ Removed calls to task manager with a settable constant (we don't really
  need that part yet, for god's sake)

FIXES/CHANGES to version 0.95

+ added a working program example, PROFILE.PRO.  See PROFORM.DOC for more info.

+ IXCREATE High performance index - see further down chapter on INDEXES

+ PROFORM.EXE program creates map structures and input field code
  SEE PROFORM.DOC

+ remarks can be embedded anywhere in code with /* remark */
  if the remark is the last thing on the line, you can omit the closing */

+ INPUT FIELDS is now a function which returns false if user pressed ESC
  Now, instead of just saying INPUT FIELDS to get fullscreen data entry,
  you should say something like SET OK TO INPUT FIELDS, then OK will contain
  true if the field editing routine was terminated normally (save the data)
  or FALSE if the user had pressed ESCAPE (abort the data).  Remember that
  the FIELD statement is used to define up to 256 data entry fields on
  the screen.

+ Line continuation is possible with underscore _
  The underscore must be the very last character on the line.  Prozol looks
  for underscores which are immediately followed by a carriage return.  If
  there is an additional space (or a remark) after the underscore it will
  not work properly.

+ Execution of programs is about twice as fast as version 0.94.  I figured
  out a simple way to parse out the interpreted lines without having to
  make recursive calls to the EXEC function.  Also the ANSI output is based
  on an internal driver rather than calls to DOS.

+ CALL FILE can invoke much larger file subroutines.  Since the calls to
  EXEC are not recursive, a true 32K limit to CALL FILE is achieved.  The
  earlier method was running out of stack space after about 50 lines of
  code were loaded.  CALL FILE invokes a prozol program in a disk file
  as though it were a subroutine, and the disk cache will make it pretty
  much memory resident if used often.

+ INPUT FIELDS do not show first half of a map variable (i.e. USER.NAME).
  For instance, specifying a screen field for the variable USER.ID would
  only show the fieldname ID: before the field, and not the word USER or
  the period.

+ GO or CTRL-G can only specify programs to run, not execute commands

+ Labels can be followed by remarks (/* xxx */)

+ ANSI.SYS is no longer required, ANSI driver is internal.  This driver
  currently has a color bug which causes an instruction to change the
  background color to blue actually changes it to low intensity yellow, or
  orange.  This will be fixed as soon as possible, I hope.

+ Source code debugging options - there are two constants defined near the
  beginning of PROZOL.BAS.  if MONOWATCH is set to %TRUE then all video
  i/o will appear simultaneously on a secondary monochrome monitor.  This
  will allow you to see how your output looks on both a color screen and
  a mono screen at the same time, or to keep an eye on a copy of prozol
  which is running in the background while you do something else in the
  foreground.  The other constant is KILLF10.  If this constant is set to
  true then a key trap is enabled around the F10 key.  Any time the F10
  key is pressed, prozol will immediately terminate.  This helps you get
  out of infinite loops and other jam ups while debugging prozol programs.
  You must re-compile PROZOL for these constants to work.

FIXES/CHANGES to version 0.94
+ TIMEOUT with no argument returns current minutes for usertime#
+ IXSTITCH command adds a record to a "Stitch" index
+ Quoted strings do not need to be spaced or separated by a comma or semicolon
+ Fixed WRITE # error
+ TASK n,Task - sets background execution of certain statements
  ==The remainder of the task functions are pending (do not use these yet!)==:
  TASK     - set a task to a prozol program on disk
  SUSPEND  - suspend a certain task or ALL
  RESUME   - resume a certain task or ALL
  FINISHED - returns true if a certain task is finished
  STATUS   - returns a status flag of a certain task
  FREETASK - returns the next free task number
  KILLTASK - kills a certain task, or ALL
  SIGNAL   - returns true if a certain signal has been set by a certain task
  DEVOTE   - devotes all time to a certain task or ALL until it's finished
  DEPTH    - sets the depth of background processing for tasks
  ============================================================================
+ SETENV "envar=value" - sets environment variables
+ INSIDE searchstring, search1, search2, search3 ...
  - returns true if any of the arguments is contained within searchstring
+ FLIP - places the first word of an argument at the end, i.e., if NAME is
  set to "OLSON ERIK L" then FLIP NAME would make NAME="ERIK L OLSON"
+ CAPS - converts argument to lower case and caps the first letter of each word
  i.e. if NAME is "ERIK L OLSON" then CAPS NAME would make NAME="Erik L Olson"

FIXES/CHANGES to version 0.93
+ PREP supports up to 676 string constants per block or line instead of 26.
+ AUTOEDIT command formats names, addresses and salutations. (see below)
+ Fixed GO to support only program files and not direct commands
+ Added support for unlimited OPENs for sequential or random access (see below)
+ data structs (MAPs) for reading and writing random access files (see below)
+ High performance index functions for random access files (see below)
+ READ and READ ALL fixed for sequential file input
+ The syntax of all file I/O has changed
  - OPEN
  - READ
  - WRITE
  - EOF,LOF
  - MAP
  - GET MAPPED
  - PUT MAPPED

  OPEN - Open a file for any type of access

         OPEN mode, buffer, filename [,length]

        Where mode is "I", "O", "A", "R", or "B", just like BASIC.  Buffer
        is any valid variable name or an arbitrary number with a pound sign
        (the pound sign MUST be used if using a number).  The filename is
        a variable or quoted string, and if it is a random access file, then
        a length parameter must be specified.  For instance,

        OPEN "R", #1, "DATABASE.DAT", LEN User

        This would open a random access file with the record length of
        a mapped variable called "User".

  READ and READ ALL - Input a line or field from a sequential file

        READ #1,A,B,C,D
        READ #1, ALL Temp   or  READ ALL #1, Temp

        The READ statement can be followed by many variables.  Elements
        are read one item at a time from a comma-delimited ASCII file.
        READ ALL is followed by one variable which will contain an
        entire line read from the file.  The buffer can be any variable
        or number with a pound sign used to open the file.

  WRITE - writes a line to a file opened for "O" or "A"

        WRITE #1, "This is a line for the file!" & CR

        WRITE will not put a carriage return or delimit variables, you
        must do that yourself.  Write can process embedded variables
        and functions just like PRINT and TYPE.  As in:

        WRITE #1, "<NAME>,<ADDRESS>,<PHONE>,@DATE()" & CR

        WRITE will write all arguments in sequence to the file without
        delimiters.

  EOF, LOF - functions return End Of File and Length of File.  EOF returns
       true if the end of file has been reached.  LOF returns the current
       length of an open file.

        IF EOF #1:PRINT "End of file!"

        PRINT "File is " LOF #1 " bytes long."

  MAP
  ===
  MAP allows you to define a record and the fields it contains.  A MAP
  variable can be used directly or with a file.  MAP variables are for
  defining the record structure of a random access file "R".

        MAP mapvar TO length, n as var1, n as var2, n as var3...

  The sum total of the fields within the map string do not have to equal
  the size of the map string, but they may not exceed it.  Once a MAP
  variable has been assigned, you may use the elements within it, or
  read the MAP variable directly, but you may not directly alter the
  MAP variable (except to copy it to another MAP variable).

        MAP Main TO 60, 10 AS FName, 10 AS LName, 20 AS Add1, 20 AS Add2

   This line would create a fixed length string called "Main" which would
   be 60 characters long.  The string would contain four fields of 10, 10,
   20, and 20 characters within it.  To use these variables, you must
   refer to them in this manner:

        SET Main.FName to "Erik"
        SET Main.LName to "Olson"

  Main.FName will not conflict with another variable called "FName" if
  it exists, but you cannot have another variable called "Main".  Thus,
  you could map two strings with the same field names, and they would
  not conflict with each other.  You can copy one mapped string to another:

        SET Main TO Main2

  But the mapping information will not copy over.  You must individually
  map each string.  To erase a string and it's mappings, simply CLEAR the
  main string.  You may also clear an individual field, which will just
  set it to nul.  If you attempt to redefine MAIN, as in

        SET Main to "Hey!"

  You will destroy the string, and an Invalid Map error will occur the
  next time you attempt to use it.

  GET MAPPED
  ==========
  GET a mapped record from a random access file ("R").  The syntax is:

        GET MAPPED variable IN buffer AT record

  For instance, if we had a file which contained many 60 byte records
  like the "Main" that we mapped above, then to open it and print the
  100th record, we'd use these lines:

        MAP Main TO 60, 10 AS FName, 10 AS LName, 20 AS Add1, 20 AS Add2
        OPEN "R", #1, "NAMES.DAT", LEN Main
        GET MAPPED Main IN #1 AT 100
        PRINT Main.FName
        PRINT Main.LName
        PRINT Main.Add1
        PRINT Main.Add2

  PUT MAPPED
  ==========
  To write a record to a random access file, simply assign the fields of
  the mapped variable and then use the PUT MAPPED command with this syntax:

        PUT MAPPED variable IN buffer AT record

 If we wanted to append a new record to the end of the above database, we
 would simply figure out how many records are in the database and then
 PUT MAPPED a new record to the end, like this:

        PUT MAPPED Main IN #1 AT CALC (LOF #1/LEN Main)+1

  HIGH PERFORMANCE INDEXES
  ========================
  IXCREATE - Create a high performance index.

  You must have a MAPPED database currently open.  The syntax for indexing
  it is:

        IXCREATE indexfile, mapname.fieldname, mapbuffer

  For instance, if you have a database opened for random access reading and
  writing, and you are using a structure named USERS to get and put records
  to the file (USERS is a MAP structure), and you wanted to index on the
  field named "ID", then you could say something like this:

        IXCREATE "USERID.IX", USERS.ID, #1

  Where "USERID.IX" would be the name of the index file to create, USERS is
  the name of the current structure being used to access the database, ID
  is a field of the USERS structure, and #1 is the file handle of the
  database which is currently open.  For instance, here is a whole program
  which might be used to index an existing file:

    MAP USERS AS 100, 10 AS NAME, 10 AS ID /* we don't care about the rest */
    OPEN "R", #1, "USERS.DAT" LEN USERS    /* open the database file */
    IXCREATE "USERID.IX", USERS.ID, #1     /* create an index for ID field */

  Then, to use the index, you could do this:

    IXOPEN "USERID.IX" AS #2               /* open the index */
    SET R TO IXFIND #2, "ERIK"             /* find a field, return in R */
    GET MAPPED USERS FROM #1, RECORD R     /* get the actual record now */

  You can have as many open indexes at once as you wish, for as many
  different databases as you wish.  An index does not have to be associated
  with any given database, and vice versa.  All of the stand-alone index
  functions return a numeric record number.  You can then use that
  record number to get a record from a database.

        IXOPEN "filename" AS buffer

  For example, if you had an index called "NAME.IX" you could prepare it
  for use like this:

        IXOPEN "NAME.IX" AS #1

  IXFIND and IXSCAN are functions which return a record number of a match
  was found in the index.  IXFIND searches alphabetically for a matching
  item which starts with the same sequence of characters as the search string,
  while IXSCAN will scan the index sequentially from the beginning and
  will stop when it finds the search string anywhere in the indexed field.

        SET R TO IXFIND #1, "OLSON, E"

  If "OLSON, E" occurs in the index, then IXFIND will return the record
  number.  The above statement has this record number assigned to the
  variable R.

        SET R TO IXSCAN #1, "ERIK"

  If the word "ERIK" occurred anywhere within the index, R will be assigned
  to it's first occurance.

        SET R TO IXSCAN REST #1, "ERIK"

  This will continue the scan from where the previous IXSCAN left off,
  or from whatever is the current point in the index.

        IXSKIP buffer,records

  IXSKIP will return a new record number after the indexed has been skipped
  in forward or backward.  I.E:

        SET R TO IXSKIP #1, 1

  Will skip forwards one record in the index and return the record number
  in R

        IXNEXT buffer
        IXPREV buffer
        IXTOP buffer or IXFIRST buffer
        IXBOTTOM buffer or IXLAST buffer

  These functions skip forwards to the next or backwards to the previous
  record, to the beginning or end of the index, and return the record
  number it corresponds to.

  IXBOF returns true if you are currently at the top of the index
  IXEOF returns true if you are currently at the end of the index

  IXWAS returns the last record number you were at and relocates
        the index pointers to continue on from there again (like if
        you had just tried to search for something else and wanted to
        go back to where you were).  An unsuccessful search will always
        retain the most recent record number, which can be retrieved
        with IXWAS.

  IX returns the current record number value for an index, in case you
     need it again without searching (like if you had switched indexes
     or something).

  IXCREATE - Create a high performance index.

  You must have a MAPPED database currently open.  The syntax for indexing
  it is:

        IXCREATE indexfile, mapname.fieldname, mapbuffer

  For instance, if you have a database opened for random access reading and
  writing, and you are using a structure named USERS to get and put records
  to the file (USERS is a MAP structure), and you wanted to index on the
  field named "ID", then you could say something like this:

        IXCREATE "USERID.IX", USERS.ID, #1

  Where "USERID.IX" would be the name of the index file to create, USERS is
  the name of the current structure being used to access the database, ID
  is a field of the USERS structure, and #1 is the file handle of the
  database which is currently open.  For instance, here is a whole program
  which might be used to index an existing file:

    MAP USERS AS 100, 10 AS NAME, 10 AS ID /* we don't care about the rest */
    OPEN "R", #1, "USERS.DAT" LEN USERS    /* open the database file */
    IXCREATE "USERID.IX", USERS.ID, #1     /* create an index for ID field */

  Then, to use the index, you could do this:

    IXOPEN "USERID.IX" AS #2               /* open the index */
    SET R TO IXFIND #2, "ERIK"             /* find a field, return in R */
    GET MAPPED USERS FROM #1, RECORD R     /* get the actual record now */

  IXUPDATE - todo - updates a single record to an index
  IXDELETE - todo - deletes a single record from an index
  IXRESORT - todo - re-alphabetizes an index

  (the structure of these indexes is simple.  The first four bytes are a
  long integer which contains the length of each field in the index.  The
  rest of the index is a simple random access file of records that length,
  offset from the start by the remainder of the size of the first field
  minus 4, in other words, an indexed field 20 characters wide would be like
  this:

        HHHH____________________
        aardvark____________nnnn
        abacus______________nnnn
        acme________________nnnn

  where HHHH is a 4-byte number which equals 24 (field length+4 bytes) and
  then there are filler bytes equal to the size of a field.  The second
  field begins with the first index entry followed by a 4 byte record number
  and so on and so forth.  The high performance index, due to it's simplicity,
  can be searched faster than any other index format and allows high speed
  scanning.  The search speed does not degrade, regardless of the size of the
  index.  The only drawback is these indexes are much harder to update.  I have
  figured out some tricks that will make this task much quicker, but I want
  to implement them before I discuss them.  Suffice it to say that if this
  works, I will have little use for Binary Trees in the future.)


  AUTOEDIT
  ========
  AutoEdit requires the file FEMALES.DAT to be in the current directory.
  Prior to calling AUTOEDIT you must set some variables which contain the
  raw data for AUTOEDIT to act on

        SET AUTONAME      TO "SMITH JOHN Q AND MARY J"
        SET AUTOADDRESS   TO "123 ANYWHERE ST"
        SET AUTOCITYSTATE TO "NEW YORK NY"
        SET AUTOZIP       TO "12345"

  If these four variables have been defined, then AUTOEDIT will do some
  fancy footwork with them and create some new ones that you can use.  To
  invoke AUTOEDIT, just say

        AUTOEDIT

  Once this routine has been called, these variables will be created:

        NAME     = "John and Mary Smith"
        ADDRESS  = "123 Anywhere St."
        CITYLINE = "New York, NY  12345"
        FORMAL   = "Mr. & Mrs. Smith"
        INFORMAL = "John and Mary"

  As you can see, AutoEdit humanizes data, and using some name pattern and
  gender recognition it can produce a wide range of formal and informal
  salutations.  AutoEdit chokes on some foreign names, particularly asian
  ones.  It removes extraneous initials or titles, and can tell whether or
  not two individuals have the same last name, and if one is female, and
  then assumes they are married.  A second name can be joined with the first
  in AUTONAME, like "SMITH JOHN Q AND MARY J", or like
  "SMITH JOHN Q AND JONES MARY J", or a second name or spouse may be
  provided under the variable AUTONAME2.  AutoEdit works best with American
  names and American addresses, and 5 digit zip codes.  Try it!


FIXES to version 0.92
=====================
+ Faster execution of programs
+ Corrected block errors on CASE..ELSE..ENDCASE and IF..ELSE..ENDIF
+ GOTO/GOSUB in middle of line or block jumps immediately
+ Default program extension is .PRO if ANSI enabled
+ Default program extension is .TTY if ANSI not enabled
+ Added EITHER and NEITHER functions to test multiple expressions:
+ Added BOTH function too

        IF EITHER SAME A,B SAME C,D ...
        IF BOTH A,B
        IF NEITHER VAL A, VAL B

+ Added SIZEOF function to return the size of a file


THE CITIDATA BBS PROGRAM
========================
I am working on a BBS program which will become quite extensive.  I have
included some of the files for this program in three ZIPs

        ROOT.ZIP - contains MAIN program and user database
        PRO.ZIP  - for subdir \PRO\ contains programs
        TYP.ZIP  - for subdir \TYP\ contains screen TYPE files

The root files and PROZOL.EXE must be in and run from the root dir of a
drive (or SUBSTed drive) to run correctly.  This BBS is far from complete,
so it may not run too far as is.  I have also not included many other
files it needs, like databases and help screens.  Writing these programs
has been a great finder of bugs.




MSP:PROZOL 1.0  from Mermaid Software Products
Freeware by Erik Lee Olson  Copyright (C) 1993  All Rights Reserved

Read PROZOL.DOC for instructions on how to configure Prozol.  This document
also describes the Prozol language structure, and includes a complete
keyword reference.

PROZOL.EXE - The Prozol interpreter
ANSI.COM   - A generic ANSI driver (ANSI is recommended for developing)
SOURCE.ZIP - contains the PowerBASIC 3.x source code to the interpreter

This version of Prozol is freeware, which means that it is copyrighted and
may be freely distributed without modification.  If you intend to use
Prozol commercially and wish to recieve updates and tech support, a $100
registration fee is requested, but not required.  If you invent any new
commands or internal procedures for Prozol (the source code is supplied)
you may be entitled to payment for them from the author.  Prozol is
written in the PowerBASIC language and requires PowerBASIC version 3.00B
or later to compile.  You may obtain PowerBASIC from PowerBASIC Inc., Byron,
California.  Their phone number is (800) 730-7707.

Prozol is a programming language designed for creating BBS systems.  Prozol
features:

        - A fully featured and structured high level language
        - High performance relational database and indexing
        - dBASE database interface and indexing
        - Support for both standard and non-standard COM ports
        - Desqview optimization
        - Built-in XMODEM file transfer capability
        - A DOOR command for running external doors and protocols
        - Network database support
        - Network global variables (available to all nodes)
        - 6-way network color-coded CHAT
        - Topical conferences with public+private reply options
        - Private user messages
        - Live OLMs (On-Line Messages) between users at any input prompt
        - Random and sequential file read/write/append access
        - Full-screen ANSI data entry to database fields or variables
        - DOS commands
        - Support for interrupt calls
        - Callable subroutines and user defined functions
        - Support for calling the contents of a file as a subroutine
        - Structured IF..ELSE..ENDIF and CASE..ELSE..ENDCASE
        - Multiple statement execution on a single line
        - Statement execution within files being TYPEd to the screen
        - Merge of variables, functions and color codes within output
        - Error handling subroutines
        - Logout handling subroutines
        - ANSI boxes and ANSI scrolling menus
        - Full ANSI screen control with CLS, LOCATE and COLOR
        - Uniform filtering out of all ANSI codes in output
        - Support for TVI 900 series terminals
        - Externally created superfast indexes for readonly databases
        - Calling subroutines within string variables
        - Automatic typing of variables (string or numeric)
        - Numeric output formatting (##.####)
        - GO to any other program at any input prompt
        - Hot-key logout (CTRL-C)
        - Hot-key toggle ANSI emulation on or off (CTRL-D)
        - Hot-key printer on/off, form feed and printscreen on TVI terminals
        - PowerBASIC source code included!

To run, just type PROZOL at the DOS prompt.  If you have never run Prozol
before you must create a config file PROZOL.CFG.  If the file is not
present Prozol will ask you a series of questions and then create the
config file.  Once the file has been created you can rebuild it by typing
CONFIG at the prozol command prompt, or by erasing PROZOL.CFG and then
running PROZOL again.

This config file contains a number of directory paths required by Prozol,
some information about the modem you will be using, and the Prozol command
prompt.  You must also provide a command for Prozol to execute after the
modem connects.  Usually this command will be a RUN or GO command along
with a startup program to run.  The END command will display a command
prompt.

  ========================================================================
  To reset Prozol, just press CTRL-C.  To exit to DOS, type "QUIT" at the
  Prozol prompt.
  ========================================================================

If you run PROZOL with a COM port parameter, PROZOL will wait for the phone
modem to recieve an incoming call.  When the call connects, PROZOL will
execute the command in the config file specified to execute on connect.

Prozol will work with COM1 through COM4 using standard port and IRQ options.
however if you wish to use PROZOL with a non-standard port (such as a
galacticomm, digiboard, or boca multi-channel serial board) you can
specify the port address and IRQ on the command line.  See PROZOL.DOC
for details.

Prozol is optimized for the best possible performance running multiple nodes
under Desqview.  You may also run multiple nodes of Prozol on a network.
Prozol supports full file sharing and multi-user record handling.  Prozol
also features network-global variables which can be set or modified by
any node on the network and seen by any other node.  Other network support
includes a 6-way chat system and OLM (hot messages) which can be sent from
any user to any other user on the system.  If the other user is currently
connected the message will pop up on the addressee's screen, otherwise the
message will be queued and displayed the next time the addressee connects.

Prozol has evolved over many years of service as a host BBS system which
is used in very large PC network systems that provide real estate agents
access to property records databases and business listings, as well as
file libraries and legal documents.  Prozol has also been used to run an
extremely off-the-wall BBS at the author's house while it was being developed.

In the very near future a self-multitasking version of Prozol will be
available.  Sooner than that, I will be concentrating on improving the
database capabilities and writing a ton of example applications and
subroutines.  There is also a great deal of room for improvement in the
message and conference areas.  More and more areas will also be converted
to assembly language which will greatly improved the speed and performance
of the interpreter.

If you have any suggestions or ideas for Prozol, please contact the author
at the locations listed below.  Please report any problems as well.  And
of course, if you have any questions at all, I am

        Erik Olson
        PowerBASIC Tech Support
        1350 Birchcrest Blvd
        Port Charlotte, FL  33952

        (813) 625-1172

        Citidata Corp. of Tampa Bay  (813) 393-7804
        Mermaid Software Products    (813) 398-7443
        Digitek Data Systems         (813) 629-9313

  CompuServe: 74141,1644
    InterNet: 74141.1644@compuserve.com
          or  erik.olson@rainnet.com

THE BIG FAT HAIRY TO-DO LIST (in order of priority)
============================
! Support for timed events (by the minute, hour, or day)

! Perminant variables: Variables that are stored in a common network file
  just like the COMMON variables, but the name of the file can be associated
  with a specific user or user group.  These variables can be used to track
  time and system activity for individuals or groups.

! GO list, to provide aliases and security for allowable GO commands.

! Weighted searches:  database queries based on a hierarchy of values
  which are returned in a sorted list (a tag file) in order of probabilility.
  with the first items being the most likely matches, and the last items
  being the least likely match.  Indexed ranges and minimum "score" values
  can be specified.

! Support for pre-processed program file formats that will run through a
  special version of the EXEC subroutine written entirely in assembler, as
  well as declarable integer and floating point data type variables.  These
  enhancements should speed up program execution by a factor of about 100.

! Time and Date functions.  Julian date calculation, days between dates,
  etc.

! Virtual BBS - a full blown generic BBS that can be executed with a single
  config file.  Standard features.  This would allow multiple BBS systems
  to reside "virtually" within the Prozol system.  The VBBS's would contain
  more advanced file, e-mail, conference, and chat facilities.

! A proprietary modem terminal with support for a complete user interface
  terminal emulation, graphics images, line drawing, mouse, disk access
  and other things not usually possible over a modem.  Among these include
  bridging through another serial port on the host to a secondary system,
  DOS access to the remote system in the background, while the remote
  user runs Prozol programs, and retrieval of general PC system information
  from the user's machine.  Also reading and writing disk files and auto-
  matic disk and print logging, automatic uploading and downloading of
  files.

! Enhanced line editing, more like the GWBASIC line editor for remote
  programming.

! ANSI editor, a full screen ANSI editor which returns the entire edited
  document in a single string variable, which can be written to disk or
  stored as an EMS object.

! A special database format for variable length text and attribute fields,
  such as an electronic mail data structure, which can be supported by
  any of of the available indexing schemes.  Also useful for descriptions
  of downloadable files, or database memos.

! EXTENSION command, specifies the default extension of programs executed
  with RUN, GO and LOAD, allows support for multiple interface configurations.

! SUBScript, a language within the language, to allow external developers
  to create customized virtual systems.

! Interactive IDE - I had an IDE with IOCOM that allowed single step,
  trace, and single statement execution, as well as background execution
  behind the editor.  I merely stripped this out while implementing the
  BozoL engine for compile speed while I am debugging the Prozol language.
  I will put the IDE back in the final version.

! CHAT rooms.  Right now, only one CHAT area exists, allowing up to 6
  simultaneous chatters.  I would like to implement an infinite number of
  CHAT areas which can be associated with conferences or any other
  text symbol.

! Load, Type, and object loading of compressed files, and storage of memory
  variables as compressed data.

! Support for the GTEK PCSS8i intelligent serial card

! Support for OS/2 communications drivers

! Support for the X00 fossil driver for up to 16 concurrent sessions per
  machine using standard serial boards (galacticomm, digiboard, boca, etc)

! Create, copy, and modify the structure of dBASE files

! Database conversion utilities and a code generator.

! EMS "objects" - text that can be stored in EMS memory, screens, subroutines,
  variables, menus, database merge templates, documents, etc.

! Multithreading - Prozol subroutines that can run in the background
  This is actually very easy, since it simply involves making a call
  to a background program execution subroutine between each statement
  and during idle times (like INPUT and DELAY).

