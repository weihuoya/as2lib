/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

//import org.as2lib.env.log.logger.SimpleHierarchicalLogger;
import org.as2lib.env.log.logger.RootLogger;
import org.as2lib.env.log.level.AbstractLogLevel;
import org.as2lib.env.log.handler.FlashoutHandler;
import org.as2lib.env.log.repository.LoggerHierarchy;
import org.as2lib.env.log.LogManager;
import org.as2lib.env.log.LogMessage;
import org.as2lib.env.log.stringifier.FlashoutLogMessageStringifier;

/**
 * {@code Flashout} ist open for your configuration in a Flashout context.
 * <p>It allows you to define all Flashout specific configurations similar to the configuration
 * in {@link main.Configuration}.
 * 
 * <p>The current code contains a example that might match to usual cases. If you have additional
 * configuration you have to overwrite (not extend!) this class in your directory. All that has to
 * stay to be compatible is {@link #init}.
 * 
 * @see main.Configuration
 * @author Martin Heidegger
 * @version 1.0
 */
class main.Flashout {
	
	/**
	 * Initialisation method for the configuration
	 */
	public static function init():Void {
		// Set up for logging
		setUpLogging();
	}
	
	/**
	 * Flashout specific Logging settings.
	 */
	private static function setUpLogging(Void:Void):Void {
		
		// Special Stringifier for a Flashout Environment.
		LogMessage.setStringifier(new FlashoutLogMessageStringifier());

		// Default Logging settings.
		var root:RootLogger = new RootLogger(AbstractLogLevel.ALL);
		root.addHandler(new FlashoutHandler());
		  
		// Definition of default logging hierarchy. 
		LogManager.setLoggerRepository(new LoggerHierarchy(root)); 
	}
}