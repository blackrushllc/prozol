******** SEE "CHANGES" FILE FOR A LIST OF CHANGES AND ADDITIONS.  THIS MANUAL
         IS FOR BETA TEST VERSION 0.90.  Additions for each beta version are
         itemized in the README file.  These changes will eventually be
         updated to this document.


PROZOL BBS LANGUAGE
===================

Copyright (C) 1993, 2025  Erik Lee Olson  All rights reserved
Blackrush LLC, Tarpon Springs, Florida


PROZOL is an extremely simple language to learn, easier than BASIC.  The
interpreter allows you to type in small programs or enter direct
statements and run them just like the old style GWBASIC interpreter.  It
would be best, however, to use a text editor like QEdit or the DOS EDIT
program to create your programs.

The purpose of PROZOL is to write BBS programs.  PROZOL features a wide
range of commands and functions to make this as easy as possible while
offering the flexibility of a complete high level programming language.

In addition to normal language features, PROZOL has built-in facilities
for messages and conferencing, binary file transfer, dBASE databases,
multiple node chat and hot messages, animated ANSI menus, global
variables (accessible to all nodes on a network), and much more.

When you create a program it will run exactly the way you see it on a
remote ANSI terminal.

RUNNING THE PROZOL INTERPRETER
==============================

To run PROZOL in local mode just type PROZOL at the DOS prompt.  You can
place A PROZOL command to execute on the command line if you wish.

        C:\PROZOL\> PROZOL
        C:\PROZOL\> PROZOL Run "startup"


QUIT OR RESET
=============

Type "QUIT" at the Prozol prompt to exit to DOS (or SYSTEM).  To reset Prozol
at any time (restart and/or re-run command line parameters) press CTRL-C or
type the command LOGOUT, RESET, or RESTART.


CONFIGURATION
=============

If you have never run PROZOL before it will prompt you to answer a few
questions which are necessary for PROZOL to run.

        1200 2400 4800 9600 14400 19200 38400
        Enter opening baud rate (default 2400) --> _


Even though you are not using the modem yet, PROZOL needs to know the
opening baud rate for on-line sessions.  If you enter 1200 or 2400 PROZOL
will initialize the modem at this baud rate and then adjust to whatever
speed the modem connects at.  For baud rates of 9600 and higher PROZOL
will remain at a fixed baud rate.

        Enter modem parameters (N,8,1,ME,FE,DT) --> _

These are the default modem parameters, although some modems may require
that you supress the RTS and CTS lines, in which case you would add
RS,CS to the parameter list.  ME and FE are required for masking framing
and overrun errors.  DT is required to keep the DTR line high during
door program execution.

        Chat file path\name (preferably on a RAM disk) --> _

The default chat file is CHAT.RAF which will be created in the current
directory when needed.  For improved performance a network chat file
should be located in a network RAM disk.  If you will not be running
multiple nodes of PROZOL then this setting is not important.

        OLM Directory (i.e. F:\OLM\   default is root) --> _

OLM's are On Line Messages which can be sent from any user to any user.
If the addressee is currently on-line the message will display
immediately on the user's screen.  If the user is not currently on line
the message will be displayed as soon as the user logs in.  These
messages must be stored somewhere.

        CONFERENCE Directory (default is root) --> _

Conference files contain many messages which are entered and viewed by
all of the users.  You must specify a directory to keep these files in.

        COMMON variable file (default is COMMON.VAR) --> _

On a network, each node can create and access variables which are global
to every copy of PROZOL running.  In order to use these common variables
PROZOL needs to store them in a file.  Placing this file in a RAM disk
improves performance.

        MAIL Directory (default is root) --> _

Private mail must be stored in a file along with indexes.  You must
specify a directory to keep these in.

        Default system prompt:
        1) OK (like gwbasic)
        2) {HOST}>
        3) Command:
        4) C:\> (like dos)
        5) No prompt - automatically log out user if prompt is displayed.
        Select --> _

When you are experimenting with PROZOL and running programs in local mode
PROZOL needs to display a prompt.  You may also allow remote users to
access the PROZOL command prompt if you trust them.  You can select from
four different types of prompts or use selection 5 to cause the command
prompt to immediately logout a remote user.  This setting may be
desireable to prevent a program from accidently ending and leaving the
caller at a command prompt from where they could re-format your hard
drive if they knew how.  You can select a normal prompt, such as number
1 and then use the PROZOL command SETPROMPT to change it later for
security.

        Execute on CONNECT (END=cmd mode) (default=GO MAIN) --> _

When a caller dials in and PROZOL answers the phone you will want to
start running PROZOL programs.  You should write a startup program that
asks for a name and password or allows new callers to obtain one.  If
you named this startup program MAIN.PRO, then the command GO MAIN or RUN
"MAIN" would cause PROZOL to run the MAIN.PRO program when the caller
connects.

Once you have answered these questions, PROZOL will create a
configuration file in the current directory.  To answer these questions
again, erase the file PROZOL.CFG and run PROZOL again, or enter the
command CONFIG at the PROZOL prompt.

SETTING UP PROZOL TO ANSWER THE PHONE
=====================================

To run PROZOL in remote mode, execute the PROZOL.EXE program with the
desired com port specified on the command line.

        C:\PROZOL\> PROZOL COM1:

You may use COM1:, COM2:, COM3:, or COM4:.  If you wish to use a non
standard port (such as a multi-channel serial board) you may specify the
port and irq numbers on the command line.

        C:\PROZOL\> PROZOL COM4: /PORT=0220 /IRQ=5

PROZOL will initialize the modem and place it in answer mode.  It will
wait for an incoming call and recycle every 60 minutes to keep the modem
awake (some modems go to sleep if they are not reinitialized every so
often).  To exit to DOS press ESC or press F10 to take the modem out of
answer mode and go to into local mode.

An initialization string of ATS0=1 is used to place the modem into
answer mode.  It may be necessary to change this initialization string
on some modems.  Initialization strings are contained in files called
INIT1 through INIT4 in the current directory.  If the file does not
exist it will be created with the string ATS0=1 in it.  You can edit
this file if you wish.

When a call comes in and PROZOL answers it, PROZOL will execute the
command specified in the config file to execute on answer.  The default
command to execute is "GO MAIN" which will load and run a program file
called MAIN.PRO in the current directory.  This program should prompt the
user for some sort of password before continuing.  From here you can run
other programs in a continuous chain.  The command LOGOUT will hang up
and reset PROZOL to answer the phone again.

        ' test sample MAIN.PRO
        CLS
        PRINT "This is a test!"
        PRINT "Press any key..."
        CWAIT
        LOGOUT

If you created the above program and placed it in the current directory
along with PROZOL.EXE, PROZOL.CFG and the INITx files, then run PROZOL with
the com port name on the command line, PROZOL will reset the modem and
wait for an incoming call.  When a call comes in the caller will see the
screen clear and the two lines of text displayed.  The system will wait
for a key press and then hang up, resetting itself for another call.

LEARNING THE PROZOL LANGUAGE
============================

PROZOL is a very simple language.  If you know BASIC then PROZOL will be a
snap.  PROZOL is similar to BASIC, however there are some substantial
differences which you will see as we go along.

The best way to become familiar with PROZOL is to play with the
interpreter directly and watch what happens when we enter certain
commands.  Once you become familiar with putting together simple
one-line statements or very short programs, then you should be able to
load up your text editor and start putting together a full blown,
completely original BBS program.

(((A Pseudo-compiler will be available shortly to allow you to create
distributable, unmodifiable and royalty-free on line systems.)))

Start up PROZOL and enter a few direct PRINT statements. (the symbol > is
used to indicate A PROZOL prompt, which can actually be anything.  The
default prompt is OK followed by a carriage return)

        >PRINT "Hello World"
        Hello World
        >PRINT 1 2 3
        1 2 3

When you type in statements at the PROZOL prompt they will be executed as
soon as you press ENTER.  Try this:

        >PRINT "This": PRINT "is": PRINT "a":PRINT "test!"
        This
        is
        a
        test!

Multiple statements can be placed on the same line separated by colons,
just like BASIC.  Now try this one:

        >INPUT "What is your name?";NAME
        What is your name?_

The INPUT statement works just like BASIC in this manner.  You may
follow INPUT with an optional prompt in quotes, followed by a delimiter
and a variable name to accept the input.  You will notice that there is
no $ after the variable name.  You could put one there if you wanted to,
but PROZOL does not differentiate between string variables and numeric
variables, so a dollar sign is not necessary to tell PROZOL that it is a
string variable.  Since a dollar sign and other BASIC variable type
identifyer symbols are valid in variable names, you could use them if
you wanted to.

The INPUT statement will display the optional prompt and then wait for
something to be entered at the keyboard.  When the user presses ENTER
whatever was typed in will be contained in the variable.

Like BASIC, variables do not have to be declared before they are used in
an command like this.

Notice that the prompt and the variable were separated by a semi-colon.
In BASIC you would use either a semicolon or a comma to separate the
parameters of most commands.  In PROZOL you may use a semicolon, comma,
space, or DUMMY KEYWORD to parse statements in any manner you wish.  In
other words, these statements are all identical:

        INPUT "What is your name?";NAME
        INPUT "What is your name?" NAME
        INPUT    "What is your name?",,,,,,,,,,,,,NAME
        INPUT "What is your name?" TO NAME

Notice the last line, where the word TO was placed between the prompt
and the variable NAME.  TO is a DUMMY KEYWORD which does nothing.  It is
not even seen by PROZOL.  The purpose of these dummy keywords is to make
your source code more readable.  There are many dummy keywords that you
may use freely wherever you wish.  For example, try this line:

        PRINT "HI THERE!" AT LOCATE 10,10 IN COLOR 0,7

This line is the same as

        COLOR 0,7:LOCATE 10,10:PRINT "HI THERE!"

Do you see the difference?  The second line has the statements listed in
the opposite order as the first.  The second line also has colons (:)
separating the statements.  Statements separated by colons are executed
in sequence, while statements separated by any other parsing character
or dummy keyword are executed "all at once".

If no colons (or carriage returns) separate multiple statements, then
all of the statements will be evaluated before they are executed.  A
simpler way to look at it is like this:  Multiple statements on the same
line will be executed in reverse order if they are NOT separated by
semicolons.

For example, if you were to say

        PRINT 1 : PRINT 2 : PRINT 3

Then PROZOL would print

        1
        2
        3

However, if you were to say

        PRINT 1 PRINT 2 PRINT 3

Then PROZOL would print

        3
        2
        1

If this seems a little strange to you then you will just have to be
trusting.  There are some very good reasons for the syntax to work this
way.  If you do not like the idea of multiple statements being executed
in reverse order then just don't worry about it and separate all of your
commands with colons or carriage returns.  The advantages of this syntax
option should become more clear as you see more examples.

ENTERING A PROGRAM

PROZOL uses line numbers to to enter and edit lines of a program, however
the line numbers are not stored when you save the program to disk.  You
cannot use line numbers with GOTO or GOSUB statements.  You must use
labels.  Enter this program at the PROZOL prompt:

        >1 START
        >2 PRINT "This is a test!"
        >3 INCR A
        >4 PRINT A
        >5 GOTO START IF SAME INKEY ""

After you have entered the program, type RUN at the PROZOL prompt:

        >RUN
        This is a test!
        1
        This is a test!
        2
        This is a test!
        3

The program will continue to display and count until you press any key.
You have probably already noticed two very odd things about this
program.  First, line 1 is a label called START.  PROZOL labels are
single words that are not keywords. Label names can be things like START
or BEGIN or GETINPUT or KILLME.  Labels must be all by themselves on a
line.  When you GOTO or GOSUB to a label, execution will jump to the line
immediately following the label.

Now you may have noticed something else kind of strange about the little
five line program.  Type LIST at the PROZOL prompt and view the lines of
the program that are currently in memory.  If you wanted to list a
single line of the program, line 5, for instance, you could just say
LIST 5.  If you wanted to view a range of lines you could say
LIST 1 TO 4, or just LIST 1 4.  TO is a dummy keyword, since LIST
requires only two parameters to list a range of lines, you can use TO,
or just separate the two parameters with a space, comma or semicolon.

Now look at line 5.

        GOTO START IF SAME INKEY ""

This line consists of several distinct actions.  This line would also be
the same as

        IF SAME INKEY : GOTO START

The IF tests if what we want to do first.  IF SAME INKEY "".  In PROZOL,
character variables must be compared with the SAME function.  SAME
followed by two character arguments will return a true or false if they
are the same.  The IF command will abort the current statement if the
condition which follows it is false, so if you are using a colon to
separate the statements GOTO START and IF SAME INKEY "" then the IF
statement must come first.  If you are not using colons to separate the
statements then the IF must follow what you want to do if the IF
evaluates true.

There is no THEN keyword in PROZOL since it is not really necessary.
Conditions such as IF, WHILE and UNTIL are followed by any expression
which will either be true or false.  If the expression indicates that
the remainder of the line should not be executed then PROZOL will skip
ahead to the next line.  Here are some examples:

        UNTIL LEN INKEY

This expression will wait for a key to be pressed.  It is not really
necessary, though, since the command CWAIT will do the same thing.

        WHILE NOT LEN INKEY

This line will continue to iterate as long as the expression NOT LEN
INKEY is true.  That is, until a key is pressed.  INKEY returns a
character waiting in the keyboard buffer, or null of no key has been
pressed.

Since we now know that expressions will be executed from left to right
if they are separated by colons, or from right to left if they are not
separated by colons, we can understand how these following complex
expressions would operate:

        UNTIL SAME INKEY," ": PRINT "Press SPACE to stop!"

This line will keep printing "Press SPACE to stop!" until the user hits
the space bar.

        WHILE EVAL A<10: INCR A: PRINT A

This line will print the numbers 1 to 10 and then stop.

There is something critical that you should know about the last example.
The EVAL keyword returns the result of a numeric expression.  For
example,

        PRINT 1+1

Will print

        1+1

on the screen!  In order to evaluate an arithmetic expression, you must
precede it with the EVAL keyword.

        PRINT EVAL 1+1

will print

        2

on the screen.  The reason for this is speed.  Since PROZOL does not need
to check for arithmetic expressions while interpreting each statement it
runs a great deal faster.  The keyword EVAL tells PROZOL to evaluate all
parameters as though they were arithmetic.  EVAL has some synonyms that
you may use interchangeably for readability.  CALC and WITH do the same
thing.

        PRINT EVAL 1+1
        PRINT CALC A+B
        PRINT CALC (1+1)*A/256 ^7
        PRINT "The answer is " CALC A/B



This brings us to variables.  A PROZOL variable can be any alphanumeric
sequence of characters which are not arithmetic operators.  PROZOL
variables cannot begin with a number but may contain them.

In BASIC you can assign a value to a variable by just saying

        LET A=1

In PROZOL, however, you cannot use the equals sign to assign a value.
You must simply omit it:

        LET A 1

Or you can insert the dummy keyword BE to make the statement more
readable:

        LET A BE 1

You can also use the keyword SET instead of LET.  In this case you
can use the dummy keyword TO, as in

        SET A TO 1

A variable does not have to be declared before it is used.  For example,
you could say

        INCR A

and if A does not exist then it will be incremented to 1 from 0.  A
variable which does not exist is assumed to be null, so if you tried to
print a null variable, a "" (blank) would be displayed.  You could, however,
assign it to a string value, or even a null string.  You must assign a value
of 0 to a variable if you wish to assume that it is 0 in an arithmetic
expression.  Conditional tests like IF or WHILE will assume a null to have
a zero value, however.  In other words, if A is undefined, then IF A will
evaluate false.

In an arithmetic expression a variable is assumed to be 0, however if it
is used in a string test (SAME) then it is assumed to be null if it is
not defined.  Therefore, if A is not defined, then

        PRINT SAME A ""

will print -1, which is TRUE.  However,

        PRINT EVAL A

will print 0, since the arithmetic value of A is 0.

As we have seen, conditional execution of lines can be decided with IF,
UNTIL or WHILE which decide whether or not the rest of the line is to be
executed or repeated.  You can also create block conditional execution
of statements.  In BASIC and other languages, you can begin a block with
IF <condition> THEN... and follow this with a bunch of lines to execute
of the condition is true.  Then you can say ELSE and then a bunch of
lines to execute if the condition is false, followed by END IF to
terminate the block.  In PROZOL you can do the same thing with the CASE
command.

        CASE EVAL A=1
                ...
        ELSE
                ...
        END CASE

CASE structures may be nested, however END CASE (or ENDCASE) will
terminate all case conditions and continue executing, therefore,
additional nested case loops can not be terminated with an END CASE.
You must do something like this:

        CASE <condition>
                CASE <other condition
        ELSE
                <if first AND second are not true>
        END CASE

IF..ELSE..ENDIF blocks can be created as long as they are on the same line,
such as

        IF A:PRINT "A is true":ELSE:PRINT "A is false"

Notice that there is no THEN keyword.  Also, ELSE is an expression by itself
and must be parsed with colons, otherwise it will not execute correctly.  If
you did not want to use colons to parse the components of IF..ELSE..ENDIF
then you would have to write it backwards, like this:

        PRINT "A is false" ELSE PRINT "A is true" IF A

You can write block IF..ELSE..ENDIF statements inside subroutines, however,
such as

        MYSUB {IF A THEN
                PRINT "A is true"
              ELSE
                PRINT "A is false"
              ENDIF
              }

Since the rules for writing code inside a subroutine or function are slightly
different from those governing ordinary line by line code.  Inside a
subroutine that is blocked with curly braces, the code must be written as
through each line was on the same line with each statement separated by
colons.  More on this later.

As we saw before, GOTO can jump to any label in the current program.
GOSUB will do the same thing, but a subsequent RETURN will jump back to
the line immediately following the GOSUB which invoked it.  You can nest
GOSUBs to 32 levels.

You can also create subroutines by placing the code to execute into a
single variable.

        SET CLEARALL TO "CLS:COLOR 7,0:LOCATE 24,1"
        CALL CLEARALL

By placing executable statements into a string variable you can call the
string variable.  This is a little more versatile than you might think
by using the FILE function.  FILE is a character function which returns
the entire contents of a file name which follows it.  For example, a
file which contains a small PROZOL program to set a number of color
constants is included under the name COLORS.PRO.  You can load this file
into a character variable like this:

        SET COLORS TO FILE "COLORS.PRO"

You can then execute this program as a subroutine like this:

        CALL COLORS

A file containing multiple lines that is executed with CALL FILE must be
written as though each line in the file was actually a part of a single line
separated by colons.

You can create functions which return values the same way using the EXIT
command in the function.  EXIT will immediately terminate a CALLed
subroutine leaving any specified parameters on the stack.  For instance
if you created a string like this:

        SET X TO "EXIT 1"

And then you said

        PRINT CALL X

PROZOL would display

        1

on the screen, since 1 followed the EXIT command it was pushed onto the
stack and returned as a parameter.  A more elaborate example would be
something like this

        SET NUMINKEY TO "SET A TO INKEY:IF EVAL VAL A>0:EXIT A"

Then you could create a loop like this:

        UNTIL CALL NUMINKEY

This line would continue to iterate until you pressed a key with a
numeric value (1 through 9).

SUBROUTINES AND FUNCTIONS

You can create subroutines and functions that do not require the CALL keyword
to execute.  The way to do this is to surround the subroutine code in curly
braces.  Here is an example:

        DAY {MID DATE 4,2}

If you were to include this line anywhere in the current program, then

        PRINT DAY

would print the current day of the month (like 15 if it was the 15th of the
month).

Here is another example:

        MENU {  COLOR 7,0
                CLS
                TYPE "MENU.TYP"
                }

Then, in your code you could simply say

        MENU

and the subroutine would execute.  When you load and run a new program
that does not contain this subroutine, it will no longer exist.

Well, now we have covered most of the fundamentals of PROZOL.  Now all
you need to do is become familiar with all of the other commands and
functions which make PROZOL a really useful language.  There are a wide
range of very typical functions, like CHR, ASC, UCASE, LCASE, LEFT,
RIGHT, LEN, INSTR, MID, TIME, DATE, VAL, etc, as well as many commands
which do things with functions, variables and constant arguments, like
PRINT, INPUT, CLS, LOCATE, RUN, GOTO, LET, IF, WHILE, UNTIL, GOSUB, etc.

There are also a wide range of specialized commands which do some very
useful things.  If you wanted to begin transmitting a file with the
XMODEM protocol, the XMODEM command would be used for this:

        INPUT "Enter the filename you want:",FI
        CASE EXIST FI
                XMODEM OUT FI
        ELSE
                PRINT "File does not exist"
        END CASE

With a full understanding of the fundamental structure of the PROZOL
language, you will be able to study the PROZOL command reference and
learn how to incorporate each command or function into its proper
context.  Since PROZOL programs work the same way on your local console
as they will over the modem, you can learn a great deal by experimenting
with each keyword, writing and running test programs, and debugging them
locally.  Once you have several programs written that all seem to run
together just fine on your local console, then you can invoke PROZOL with
a com port parameter and allow users to dial in and run the very same
programs with PROCOMM or QMODEM or any other ANSI compatible terminal
program.


Named procedures will also work at the immediate command prompt.  For instance,
start Prozol (or reset) and type this:

        10 DAY { MID DATE 4,2 }

Then type this:

        PRINT DAY

Prozol would print the current day (like 15 if it is the 15th of the month)
on the screen.

PROZOL PROGRAM STRUCTURE
========================

        GOTO label

A label can be any unique word at the beginning of a line.  For example,

        START
        PRINT "hi there!"
        GOTO START IF NOT LEN INKEY

Your label could also be a bit longer

        START.AT.THE.VERY.BEGINNING
        PRINT "hi there!"
        GOTO START IF NOT LEN INKEY

in order to jump to a label you must specify characters that can be found
at the beginning of the line containing the label, but it does not have
to be the entire label.  You cannot have any spaces or punctuation in a
label.

Labels are not case sensitive.  You cannot use line numbers in a GOTO or
GOSUB.


        GOSUB label

This works just like GOTO except that a subsequent RETURN will come back to
the line immediately following the GOSUB.  Any remainder to the line will
be bypassed.


        CALL string

CALL will invoke a line of code contained within a variable, a single line
which starts with a label, or a disk file containing a program.

        SET A TO "PRINT 'hi there!'"
        CALL A

This will print "hi there!" on the screen.  You can also call a line which
starts with a label.

        CALL LINE XYZ
        END

        XYZ PRINT "Hi there!"

This will also print "hi there!"

        CALL FILE "XYZ.SUB"

This will load XYZ.SUB into memory and execute lines of program code in it.

Another form of call is implied.  You do not have to use the CALL keyword
when attempting to execute a line of code which starts with a label.  For
instance, if you had a line somewhere in your program that went like this:

        MAINMENU  { COLOR 7,0:CLS:TYPE "MAINMENU.TYP":INPUT A }

Then anytime you wanted to execute the commands to show the main menu
you could just say

        MAINMENU

which would be the same as

        CALL LINE MAINMENU

The same line above could return a value like a function.  All you have
to do is leave the values you want to return at the end of the line, like
this:

        MAINMENU { COLOR 7,0:CLS:TYPE "MAINMENU.TYP":INPUT A: A }

The you could say

        SET X TO MAINMENU

And the MAINMENU function would run and return the value in A, which the
above statement would be assigning to the variable X.


BLOCK STATEMENTS
================

You can create blocks of statements that behave just like they were on a
single line, only they can be up to 32K in length.  You cannot enter
block statements directly in the interpreter.  To use them you must edit
your program with a text editor and then load and run the program.  A block
statement is written like this:

        LABEL { program line
                  program line
                    program line
                  program line
                program line } return value

For instance, a menu subroutine could be created that displays a specified
menu and waits for input, returning the key value like this:

        SHOWMENU { SET MNU TO ?
                   COLOR 7,0:CLS
                   TYPE MNU
                   PRINT:PRINT:INPUT "Please select --> ";X
                   } X

Then you could display a menu contained in the file MAINMENU.TYP like this

        SET A TO SHOWMENU "MAINMENU.TYP"

Notice the first line of the SHOWMENU subroutine, SET MNU TO ?.  This means
to use whatever has been passed as a parameter.  If many parameters are passed
then each subsequent ? is used in place of a variable or argument to read
the parameters from the stack.  ? is just a place holder and does nothing,
hence, whatever is already on the argument stack is used in it's place.
The subroutine displays the file with the TYPE command and then waits for
input.  The input is pushed onto the stack as a return value, so SHOWMENU
will return the keyed in response to the menu.


LOOPS
=====

Block statements can also be used for controlling loops.  As you have seen,
WHILE, UNTIL and IF can only be used to affect the current line.  To iterate
or conditionally execute a large block of items, you can block them.

        IF EVAL A=1: { do this
                       do that
                       do the other
                       etcetera }

        {do this
            do that
                do the other
                    etcetera } UNTIL EVAL A>B


        WHILE NOT LEN INKEY {do this
                             do that
                              do the other}





SPECIAL PROZOL COMMANDS
=======================

PROZOL features a rich set of primative language essentials, but it also
includes some powerful special commands which invoke complex BBS
oriented subroutines.  These are described first.  After this section we
will describe some of the more typical language features.

ANSI - Activates ANSI terminal emulation

ANSI turns on ANSI emulation.  This command is usually not necessay
since ANSI is the default emulation.

ANSWER - ANSWER COMn: waits for an incoming call on com port n

The ANSWER command causes PROZOL to reset the modem and wait for an
incoming call.  This command can be used instead of invoking PROZOL with
a com port on the command line.

CHAT - invokes a 6-way chat system

CHAT must be followed by a user ID which is a unique string of 8
characters or less.  CHAT places the user into global chat mode in which
the user may converse in a color coded multi-node chat with other users.
For example, CHAT "SYSOP" will place you in CHAT mode where you may
engage in live chat with up to 6 other users who have also been placed
into chat mode with the CHAT command.

CONFERENCE - invokes a conference message system

This command must be followed by a conference file name without a path.
This command invokes an internal procedure which allows the user to
search the specified conference file or add messages to it.

CONFIG - invokes the internal configuration routine

CONFIG erases the current configuration file and prompts you to create a
new one.

CONNECT - opens a serial port and connects for terminal mode

This command must be followed by legitmate modem parameters, i,e,
"COM1:2400,N,8,1".  This command has the effect of allowing a local user
or remote caller to open a different serial port and begin interacting
with it.

DISCONNECT - disconnects secondary serial port

This command closes the secondary serial port opened with CONNECT.  It
does not log out the user who may be connected to a primary serial port.

DOOR - shells to a door program

Door shells to DOS and runs a door program specified as a string
parameter.  For instance,

        DOOR "COMMAND.COM <COM1: >COM1:"

will run DOS redirected to the com port COM1:.  DOOR does not
automatically redirect the command line to the com port.  In fact, DOOR
differs from SHELL in that it actually closes the connection and reopens
it after the door is completed.  You must create a door info file prior
to invoking a commercial door program which requires it.

ECHO - sets character echo on or off

ECHO OFF supresses character output to the user.  This command might be
useful for a subsequent INPUT which asks for a password, during which ou
do not want to echo characters back to the user.  You can also use ECHO
OFF to suppress database messages like "Not Found" during database
searches.  ECHO ON will re-enable character output to the user.

EDITCOMMENT - edits an e-mail comment

EDITCOMMENT must be followed by a comment ID string of up to 20
characters.  A comment ID string can be the user's name, ID number, or
any other kind of category, like a conference topic, a record number, or
some sort of other ID.  EDITCOMMENT will then allow the user to create
and edit a message up to 9 lines long that can then be stored under the
comment ID.  The GETCOMMENT command is used to retrieve and display all
comments under that same ID.

GETCOMMENT - checks for e-mail and displays if exists

GETCOMMENT must be followed by a comment ID string of up to 20
characters.  If any comments are found which were created with this ID
they will be stacked and displayed one at a time to the user.  The user
mey view the comments, kill them, or send a reply to the originator of
the comment.

GETTAG - gets a tag number from a tag file

This command goes along with the TAG command, which appends a number to
a TAG file.  If you wanted to know what the first TAG entry of a certain
TAG file was, you could use the command

        PRINT GETTAG "TEST.TAG",1

to display it.  Tag files can be very useful for marking database record
numbers. You could have a tag file which lists all database records that
a user is interested in.  By creating a tag file, the user can then go
and retrieve them at a later date.

GLOBAL - sets a global variable or returns the value of one

GLOBAL is actually not a good keyword to describe what GLOBAL does.
GLOBAL variables are really not global in any sense, they are simply
variable values that you can set and then view.  PROZOL uses some of them
for internal purposes, for instance, GLOBAL 1 should always be the
user's login name, 8 characters or less with no spaces or punctuation.
GLOBAL 3 is always the name of the program currently running, and GLOBAL
4 is an ANSI color code for the color scheme of all menu commands.

There are a total of 32 global variables which can be defined by

        GLOBAL 1, "Hi!"

Or retrieved as

        PRINT GLOBAL 1

All of them except for 1,3 and 4 are undefined but reserved for future
use.  For instance, a future version of PROZOL will store the current
terminal type in GLOBAL 2, and the default file transfer protocol in
GLOBAL 5.  No other global variables are defined, but do not use them as
they may be reserved in the future.

GO - executes an interpreted program without quotes around the program name

If you want to run A PROZOL program you can say RUN "xxxx", with the
program name in quotes.  You could also use the GO command and follow it
by the program name without quotes.  OK, big deal, but wait.  At any input
prompt a user may enter GO xxxxx instead of whatever normal input was
expected.  PROZOL will completely abandon the current program in memory
and run the requested program instead.  If the user is sitting at an
animated ANSI menu instead of an input prompt, they may press control-G
instead.  PROZOL will pop up a prompt window within which the user may
enter a program name.  If the program, or the program with an ".PRO"
extention does not exist in the current directory or in a directory
called "\PRO\", then the current program will simply resume, otherwise
the new program will be loaded and executed.  For instance, a user
sitting at the main menu selection prompt may type "GO FILES" instead of
making a selection and automatically run a program called "FILES.PRO"
which may reside in the current directory or in a directory called \PRO\
from the root of the current disk drive.

GOD - sets the value of the GOD variable

GOD ON or GOD OFF will set the GOD variable.  If GOD is ON then the user
may execute any PROZOL command at any input line by preceeding the line with
a slash character.  For instance, if GOD is on then you can drop to an
PROZOL prompt by typing in /END at any input prompt.

MENU - displays a square box on the screen containing a menu

MENU displays an ANSI box containing items and then accepts user input
in the last line of the box.  The XMENU function replaces menu and
should be used instead.  See the description of XMENU for more
information.

MENUCOLOR - sets the default color of menus

The XMENU command invokes an animated ANSI menu in which the user is
presented with a square box full of options from which they may select
using the arrow keys.  MENUCOLOR sets the color scheme of all subsequent
MENU commands.  The argument of MENUCOLOR should be a quoted string
containing ANSI color codes.  See the section entitled ANSI COLOR
SYMBOLS for a complete list of valid ansi color codes that can be used
as parameters for the MENUCOLOR command.

MORE - sets the number of lines for scrolling text files

The TYPE command will dump a file to the screen.  This file may contain
lines of text. PROZOL variables, functions, and executable statements.
MORE is used to set the number of lines to display before pausing with a
-more- prompt and waiting for a key press before continuing.

OLM - sets OLM scanning on or off or sends an OLM message to another user

OLMs are On Line Messages that one user can send to another user.  If
the other user is currently on line then the message will be displayed
on the users's screen immediately.  If the other user is not on line
then the OLM messages will be stacked and displayed the next time the
user connects.  The proper syntax for sending OLM messages is

        OLM <username>,<message>

By default, OLM message checking is off.  To enable OLM message
reception, you must invoke an OLM ON statement.  To disable OLM checking
(desireable for faster program execution) you may say OLM OFF in a
program.

ONERROR - sets a string which contains a routine to execute on error

        ONERROR FILE "ERRORHAN.PRO"
        ON ERROR "PRINT 'An error has occurred!':LOGOUT"
        ON ERROR LINE ERRORHANDLER

The first example loads a file which contains a subroutine to execute if
any error occurs.  The second line sets the error handler to a literal
string of code to execute.  The third lines sets the error handler to a
line in the current program.  Even if a new program is loaded the original
line (or subroutine) will be remembered because it was loaded into a
special error handling area by the ONERROR command.

If an error occurs (like DISK FULL or OUT OF MEMORY) then the subroutine
will execute, otherwise an error message will be displayed and the user
will have to choose between retrying or aborting the program.  In a live
situation you should set the command prompt to automatically log the user
out to prevent accidentally allowing users full access to your computer at
the command prompt.  The variable ERROR will contain the error code and
error message. If ERROR is used in an arithmetic statement then only the
error code number will be returned.  If it is printed to the screen or
otherwise used as a string it will contain the error code and the literal
error message.


ONLOGOUT - sets a string which contains a routine to execute on logout

        ONLOGOUT FILE "ONLOGOUT.PRO"
        ONLOGOUT "PRINT 'Goodbye!'":LOGOUT
        ONLOGOUT LINE LOGOUTUSER

This works just the same as ONERROR.  Use ONLOGOUT to specify code to execute
when the user logs out, whether on purpose, due to an error, or due to a
keyboard timeout.

RESET - logs out the current user and resets the system

This is similar to the LOGOUT command exept it will not run the ONLOGOUT
routine specified.

RESTART - same as reset

SEND - transmits an argument to a secondary port opened with CONNECT

You can open a serial port which is different from the one the user connected
through and send characters to it.  SEND "ATZ" CHR 13 will sent a reset
command to an alternate modem.  The purpose of a command such as this is
to allow you to write bridge routines.  A user can call your system and
then dial into another system _from_ your system.  You can also program
your system to dial into another system while the user waits, retrieve some
information, hang up, and then display it for the user.

TAG - writes a tag value to a tag file

        TAG filename,number

This appends a long integer number to a tag file, used for marking records
in a database or any other purpose.

TAGGED - returns the number of items in a tag file

        PRINT TAGGED "TAGFILE.TAG"

Will print the number of tagged entries in the file "TAGFILE.TAG"

TIMEOUT - sets the user timeout value in minutes

By default, a user can remain connected for 3600 minutes before the system
will force a logout.  You can set this timeout value to anything as low
as 1 minute.

TTY - disables ANSI terminal emulation

By default, ANSI emulation is enabled.  The TTY command will cause all
subsequent ANSI terminal control codes to be replaced with a space, carriage
return, or asterisk where appropriate.

TYPE - dumps a file to the screen, processing metastatements and functions

This is an extremely powerful and versatile command.  TYPE followed by a
filename will read and dump the contents of the file to the screen.  You
can use TYPE to display menus, help screens, bulletins or other bits of
text.

While the file is being TYPEd to the screen it is scanned for special
symbols, functions, variables, and metacommands.  See the next section for
a full description of these items.

WINDOW - displays a box on the screen containing a title

        WINDOW 5,10,5,70,"Welcome to the system!"

This command will display a box on the screen at the coordinates specified
with the title centered inside it.  The coordinates indicate the dimensions
of the inside of the box.

XMENU - displays a scroll-bar menu on the screen

        XMENU 10,30,20,50."Main Menu"

XMENU displays a box on the screen with the dimensions specified.  The title
is centered inside the first line of the box.  Previously listed ITEMs are
then displayed inside the box and the user is prompted to scroll through
the items.  When the user presses ENTER the menu is exited and XMENU returns
the value of the item selected.

        ITEM 1,"Files Area"
        ITEM 2,"Messages"
        ITEM 3,"LOGOUT"
        SET A TO XMENU 10,10,15,20;"Options"

The ITEM command sets a menu item for an upcoming MENU or XMENU command.
You must use XMENU as a function which returns a value from 0 to the number
of items specified.  The user may scroll up and down with a highlight bar
through the menu items, or enter a number (1-?) which corresponds to a menu
item.  When the user takes this action the menu is exited and returns the
number of the menu item selected.  The user may press X and the function
will return 0.

Also, at this point the user does not have access to an input prompt, so
the user is not able to type GO followed by a program to run.  Inside the
XMENU the user may press CTRL-G and a GO prompt will pop up on top of the
menu box.  The user may then type in the name of a program to run.

XMODEM - transfers a file using the XMODEM protocol

        XMODEM IN filename
        XMODEM OUT filename

This command transfers a file using an internal XMODEM protocol. You may
also shell to an external protocol like DSZ, KERMIT or JMODEM with the
DOOR command.



TEXT OUTPUT SYMBOLS
===================

        It may be desireable to embed variables and database field names
        in text that is being output to the screen with the TYPE command,
        or with PRINT FILE.  Any single word enclosed in greater than-less
        than brackets <> will be converted to a variable and the content
        of the variable will be displayed instead, sort of like a mail
        merge feature.   For instance, you can have a letter that contains
        fields from a database:


        ======================
        <NAME>
        <ADDRESS>
        <CITY>, <STATE>  <ZIP>

        Dear <SALUT>,

        Blah Blah Blah

        Sincerely, <USERNAME>
        ======================


        When you TYPE this file to the screen, the database fields and
        variable USERNAME will be inserted in the proper places.

        Any string output may contain symbols to represent ANSI color or
        control codes.  Symbols can also perform program commands or
        functions.  A good reason for this capability is to insert calculations
        or process data in text files which are being output to the screen.
        Any text output which contains an ansi symbol, function, memory
        variable or database field according to the following format will
        be processed accordingly.

        Variables may also contain the names of subroutines or functions to
        execute, like <DAY> or <JULIANDATE> if defined.

        Symbols    - ^x  where x is a color code.

        ^0 - all attributes off
        ^I - inverse text
        ^F - flashing
        ^B - bold text
        ^P - print on (televideo)
        ^p - print off (televideo)


        Foreground colors, text

        ^n - normal text (White)
        ^r - red
        ^g - green
        ^y - yellow
        ^b - blue
        ^m - magenta
        ^c - cyan
        ^w - white

        Background colors

        ^N - normal background (black)
        ^R - red
        ^G - green
        ^Y - yellow
        ^U - blue
        ^M - magenta
        ^C - cyan
        ^W - white

        For instance, PRINT "^B^F^r^WHELLO!" would print the word HELLO!
        in ^Bold, ^Flashing, ^red text on a ^White background.  You can
        place these codes into files that are displayed on the screen with
        the TYPE command.


        Functions  - @FUNCTION(arguments)

        Functions are also embedded within text that is output with PRINT
        commands or by TYPEing a file to the screen.  Functions can
        process data, perform size fixing, rounding, etc.  Remember, these
        functions are not a part of your regular program, but a "hot" function
        which is calculated at the exact moment it is output to the screen.
        Instead of the literal function, the result (or blank) will be
        printed instead.  All variables must be enclosed in <brackets> or
        they will be taken literally.

        @OR(x,y)
        @AND(x,y)
        @NOT(x)
        Return logical OR, AND or NOT of the arguments

        @LOOKUP(file,searchstring)
        Scans the file for a line which begins with the search string and
        then outputs the entire line on the screen.  Good for converting
        coded items to a verbose listing

        @CWAIT()
        Pauses and waits for a keypress

        @USING(formatstring,var)
        Formats a numeric or string variable for output

        @FIX(var,length)
        Fixes the length of a variable, lengthens or shortens it and outputs
        the fixed length value.  The variable is not changed.

        @LOGOUT()
        Immediately logs out the user

        @INPUT(prompt,var)
        Inputs a line of text to the specified variable.  Do not bracket the
        variable

        @FOUND()
        Returns true if last database search was successful

        @PARM()
        returns the current modem parameters

        @PORT()
        returns the current serial port number

        @CRC(x)
        returns a CRC of x

        @EXIST(filename)
        returns true if the file exists

        @INKEY()
        returns a waiting keypress or nul

        @LEN(string)
        returns the length of the argument

        @UPPER(string), @UCASE(string)
        returns the upper case of the argument

        @LOWER(string), @LCASE(string)
        returns the lower case of the argument

        @INSTR(string,string), @SUBSTR(string,string)
        returns the position of a string within a substring

        @LEFT(string,n)
        returns the left most n characters

        @RIGHT(string,n)
        returns the right most n characters

        @CHR(x)
        returns the char of ascii code x

        @ASC(string)
        returns the ascii value of a character

        @ENVIRON(envar)
        returns the contents of an environment variable

        @DUP(string,count)
        returns a duplicated string a specified number of times

        @RTRIM(string)
        returns a right trimmed string

        @LTRIM(string)
        returns a left trimmed string

        @CALC(expression)
        returns the results of an arithmetic calculation

        @GETFILE(filename)
        returns the entire contents of a file

        @VAL(var)
        returns the value of a variable

        @EOF()
        returns true if the current database record is the last one

        @COUNT()
        returns the number of records in a database

        @RECNUM(),@RECNO()
        returns the current record number

        @LOCATE(x,y)
        returns an ANSI code to position the cursor at x,y

        @SGR(code;code;code...)
        returns an ANSI code to set graphics rendition codes

        @CLS()
        returns an ANSI code to clear the screen

        @TIMEOUT()
        returns the number of minutes a user has left

        @GLOBAL(n)
        returns the value of a global variable

        @CUU()
        returns and ANSI code for CURSOR UP

        @CUD() - cursor down

        @CUF() - cursor forward

        @CUB() - cursor back

        @SCP() - save cursor position

        @RCP() - restore cursor position

        @EOL() - erase to end of line

        @TIME()
        returns the current time

        @DATE()
        returns the current date

        @GOD()
        returns the value of the GOD variable

        @RND(n), @RANDOM(n)
        returns a random number between 1 and n

        @BAUD()
        returns the current BAUD rate

        @DOS()
        returns the current drive and directory




ALL PROZOL KEYWORDS REFERENCE
=============================

ABS - function to return the absolute value of an argument

        PRINT ABS CALC -1

would print 1 on the screen

AND - logical operator returns true if X AND X are true

        IF A AND B:PRINT "Both are true"

ANSI - Activates ANSI terminal emulation

ANSI is active by default, but may be disabled with the TTY command.  ANSI
restores ANSI terminal emulation.  When the TTY command is executed, all
ANSI control codes are supressed or replaced with a simple carriage return
and MENU, XMENU, and WINDOW commands operate without ANSI screen drawing
facilities.

ANSWER - ANSWER COMn: waits for an incoming call on com port n

Running PROZOL with a com port parameter will automatically start up PROZOL
to wait for an incoming call, however the ANSWER COMn: command will do the
same thing from within a program.  If the modem is currently connected it
will be reset.

APPEND - user edits a blank record which is appended to the current database

Append will display the current database screen format and allow the user
to create a new record.

ASC,ASCII - function to return the ASCII code of a character argument

        PRINT ASC 65

Will print A on the screen

ASK - debugging command displays all variables currently in memory

ASK is used for debugging programs.  When you type in ASK at the command
prompt, all currently defined memory variables will be display.  ASK does
not display currenly database fields.

AUTOEDIT - Create variables appropriate for a mailing label and mail merge

(This is undefined at the time of this writing.  See the README file
for instructions on how to use AUTOEDIT in the current version.)

Basically, suppose you have several fields in your database that look like
this:

        SMITH JOHN X & MARY Q
        123 ANYWHERE ST
        SOMEWHERE ST 12345

You can use AUTOEDIT to create a set of new variables that look like this:

        John and Mary Smith
        123 Anywhere St.
        Somewhere, ST  12345

As well as

        Mr & Mrs. Smith
        John and Mary
        John
        Smith
        Mary
        Smith
        Mr & Mrs. John Smith

AUTOEDIT not only creates a proper address, it also creates several differnt
salutations based on pretty sophisticated name, gender, and name pattern
recognition algorithms.  At the time of this writing the AUTOEDIT feature
is not year complete.  You must refer to the README file for instructions
on how to use it.

BOTTOM,LAST - database command jumps to the end of the database

CALC,EVAL,WHAT,DOES - functions return arithmetic solution of parameters

Any arithmetic expression must be preceded by one of these keywords.  For
instance,

        PRINT 1+2+3

Will print 1+2+3 on the screen.  In order to print the result of 1+2+3
arithmetically, you must say

        PRINT CALC 1+2+3

Because of the parsing technique used, PROZOL does not assume that 1+2+3 is
meant to be evaluated.  The same goes for testing two numeric items.  For
example,

        PRINT A>B

Will print A>B.  You must use

        PRINT CALC A>B

or
        PRINT EVAL A>B

To display true or false (-1 or 0) or to use A>B in an expression.

or use WHAT or DOES.  All four keywords do the same thing.  You can use them
as you see fit for readability.

CALL - function executes a variable which contains an interpreted subroutine

CALL can be used to invoke a subroutine or function which is contained in
a variable.  You can also call the contents of a FILE or LINE with CALL FILE
or CALL LINE followed by the filename or line label.

CAPS - returns a string with all words capitalized

For example, if A was equal to "ERIK LEE OLSON" then the command

        PRINT CAPS A

Would print "Erik Lee Olson" on the screen.  CAPS is a function that will
take a string argument and return it with all words in lower case and the
first character of each work in upper case.  Use this in conjunction with
FLIP. FLIP will take the first word of a string argument and return the
string argument with the first word placed at the end.  FLIP and CAPS
are ideal for taking a capitalized name with the last name first and
flipping it around to be presentable on a mailing label.  See also the
entry for AUTOEDIT, which is an extremely powerful command.

CASE - beginning of a block CASE ... ELSE ... END CASE structure

CASE is used instead of IF..ELSE..ENDIF blocks outside of a subroutine.
CASE cannot be used inside a subroutine.

CD,CHDIR - command to change directory

CD or CHDIR must be followed by the directory name in quotes

CHAT - invokes a 6-way chat system

        CHAT "ERIK"

Will place the user into chat mode under the name "ERIK".  Up to 6 users
may chat at a time.

CHR - function to return the character value of an ASCII code

        PRINT CHR 65

will print "A" on the screen

CLEAR - clears all variables or erases the specified variable

Clear wipes all memory variables.  It has no effect on database fields.

CLOSE - close a file opened for sequential read/write

CLOSE closes a file opened with OPEN

CLS - clear the screen

CLS outputs a control code to clear the screen on ANSI, VT and Televideo
terminals

COL - function returns the current cursor column position

This applies only to users with ANSI terminal emulation.  COL is similar to
the BASIC POS function.

COLOR - set foreground and background colors

This applies only to users with ANSI terminal emulation.  COLOR outputs an
ANSI stream to set the user's screen color to a foreground and background
setting.

COMMON - set variables which are common to all nodes

        COMMON VAR,"Value"

This command sets the value of a common variable which can be seen by any
node on a network (or machine task).  As long as the variable has not already
been assigned as a local variable, PROZOL will scan a common variable file
for the value of any variable that is referenced in a program.

CONFERENCE - invokes a conference message system

        CONFERENCE conferencename

This will invoke a procedure which allows users to scan, view, edit or add
to a message conference specified by <conferencename>.  In order to use this
command you must have a directory on the current drive called \CONF which
is used to store pointers for each user that accesses a conference.  These
pointers must be maintained to allow users to re-enter conferences at "last
read" messages.

CONFIG - invokes the internal configuration routine

See the very beginning of this document for a very graphic description of
what will happen if you enter this command.

CONNECT - opens a serial port and connects for terminal mode

Used with SEND and DISCONNECT.  CONNECT activates an alternate serial port
for transmitting and receiving data through another modem while the user
is connected.

COUNT - database function returns the number of records in a database

        PRINT COUNT

Will print the number of records in a database opened with the USE command.

CR - function returns a carriage return string

        PRINT CR CR CR CR

Will print 4 carriage returns.

CREATEFORMAT - invokes a routine to create a screen edit format

        CREATEFORMAT filename

this command fires up an internal routine which you can use to move fields
around on the screen to create a screen format file.  A better alternative
is to use the FIELD command to create screen fields for input.

CREATEINDEX - creates in index on a specific database field

        CREATEINDEX field
        CREATEINDEX field,filename

This command will create a btree index based on the field specified.  If no
filename argument is given the the file will be the same name as the field
with a .BTX extention.

CWAIT - pauses and waits for a keystroke

This is very simple.  if you want to pause and wait for the user to hit
any key just say CWAIT.

DATE - function returns the current date

This function returns the current system date in MM-DD-YYYY format.

DBEND - database function returns true if the current record is the last one

DECR - decrements a numeric veriable argument

DEL - deletes a disk file

DEL will also remove a subdirectory if it is empty.  No error will be
generated if DEL is not successful.

DELAY - delays program execution for specified number of seconds

        DELAY 4

Will delay for 4 seconds.  Any keys entered during a delay will be queued.

DELIMITED - database function returns comma delimited form of the database

This is a neat function.  DELIMITED returns a large string containing the
entire current database record in a comma delimited ASCII form.

DISCONNECT - disconnects secondary serial port

If a secondary port had been opened with CONNECT, DISCONNECT will close it.

DOOR - shells to a door program

The difference between door and shell is that DOOR closes the current com
port and leaves DTR high while shelling to another program.  When the shell
is completed the port will be reopened and normal user interaction will
resume.  You can create a DOORINFO.SYS or other file with OPEN and WRITE
prior to executing a DOOR command.

ECHO - sets character echo on or off

The obvious use for this command is during input of a password:

        PROMPT "Enter password:":ECHO OFF:INPUT pw:ECHO ON

However another good use for this is to supress the output of a "not found"
message during a database search when the success or failure of the search
does not need to be known, specifically when searching for a match in a
login database.  If you ask the user to enter a login name, then search the
database for a record which contains the login name, you may not want the
message "not found" to dislay on the screen.

EDIT - edits the current database record

Using the current screen format, or an input format specified with FIELD
statements, EDIT will allow the user to edit the current database record

EDITCOMMENT - edits an e-mail comment

This command will invoke a 9 line editor which allows the user to create a
commant.  The syntax for this command must supply a comment ID.  For example,

        EDITCOMMENT "ERIK"

Will then allow the user to edit a 9 line comment that is labeled "ERIK".
A subsequent GETCOMMENT "ERIK" will retrieve all comments edited under this
ID.  This command can be used to personal messages or for attaching
text comments to a specific database record.

ELSE - use in block CASE..ELSE..END CASE structures

ELSE can occur in the main program as a logical control keyword for CASE
structures, or on a single line for IF..ENDIF structures.  Inside a
subroutine or function ELSE can be used on a line by itself in IF..ELSE..
ENDIF structures.

END - ends the current program and returns to a command prompt

The current program will end and display the PROZOL command prompt.  If the
command prompt is set to logout the user then the user will be logged out
at this point.

ENDTYPE - ends a file which is being typed to the screen

This command can only be seen as a metacommand from within a file that
is being TYPEd to the screen.

        $ENDTYPE

Will stop the file from being TYPEd to the screen.

EQUALS,SAME - function returns true if two strings are the same

This statement will return true if two string arguments are the same.  Use
this function if IF, CASE, WHILE or UNTIL statements to test the equality of
two string arguments.

        PRINT "They match!" IF SAME A,B

EXECUTE - runs a new EXE program

This command completely terminates PROZOL and executes another DOS program.
This is not a SHELL.

EXIST - function returns true if filename argument exists

This is a function which returns true if a filename argument exists

EXIT - exits a CALL subroutine

EXIT will immediately abort a subroutine and resume program execution to
the statement immediately following a CALL command or an implied call.  EXIT
will also abort a line.  You may follow EXIT with parameters to be returned
to the calling expression.

FALSE, OFF, NO - returns 0

FIELD

FIELD by itself clears all defined screen data entry fields.  FIELD followed
by parameters defines a screen data entry field.

        FIELD n, "var", length, row, column, [foreground,background]

n is the number of the data entry field on the screen in the order it will
be accepted.  "var" contains the name of the memory variable or database
field that the entered data will display and be edited to.  Length is the
length of the input field on the screen.  Row and column are the position
to place the field on the screen.  The default color for fields is black
on white, or inverse.  You may specify an optional color scheme for an
input field.  Defined input fields are not displayed until an INPUT FIELDS
command is issued.  At that point, all defined fields are displayed on the
screen and the user is prompted to fill in the values of all of the fields.


FIELDS

This keyword is used as an argument to INPUT.  INPUT requires an optional
prompt and a variable to accept the input at the current cursor position.
INPUT FIELDS displays all defined fields (defined with the FIELD statement)
on the screen and waits for the user to provide input for all of them.

FILE - function returns the entire contents of specified file

FILE is a function which returns the content of an entire file.  For example

        PRINT FILE "\AUTOEXEC.BAT"

Would print your AUTOEXEC.BAT file on the screen.

        SET A TO FILE "TEST"

Would load the contents of a file called "TEST" into the variable A

        CALL FILE "SUB.PRO"

Would load an execute the contents of the file "SUB.PRO"

FILES - prints the current directory or specified path or wildcards

FILES will display all files in the current directory on the screen in four
columns.  You may supply a path or wildcard specification.

        FILES "*.PRO"

Will print all program files in the current directory on the screen.

FIND - searches for a matching record in the database

FIND will search the current index for a matching record.  If no index
has been set (with the INDEX command) then the entire database will be
scanned for a matching string from beginning to end.

FORMAT - sets the current screen format for database editing and viewing

        FORMAT filename

This can be used instead of FIELD to set a screen input format.  The
data entry fields must have been defined with the CREATEFORMAT command.

FLIP - move the first word in a string argument to the end

        SET X TO FLIP Z

If Z contained the string "OLSON ERIK L" then FLIP would return the string
"ERIK L OLSON".  Flip takes the first word of a string argument and places
it at the end.

FREEFILE - returns the next free file buffer number

This works just like the BASIC FREEFILE command, which returns a free file
handle number for use with the OPEN statement.

GET - gets a specific record in a database

        GET 1

Will load the first record in a database

GETCOMMENT - checks for e-mail and displays if exists

This command will run an internal routine that displays all comment records
filed under a certain name.  For example,

        GETCOMMENT "ERIK"

will display a stack of all messages posted under the name "ERIK" with the
EDITCOMMENT command.  If no messages exist for the specified ID then this
command will display "no mail for ERIK" on the screen.

GETTAG - gets a tag number from a tag file

For use with the TAG command.  TAGGED returns the number of records that have
been tagged in a database.

        GETTAG filename,number

uwill return the contents of a tag figure.  For example, if you have used
TAG to tag 100 records in a database, then

        GETTAG "tagfile",50

will return the 50th tagged record in the file "tagfile".

GLOBAL - sets a global variable or returns the value of one

GLOBAL variables are not really global.  The keyword is a throwback to old
PROZOL.  There are 32 GLOBAL variables which can be defined, GLOBAL 1 through
GLOBAL 32.  This is just an array for storing values that are not erased
with the CLEAR command.  Only three GLOBAL variables have been defined.  You
may use the rest of them for your own purposes.

GLOBAL 1 must contain the name of the current user.  This should be 8 letters
or less with no spaces or punctuation, a valid filename with no extention.

GLOBAL 3 contains the name of the currenltly running program

GLOBAL 4 contains the value of the screen color codes specified with the
MENUCOLOR command.

GO - executes an interpreted program without quotes around the program name

GO works just like RUN, except the name of the program to run is not
enclosed in quotes.  GO is unique because any input line that begine with
the word GO followed by a space will be executed as a literal command.

GOD - sets the value of the GOD variable

If you say GOD 1 or GOD TRUE then the user will be able to execute any
PROZOL command at any input prompt by simply preceding the input line with
a slash character "/".  This would allow a system operator full access to
the PROZOL command line by simply typing /END at any command prompt.

GOSUB - jumps to a label subroutine in a program which ends with RETURN

        GOSUB label

Execution will jump the the labelled line specified an execution will
resume at the line following the GOSUB line when the command RETURN is
encountered.

GOTO - jumps to a label in a program

        GOTO label

Will jump to any line in the program which begins with the literal text
of the specified label

HOME - clears the screen and resets the current color to low white on black

This is essentially the same as CLS except that it resets the current color
scheme (in ANSI) to normal (white on black).

IF - conditionally executes the remainder of a program line

        IF condition : statements... [: ELSE : statements ... : ENDIF : ...

        or

        procedure {
                        statements
                        IF condition
                                statements
                        ELSE
                                statements
                        ENDIF
                        statements } [return value]

IF followed by any condition will continue to execute statements on the
same line if the condition is true.  A condition can be a single value
expression like LEN or VAL, or can be an arithmetic expression like
EVAL A>B or CALC A=0 (EVAL and CALC do the same thing) or it can be a
string equality test, such as IF SAME string,string or IF NOT SAME string,
string.  The IF expression must be followed by a colon.  There is no
THEN keyword in PROZOL.

A multi-line IF..ELSE..ENDIF statement may occur within a subroutine or
function procedure.  IF statements can be nested, but ELSE and ENDIF cannot.
In other words, a nested IF expression can only be written like this:

        IF condition
                statements
                IF condition
                        statements
                                IF condition
                                        statements
                                ELSE
                                        statements
                                ENDIF

The same rule applies to single line IF..ELSE..ENDIF statements.  Another
important thing to not is that while ENDCASE and END CASE mean the same
thing, ENDIF must be a single word.  END IF is actually two keywords,
END and IF.

INCR - increments a numeric variable argument

INDEX - sets the current database index

        INDEX fieldname [,filename]

The index must have been created with CREATEINDEX.  INDEX sets a Btree index
which relates to the current database.  A database must be open in order to
set an index.  The index is automatically updated if records are changed or
new records are added.  If the filename is omitted then it will be assumed
to be the same as the fieldname with a .BTX extension.

To search an index, use the FIND string command.  Once a position in the
index has been set with FIND, then NEXT, PREV (or PREVIOUS), SKIP n, TOP and
BOTTOM (or FIRST and LAST) will move around within the index and load
records into memory.

INDEX with no parameters disables the current index and causes FIND, NEXT,
SKIP and other commands to work with the database in literal order.

INDEXFIELD - returns the currently indexed field

If the index has been set then INDEXFIELD will return the name of the field
currently indexed.

INDEXFILE - returns the name of the current index file

This function will return the actual file name of the index file.

INKEY - returns the next single incoming character

This works just like the BASIC INKEY$ function.  It returns a single character
waiting in the keyboard or communications buffer, or null if no characters
are waiting.

INPUT - prompts the user for input and waits for a line to be entered

        INPUT [prompt] inputvar

INPUT works just like the BASIC INPUT command.  An optional prompt can be
specified and PROZOL will wait for a full line of input terminated with
a carriage return.  The input text will be placed in the specified variable.
During input the user my type GO followed by a program name to run in the
current directory or in a directory called \PRO.  The user may also press
CTRL-C to logout, CTRL-D to toggle between ANSI emulation and TTY, CTRL-P
to print the screen on a televideo terminal, CTRL-L to output a form fee
character, or a slash (/) followed by any PROZOL command if the GOD variable
has been set to TRUE.

INSIDE - Return whether any arguments occur withing a string

        IF INSIDE Target, Source1, Source2, Source3, ...

For example, if you wanted to know if the variable X contained any one of
several strings, you could use INSIDE to return true or false if any one
of several strings occurred withing x.  For example, if you had a variable
called NAME which contained a person's name, and you wanted to know if the
name contained "SKI". "O'", "MC". "LE" or "LA", then you could use this
sort of expression:

        IF INSIDE NAME, "SKI","O'","MC","LE",LA":then do something....

INSTR - function to return the position of a substring within a string

        INSTR mainstring,searchstring

Returns 0 if the search string does not occur within the main string.  If it
does occur then the position of the search string within the main string will
be returned.

INT - calls an interrupt

        INT interrupt

ISOPEN - returns true if a database file is currently open

If a database is in USE then ISOPEN will return the file handle number of
the database, otherwise it will return 0

ITEM - sets a menu item for a subsequent MENU or XMENU call

Prior to issuing a MENU or XMENU command, ITEM sets the contents of a menu
item, as in

        ITEM 1,"Main Menu"

Will set the first item of a subsequent menu to "Main Menu"

LCASE,LOWER - function returns the lower case of an argument

        PRINT LCASE variable

LEFT - function returns the left most n characters of an argument

        PRINT LEFT variable,count

LEN - function returns the length of an argument

        PRINT LEN variable
        IF EVAL LEN variable=0 ...

LET, SET - sets the value of a variable

        SET A TO 1
        LET NAME BE "Erik"

LIST - displays all or part of the program currently in memory

        LIST
        LIST 10
        LIST 10 TO 100

LOAD - loads a program from disk into memory

        LOAD filename

LOCATE - positions the cursor at the specified coordinates

        LOCATE Row, Column

LOCK - locks a username to prevent duplicate logins

        LOCK "Erik"

LOGOUT - logout a user and reset the system, hanging up if necessary

        LOGOUT

LTRIM - function returns argument trimmed of spaces from the left

        PRINT LTRIM variable

MD,MKDIR - creates a subdirectory

        MD "\NEW"

MENU - displays a square box on the screen containing a menu

        MENU top,left,bottom,right,title

MENU displays a menu of items specified with the ITEM command.  This routine
then prints a "Select -->" prompt below the menu and waits for input.  What-
ever was input by the user is returned.  MENU is a function, so it must
be used in an expression or variable assignment, as in

        SET A TO MENU 10,20,15,40,"Main Menu"

MENUCOLOR - sets the default color of menus

Before making an XMENU call, a MENUCOLOR must be specified.  MENUCOLOR must
be set to a symbolic color code, such as "^W^b" for a white background and
black foreground.


MID,SUBSTR - returns a substring withing a string

        SET DAY TO MID DATE,4,2

This function works just like the BASIC MID$ function except that parenthesis
are not used.

MORE - sets the number of lines for scrolling text files

When TYPE commands are used to display files to the screen, the MORE setting
will pause the display every few lines.  For instance, if you want the file
to pause every 23 lines, then you could specify

        MORE 23

and all subsequent TYPE commands will pause the file listing every 23 lines.

        MORE 0

will turn off pausing.

NEG,MINUS - negates an argument, use instead of -

Since the minus sign is treated like an individual keyword in PROZOL, you can
only negate a literal value with NEG or MINUS.  In other words,

        SET A TO -1

Will set A to "-" and throw away the 1, since it is considered to be a
second parameter.  In order to set a variable to a negative number you must
say

        SET A TO NEG 1

NEXT - gets the next record in a database

If an index has been set with the INDEX command then NEXT will skip to the
next record in the index and load it.  If no index has been set then NEX
will skip to the next physical record in the database.

NOT - returns a logical NOT of an argument

        IF NOT A:PRINT "A is false!"

NUMFIELDS - function returns the number of fields in the database

OFF - returns 0

This can be used in place of 0 wherever desired.  For instance, to set the
GOD variable to 0 you could just say GOD OFF.

OFIND - returns a matching record number from an IX file

OFIND is a function which returns the record number of a random access index
file.  You must specify the file name, the data to find in the index, and the
field length of each record in the random access index.  For example,

        SET R TO OFIND "BIGINDEX", "OLSON, ERIK", 24

Will search a random access file named "BIGINDEX" for the first entry that
matches "OLSON, ERIK".  Each record in this random access file is 20 characters
long plus 4 bytes for a long integer pointer which is returned by the function.
The file is searched using a binary halving message so it must be alphabetized.
The pointer location of the record is retained for subsequent OSKIP functions.
These index files can be created with dBASE or BASIC or other languages
which are capable of creating alphabetized random access files.  These indexes
cannot be updated without being completely rebuilt, but they have the
advantage of being extremely fast and can be as large as any disk capacity.
No matter how large these indexes get, the search and skip performance
within them will be nearly instantaneous.  They do have the major drawback
of being read-only and cannot be updated on the fly.  They are very
good for large read-only databases that are not frequently updated, such
as multi-million record phone lists or property records.

OLM - sets OLM scanning on or off or sends an OLM message to another user

        OLM user,message

If the user is currently on line the message will appear on the target user's
screen as soon as he has been sitting idle for 10 seconds.  If the user is
not online then the message will appear as soon as the user logs in and is
idle for 10 seconds.

        OLM ON|OFF

By default OLM checking is OFF since it slightly slows down performance for
the current user.  If OLM checking is turned on then any OLM messages sent
or any messages waiting will be displayed as soon as the user has been
idle for 10 seconds.

ON - returns -1

ON can be used wherever -1 (or TRUE) would be used.  For instance, many
toggles are turned on or off with ON and OFF.  ON and OFF are simply
synonyms for TRUE and FALSE, which are the same as -1 and 0.

ONERROR - sets a string which contains a routine to execute on error

When a non-critical error occurs (such as Out of Memory or Com Buffer
Overflow) then a user defined subprogram can be executed.  The argument
to ONERROR must contain the entire subprogram to execute.  It can be
in the form of a disk file:

        ONERROR FILE filename

or in the form of a variable

        ONERROR variable

or a literal string

        ONERROR "print 'error!':logout"

or a subroutine in your program:

        ONERROR LINE ERRORHANDLER

ONLOGOUT - sets a string which contains a routine to execute on logout

ONLOGOUT works very much the same as ONERROR, except it specifies a subroutine
to execute whenever the user logs out for any reason (including CTRL-C)
except for when a critical error occurs, such as a communications buffer
overflow or out of memory error.

OPEN - opens a sequential file for input or output

        OPEN "I" filename
        OPEN "O" filename
        OPEN "A" filename
        OPEN "R" filename
        OPEN "B" filename

Files can be opened for Input, Output, or Append.  You can also open non
sequential files for Random access or Binary access.  Files opened in this
manner must be closed with CLOSE followed by the mode character in quotes.

Files opened for input can be read one (comma delimited ascii) field at a
time with the READ command.  Files opened for output or append can be
written to with the WRITE command.  WRITE will not automatically delimit
output.  You must do that yourself, and add carrige returns with CR.

Files opened for Random access can be read as database records with the
MAP command or with the most recent TYPE structure definition.  The GET
command followed by the name of a TYPE structure or MAP variable will
load the fields specified.  The PUT command followed by a TYPE structure
or MAP variable and a record number will write to the file.

Files opened as Binary files can be read with the GET function, in which
you must specify the starting byte and the number of bytes to read from
the file.  To write to a file you must use the PUT function followed by
a starting byte value and a string to write to the file.  Both GET and
PUT for binary files use a base of 1 for the first byte in the file.

OR - returns the logical OR of two items

        IF A or B:PRINT "one of the is true!"

OSKIP - returns skipped n number of records in an IX file

        OSKIP n
        OSKIP NEG n
        OSKIP MINUS n

OSKIP is a function which returns the record number of an index originally
searched with the OFIND function.  See OFIND for more information on what
O indexes are and how to create them.

PREV,PREVIOUS - skips to the previous record in a database

If an index is defined then this command will skip backwards one record in
the index and load the record into memory.  If an index has not been defined
then this function will skip backward one physical record in the database.

PRINT - prints all arguments to the screen with a carriage return

PRINT followed by any number of parameters will print all parameters to the
screen.

        PRINT "You selected " X " as your response"

PRINT will always follow output with a carriage return.  To print without a
carriage return use the PROMPT command.

PROMPT - prints all arguments to the screen

PROMPT is the same as the PRINT command except it is not followed by a
carriage return.

PUT - writes a record to a database file

PUT followed by a record number will write the current field variables to
the database. PUT with 0 or no record number will append the fields to
the database file.  PUT followed by two arguments will write data to a
random access or binary file.  The first argument is the record number
or byte position, the second argument if the data to write to the file.
You cannot have a random access and a binary file open at the same time.

PUTFILE - appends an argument to the specified disk file

        PUTFILE filename,data

The filename will be opened for append and the data will be written to the
end of the file.  You must specify a CR at the end of the data if you wish
to append a carriage return to the end of the data you are writing to the
file, as in

        PUTFILE filename,data & CR

QUIT - exits the interpreter to DOS

QUIT should only be use locally unless you want the PROZOL interpreter to
exit to DOS without any logging out of the user.  QUIT immediately
terminates the interpreter.  If a communications line is active it will
be hung up and reset first.  To run another program without resetting the
modem use the EXECUTE command.

RD - erases a subdirectory from the hard drive

RAW - outputs unprocessed text which may contain symbols and functions.

If you said PRINT "@CHR(65)" then PROZOL would print A on the user's screen.
If you wanted to literally print @CHR(65) or any other control code then
use the RAW command instead of PRINT.  This is useful for displaying lines
of a help screen which may contain references to symbols, functions, or
variables that would otherwise be processed before output.

READ - reads a line or item from a sequential file

        READ var

This would read the next item from a comma delimited ascii file opened with
OPEN "I".  To read an entire line ignoring delimiters, use READ in this
manner

        READ ALL var

RECNUM,RECNO - function returns the current database record number

Both functions can be used interchangeable to return the current database
record number.  If no record number has been loaded or if the result of
a previous FIND was not successful then this function will return 0.

REG - sets a register for an interrupt call

This is used in conjuntion with the INT command.  Prior to calling an
interupt you may want to set the values of certain CPU registers.

        REG n,val

sets the value of a register.  You may use hex notation with &H or binary
notation with &H in front of the number.  For instance,.

        REG 1,&HFF

will set the hex value of FF to the AX register.  register numbers
correspond to this table:

        1 - AX
        2 - BX
        3 - CX
        4 - DX
        5 - DS
        6 - ES
        7 - SS
        8 - SI
        9 - DI

REN,RENAME - renames a disk file or directory

        REN source,target

RESET - logs out the current user and resets the system

RESET is the same as LOGOUT except it will bypass the ONLOGOUT subroutine
if one has been set.

RESTART - same as reset

RETURN - returns to caller from a GOSUB routine

GOSUB label will jump to any line beginning with the specified label.
The program will continue to execute line by line until RETURN is issued,
at which point execution of the program will begin at the line immediately
following the line containing the most recent GOSUB.  GOSUBs can be nested
to 32 levels.

RIGHT - function returns the right most n characters from a string

        PRINT RIGHT variable,count

ROW - function returns the current cursor row

        SET X TO ROW

This function is the same as the BASIC CSRLIN function only it applies to
both ANSI and TTY output.

RTRIM - function returns a string argument with spaces trimmed from right

        PRINT RTRIM variable

RUN - runs a specified interpreted program

        RUN "program"

An extension of .PRO is assumed if not specified.  RUN loads an executes an
PROZOL program.

SAVE - saves the current program in memory do disk

After a program has been entered using line numbers at the PROZOL command
line it can be saved to disk with the SAVE command.  An extension of .PRO
is assumed if not provided in the filename.

SEND - transmits an argument to a secondary port opened with CONNECT

If a secondary serial port has been opened with the CONNECT command then
characters can be sent to it with the SEND command.  A string parameter to
SEND will be transmitted through an alternate serial port.  CONNECT and
SEND can be used to allow users to dial into your system and then dial
through your system into another system.

SETPROMPT - sets the immediate mode prompt

SETPROMPT followed by a string parameter will set the prompt which is
displatyed on the screen while you are in command mode.  Command mode is
also referred to as "immediate" mode.  The default prompt is set up during
the CONFIG process.  To set the prompt to a DOS prompt, you might say

        SETPROMPT "@CHR(13)@CHR(10)@DOS()>"

For security reasons you will probably want to set the prompt up to auto-
matically log out the user should it ever display.  You probably DO NOT
want users to have access to a command prompt, so should they ever find
their way to one, you could make the prompt automatically kick them out with
this setting:

        SETPROMPT "@LOGOUT()"

SKIP - skips the specified number of records in a database

If an index has been set then SKIP n will skip n number of records in the
current index and load the ultimate record into memory.  If no index has
been set then SKIP will skip the specified number of records physically in
the database.  Remember that negative constants are not possible in PROZOL
so you must use the NEG or MINUS keywords to indicate a negative number
constant with SKIP, such as

        SKIP NEG 1

If a variable contains a negative number then you do not have to use the
NEG or MUNUS keywords.

TAB - returns a tab character

        PRINT A TAB B TAB C

Will print A, B and C separated by tabs (ascii code 9)

TAG - writes a tag value to a tag file

        TAG filename,value

This appends a long integer value to the file specified.  This command
is used to mark records in a database for a specific user or any other
function you can use it for.  You can return the number of records that
have been added to the tag file with the TAGGED function.  You can return
the long integer value of a specific tagged record with the GETTAG function.

TAGGED - returns the number of items in a tag file

TIME - returns the current time

TIMEOUT - sets the user timeout value in minutes

By default a user has 3600 minutes per login session.  You can set this
limit to anything from 0 minutes on up.  0 minutes is a good way of locking
out users who have not paid their bills without removing their passwords
from the database.  It really gets their attention because they are kicked
out as soon as they are done logging in!

TO, IN, WITH, IS, BE, EQUAL, OF, THE, AT, AS, ?, THEN  - dummy key words

You can use any of these keywords wherever you may deem appropriate to make
your source code more readable.  Here are some examples of where you might
use these "do nothing" keywords:

        SET A TO 1
        BE UNTIL LEN INKEY
        IF EVAL A IS EQUAL TO B
        PRINT X IN COLOR F,B AT LOCATE X,Y
        IF CALC A=B THEN
        IS A IS THE SAME AS B
        SET X TO ?


TOP,FIRST - jumps to the first record in a database

If an index has been set then these commands will jump to the first record
in the database index and load it otherwise they will go to the first
physical record in the database (literal record 1) and load it.

TROFF - disables line tracing

By default TROFF is off.  Use TRON for debgging to print each command to
the screen in curly braces as it is being executed.

TRON - enables line tracing

Use TRON for debugging.  Unlike BASIC, TRON will not print line numbers to
the screen, it will print each literal command, function, or variable as it
is being evalueated by the interpreter.  This is very handly for seeing where
the program may seem to be going astray.

TRUE, ON, YES - returns -1

Use TRUE, ON, or YES in place of a logical -1 (true) wherever desired.

TTY - disables ANSI terminal emulation

By default, ANSI emulation is enabled.  TTY will cause all subseuent COLOR,
LOCATE, CLS and other control codes to be supressed.  Some functions, like
LOCATE and CLS will be replaced with a simple carriage return.  Also MENU,
XMENU, and WINDOW functions will operate in a teletypewriter format instead
of animated ANSI displays.

TYPE - dumps a file to the screen, processing metastatements and functions

        TYPE filename

This command will type a file to the screen.  Any embedded variables,
ANSI color symbols. functions, or metacommands will be evalueated.  See the
section previous to this keyword list for more information on these special
codes that you can embed in files that are being TYPEd to the screen.
TYPE is ideal for displaying menus, help screens, database record screens,
messages, and anything else.


UCASE,UPPER - function returns the upper case of a string

        PRINT UCASE variable

UNLOCK - releases the current user from multiple login protection

        UNLOCK "Erik"

UNTIL - control command iterates current line until argument is true

        PRINT "Press a key!" UNTIL LEN INKEY

UNTIL will continue to iterate the current function or line until the condition
which follows UNTIL is satisfied.  You can apply UNTIL to a block of code
or subroutine with curly braces using the following format:

        PROCEDURE {
                        statements
                        statements
                        statements } UNTIL condition

USE - opens a database for use

        USE filename

The specified filename is loaded as a dBASE compatable database and prepared
for use.  An extension of .DBF is assumed if not otherwise specified.

VAL - function returns the numeric value of an argument

        PRINT VAL A

VIEW - displays the current record of a database on the screen

If a record format file has been specified or if FIELD statements have
been used to specify a record format for the scren then the specified format
will be used to display the current record, otherwise a default display
format will be used.

WHILE - control command iterates current line while argument is true

WHILE is just like UNTIL, except it will iterate a line or block statement
for as long as the supplied condition is true.  For example, on a single
line you could say

        do something UNTIL condition

or in a subroutine you could write

        procedure {
                        statements
                        statements
                        } UNTIL condition

and the procedure will iterate continuously until the supplied condition
evalueates to true.


WINDOW - displays a box on the screen containing a title

A box will appear on the screen surrounding the specified coordinates
and the supplied title will be contained within the box.  For example,

        WINDOW 5,10,5,70,"This is a Box!"

Will display a window from the 4th line to the 6th line of the screen from
the 10th column to the 70th column and the title "This is a Box!" will be
centered within the box.

WRITE - prints argument to a sequential file

        WRITE string [& CR]

Writes a raw string of output to a sequential file opened with the OPEN
statement.  Any string written to an output file is written literally with
out a carriage return or delimiter unless specified with & CR (which adds
a carriage return to output).


XMENU - displays a scroll-bar menu on the screen

        SET variable to XMENU top, left, bottom, right, Titlestring

XMENU displays an animated ANSI menu using the items itemized with then
ITEM statement. XMENU is a function which returns the menu item specified
or 0 if the user chose to abort the menu with "X".  While the menu is
being displayed the user may press CTRL-G which will pop up a box within
which the user may specify a GO command to run another program. If ANSI
emulation is not active then a standard INPUT prompt is displayed
instead of the animated menu.  During execution of the animated menu the
user may use the arrow keys to select a menu item if they are using
Procomm, Telix, or Qmodem, otherwise they must use SPACE or the + and - keys
to select menu items, or they may enter a number from 1 to the maximum menu
item number to select a menu option.

XMODEM - transfers a file using the XMODEM protocol

        XMODEM IN filename
        XMODEM OUT filename

This command will initiate an internal XMODEM file transfer routine.  For
other file tansfer protocols, use SHELL or DOOR to run external public
domain, shareware, or commercial file transfer protocol programs.  Xmodem,
Ymodem, and Zmodem are provided with the DSZ program and KERMIT is provided
with the KERMIT program included with PROZOL.

LIMITS TO PROZOL
================

Currently, dBASE databases can be indexed to up to 65,535 records.  This will
be increased in the very near future to 2 trillion records.  Right now up
to 2 trillion records can be indexed using the external indexes accessed
with OFIND, OSKIP, ONEXt and OPREV.  These indexes can be created with
any external database application.  See the entry for OFIND for more
information on these "superfast" indexes.

All numeric variables are considered to be single-precision floating point
variables which have a resolution of up to 8 deciman places.

Any string variable, subroutine, or FILE parameter can be up to 32K lin
length.

Programs are limited to 1000 lines each.  You may have 1000 variables
defined in memory at any given time.  All variables must reside within
640K along with Prozol.  Each program must be 64K or less in size.

COM ports must be standard UART serial ports (non-intelligent) and modems
must be Hayes-compatible.  COM ports can be any IRQ and and port address.
There is no limit to the number of COM ports that can be used under a
multi-tasking platform or on a network.

Only 6 users may chat simultaneously.

PROZOL requires at least 256K of memory and will run on any IBM compatible
PC, or a PC running windows, OS/2 or Desqview.  Prozol requires DOS verison
3.3 or higher, and requires at least 360K of disk space.

Each line may contain up to 256 separate statements.

* * *

This entire document was written while getting extremely hammered at the
Promenades lounge on US 41 in Port Charlotte, Florida, December 7, 1993.
It is dedicated to Anheuser-Busch and the very cute girl who kept me
supplied with Michelob Lights while I was writing this on my incredibly
cheap Tandy 1100 laptop, which I bought for just this purpose.  It is also
dedicated to Mr. Augie Busch (of Anheuser-Busch and Busch Gardens, Tampa)
who I spilled the very cold ice water on at the Wine Cellar restaurant
in 1986.  He was very mature about that.  I was not a waiter, I was the
computer guy, conscripted by the owner of the restaurant to fill in for
someone who had better things to do than come to work.  Instead of cash
I made sure he gave me two bottles of Lafon Rochet '82 which my brother
and I pounded down in the car on the way home from work that night.  It
doesn't get any better than that.

