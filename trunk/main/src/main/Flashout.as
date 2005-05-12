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

import org.as2lib.env.log.LogManager;
import org.as2lib.env.log.LogMessage;
import org.as2lib.env.log.logger.RootLogger;
import org.as2lib.env.log.level.AbstractLogLevel;
import org.as2lib.env.log.handler.FlashoutHandler;
import org.as2lib.env.log.repository.LoggerHierarchy;
import org.as2lib.env.log.stringifier.SimpleLogMessageStringifier;

/**
 * {@code Flashout} is intended for applications that want to use Flashout for log
 * messages.
 * 
 * <p>It allows you to define all Flashout specific configurations similar to the
 * configuration in {@link main.Configuration}.
 * 
 * <p>The current code contains an example that can be used in most cases. If you
 * have additional configuration you must overwrite (not extend!) this class in your
 * application directory. All that must be the same to be compatible is the static
 * {@link #init} method.
 * 
 * @see main.Configuration
 * @author Martin Heidegger
 * @version 1.0
 */
class main.Flashout {
	
	/**
	 * Initializes and starts the Flashout configuration.
	 */
	public static function init():Void {
		// sets up logging
		setUpLogging();
	}
	
	/**
	 * Configures Flashout.
	 */
	private static function setUpLogging(Void:Void):Void {
		// sets the stringifier
		LogMessage.setStringifier(new SimpleLogMessageStringifier());
		// creates and initializes the root logger
		var root:RootLogger = new RootLogger(AbstractLogLevel.ALL);
		root.addHandler(new FlashoutHandler());
		// sets logger hierarchy as repository 
		LogManager.setLoggerRepository(new LoggerHierarchy(root)); 
	}
	
}