
Alcon (Actionscript Logging Console) v1.0.7

External output console for Actionscript
by Sascha Balkau <sascha@hiddenresource.corewatch.net>
http://fgpwiki.corewatch.net/wiki/alcon

Alcon is a debugging tool for Flash developers that uses Flash's LocalConnection
to send data from a static Debug class to an external output window.

Main features:
- Colors, font, window size & position and keyword names are configurable.
- Supports recursive Object tracing.
- Small memory footprint (compiled Debug class is about 1 Kb).
- MTASC compatible.
- Traces output larger than Flash's 40Kb LocalConnection limit.
- Unicode support.


This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.


CONTENTS:
1. INSTALLATION
2. DEBUG CLASS USAGE
3. CONSOLE USAGE
4. CONTACT
5. HISTORY


1. INSTALLATION
---------------
a) Go to the source folder that is included in the Alcon distribution (source\src) and copy
   the path and file 'net/hiddenresource/util/debug/Debug.as' to your Actionscript Class Path
   (by default 'C:\Documents and Settings\username\Local Settings\Application Data\Macromedia\
    Flash MX 2004\en\Configuration\Classes\') or to where you store your additional classes.
b) Copy the 'Alcon' folder to where you like (for example 'C:\Program Files\').
c) The other files in the 'source' folder (bin, lib etc.) are only needed if you want to compile
   Alcon by youself. An Ant build file is included.

Alcon doesn't make any changes to the Windows registry or any other places.
For uninstalling, it is only necessary to delete the copied files/folders.


2. DEBUG CLASS USAGE
--------------------
Start Alcon by executing 'Alcon.exe' on Windows. You might want to create a link of it in
the Startmenu or on the Desktop for easier access.

Import the Alcon class into your project with:
   import net.hiddenresource.util.debug.Debug;

Use Alcon's trace method to send messages to the Alcon output console:

   Debug.trace("test!");


The trace method supports three arguments which are all optional. If no argument was given,
Alcon will trace nothing. The following arguments can be set:

   Debug.trace(outputVar, recursiveObjTracing, severityLevel);
   
   [outputVar]
      is the variable that is traced.

   [recursiveObjTracing]
      a Boolean. If set to true and outputVar is of type Object,
      Movieclip or Array, Alcon will evaluate the object and trace
      all it's contents recursively. Defaults to false if omitted.
			
   [severityLevel]
      a Number which determines the severity level of the output.
      Defaults to 1 if omitted. Possible levels are 0 (DEBUG),
      1 (INFO), 2 (WARN), 3 (ERROR) and 4 (FATAL).


Some examples of using the trace method:

   Debug.trace("Test Message!", 0);
      traces the text with a severity level of DEBUG.
   
   Debug.trace(test_obj, true);
      recursively traces the Object test_obj with severity level of INFO.

   Debug.trace(_root, true, 2);
      traces all variables, objects and movieclips in _root recursively with a
      severity level of WARN.



Setting the Filter Level
------------------------
The filter level can be changed with Alcon.setFilterLevel(0-4). By default all severity
levels will be traced. For example by using ...

   Debug.setFilterLevel(2);

... only outputs with a level of 2 (WARN) and higher will be traced.



Setting recursion depth for object tracing
------------------------------------------
By default this depth is set to 20. This means that by using 'recursive object tracing'
an object's or movieclip's contents will be traced down to a hierarchy of 20 levels.
This is enough for most cases but if you are using objects/clips with a deeper hierarchy,
you can raise the maximum limit by using setRecursionDepth():

   Debug.setRecursionDepth(60);
      sets the maximum recursion depth to 60.



Using console signals
---------------------
It is possible to send signals to the console to clear the buffer, send a delimiter line or
set the console to pause mode. The console will parse the tags [%CLR%], [%DLT%] and [%PSE%]
to clear the buffer, place a delimiter line or set to pause mode. For these tags to be recognized
by the console they must be written uppercase and at the beginning of a text. Optionally you can
use the methods Debug.clear(), Debug.delimiter() and Debug.pause() to send the signals.

   Debug.trace("[%CLR%]Here's some output!");
      clears the console buffer and outputs the text.
      
   Debug.clr();
   Debug.trace("Here's some output!");
      Same as above.
      
   Debug.trace("[%DLT%]More text to come ...");
   or ...
   Debug.delimiter();
   Debug.trace("More text to come ...");
      ... both yield in placing a delimiter line and outputting the text under it.

   Debug.pause();
      ... sets the console to pause.

   Debug.trace("[%LV3%]Some text!");
      Sends the text with a severity level of 3.



Splitting data blocks larger than 40Kb
--------------------------------------
Flash's LocalConnection has a limitation of maximally sending 40Kb at once through. To overcome
this limitation Alcon splits data which is larger than 40Kb into 40Kb chunks and sends these to the
console one by one, where the data is merged again. This functionality is active by default but can
be turned off by using the splitData method:

   Debug.splitData(false);
      ... turns data splitting off. All data blocks larger than 40Kb will not be sent and the console
      will display 'Send Error' in it's statusbar.





3. CONSOLE USAGE
----------------
Alcon comes with two different versions, the executable and the SWF version. The executable offers the
full features but only runs on Windows. The SWF version offers the most important features for debugging.
For users who are not able to use the executable version, press the <K> key to get a list of the keyboard
shortcuts.

Configurating the console
-------------------------
Alcon's output console can be configured by changing the 'Alcon.cfg' file!
The following settings are available:

FONT_FACE			Determines which font face will be used (i.e. Andale Mono).
FONT_SIZE			Determines the used font size.
BUFFER_LENGTH		Sets the buffer size of the output console. If this value is
					reached, the buffer will be emptied. Max. possible is 10000000.
WIN_XPOS			The x position of Alcon's window. Negative values are possible.
WIN_XPOS			The y position of Alcon's window. Negative values are possible.
WIN_WIDTH			The width of Alcon's window.
WIN_HEIGHT			The height of Alcon's window.
WIN_STAYONTOP		Determines if Alcon window stays on top of other windows or not.
SHOW_KEYWORDS		Determines if level keywords are shown or not.
SHOW_ORIGIN			Determines if debug origin (class name and linr nr.) is displayed. (only with MTASC trace!)
KEYWORD_[0-4]		The names that are used for the level keywords.
USE_COLORS			Determines of color mode is used or not. If disabled, all text will
					use the LEVEL_1_COLOR. If enabled, the output area will be in HTML mode.
BG_COLOR			Defines the background color of the output area.
LEVEL_[0-4]_COLOR	These values define the colors for the various severity levels.
DELIMITER			A string which is used for the delimiter signal.




4. CONTACT
----------
Comments, suggestions, feature requests or bug reports?
Send email to <sascha@hiddenresource.corewatch.net> or post them on the discussion tab at
http://fgpwiki.corewatch.net/wiki/alcon



5. HISTORY
----------
v1.0.7
- Added full support for MTASC trace facility (works now with additional arguments).
- Added option to console to turn on/off displaying the debug origin (class name, line nr.),
  this only works when using the MTASC trace facility!
- Added [%LVx%] console signal. Used to send severity level (x) inside the string without using
  additional arguments.
- Fixed some minor bugs.

v1.0.6
- Added save log buffer option.
- Added print log buffer option.
- Added screen dump to printer option.
- Added stay on top option.
- Added menu bar.
- Added functionality to trace data blocks which are larger than 40Kb by splitting them.
- Added pause console signal.
- Added keyword names now editable in console settings file.
- Moved show keywords option from debug class to console settings.
- Reduced color text overhead by using short stylesheet tags for color output.
- Removed BUFFER_INFO from settings (not necessary).
- Fixed bug that caused exception when using clear buffer/reset.
- Fixed bug that would prevent showing html special chars (&amp; etc.) in color text mode.
- Changed Debug class to have its own sole package for easier use with MTASC trace.
- Many other internal improvements and bug fixes.

v1.0.5
- Added control tags [%CLR%] and [%DLT%] for sending buffer clear and delimiter signals.
- Added clr() method to Debug.as for sending clear buffer signals.
- Added dlt() method to Debug.as for sending delimiter signals.
- Added delimiter string to Alcon.cfg file so it can be changed by the user.
- Changed config file so it uses '#' instead of '//' for comment lines.
- Replaced supressLevelDesc() method with showKeywords() and hideKeywords().
- Added getFilterLevel() method to Debug.as for compability with as2lib.
- Fixed a bug in the console that crippled output text in color mode when sending '<' and '>'
  characters.
- Changed package of Debug class to net.hiddenresource.util because an extra namespace is not
  necessary for only one class.
- Made exe version a standalone barebone projector so it fits better into an open source
  development environment.
- Several internal changes in Debug.as and Console.as.

v1.0.4
- Changed class name to Debug.
- Added compability for Debug.as to compile with MTASC.

v1.0.3
- Application name changed from 'Output Logger' to 'Alcon'.
- Statusbar added for the executable version which displays some info like
  buffer status and pause mode.
- Added option to display buffer info in the status bar.
- Added support for recursive object tracing.
- Added keyboard control for using pause, clear buffer and reset.
- Right click menu has been changed.
- Added 'about' info.
- Removed a bug which caused a memory access violation when using clear buffer
  while logging (hopefully!).
- Uses 'Courier New' as default font now which most people should have.

v1.0.2
- Added support for setting the console window size.
- Included ReadMe file.
- Rewrote console code to AS2 class code.

v1.0.1
- Added support for positioning the console window.
- Added option to turn off color mode.

v1.0.0
Initial public release.


** Big thanks to the folks on [Flashcoders] and [OSFlash] for all the help! **
