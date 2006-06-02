/*
 * Alcon (Actionscript Logging Console) v1.0.7 2006/01/16
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * 
 * Sascha Balkau <sascha@hiddenresource.corewatch.net>
 */

import mx.controls.TextArea;
import mx.containers.Window;
import mx.managers.PopUpManager;
import TextField.StyleSheet;
import net.hiddenresource.util.Delegate;


/**
 * Alcon Console class
 * @version 1.0.6 2006/01/16
 * @author Sascha Balkau
 */
class Console
{
	// App information:
	private var APP_NAME:String			= "Alcon";
	private var APP_DESCRIPTION:String	= "ActionScript Logging Console";
	private var APP_VERSION:String		= "1.0.7";
	private var APP_YEAR:String			= "2005/2006";
	private var APP_WEBSITE:String		= "fgpwiki.corewatch.net/wiki/alcon";
	private var APP_DOCS:String			= "docs\\ReadMe.txt";
	private var APP_AUTHOR:String			= "Sascha Balkau";
	private var APP_COMPANY:String		= "";
	
	// Config filename:
	private var CFG_FILE:String		= "Alcon.cfg";
	
	// Default settings:
	private var FONT_FACE:String		= "Courier New";
	private var FONT_SIZE:String		= "11";
	private var BUFFER_LENGTH:String	= "200000";
	private var WIN_XPOS:String		= "20";
	private var WIN_YPOS:String		= "20";
	private var WIN_WIDTH:String		= "300";
	private var WIN_HEIGHT:String		= "600";
	private var WIN_STAYONTOP:String	= "false";
	private var SHOW_KEYWORDS:String	= "true";
	private var SHOW_ORIGIN:String	= "false";
	private var KEYWORD_0:String		= "[DEBUG]";
	private var KEYWORD_1:String		= " [INFO]";
	private var KEYWORD_2:String		= " [WARN]";
	private var KEYWORD_3:String		= "[ERROR]";
	private var KEYWORD_4:String		= "[FATAL]";
	private var USE_COLORS:String		= "true";
	private var BG_COLOR:String		= "ffffff";
	private var LEVEL_0_COLOR:String	= "0055aa";
	private var LEVEL_1_COLOR:String	= "000000";
	private var LEVEL_2_COLOR:String	= "ff8800";
	private var LEVEL_3_COLOR:String	= "ff3300";
	private var LEVEL_4_COLOR:String	= "bb0000";
	private var DELIMITER:String		= "----------------------------------------";
	
	// Console is a singleton:
	private static var newConsole:Console = null;
	// Keeps message if settings load succeeded or not:
	private var lsuccess:String;
	// Determines paused mode:
	private var paused:Boolean;
	// Textarea object:
	private var tarea:TextArea;
	// Stylesheet object for textarea:
	private var ta_style:StyleSheet;
	// A sbuffer that is used to store a non HTML version of the log output:
	private var sbuffer:String;
	// Keeps path for file saving:
	private var spath:String;
	// Keeps current buffer state for use in statusbar:
	private var bstate:String;
	// LocalConnection object:
	private var alcon_lc:LocalConnection;
	// Name of the alcon LC:
	private var alcon_lc_name:String;
	// Determines whether window stays on top or not:
	private var stayontop:Boolean;
	// Determines if keywording is active:
	private var kw:Boolean;
	// Determines if MTASC info is displayed:
	private var so:Boolean;
	// Determines if about dialog is shown:
	public var sabout:Boolean;
	
	// Force inclusion of UIComponentExtensions:
	private static var incExt:Object = mx.core.ext.UIComponentExtensions;
	
	
	/**
	 * Constructor
	 */
	private function Console()
	{
		lsuccess = "";
		paused = true;
		sbuffer = "";
		spath = undefined;
		bstate = "";
		alcon_lc_name = "_alcon_lc";
		stayontop = false;
		kw = true;
		so = true;
		sabout = false;
		
		if (_root.init == undefined) prepareConsole();
		loadSettings();
	}
	
	
	/**
	 * Program entry point.
	 */
	public static function main():Void
	{
		if (Console.newConsole == null) Console.newConsole = new Console();
	}
	
	
	/**
	 * Prepares the console window and generate custom menu.
	 */
	private function prepareConsole():Void
	{
		// Give focus to main form:
		mdm.Application.onFormChangeFocus = mdm.Application.onAppRestore = function():Void
		{
			mdm.Forms.thisForm.setFocus();
		};
		
		// Create statusbar:
		mdm.Forms.thisForm.showStatusBar();
		
		// Prepare custom menu:
		mdm.Menu.Main.menuType = "function";
		mdm.Menu.Main.insertHeader("File");
		mdm.Menu.Main.insertItem("File", "Save Log");
		mdm.Menu.Main.insertItem("File", "Print Log");
		mdm.Menu.Main.insertItem("File", "Screen Dump");
		mdm.Menu.Main.insertDivider("File");
		mdm.Menu.Main.insertItem("File", "Exit");
		mdm.Menu.Main.insertHeader("Control");
		mdm.Menu.Main.insertItem("Control", "Pause");
		mdm.Menu.Main.insertDivider("Control");
		//mdm.Menu.Main.insertItem("Control", "Clear buffer");
		//mdm.Menu.Main.insertItem("Control", "Reset");
		//mdm.Menu.Main.insertDivider("Control");
		mdm.Menu.Main.insertItem("Control", "Show Keywords");
		mdm.Menu.Main.insertItem("Control", "Show Trace Origin");
		mdm.Menu.Main.insertItem("Control", "Stay On Top");
		mdm.Menu.Main.insertHeader("Help");
		mdm.Menu.Main.insertItem("Help", "Alcon Help");
		mdm.Menu.Main.insertItem("Help", "Keyboard Shortcuts");
		mdm.Menu.Main.insertItem("Help", "Visit Website");
		mdm.Menu.Main.insertItem("Help", "About");
		
		// Create custom context menu:
		mdm.Menu.Context.enable();
		mdm.Menu.Context.menuType = "function";
		mdm.Menu.Context.insertItem("Save Log");
		mdm.Menu.Context.insertItem("Print Log");
		mdm.Menu.Context.insertItem("Screen Dump");
		mdm.Menu.Context.insertDivider();
		mdm.Menu.Context.insertItem("Pause");
		mdm.Menu.Context.insertDivider();
		//mdm.Menu.Context.insertItem("Clear buffer");
		//mdm.Menu.Context.insertItem("Reset");
		//mdm.Menu.Main.insertDivider("Control");
		mdm.Menu.Context.insertItem("Show Keywords");
		mdm.Menu.Context.insertItem("Show Trace Origin");
		mdm.Menu.Context.insertItem("Stay On Top");
		mdm.Menu.Context.insertDivider();
		mdm.Menu.Context.insertItem("Alcon Help");
		mdm.Menu.Context.insertItem("Keyboard Shortcuts");
		mdm.Menu.Context.insertItem("Visit Website");
		mdm.Menu.Context.insertItem("About");
		
		// Nested menu functions:
		mdm.Menu.Main["onMenuClick_Save_Log"] =
		mdm.Menu.Context["onContextMenuClick_Save_Log"] = Delegate.create(this, function():Void
		{
			this.saveLog();
		});
		
		mdm.Menu.Main["onMenuClick_Print_Log"] =
		mdm.Menu.Context["onContextMenuClick_Print_Log"] = Delegate.create(this, function():Void
		{
			this.printLog();
		});
		
		mdm.Menu.Main["onMenuClick_Screen_Dump"] =
		mdm.Menu.Context["onContextMenuClick_Screen_Dump"] = Delegate.create(this, function():Void
		{
			this.screenDump();
		});
		
		mdm.Menu.Main["onMenuClick_Exit"] = Delegate.create(this, function():Void
		{
			this.exit();
		});
		
		mdm.Menu.Main["onMenuClick_Pause"] =
		mdm.Menu.Context["onContextMenuClick_Pause"] = Delegate.create(this, function():Void
		{
			if (!this.sabout)
			{
				if (!this.paused) this.pause(true);
				else this.unpause(true);
			}
		});
		
		/* TODO disabled for now! Both are throwing Zinc exceptions with mdm2.0 script! */
		/*
		mdm.Menu.Main["onMenuClick_Clear_buffer"] =
		mdm.Menu.Context["onContextMenuClick_Clear_buffer"] = Delegate.create(this, function():Void
		{
			if (!this.sabout) this.clearBuffer();
		});
		mdm.Menu.Main["onMenuClick_Reset"] =
		mdm.Menu.Context["onContextMenuClick_Reset"] = Delegate.create(this, function():Void
		{
			if (!this.sabout) this.reset();
		});
		*/
		
		mdm.Menu.Main["onMenuClick_Show_Keywords"] =
		mdm.Menu.Context["onContextMenuClick_Show_Keywords"] = Delegate.create(this, function():Void
		{
			this.toggleKeywords();
		});
		
		mdm.Menu.Main["onMenuClick_Show_Trace_Origin"] =
		mdm.Menu.Context["onContextMenuClick_Show_Trace_Origin"] = Delegate.create(this, function():Void
		{
			this.toggleOrigin();
		});
		
		mdm.Menu.Main["onMenuClick_Stay_On_Top"] =
		mdm.Menu.Context["onContextMenuClick_Stay_On_Top"] = Delegate.create(this, function():Void
		{
			this.toggleWinBehavior();
		});
		
		mdm.Menu.Main["onMenuClick_Alcon_Help"] =
		mdm.Menu.Context["onContextMenuClick_Alcon_Help"] = Delegate.create(this, function():Void
		{
			this.browseURL(this.APP_DOCS);
		});
		
		mdm.Menu.Main["onMenuClick_Keyboard_Shortcuts"] =
		mdm.Menu.Context["onContextMenuClick_Keyboard_Shortcuts"] = Delegate.create(this, function():Void
		{
			this.quickHelp();
		});
		
		mdm.Menu.Main["onMenuClick_Visit_Website"] =
		mdm.Menu.Context["onContextMenuClick_Visit_Website"] = Delegate.create(this, function():Void
		{
			this.browseURL("http://" + this.APP_WEBSITE);
		});
		
		mdm.Menu.Main["onMenuClick_About"] =
		mdm.Menu.Context["onContextMenuClick_About"] = Delegate.create(this, function():Void
		{
			this.aboutDialog();
		});
	}
	
	
	/**
	 * Sets up the screen behavior.
	 * @param	<code>lColors</code>	An array that contains the level color values.
	 */
	private function initScreen(lColors:Array):Void
	{
		// Only set these things once at init:
		if (_root.init == undefined)
		{
			_root.init = true;
			
			// Position and resize the app window:
			mdm.Forms.thisForm.x = WIN_XPOS;
			mdm.Forms.thisForm.y = WIN_YPOS;
			mdm.Forms.thisForm.width = WIN_WIDTH;
			mdm.Forms.thisForm.height = WIN_HEIGHT;
			
			Stage.scaleMode = "noScale";
			Stage.align = "TL";
			
			kw = (SHOW_KEYWORDS == "true") ? true : false;
			so = (SHOW_ORIGIN == "true") ? true : false;
			stayontop = (WIN_STAYONTOP == "true") ? true : false;
			
			// Create text area:
			tarea = _root.createClassObject(TextArea, "tarea", 0);
			tarea.move(-2, -2);
			tarea.setSize((Stage.width + 4), (Stage.height + 4));
			tarea.editable = false;
			tarea.wordWrap = true;
			tarea.vScrollPolicy = "on";
			// Set resize functionality for text area:
			var stageListener:Object = new Object();
			stageListener.onResize = Delegate.create(this, function():Void
			{
				this.tarea.move(-2, -2);
				this.tarea.setSize((Stage.width + 4), (Stage.height + 4));
			});
			Stage.addListener(stageListener);
		}
		
		// Set behaviors menu entries at every reset:
		setKeywordBehavior();
		setOriginBehavior();
		setWinBehavior();
		
		// Set the text area styles everytime at init or reset:
		tarea.setStyle("backgroundColor", parseInt("0x" + BG_COLOR));
		tarea.setStyle("fontFamily", FONT_FACE);
		tarea.setStyle("fontSize", FONT_SIZE);
		tarea.setStyle("color", parseInt("0x" + lColors[1]));
	}
	
	
	/**
	 * Displays the about window.
	 */
	private function aboutDialog():Void
	{
		if (!sabout)
		{
			sabout = true;
			pause(true);
					
			// Reference for nested function (We don't want to make it more complex
			// by using Delegate.create just for the removeEventListener stuff!):
			var ref:Console = this;
			
			// Create modal about window:
			var aboutWin:Window = Window(PopUpManager.createPopUp(_root, Window, true));
			aboutWin.title = "About";
			aboutWin.closeButton = true;
			aboutWin.contentPath = "aboutContent_mc";
			aboutWin.setSize(200, 170);
			aboutWin.move(Math.floor((Stage.width / 2) - (aboutWin.width / 2)), Math.floor((Stage.height / 2) - (aboutWin.height / 2)));
			
			// Set about window vars:
			_root.app_name = APP_NAME;
			_root.app_description = APP_DESCRIPTION;
			_root.app_version = "version " + APP_VERSION;
			_root.app_year = "Written " + APP_YEAR + " by";
			_root.app_author = APP_AUTHOR;
			_root.app_company = APP_COMPANY;
			
			// Add window listener:
			var aboutWinListener:Object = new Object();
			aboutWinListener.click = function():Void
			{
				aboutWin.deletePopUp();
				aboutWin.removeEventListener("click", aboutWinListener);
				ref.unpause(true);
				ref.sabout = false;
			};
			aboutWin.addEventListener("click", aboutWinListener);
		}
	}
	
	
	/**
	 * Sends messages to the status bar.
	 * @param	<code>msg</code>	A String containing the statusbar message.
	 */
	public function statusBar(msg:String):Void
	{
		msg = "Buffer: " + bstate + "    " + msg;
		mdm.Forms.thisForm.setStatusBarText(msg);
	}
	
	
	/**
	 * Turns pause mode on.
	 * @param	<code>show</code>	boolean, if true shows the paused mode.
	 */
	private function pause(show:Boolean):Void
	{
		paused = true;
		
		if (show)
		{
			mdm.Menu.Main.itemChecked("Control", "Pause", true);
			mdm.Menu.Context.itemChecked("Pause", true);
			statusBar("Paused");
			tarea.vPosition = tarea.maxVPosition;
		}
	}
	
	
	/**
	 * Turns paused mode off.
	 * @param	<code>clearSB</code>	boolean, if true clears the statusbar.
	 */
	public function unpause(clearSB:Boolean):Void
	{
		mdm.Menu.Main.itemChecked("Control", "Pause", false);
		mdm.Menu.Context.itemChecked("Pause", false);
		if (clearSB) statusBar("");
		
		paused = false;
	}
	
	
	/**
	 * Clears the display buffer and the save buffer.
	 */
	private function clearBuffer():Void
	{
		pause();
		statusBar("Cleared");
		tarea.text = "";
		sbuffer = "";
		bstate = "0/0";
		statusBar("");
		unpause();
	}
	
	/**
	 * Closes the local connection and resets the console.
	 */
	private function reset():Void
	{
		Key.removeListener(this);
		pause();
		alcon_lc.close();
		clearBuffer();
		loadSettings();
	}
	
	
	/**
	 * Quits the application.
	 */
	private function exit():Void
	{
		if (!sabout)
		{
			pause();
			alcon_lc.close();
			mdm.Application.exit();
		}
	}
	
	
	/**
	 * Saves the current log buffer to a file. If HTML mode is active, the
	 * sbuffer is used for saving, otherwise the contents of <code>tarea.text</code>.
	 */
	private function saveLog():Void
	{
		if (!sabout)
		{
			pause(true);
			alcon_lc.close();
			
			var html:Boolean = (USE_COLORS == "true") ? true : false;
			if (!html) sbuffer = tarea.text;
			
			spath = undefined;
			var defaultPath:String = mdm.Application.pathUnicode + "logs";
			
			mdm.Dialogs.BrowseFileUnicode.title = "Save log file...";
			mdm.Dialogs.BrowseFileUnicode.defaultDirectory = defaultPath;
			mdm.Dialogs.BrowseFileUnicode.defaultExtension = "log";
			mdm.Dialogs.BrowseFileUnicode.defaultFilename = "alcon.log";
			spath = mdm.Dialogs.BrowseFileUnicode.show();
			
			// Nested interval to wait until save path is available:
			var waitInterval:Number;
			waitInterval = setInterval(Delegate.create(this, function():Void
			{
				if (this.spath != undefined)
				{
					if (this.spath != "false")
					{
						/* TODO Using fscommand for saving data as long as mdm2.0 script is still buggy! */
						//mdm.FileSystem.saveFileUnicode(this.spath, this.sbuffer);
						_root.writeData(this.spath, this.sbuffer);
						this.statusBar("Log saved");
					}
					clearInterval(waitInterval);
					this.unpause();
					this.alcon_lc.connect(this.alcon_lc_name);
				}
			}), 100);
		}
	}
	
	
	/**
	 * Prints the current log buffer.
	 */
	private function printLog():Void
	{
		if (!sabout)
		{
			pause(true);
			alcon_lc.close();
			if (!USE_COLORS) sbuffer = tarea.text;
			/* TODO use mdm1.0 script print var as long as 2.0 script is buggy! */
			//mdm.Application.printVar(sbuffer, true);
			_root.printData(this.sbuffer);
			// Wait a second before wiping _root.txt (needed for fscommand):
			var delayInterval:Number;
			delayInterval = setInterval(Delegate.create(this, function():Void
			{
				_root.txt = _root.sd = undefined;
				clearInterval(delayInterval);
			}), 1000);

			alcon_lc.connect(alcon_lc_name);
			unpause(true);
		}
	}
	
	
	/**
	 * Makes a screen dump of the current window content to the printer.
	 */
	private function screenDump():Void
	{
		if (!sabout)
		{
			pause(true);
			alcon_lc.close();

			var scrDump:PrintJob = new PrintJob();
			if (scrDump.start())
			{
				var pagesToPrint:Number = 0;
				if (scrDump.addPage("tarea", {xMin:2, xMax:(tarea.width - 18), yMin:2, yMax:(tarea.height - 2)}))
				{
					pagesToPrint++;
				}
				if (pagesToPrint > 0) scrDump.send();
			}
			delete scrDump;
			
			alcon_lc.connect(alcon_lc_name);
			unpause(true);
		}
	}
	
	
	/**
	 * Opens a URL or file in the browser.
	 */
	private function browseURL(_url:String):Void
	{
		if (!sabout) getURL(_url, "_top");
	}
	
	
	/**
	 * Displays a quick help text on the console.
	 */
	private function quickHelp():Void
	{
		if (!sabout)
		{
			var htxt:String = "Alcon keyboard shortcuts:\n";
			htxt += "<P> Pause/unpause output\n";
			htxt += "<C> Clear console\n";
			htxt += "<R> Reset console\n";
			htxt += "<A> Show about window\n";
			htxt += "<K> List keyboard shortcuts\n";
			htxt += "<CTRL> + <S> Save log buffer to disk\n";
			htxt += "<CTRL> + <T> Print log buffer\n";
			htxt += "<CTRL> + <D> Screen dump to printer\n";
			htxt += "<CTRL> + <H> Open Alcon help document\n";
			htxt += "<CTRL> + <W> Open Alcon website\n";
			htxt += "<CTRL> + <Q> Quit Alcon\n\n";
			htxt += "Console signal tags:\n";
			htxt += "[%CLR%]   Clear log buffer\n";
			htxt += "[%DLT%]   Place delimiter line\n";
			htxt += "[%PSE%]   Pause the console\n";
			htxt += "[%LV0-4%] Severity level signal";
			sendMsg("\n" + htxt, "[%DLT%]", false);
			sendMsg("\n", "[%DLT%]", false);
		}
	}
	
	
	/**
	 * Toggles keywording on/off.
	 */
	private function toggleKeywords():Void
	{
		if (!sabout)
		{
			if (kw) kw = false;
			else kw = true;
			setKeywordBehavior();
		}
	}
	
	
	/**
	 * Sets the keyword on/off and toggles the according menu entries.
	 */
	private function setKeywordBehavior():Void
	{
		if (kw)
		{
			mdm.Menu.Main.itemChecked("Control", "Show Keywords", true);
			mdm.Menu.Context.itemChecked("Show Keywords", true);
		}
		else
		{
			mdm.Menu.Main.itemChecked("Control", "Show Keywords", false);
			mdm.Menu.Context.itemChecked("Show Keywords", false);
		}
	}
	
	
	/**
	 * Toggles show origin (classname & line number) on/off.
	 */
	private function toggleOrigin():Void
	{
		if (!sabout)
		{
			if (so) so = false;
			else so = true;
			setOriginBehavior();
		}
	}
	
	
	/**
	 * Sets the show origin on/off and toggles the according menu entries.
	 */
	private function setOriginBehavior():Void
	{
		if (so)
		{
			mdm.Menu.Main.itemChecked("Control", "Show Trace Origin", true);
			mdm.Menu.Context.itemChecked("Show Trace Origin", true);
		}
		else
		{
			mdm.Menu.Main.itemChecked("Control", "Show Trace Origin", false);
			mdm.Menu.Context.itemChecked("Show Trace Origin", false);
		}
	}
	
	
	/**
	 * Toggles stayontop mode on/off.
	 */
	private function toggleWinBehavior():Void
	{
		if (!sabout)
		{
			if (stayontop) stayontop = false;
			else stayontop = true;
			setWinBehavior();
		}
	}
	
	
	/**
	 * Sets the application whether to stay on top or not.
	 */
	private function setWinBehavior():Void
	{
		if (stayontop)
		{
			mdm.Menu.Main.itemChecked("Control", "Stay on top", true);
			mdm.Menu.Context.itemChecked("Stay on top", true);
			mdm.Application.onAppChangeFocus = function():Void
			{
				mdm.Forms.thisForm.setFocus();
			};
		}
		else
		{
			mdm.Menu.Main.itemChecked("Control", "Stay on top", false);
			mdm.Menu.Context.itemChecked("Stay on top", false);
			mdm.Application.onAppChangeFocus = function():Void
			{
			};
		}
	}
	
	
	/**
	 * Tries to load the settings file.
	 */
	private function loadSettings():Void
	{
		var settingsVars:LoadVars = new LoadVars();
		settingsVars.onData = Delegate.create(this, parseSettings);
		settingsVars.load(CFG_FILE);
	}
	
	
	/**
	 * Parses the settings from the loaded text file.
	 * @param	<code>settingsText</code>	The data from the loaded text file.
	 */
	private function parseSettings(settingsText:String):Void
	{
		if (settingsText != undefined)
		{
			lsuccess = "Settings loaded!";
			
			// Strip linefeeds:
			var tmpArray:Array = settingsText.split("\r\n");
			settingsText = tmpArray.join("\r");
			
			// Divide settings name and settings value
			// into two different arrays:
			var nameArray:Array = [];
			var valueArray:Array = [];
			for (var i:Number = 0; i < tmpArray.length; i++)
			{
				// Don't parse empty or comment lines:
				if ((tmpArray[i] != "") && (tmpArray[i].substring(0, 1) != "#"))
				{
					var subArray:Array = tmpArray[i].split(" = ");
					nameArray.push(subArray[0]);
					valueArray.push(subArray[1]);
				}
			}
			
			// Parse:
			for (var i:Number = 0; i < nameArray.length; i++)
			{
				var val:String = valueArray[i];
				//trace(i + ". [" + nameArray[i] + ": " + val + "]");
				if (nameArray[i] == "FONT_FACE") FONT_FACE = val;
				if (nameArray[i] == "FONT_SIZE") FONT_SIZE = val;
				if (nameArray[i] == "BUFFER_LENGTH") BUFFER_LENGTH = val;
				if (nameArray[i] == "WIN_XPOS") WIN_XPOS = val;
				if (nameArray[i] == "WIN_YPOS") WIN_YPOS = val;
				if (nameArray[i] == "WIN_WIDTH") WIN_WIDTH = val;
				if (nameArray[i] == "WIN_HEIGHT") WIN_HEIGHT = val;
				if (nameArray[i] == "WIN_STAYONTOP") WIN_STAYONTOP = val.toLowerCase();
				if (nameArray[i] == "SHOW_KEYWORDS") SHOW_KEYWORDS = val.toLowerCase();
				if (nameArray[i] == "SHOW_ORIGIN") SHOW_ORIGIN = val.toLowerCase();
				if (nameArray[i] == "KEYWORD_0") KEYWORD_0 = val;
				if (nameArray[i] == "KEYWORD_1") KEYWORD_1 = val;
				if (nameArray[i] == "KEYWORD_2") KEYWORD_2 = val;
				if (nameArray[i] == "KEYWORD_3") KEYWORD_3 = val;
				if (nameArray[i] == "KEYWORD_4") KEYWORD_4 = val;
				if (nameArray[i] == "USE_COLORS") USE_COLORS = val.toLowerCase();
				if (nameArray[i] == "BG_COLOR") BG_COLOR = val;
				if (nameArray[i] == "LEVEL_0_COLOR") LEVEL_0_COLOR = val;
				if (nameArray[i] == "LEVEL_1_COLOR") LEVEL_1_COLOR = val;
				if (nameArray[i] == "LEVEL_2_COLOR") LEVEL_2_COLOR = val;
				if (nameArray[i] == "LEVEL_3_COLOR") LEVEL_3_COLOR = val;
				if (nameArray[i] == "LEVEL_4_COLOR") LEVEL_4_COLOR = val;
				if (nameArray[i] == "DELIMITER") DELIMITER = val;
			}
		}
		else
		{
			lsuccess = "Settings file not found,\nusing defaults!";
		}
		
		// start main part:
		runLogger();
	}
	
	
	/**
	 * Contains the loggers main guts.
	 */
	private function runLogger():Void
	{
		// Local vars:
		var buffer:Number = parseInt(BUFFER_LENGTH);
		if (buffer < 0) buffer = 0;
		else if (buffer > 10000000) buffer = 10000000;
		
		var html:Boolean = (USE_COLORS == "true") ? true : false;
		var lcols:Array = [LEVEL_0_COLOR, LEVEL_1_COLOR, LEVEL_2_COLOR, LEVEL_3_COLOR, LEVEL_4_COLOR];
		var kws:Array = [(KEYWORD_0 + " "), (KEYWORD_1 + " "), (KEYWORD_2 + " "), (KEYWORD_3 + " "), (KEYWORD_4 + " ")];
		var kwp:String = "";
		var len:Number = 0;
		
		// Chunk buffer, used for chunks combining:
		var chb:String = "";
		
		// Initialize the visual assets:
		initScreen(lcols);
		
		// In case color text (html) is used, define the stylesheet:
		if (html)
		{
			ta_style = new StyleSheet();
			ta_style.setStyle("l0", {fontFamily: FONT_FACE, fontSize: FONT_SIZE, color: ("#" + lcols[0])});
			ta_style.setStyle("l1", {fontFamily: FONT_FACE, fontSize: FONT_SIZE, color: ("#" + lcols[1])});
			ta_style.setStyle("l2", {fontFamily: FONT_FACE, fontSize: FONT_SIZE, color: ("#" + lcols[2])});
			ta_style.setStyle("l3", {fontFamily: FONT_FACE, fontSize: FONT_SIZE, color: ("#" + lcols[3])});
			ta_style.setStyle("l4", {fontFamily: FONT_FACE, fontSize: FONT_SIZE, color: ("#" + lcols[4])});
			ta_style.setStyle("l5", {fontFamily: FONT_FACE, fontSize: FONT_SIZE, color: ("#" + lcols[1])});
			ta_style.setStyle("l6", {fontFamily: FONT_FACE, fontSize: FONT_SIZE, color: ("#" + lcols[1])});
			
			tarea.styleSheet = ta_style;
			tarea.html = true;
		}
		else
		{
			tarea.styleSheet = undefined;
			tarea.html = false;
		}
		
		// Initialize the receiver functionality:
		alcon_lc = new LocalConnection();
		alcon_lc.allowDomain = function():Boolean
		{
			return true;
		};
		alcon_lc.onMessage = Delegate.create(this, function(msg:String, sig:String, ms:String, lvl:Number):Void
		{
			if (!this.paused)
			{
				// Check if buffer is full:
				if (len > buffer) this.clearBuffer();
				
				// Check console signal tags:
				if (sig != "")
				{
					sig = this.chkSig(sig);
					if (sig.length == 1)
					{
						lvl = parseInt(sig);
						sig = "";
					}
				}
				
				// No debug origin info when turned off or level is 5:
				if (!this.so) ms = "";
				if (lvl == 5) ms = "";
				
				// Assemble msg string:
				msg = sig + msg;
				
				// If level 6, data is split into chunks, so combine the chunks again:
				if (lvl == 6)
				{
					chb += msg;
				}
				else
				{
					// If chunk buffer was collected, combine it with the last sent data
					// and clear the chunk buffer afterwards:
					if (chb != "")
					{
						msg = chb + "\n" + msg;
						chb = "";
					}
					
					// Prepare keyword string, if keywording is inactive, just use an empty string:
					kwp = (this.kw && lvl < 5) ? kws[lvl] : "";
					
					if (html)
					{
						// Save raw text version in save buffer:
						this.sbuffer += kwp + ms + msg + "\n";
						// Keywords and debug origin stuff in bold for html text:
						if (kwp != "") kwp = "<b>" + kwp + "</b>";
						if (ms != "") ms = "<b>" + ms + "</b>";
						// Prepare tags for html output:
						msg = "<l" + lvl + ">" + kwp + ms + this.cvTags(msg) + "</l" + lvl + ">";
					}
					else
					{
						msg = kwp + ms + msg + "\n";
					}
					
					this.tarea.text += msg;
					this.tarea.vPosition = this.tarea.maxVPosition;
					msg = "";
					
					// Update buffer info display:
					len = this.tarea.length;
					this.bstate = len + "/" + buffer;
					this.statusBar("");
				}
			}
		});
		
		alcon_lc.connect(alcon_lc_name);
		
		// Send init message:
		sendMsg("\n*** " + this.APP_NAME + " v" + this.APP_VERSION + " ***\n" + this.lsuccess, "[%DLT%]", false);
		sendMsg("\n", "[%DLT%]", false);
		
		// Allow keyboard control from now:
		Key.addListener(this);
	}
	
	
	/**
	 * Checks for special console signals. Called from runLogger().
	 * @param <code>sig</code> the string to check for signal occurances.
	 * @return	the processed sig string.
	 */
	private function chkSig(sig:String):String
	{
		// Check for level signal tag:
		if (sig.substring(0, 4) == "[%LV")
		{
			return sig.substring(4, 5);
		}
		// Check for delimiter signal:
		else if (sig == "[%DLT%]")
		{
			return (DELIMITER);
		}
		// Check for clear buffer signal:
		else if (sig == "[%CLR%]")
		{
			clearBuffer();
		}
		// Check for pause signal:
		else if (sig == "[%PSE%]")
		{
			pause(true);
		}
		// Check for error signal:
		else if (sig == "[%ERR%]")
		{
			pause();
			sendMsg("", "", true);
		}
		return "";
	}
	
	
	/**
	 * Converts all occurances of HTML special characters and braces.
	 * @param <code>txt</code> the string which should be converted.	 */
	private function cvTags(txt:String):String
	{
		return (((((txt.split("&amp;").join("&amp;amp;")).split("&quot;").join("&amp;quot;")).split("&lt;").join("&amp;lt;")).split("&gt;").join("&amp;gt;")).split("<").join("&lt;")).split(">").join("&gt;");
	}
	
	
	/**
	 * Opens a temporary send connection to the console and sends a message.
	 * @param <code>msg</code> string to be broadcasted to the console.
	 * @param <code>err</code> a boolean if true shows an error message and pauses the output.
	 */
	private function sendMsg(msg:String, sig:String, err:Boolean):Void
	{
		// Send a message with a short delay because local connection needs a moment:
		var delayInterval:Number;
		delayInterval = setInterval(Delegate.create(this, function():Void
		{
			this.unpause();
			var msg_lc:LocalConnection = new LocalConnection();
			msg_lc.send(this.alcon_lc_name, "onMessage", msg, sig, "", 5);
			delete msg_lc;
			
			if (err)
			{
				/* TODO see if this error code fits somewhere else! */
				this.pause();
				this.statusBar("Send Error");
			}
			
			clearInterval(delayInterval);
		}), 60);
	}
	
	
	/**
	 * onKeyDown functionality.
	 */
	private function onKeyDown():Void
	{
		// Only allow keyboard control if about dialog is not displayed:
		if (!sabout)
		{
			// Check for pause key (p):
			if (Key.getCode() == 80)
			{
				if (!paused) pause(true);
				else unpause(true);
			}
			// Check for clear buffer key (c):
			else if (Key.getCode() == 67)
			{
				clearBuffer();
			}
			// Check for reset key (r):
			else if (Key.getCode() == 82)
			{
				reset();
			}
			// Check for about key (a):
			else if (Key.getCode() == 65)
			{
				aboutDialog();
			}
			// Check for save key (ctrl + s):
			else if (Key.isDown(Key.CONTROL) && Key.getCode() == 83)
			{
				saveLog();
			}
			// Check for print key (ctrl + t):
			else if (Key.isDown(Key.CONTROL) && Key.getCode() == 84)
			{
				printLog();
			}
			// Check for screen dump key (ctrl + d):
			else if (Key.isDown(Key.CONTROL) && Key.getCode() == 68)
			{
				screenDump();
			}
			// Check for exit key (ctrl + q):
			else if (Key.isDown(Key.CONTROL) && Key.getCode() == 81)
			{
				exit();
			}
			// Check for quick help key (k):
			else if (Key.getCode() == 75)
			{
				quickHelp();
			}
			// Check for help key (ctrl + h):
			else if (Key.isDown(Key.CONTROL) && Key.getCode() == 72)
			{
				browseURL(APP_DOCS);
			}
			// Check for visit website key (ctrl + w):
			else if (Key.isDown(Key.CONTROL) && Key.getCode() == 87)
			{
				browseURL("http://" + APP_WEBSITE);
			}
		}
	}
}
