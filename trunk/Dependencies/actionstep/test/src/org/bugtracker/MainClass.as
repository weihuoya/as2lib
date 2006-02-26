/* See LICENSE for copyright and terms of use */

import org.bugtracker.Application;
import org.actionstep.NSApplication;

/**
 * This is the main class for the bug tracker application.
 * 
 * @author Scott Hyndman
 */
class org.bugtracker.MainClass {
	
	/**
	 * The entry point for the application.
	 */
	public static function main():Void {
		try {
			var app:Application = (new Application()).init();
		} catch (e:Error) {
			trace(e.toString());
			NSApplication.sharedApplication().run();
		}
	}
}