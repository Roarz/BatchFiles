::============================================================================
::	Welcome to Rorie McPherson's awesome batch file that works heaps of magic.
::	It was created on 27/05/2013
::============================================================================

:: This will stop the window/menu from being flooded with messages the user doesn't need or want to see.
echo OFF

:: Cool matrixy color :D
color 0a
:menu
::if we have done a previous command, (i.e random number generator) the screen will be cleared to give a 'refreshed' appearance when we return to the menu. 
cls

::Normally the date command will ask the user to enter a new date. This method will print the current date and time in the command line window without asking the user to enter a new time/date.
:: Shows the user who made the batch file (me) and the current date and time.
echo Today's date: %date% 
echo Current time: %time%
::"echo." Prints a new line for increased readability
echo.
echo =============Rorie's sexy menu====================
echo.
echo  Enter the corresponding number to execute a command.
echo.
echo  1.  Backup files now.
echo  2.  Defragment C drive.
echo  3.  Check C drive for errors.
echo  4.  View document heirachy tree of C drive by page.
echo  5.  Generate a random number between 1-100.
echo  6.  Restart the computer.
echo  7.  Shut down the computer.
echo  (R) Read a .txt file in cmd!
echo.
echo ==========PRESS 'Q' TO QUIT MENU==================
echo.

::/p is used to set a variable from the user (prompt).
set /P input=Please select a number: 

::/I is used for comparing string. i.e. if the users input text/string matches.
if /I '%input%'=='1' goto Backup
if /I '%input%'=='2' goto Defrag
if /I '%input%'=='3' goto Check-error
if /I '%input%'=='4' goto Tree
if /I '%input%'=='5' goto RandomNumber
if /I '%input%'=='6' goto Restart
if /I '%input%'=='7' goto Shutdown
if /I '%input%'=='Q' goto Quit
if /I '%input%'=='R' goto Read

::clears the screen so that if the input is invalid, it will only show the message that it is invalid. If we do not have a clear screen here, the user will also see the menu and may not see the invalid input screen.
cls

::if the user forgets to input something (or the input is wrong..) it will print a message letting them know this and return them to the menu to try again. It will do this because none of the 'if' statements above will be true, so it will continue to flow through the batch file.
echo ============INVALID INPUT============
echo.
echo Please select a number from the Main
echo Menu [1-7] or select 'Q' to quit.
echo.
echo =====================================
echo.

::we need to pause here so we know the user has enough time to read the message.
pause

:: returns to the menu to allow the user to try another input
goto menu

:Backup
	cls
	echo Are you sure you would like to make a copy of your 'Bit-folder' onto your flash drive?
	set /P input=y/n (yes/no): 
	::Allow for both "y","yes" and "n","no" user input. Anything else will print an error.
	if /I '%input%'=='y' goto letsDoThis
	if /I '%input%'=='yes' goto letsDoThis
	if /I '%input%'=='n' goto backToMenu
	if /I '%input%'=='no' goto backToMenu
	
	cls
	echo ============INVALID INPUT============
	echo.
	echo Please enter either yes/no or y/n.
	echo.
	echo =====================================
	echo.
	pause
	goto Backup
	
	:backToMenu
		goto menu
	:letsDoThis
		echo.
		echo Enter what time you would like the backup to take place. Please use the 24 hour time format (i.e. 10:30pm = 22:30)
		echo.
		set /P input=time:
		cls
		::Creates a new task in windows task scheduler, (SC) schedules it to be run only once, (TN) what it will be called in the task schedular, (TR) The target of the thing that will be executed(my external batch file for backing up). (ST) This will be what time the task will run (the users input).
		SCHTASKS /Create /SC ONCE /TN backup /TR "C:\Users\%username%\Desktop\backup.bat" /ST %input%
		echo.
		::confirm to the user when the backup will take place.
		echo A backup will take place at: %input%
		pause
		goto menu
		
::Defrag and error checking will only work if the Command Prompt is ran as administrator. This is intended.
:Defrag
	defrag c:
	pause
	goto menu

:: It wont actually fix any errors it finds because i havent told it to (/f = fix).
:Check-error
	chkdsk c:
	pause
	goto menu

:Tree
	cls
	echo The C drive will be processed
	pause
	::more command puts the user in control of progression.
	tree c:\ | more
	pause
	goto menu 

:RandomNumber
	::This will set a variable called 'rand'. It will be a random number between 1-100 (inclusive).
	set /a "rand=%random% %% 100 + 1"
	::echos the rand variable we created
	echo Your random number is: %rand%
	pause
	goto menu

:Restart
	cls
	::allows the user to have a final choice whether they would like to restart or not (incase of accidental input)
	echo Are you sure you would like to restart the computer? If not, close this window.
	pause
	:: will restart in 5 seconds
	shutdown -t 5 -r
	exit
	
:Shutdown
	cls
	::allows the user to have a final choice whether they would like to shut down or not (incase of accidental input)
	echo Are you sure you would like to shutdown the computer? If not, close this window.
	pause
	:: will shut down in 5 seconds
	shutdown -t 5 -s	exit
	
:Read
	cls
	::asks the user what file should be opened
	set /P input=name:
	:: gradually progresses through txt file as user presses spacebar or enter
	more %input%.txt
	:: if the file does not exist, it will go to 'fail'
	IF NOT %ERRORLEVEL% == 0 goto fail
	goto menu
	
:fail
	cls
	echo Please try again
	pause
	::allows the user to have a second chance at entering a text file.
	goto Read
	
:Quit
	exit